$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
$counter = 0
$timeout = new-timespan -Minutes 1
while ($stopwatch.elapsed -lt $timeout)
{
    $counter++;
    Write-Host "Increasing counter:" $counter
    start-sleep -Seconds 30
}

Write-Host "Finishing..." $counter
$stopwatch.Stop()
$stopwatch