using namespace System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms

# 変数一覧
#region global
    $ClipText = [Windows.Forms.Clipboard]::GetText()
    $BeforeClipText = [Windows.Forms.Clipboard]::GetText()
    $OutFile = (Get-Date).ToString("yyyyMMdd")+".csv"
#endregion

# 処理
#region logic
    
    # 無限ループ
    while ($true) {
        
        # クリップボードの値を取得
        $ClipText = [Windows.Forms.Clipboard]::GetText()

        # クリップボードの値を書き込み
        If ($BeforeClipText -ne $ClipText) {
            $BeforeClipText = $ClipText

            #出力用に編集
            $Record = (Get-Date).ToString("yyyyMMddHHmmsss")+","+$ClipText.Replace("`n","　")

            # ファイル書き込み
            $Record | Add-Content $OutFile -Encoding Default
        }
        # 1秒スリープ
        Start-Sleep -Seconds 1
    }

#endregion