#�f�B���N�g��
$dir = $Args[0]

#�u���O����
$target = "�y���r���[�z"

#�u���㕶��
$replace = ""

$itemList = Get-ChildItem $dir
foreach($item in $itemList)
{
    if(-not $item.PSIsContainer)
    {
        #�t�@�C�����ύX
        Get-ChildItem $item.FullName | Rename-Item -NewName { $_.Name -replace $target,$replace }
    }
} 