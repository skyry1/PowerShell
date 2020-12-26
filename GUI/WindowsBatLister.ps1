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
    $CheckedBox.size ="200,22" 
    $CheckedBox.Location = "5, 5"
    $CheckedBox.Checked = $True
    $CheckedBox.font = $Font
    $form.Controls.Add($CheckedBox)

    function Form_Load
    {
        $LocationX = 25
        $LocationY = 30
        $i = 1        
        $batNum = 0

        # �T�u�t�H���_�܂܂Ȃ�
        #$itemList = Get-ChildItem $dir
        # �T�u�t�H���_�܂�
        $itemList = Get-ChildItem $dir -Recurse
        foreach($item in $itemList)
        {
            #bat,cmd�t�@�C���̂�
            if($item.Extension -eq ".bat" -or $item.Extension -eq ".cmd")
            {
                #���O����t�@�C��
                if($item.Name -eq "")
                {
                    continue
                }

                $btn = New-Object Button
                $btn.font = $Font
                #�{�^�����͒u���\
                $btn.Text =  [regex]::Replace($item.BaseName, "�Z�Z�V�X�e��", "")
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
                $batNum += 1
            }
        }
        If ($batNum -eq 0)
        {
            [System.Windows.Forms.MessageBox]::Show("BAT/CMD�t�@�C�������݂��Ȃ����ߏI�����܂��B", "���", "OK", "None")
        } else {
            $form.MaximumSize = $form.Size
            $form.MinimumSize = $form.Size
            $form.ShowDialog()
        }
    }
#endregion

# �X�^�[�g�A�b�v����
#region startup
    Form_Load

#endregion