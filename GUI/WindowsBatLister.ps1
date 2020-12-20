# ���܂��Ȃ�
using namespace System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# �t�H�[�����
#region designer

    # �J�����g�f�B���N�g��
    $scriptPath = Get-Location
    
    # �t�H���g�̐ݒ�
    $Font = New-Object System.Drawing.Font("���C���I",8)

    # �t�H�[��
    $form = New-Object Form
    $form.Text = "�o�b�`�ꗗ($scriptPath)"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.StartPosition = "CenterScreen"
    $form.Size = "565, 150"
    $form.font = $Font

    # �`�F�b�N�{�b�N�X
    $CheckedBox = New-Object CheckBox
    $CheckedBox.Text = "�Ǘ��Ҍ����Ŏ��s"
    $CheckedBox.size ="150,22" 
    $CheckedBox.Location = "5, 5"
    $CheckedBox.Checked = $True
    $CheckedBox.font = $Font
    $form.Controls.Add($CheckedBox)

    function Form_Load
    {
        $LocationX = 25
        $LocationY = 30
        $i = 1        

        # �T�u�t�H���_�܂܂Ȃ�
        #$itemList = Get-ChildItem $dir
        # �T�u�t�H���_�܂�
        $itemList = Get-ChildItem $dir -Recurse
        foreach($item in $itemList)
        {
            #bat�t�@�C���̂�
            if($item.Extension -eq ".bat")
            {
                $btn = New-Object Button
                $btn.font = $Font
                $btn.Text = $item.BaseName
                $btn.Tag = $item.FullName
                $btn.Size = "150, 50"
                $btn.Location = "$LocationX,$LocationY"

                #3�{�^����ݒu�����玟�̍s��
                if($i % 3 -eq 0)
                {
                    $LocationX = 25
                    $LocationY += $btn.height + 25
                    $form.Height += $btn.height + 25
                } else 
                {
                    $LocationX += $btn.Width + 25
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
        $form.MaximumSize = $form.Size
        $form.MinimumSize = $form.Size
    }
#endregion

# �X�^�[�g�A�b�v����
#region startup
    Form_Load
    $form.ShowDialog()
#endregion