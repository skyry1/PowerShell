# ���܂��Ȃ�
using namespace System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# �t�H�[�����
#region designer
    
    # �t�H���g�̐ݒ�
    $Font = New-Object System.Drawing.Font("���C���I",8)

    $form = New-Object Form
    $form.FormBorderStyle = "FixedToolWindow"
    $form.Text = "�o�b�`�ꗗ(Made with powershell)"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.StartPosition = "CenterScreen"
    $form.Size = "550, 125"

    $CheckedBox = New-Object CheckBox
    $CheckedBox.Text = "�Ǘ��Ҍ����Ŏ��s"
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
            #bat�t�@�C���̂�
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
                     # �Ǘ��Ҍ����Ŏ��s
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

# �X�^�[�g�A�b�v����
#region startup
    Form_Load
    $form.ShowDialog()
#endregion