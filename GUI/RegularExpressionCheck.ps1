using namespace System.Windows.Forms

# �t�H�[�����
#region designer
    $form = New-Object Form
    $form.Text = "���K�\���`�F�b�J�[(Made with powershell)"
    $form.Size = "600, 250"
    $form.MaximumSize  =$form.Size
    $form.MinimumSize  =$form.Size
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.StartPosition = "CenterScreen"
    
    $lbl1 = New-Object Label
    $lbl1.Text = "����������:"
    $lbl1.Location = "15, 30"

    $lbl2 = New-Object Label
    $lbl2.Text = "�u���O:"
    $lbl2.Location = "15, 60"

    $lbl3 = New-Object Label
    $lbl3.Text = "�u����:"
    $lbl3.Location = "15, 90"

    $lbl4 = New-Object Label
    $lbl4.Text = "�u������:"
    $lbl4.Location = "15, 120"
    
    #����������
    $txt1 = New-Object TextBox
    $txt1.location = "125,30"
    $txt1.Width = 450

    #�u���O
    $txt2 = New-Object TextBox
    $txt2.location = "125,60"
    $txt2.Width = 450

    #�u����
    $txt3 = New-Object TextBox
    $txt3.location = "125,90"
    $txt3.Width = 450

    #�u������
    $txt4 = New-Object TextBox
    $txt4.location = "125,120"
    $txt4.Width = 450

    $btn = New-Object Button
    $btn.Text = "�m�F"
    $btn.Size = "150, 40"
    $btn.Location = "125, 150"

    $btn2 = New-Object Button
    $btn2.Text = "�N���A"
    $btn2.Size = "150, 40"
    $btn2.Location = "300, 150"

    $form.Controls.AddRange(@($lbl1,$lbl2,$lbl3,$lbl4,$txt1,$txt2,$txt3,$txt4,$btn,$btn2))
#endregion

# �{�^���̃N���b�N����
#region designer
$button_Click = {
    #�}�E�X�J�[�\���F�ҋ@���
    [System.Windows.Forms.Cursor]::Current = [System.Windows.Forms.Cursors]::WaitCursor

    #���K�\�����s
    $txt4.Text = [regex]::Replace($txt1.Text, $txt2.Text, $txt3.Text)

    #�}�E�X�J�[�\���F�f�t�H���g
    [System.Windows.Forms.Cursor]::Current = [System.Windows.Forms.Cursors]::Default
}
$button_Click2 = {
    #�}�E�X�J�[�\���F�ҋ@���
    [System.Windows.Forms.Cursor]::Current = [System.Windows.Forms.Cursors]::WaitCursor

    #���K�\�����s
    $txt1.Text = ""
    $txt2.Text = ""
    $txt3.Text = ""
    $txt4.Text = ""

    #�}�E�X�J�[�\���F�f�t�H���g
    [System.Windows.Forms.Cursor]::Current = [System.Windows.Forms.Cursors]::Default
}
$btn.Add_Click($button_Click)
$btn2.Add_Click($button_Click2)
#endregion

# �X�^�[�g�A�b�v����
#region startup
    $form.ShowDialog()
#endregion