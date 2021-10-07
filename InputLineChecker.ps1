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
        Write-Host "[INFO]:$msg" -ForegroundColor yellow
    }
    
    function LoggerError($msg){
        Write-Host "[INFO]:$msg" -ForegroundColor red
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
#endregion

#メイン処理
#region main
    if([string]::IsNullorEmpty($Args[0]))
    {
        LoggerError "引数が指定されていません"
        pause
        return
    }
    
    LoggerInfo "処理を開始します。"
    #ファイル一覧を取得する
    $DIRFILE = dir -Recurse -File $Args[0]
    $Files = ${DIRFILE}.fullname
    
    #ファイルを1件ずつ処理をしていく
    foreach($File in $Files)
    {
        #拡張子を取得
        $Extension = [System.IO.Path]::GetExtension("$File")
        #ファイルの中身をチェックしていく（拡張子によりチェック処理の内容は変わる）
        if ($Extension -match $ExcelFileExtensions)
        {
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

