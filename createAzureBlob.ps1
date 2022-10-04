param(
	[string]$storageAccountName,
	[string]$storageContainerName,
	[string]$blobSAStoken,
	[string]$filename,
	[string]$body
)

$headerDate = '2021-08-06'
$Url = "https://$($storageAccountName).blob.core.windows.net/$($storageContainerName)/$($filename)?$($blobSAStoken)"
$xmsdate = (get-date -format r).ToString()

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("x-ms-date", $xmsdate)
$headers.Add("x-ms-version", $headerDate)
$headers.Add("x-ms-blob-type", "BlockBlob")
$headers.Add("Content-Type", "application/json")

Invoke-RestMethod $Url -Method 'PUT' -Headers $headers -Body $body
