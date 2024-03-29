Add-Type -AssemblyName System.Windows.Forms

#エラーチェック用変数
$ErroeStrs = @('パース'
                ,'テスト')
$ErrorMsgs = @('パースは不適切です。パスに修正してください。'
                ,'テストは不適切です。')

#処理概要
#region Readme
    #事前準備
    #powershellの実行ポリシーを変更
    #Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
    
    #処理順序
    #�@引数からファイルパスを抽出する
    #�Aファイルを１つずつ開いていく
    #�Bファイルの中身を1行ずつチェックし、チェック結果を配列に格納していく
    #�Cまだファイルが残っていたら�Aに戻る
    #�Dチェック結果をCSVファイルに出力する
#endregion

#グローバル変数一覧
#region GlobalVariable
    #エラーチェック用拡張子
    $ExcelFileExtensions = 'xls'
    $TextFileExtensions = 'txt|java'
    
    #チェック結果格納用配列
    $checkResults = New-Object System.Collections.Generic.List[string]
#endregion

#Funcion記載箇所
#region Funcions
    function LoggerInfo($msg){
        Write-Host "[INFO]:$msg"
    }
    function LoggerWarn($msg){
        Write-Host "[WARN]:$msg" -ForegroundColor yellow 
    }
    function LoggerError($msg){
        Write-Host "[ERROR]:$msg" -ForegroundColor red
    }
    #CSVファイル出力
    function OutputCsvFile($FileName) {
        LoggerInfo $FileName'を出力します。'
        #ヘッダー出力
        "No,ファイル,行番号,指摘内容"| Out-File $FileName -append  -encoding Default
        $i=1
        #レコード書き込み
        foreach($checkResult in $checkResults) {
            $msg = [string]$i+','+$checkResult
            #-encoding DefaultはSJIS書き込み
            try
            {
                $msg | Out-File $FileName -append  -encoding Default
            } catch {
                LoggerError $FileName'の書き込みに失敗しました。'
                LoggerError '書き込みを中断し処理を終了します。'
                return
            }
            $i++
        }
    }
    #テキストファイルチェック
    function OpenTextFile($File){
        
        #テキストファイルの全行を読み込む
        $Lines = (Get-Content $File) -as [string[]]
        $LineCount=1
    
        #1行ずつチェックしていく
        foreach ($Line in $Lines) {
            $j=0
            foreach ($ErroeStr in $ErroeStrs) {
                if($Line.Contains($ErroeStr)) {
                    $checkResult = $File +',' +$LineCount +'行目,' +$ErrorMsgs[$j]
                    $checkResults.add($checkResult)
                }
                $j++
            }
            $LineCount++
        }
    }
    #Excelファイルチェック
    function OpenExcelFile($File){
        # Excelオブジェクト作成
        $excel = New-Object -ComObject Excel.Application
        $book = $null
        try{
            # 画面表示しない
            $excel.Visible = $false

            # Excelブックを開く
            # Write-Host $book.Name
            $book = $excel.Workbooks.Open($File)            

            # シートを１件ずつ処理
            foreach($Sheet in $book.Sheets) {
                # Write-Host $Sheet.Name
                for($row=1; $row -lt 100; $row++) {
                    for($col=1; $col -lt 10; $col++) {
                        $Line = $sheet.Cells.Item($row,$col).Text
                        If ($Line -eq '') {
                            continue
                        }
                        
                        $j=0
                        foreach ($ErroeStr in $ErroeStrs) {
                            if($Line.Contains($ErroeStr)) {
                                [string]$cellpoint = $Sheet.Name + '_' + [string]$row + '行_' + [string]$col +'列セル'
                                [string]$checkResult = $File +',' + $cellpoint +',' +$ErrorMsgs[$j]
                                $checkResults.add($checkResult)
                            }
                            $j++
                        }
                    }
                }
            }
        } catch {
            LoggerError $File'の操作に失敗しました。'
        } finally {
            # Excelブックを閉じる
            if ($book -ne $null) {
                [void]$book.Close($false)
                [void][System.Runtime.Interopservices.Marshal]::ReleaseComObject($book)
            }

            # Excelの終了
            [void]$excel.Quit()

            # オブジェクトの開放
            # ApplicationとBookに対して行えばよい
            [void][System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel)
        }
    }
#endregion

#メイン処理
#region main
    
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
        Description = 'チェック対象ファイルがあるフォルダを選択してください。'
    }

    if($FolderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK){
        #[System.Windows.MessageBox]::Show('選択したフォルダ：' + $FolderBrowser.SelectedPath)
    }else{
        LoggerInfo 'フォルダは選択されませんでしたので処理を終了します。'
        pause
        return
    }
    
    LoggerInfo "処理を開始します。"
    #ファイル一覧を取得する
    $DIRFILE = dir -Recurse -File $FolderBrowser.SelectedPath
    $Files = ${DIRFILE}.fullname
    
    #ファイルを1件ずつ処理をしていく
    foreach($File in $Files)
    {
        #拡張子を取得
        $Extension = [System.IO.Path]::GetExtension("$File")
        #ファイルの中身をチェックしていく（拡張子によりチェック処理の内容は変わる）
        if ($Extension -match $ExcelFileExtensions)
        {
            OpenExcelFile $File
        } elseif ($Extension -match $TextFileExtensions)
        {
            OpenTextFile $File
        } else {
            LoggerInfo $Extension'の拡張子は未対応です。'
        }
    }
    
    if ($checkResults.Count -eq '0') {
        LoggerInfo '処理結果が0件のため処理結果ファイルを出力しません。'
    } else {
        #エラー結果をCSVファイルに記入していく
        $FileName = 'CheckResult_'+(Get-Date).ToString("yyyyMMddHHmm")+'.csv'
        OutputCsvFile $FileName
    }
    LoggerInfo '処理が終了しました。'
    pause
#endregion

