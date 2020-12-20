# おまじない
using namespace System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# フォーム情報
#region designer
    
    # フォントの設定
    $Font = New-Object System.Drawing.Font("メイリオ",8)

    $form = New-Object Form
    $form.FormBorderStyle = "FixedToolWindow"
    $form.Text = "バッチ一覧(Made with powershell)"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.StartPosition = "CenterScreen"
    $form.Size = "550, 125"

    $CheckedBox = New-Object CheckBox
    $CheckedBox.Text = "管理者権限で実行"
    $CheckedBox.size ="250,22" 
    $CheckedBox.Location = "10, 5"
    $CheckedBox.Checked = $True
    $CheckedBox.font = $Font
    $form.Controls.Add($CheckedBox)

    function Form_Load
    {
        $x = 25
        $y = 30
        $i = 1
        $itemList = Get-ChildItem $dir -Recurse
        foreach($item in $itemList)
        {
            #batファイルのみ
            if($item.Extension -eq ".bat")
            {
                $btn = New-Object Button
                $btn.Size = "150, 40"
                $btn.font = $Font
                $btn.Text = $item.BaseName
                $btn.Tag = $item.FullName
                $btn.Location = "$x,$y"
                if($i % 3 -eq 0)
                {
                    $x = 25
                    $y += 50
                    $form.Height += 30
                } else 
                {
                    $x += 175
                }
                $btn.Add_Click({
                     # 管理者権限で実行
                     If($CheckedBox.Checked)
                     {
                        Start-Process -FilePath $this.Tag -Verb runas
                     }
                     else
                     {
                        Start-Process -FilePath $this.Tag
                     }
                     
                })
                $form.Controls.Add($btn)
                $i += 1
            }
        }
        $form.MaximumSize  =$form.Size
        $form.MinimumSize  =$form.Size
    }
#endregion

# スタートアップ処理
#region startup
    Form_Load
    $form.ShowDialog()
#endregion