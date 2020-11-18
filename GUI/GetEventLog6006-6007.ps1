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
    $Date.Width = 150
#endregion

# �o�͗�
#region TextBox
    $txt1 = New-Object TextBox
    $txt1.location = "100,60"
    $txt1.Width = 100

    $txt2 = New-Object TextBox
    $txt2.location = "100,90"
    $txt2.Width = 100
#endregion

# �m�F�{�^��
#region Button
	$btn = New-Object Button
	$btn.Text = "�m�F"
	$btn.Size = "150, 40"
	$btn.Location = "100, 120"
	$btn.AutoSize = $True
#endregion

# �{�^���̃N���b�N
$button_Click = {
    
    #������
    $txt1.Text = ""
    $txt2.Text = ""
    
    #$str = GET-EVENTLog System -After "2020/01/18 12:00:00" -Newest 1| Where-Object{$_.EventId -eq 6005} | select-Object TimeGenerated
    $before = $Date.Value.Date + " 23:59:59"
    $after = $Date.Value.Date + " 00:00:00"
    $replace = "@{TimeGenerated="+$Date.Value.Month+"/"+$Date.Value.Day+"/"+$Date.Value.Year+" "
    Write-Host $before
    Write-Host $after
    Write-Host $replace
    try
    {
        $result1 = GET-EVENTLog System -After $after -before $before| Where-Object{$_.EventId -eq 6005 -or $_.EventId -eq 7001} | select-Object TimeGenerated
        $rs1 = $result1.Length
        write-host $result1
        Write-Host $rs1
        $txt1.Text = $result1[$rs1 - 1]
        $txt1.Text = $txt1.Text.Replace($replace,"").Replace("}","")
    }
    catch
    {
    }

    try
    {
        $result2 = GET-EVENTLog System -After $after -before $before| Where-Object{$_.EventId -eq 6006 -or $_.EventId -eq 7002} | select-Object TimeGenerated
        write-host $result2
        $txt2.Text = $result2[0]
        $txt2.Text = $txt2.Text.Replace($replace,"").Replace("}","")
    }
    catch
    {
    }
}
$btn.Add_Click($button_Click)

# �t�H�[��
#region Form
	$f = New-Object Form
	$f.Text = "6005(7001)-6006(7002)"
	$f.Size = "330, 220"
    $f.MaximumSize  =$f.Size
    $f.MinimumSize  =$f.Size
    $f.MaximizeBox = $false
    $f.MinimizeBox = $false
    $f.StartPosition = "CenterScreen"
    $f.Controls.AddRange(@($lbl1,$lbl2,$lbl3,$Date,$txt1,$txt2,$btn))
    $f.ShowDialog()
#endregion