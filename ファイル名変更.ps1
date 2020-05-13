#ディレクトリ
$dir = $Args[0]

#置換前文字
$target = "【レビュー】"

#置換後文字
$replace = ""

$itemList = Get-ChildItem $dir
foreach($item in $itemList)
{
    if(-not $item.PSIsContainer)
    {
        #ファイル名変更
        Get-ChildItem $item.FullName | Rename-Item -NewName { $_.Name -replace $target,$replace }
    }
} 