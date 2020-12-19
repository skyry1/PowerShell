using namespace System.Windows.Forms

# フォーム情報
#region designer
    $form = New-Object Form
    $form.Text = "正規表現チェッカー(Made with powershell)"
    $form.Size = "600, 250"
    $form.MaximumSize  =$form.Size
    $form.MinimumSize  =$form.Size
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.StartPosition = "CenterScreen"
    
    $lbl1 = New-Object Label
    $lbl1.Text = "検索文字列:"
    $lbl1.Location = "15, 30"

    $lbl2 = New-Object Label
    $lbl2.Text = "置換前:"
    $lbl2.Location = "15, 60"

    $lbl3 = New-Object Label
    $lbl3.Text = "置換後:"
    $lbl3.Location = "15, 90"

    $lbl4 = New-Object Label
    $lbl4.Text = "置換結果:"
    $lbl4.Location = "15, 120"
    
    #検索文字列
    $txt1 = New-Object TextBox
    $txt1.location = "125,30"
    $txt1.Width = 450

    #置換前
    $txt2 = New-Object TextBox
    $txt2.location = "125,60"
    $txt2.Width = 450

    #置換後
    $txt3 = New-Object TextBox
    $txt3.location = "125,90"
    $txt3.Width = 450

    #置換結果
    $txt4 = New-Object TextBox
    $txt4.location = "125,120"
    $txt4.Width = 450

    $btn = New-Object Button
    $btn.Text = "確認"
    $btn.Size = "150, 40"
    $btn.Location = "125, 150"

    $btn2 = New-Object Button
    $btn2.Text = "クリア"
    $btn2.Size = "150, 40"
    $btn2.Location = "300, 150"

    $form.Controls.AddRange(@($lbl1,$lbl2,$lbl3,$lbl4,$txt1,$txt2,$txt3,$txt4,$btn,$btn2))
#endregion

# ボタンのクリック処理
#region designer
$button_Click = {
    #マウスカーソル：待機状態
    [System.Windows.Forms.Cursor]::Current = [System.Windows.Forms.Cursors]::WaitCursor

    #正規表現実行
    $txt4.Text = [regex]::Replace($txt1.Text, $txt2.Text, $txt3.Text)

    #マウスカーソル：デフォルト
    [System.Windows.Forms.Cursor]::Current = [System.Windows.Forms.Cursors]::Default
}
$button_Click2 = {
    #マウスカーソル：待機状態
    [System.Windows.Forms.Cursor]::Current = [System.Windows.Forms.Cursors]::WaitCursor

    #正規表現実行
    $txt1.Text = ""
    $txt2.Text = ""
    $txt3.Text = ""
    $txt4.Text = ""

    #マウスカーソル：デフォルト
    [System.Windows.Forms.Cursor]::Current = [System.Windows.Forms.Cursors]::Default
}
$btn.Add_Click($button_Click)
$btn2.Add_Click($button_Click2)
#endregion

# スタートアップ処理
#region startup
    $form.ShowDialog()
#endregion