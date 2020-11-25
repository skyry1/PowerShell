# 仕様として、dll の参照追加よりも、using 名前空間の方を先に記載しなくちゃいけない
using namespace System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ビジュアルスタイルを適用（未記載の場合クラシック形式の表示）
# [Application]::EnableVisualStyles()

# ラベル
#region Label
	$lbl1 = New-Object Label
	$lbl1.Text = "検索日付:"
	$lbl1.Location = "15, 30"
	$lbl1.AutoSize = $True
    
	$lbl2 = New-Object Label
	$lbl2.Text = "起動:"
	$lbl2.Location = "15, 60"
	$lbl2.AutoSize = $True

	$lbl3 = New-Object Label
	$lbl3.Text = "ログイン:"
	$lbl3.Location = "15, 90"
	$lbl3.AutoSize = $True

	$lbl4 = New-Object Label
	$lbl4.Text = "ログオフ:"
	$lbl4.Location = "15, 120"
	$lbl4.AutoSize = $True

	$lbl5 = New-Object Label
	$lbl5.Text = "シャットダウン:"
	$lbl5.Location = "15, 150"
	$lbl5.AutoSize = $True
#endregion

# 入力欄
#region Date 
    $Date = New-Object System.Windows.Forms.DatetimePicker
    $Date.location = "100,30"
    $Date.Format = "Long"
	$Date.AutoSize = $True
    $Date.Width = 150
#endregion

# 出力欄
#region TextBox
    $txt1 = New-Object TextBox
    $txt1.location = "100,60"
    $txt1.Width = 100

    $txt2 = New-Object TextBox
    $txt2.location = "100,90"
    $txt2.Width = 100

    $txt3 = New-Object TextBox
    $txt3.location = "100,120"
    $txt3.Width = 100

    $txt4 = New-Object TextBox
    $txt4.location = "100,150"
    $txt4.Width = 100

    $txtTemp = New-Object TextBox
#endregion

# 確認ボタン
#region Button
	$btn = New-Object Button
	$btn.Text = "確認"
	$btn.Size = "150, 40"
	$btn.Location = "100, 180"
	$btn.AutoSize = $True
#endregion

# ボタンのクリック
$button_Click = {    
    #検索結果格納
    $txt1.Text = getEventLog(6005)
    $txt2.Text = getEventLog(7001)
    $txt3.Text = getEventLog(7002)
    $txt4.Text = getEventLog(6006)
}
$btn.Add_Click($button_Click)


function getEventLog($eventId)
{
    $replace = "@{TimeGenerated="+$Date.Value.Month+"/"+$Date.Value.Day+"/"+$Date.Value.Year+" "    
    $before = $Date.Value.Date + " 23:59:59"
    $after = $Date.Value.Date + " 00:00:00"
    $txtTemp.Text = ""
    try
    {
        $eventLog = GET-EVENTLog System -After $after -before $before| Where-Object{$_.EventId -eq $eventId} | select-Object TimeGenerated
        If(($eventId -eq "6005") -or ($eventId -eq "7001"))
        {
            $length = $eventLog.Length
            $txtTemp.Text = $eventLog[$length - 1]
        }
        Else {
            $txtTemp.Text = $eventLog[0]
        }
        $txtTemp.Text = $txtTemp.Text.Replace($replace,"").Replace("}","")
    }
    catch
    {
        Write-host $eventId"でエラー"
    }
    return $txtTemp.Text
}

# フォーム
#region Form
	$f = New-Object Form
	$f.Text = "起動から終了まで"
	$f.Size = "330, 270"
    $f.MaximumSize  =$f.Size
    $f.MinimumSize  =$f.Size
    $f.MaximizeBox = $false
    $f.MinimizeBox = $false
    $f.StartPosition = "CenterScreen"
    $f.Controls.AddRange(@($lbl1,$lbl2,$lbl3,$lbl4,$lbl5,$Date,$txt1,$txt2,$txt3,$txt4,$btn))
    $f.ShowDialog()
#endregion