#対象ディレクトリ(第1引数で受け取る)
$dir = $Args[0]

#サブフォルダ含め削除
$itemList = Get-ChildItem $dir -Recurse
foreach($item in $itemList)
{
    if($item.Name -eq "削除したいファイル名")
    {
        #ファイル削除
        Remove-Item $item.FullName
    }
} 