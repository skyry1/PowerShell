# �d�l�Ƃ��āAdll �̎Q�ƒǉ������Ausing ���O��Ԃ̕����ɋL�ڂ��Ȃ����Ⴂ���Ȃ�
using namespace System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# �r�W���A���X�^�C����K�p�i���L�ڂ̏ꍇ�N���V�b�N�`���̕\���j
[Application]::EnableVisualStyles()

# ���x��
#region Label
	$lbl1 = New-Object Label
	$lbl1.Text = "�������t:"
	$lbl1.Location = "15, 30"
	$lbl1.AutoSize = $True
    
	$lbl2 = New-Object Label
	$lbl2.Text = "�J�n����:"
	$lbl2.Location = "15, 60"
	$lbl2.AutoSize = $True

	$lbl3 = New-Object Label
	$lbl3.Text = "�I������:"
	$lbl3.Location = "15, 90"
	$lbl3.AutoSize = $True
#endregion

# ���͗�
#region Date 
    $Date = New-Object System.Windows.Forms.DatetimePicker
    $Date.location = "100,30"
    $Date.Format = "Long"
	$Date.AutoSize = $True
#endregion

# �o�͗�
#region TextBox
    $txt1 = New-Object TextBox
    $txt1.location = "100,60"
    $txt1.Width = 200

    $txt2 = New-Object TextBox
    $txt2.location = "100,90"
    $txt2.Width = 200
#endregion

# �m�F�{�^��
#region Button
	$btn = New-Object Button
	$btn.Text = "�m�F"
	$btn.Size = "150, 40"
	$btn.Location = "150, 130"
	$btn.AutoSize = $True
#endregion

# �{�^���̃N���b�N
$button_Click = {
    #$str = GET-EVENTLog System -After "2020/01/18 12:00:00" -Newest 1| Where-Object{$_.EventId -eq 6005} | select-Object TimeGenerated    
    $today = Get-Date -Format "MM/dd/yyyy"
    try
    {
        $txt1.Text = GET-EVENTLog System -After $Date.Value.Date| Where-Object{$_.EventId -eq 6005} | select-Object TimeGenerated
        $txt1.Text = $txt1.Text.Replace("@{TimeGenerated="+$today+" ","").Replace("}","")
    }
    catch
    {
    }

    try
    {
        $txt2.Text = GET-EVENTLog System -After $Date.Value.Date| Where-Object{$_.EventId -eq 6006} | select-Object TimeGenerated
        $txt2.Text = $txt2.Text.Replace("@{TimeGenerated="+$today+" ","").Replace("}","")
    }
    catch
    {
    }
}
$btn.Add_Click($button_Click)

# �t�H�[��
#region Form
	$f = New-Object Form
	$f.Text = "�V�X�e���C�x���g���O6006-6007�擾"
	$f.Size = "400, 230"
    $f.MaximizeBox = $false
    $f.MinimizeBox = $false
    $f.StartPosition = "CenterScreen"
    $f.Controls.AddRange(@($lbl1,$lbl2,$lbl3,$Date,$txt1,$txt2,$btn))
    $f.ShowDialog()
#endregion