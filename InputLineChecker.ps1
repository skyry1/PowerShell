Add-Type -AssemblyName System.Windows.Forms

#�G���[�`�F�b�N�p�ϐ�
$ErroeStrs = @('�p�[�X'
                ,'�f�^')
$ErrorMsgs = @('�p�[�X�͕s�K�؂ł��B�p�X�ɏC�����Ă��������B'
                ,'�f�^�͕s�K�؂ł��B�f�[�^�ɏC�����Ă��������B')

#�����T�v
#region Readme
#���O����
#powershell�̎��s�|���V�[��ύX
#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

#��������
#�@��������t�@�C���p�X�𒊏o����
#�A�t�@�C�����P���J���Ă���
#�B�t�@�C���̒��g��1�s���`�F�b�N���A�`�F�b�N���ʂ�z��Ɋi�[���Ă���
#�C�܂��t�@�C�����c���Ă�����A�ɖ߂�
#�D�`�F�b�N���ʂ�CSV�t�@�C���ɏo�͂���
#endregion

#�O���[�o���ϐ��ꗗ
#region GlobalVariable
    #�G���[�`�F�b�N�p�g���q
    $ExcelFileExtensions = 'xls'
    $TextFileExtensions = 'txt|java'
    
    #�`�F�b�N���ʊi�[�p�z��
    $checkResults = New-Object System.Collections.Generic.List[string]
#endregion

#Funcion�L�ډӏ�
#region Funcions
    function LoggerInfo($msg){
        Write-Host "[INFO]:$msg"
    }
    function LoggerWarn($msg){
        Write-Host "[WARN]:$msg" -ForegroundColor yellow 
    }
        
    function LoggerError($msg){
        Write-Host "[ERROR]:$msg" -ForegroundColor red
    }

    #CSV�t�@�C���o��
    function OutputCsvFile($FileName) {
        LoggerInfo $FileName'���o�͂��܂��B'
        #�w�b�_�[�o��
        "No,�t�@�C��,�s�ԍ�,�w�E���e"| Out-File $FileName -append  -encoding Default
        $i=1
        #���R�[�h��������
        foreach($checkResult in $checkResults) {
            $msg = [string]$i+','+$checkResult
            #-encoding Default��SJIS��������
            try
            {
                $msg | Out-File $FileName -append  -encoding Default
            } catch {
                LoggerError $FileName'�̏������݂Ɏ��s���܂����B'
                LoggerError '�������݂𒆒f���������I�����܂��B'
                return
            }
            $i++
        }
    }
    
    #�e�L�X�g�t�@�C���`�F�b�N
    function OpenTextFile($File){
        
        #�e�L�X�g�t�@�C���̑S�s��ǂݍ���
        $Lines = (Get-Content $File) -as [string[]]
        $LineCount=1
    
        #1�s���`�F�b�N���Ă���
        foreach ($Line in $Lines) {
            $j=0
            foreach ($ErroeStr in $ErroeStrs) {
                if($Line.Contains($ErroeStr)) {
                    $checkResult = $File +',' +$LineCount +'�s��,' +$ErrorMsgs[$j]
                    $checkResults.add($checkResult)
                }
                $j++
            }
            $LineCount++
        }
    }

    #Excel�t�@�C���`�F�b�N
    function OpenExcelFile($File){
        # Excel�I�u�W�F�N�g�쐬
        $excel = New-Object -ComObject Excel.Application
        $book = $null
        try{
            # ��ʕ\�����Ȃ�
            $excel.Visible = $false

            # Excel�u�b�N���J��
            $book = $excel.Workbooks.Open($File)
        } catch {
            LoggerError $File'�̑���Ɏ��s���܂����B'
        } finally {
            # Excel�u�b�N�����
            if ($book -ne $null) {
                [void]$book.Close($false)
                [void][System.Runtime.Interopservices.Marshal]::ReleaseComObject($book)
            }

            # Excel�̏I��
            [void]$excel.Quit()

            # �I�u�W�F�N�g�̊J��
            # Application��Book�ɑ΂��čs���΂悢
            [void][System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel)
        }
    }
#endregion

#���C������
#region main
    
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
        Description = '�`�F�b�N�Ώۃt�@�C��������t�H���_��I�����Ă��������B'
    }

    if($FolderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK){
        #[System.Windows.MessageBox]::Show('�I�������t�H���_�F' + $FolderBrowser.SelectedPath)
    }else{
        LoggerInfo '�t�H���_�͑I������܂���ł����̂ŏ������I�����܂��B'
        pause
        return
    }
    
    LoggerInfo "�������J�n���܂��B"
    #�t�@�C���ꗗ���擾����
    $DIRFILE = dir -Recurse -File $FolderBrowser.SelectedPath
    $Files = ${DIRFILE}.fullname
    
    #�t�@�C����1�������������Ă���
    foreach($File in $Files)
    {
        #�g���q���擾
        $Extension = [System.IO.Path]::GetExtension("$File")
        #�t�@�C���̒��g���`�F�b�N���Ă����i�g���q�ɂ��`�F�b�N�����̓��e�͕ς��j
        if ($Extension -match $ExcelFileExtensions)
        {
            LoggerWarn $Extension'�̊g���q�͎������ł��B'
            OpenExcelFile $File
        } elseif ($Extension -match $TextFileExtensions)
        {
            OpenTextFile $File
        } else {
            LoggerInfo $Extension'�̊g���q�͖��Ή��ł��B'
        }
    }
    
    #�G���[���ʂ�CSV�t�@�C���ɋL�����Ă���
    $FileName = 'CheckResult_'+(Get-Date).ToString("yyyyMMddHHmm")+'.csv'
    OutputCsvFile $FileName
    LoggerInfo '�������I�����܂����B'
#endregion

