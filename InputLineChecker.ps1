Add-Type -AssemblyName System.Windows.Forms

#エラーチェック用変数
$ErroeStrs = @('パース'
                ,'デタ')
$ErrorMsgs = @('パースは不適切です。パスに修正してください。'
                ,'デタは不適切です。データに修正してください。')

#処理概要
#region Readme
#事前準備
#powershellの実行ポリシーを変更
#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

#処理順序
#①引数からファイルパスを抽出する
#②ファイルを１つずつ開いていく
#③ファイルの中身を1行ずつチェックし、チェック結果を配列に格納していく
#④まだファイルが残っていたら②に戻る
#⑤チェック結果をCSVファイルに出力する
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
            $book = $excel.Workbooks.Open($File)
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
            LoggerWarn $Extension'の拡張子は実装中です。'
            OpenExcelFile $File
        } elseif ($Extension -match $TextFileExtensions)
        {
            OpenTextFile $File
        } else {
            LoggerInfo $Extension'の拡張子は未対応です。'
        }
    }
    
    #エラー結果をCSVファイルに記入していく
    $FileName = 'CheckResult_'+(Get-Date).ToString("yyyyMMddHHmm")+'.csv'
    OutputCsvFile $FileName
    LoggerInfo '処理が終了しました。'
#endregion

