#�Ώۃf�B���N�g��(��1�����Ŏ󂯎��)
$dir = $Args[0]

#�T�u�t�H���_�܂ߍ폜
$itemList = Get-ChildItem $dir -Recurse
foreach($item in $itemList)
{
    if($item.Name -eq "�폜�������t�@�C����")
    {
        #�t�@�C���폜
        Remove-Item $item.FullName
    }
} 