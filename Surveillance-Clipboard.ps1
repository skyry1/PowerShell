using namespace System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms

# �ϐ��ꗗ
#region global
    $ClipText = [Windows.Forms.Clipboard]::GetText()
    $BeforeClipText = [Windows.Forms.Clipboard]::GetText()
    $OutFile = (Get-Date).ToString("yyyyMMdd")+".csv"
#endregion

# ����
#region logic
    
    # �������[�v
    while ($true) {
        
        # �N���b�v�{�[�h�̒l���擾
        $ClipText = [Windows.Forms.Clipboard]::GetText()

        # �N���b�v�{�[�h�̒l����������
        If ($BeforeClipText -ne $ClipText) {
            $BeforeClipText = $ClipText

            #�o�͗p�ɕҏW
            $Record = (Get-Date).ToString("yyyyMMddHHmmsss")+","+$ClipText.Replace("`n","�@")

            # �t�@�C����������
            $Record | Add-Content $OutFile -Encoding Default
        }
        # 1�b�X���[�v
        Start-Sleep -Seconds 1
    }

#endregion