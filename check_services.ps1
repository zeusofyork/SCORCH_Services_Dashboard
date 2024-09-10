$services = @("ServiceName1", "ServiceName2") # Replace with SCORCH service names
$statusResults = @()

foreach ($service in $services) {
    $serviceStatus = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($serviceStatus.Status -eq "Running") {
        $statusResults += @{Service = $service; Status = "Up"}
    } else {
        $statusResults += @{Service = $service; Status = "Down"}
    }
}

$statusResults | ConvertTo-Json
