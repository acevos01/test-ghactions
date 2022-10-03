param(
	[string]$storageAccountName,
	[string]$storageContainerName,
	[string]$storageAccountKey,
	[string]$filename,
	[string]$body
)

$method = "PUT"
$headerDate = '2021-08-06'
$headers = @{"x-ms-version"="$headerDate"}
#$storageAccountName = "<your account name>"
#$storageContainerName = "etl"
#$storageAccountKey = "<your account key>"
$Url = "https://$storageAccountName.blob.core.windows.net/$storageContainerName/$filename"
#$body = "Hello world"
$xmsdate = (get-date -format r).ToString()
$headers.Add("x-ms-date",$xmsdate)
$bytes = ([System.Text.Encoding]::UTF8.GetBytes($body))
$contentLength = $bytes.length
$headers.Add("Content-Length","$contentLength")
$headers.Add("x-ms-blob-type","BlockBlob")

$signatureString = "$method$([char]10)$([char]10)$([char]10)$contentLength$([char]10)$([char]10)$([char]10)$([char]10)$([char]10)$([char]10)$([char]10)$([char]10)$([char]10)"
#Add CanonicalizedHeaders
$signatureString += "x-ms-blob-type:" + $headers["x-ms-blob-type"] + "$([char]10)"
$signatureString += "x-ms-date:" + $headers["x-ms-date"] + "$([char]10)"
$signatureString += "x-ms-version:" + $headers["x-ms-version"] + "$([char]10)"
#Add CanonicalizedResource
$uri = New-Object System.Uri -ArgumentList $url
$signatureString += "/" + $storageAccountName + $uri.AbsolutePath

$dataToMac = [System.Text.Encoding]::UTF8.GetBytes($signatureString)

$accountKeyBytes = [System.Convert]::FromBase64String($storageAccountKey)

$hmac = new-object System.Security.Cryptography.HMACSHA256((,$accountKeyBytes))
$signature = [System.Convert]::ToBase64String($hmac.ComputeHash($dataToMac))

$headers.Add("Authorization", "SharedKey " + $storageAccountName + ":" + $signature);
write-host -fore green $signatureString
Invoke-RestMethod -Uri $Url -Method $method -headers $headers -Body $body -SkipHeaderValidation