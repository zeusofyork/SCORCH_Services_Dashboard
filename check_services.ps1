$servers = @("Hostname1", "Hostname2")  # List of SCORCH server hostnames
$services = @("ServiceName1", "ServiceName2")  # List of SCORCH services

$statusResults = @()

# Function to check service status
foreach ($service in $services) {
    $serviceStatus = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($serviceStatus.Status -eq "Running") {
        $statusResults += @{Service = $service; Status = "Up"}
    } else {
        $statusResults += @{Service = $service; Status = "Down"}
    }
}

# Function to ping the servers
foreach ($server in $servers) {
    if (Test-Connection -ComputerName $server -Count 1 -Quiet) {
        $statusResults += @{Server = $server; Status = "Up"}
    } else {
        $statusResults += @{Server = $server; Status = "Down"}
    }
}

$statusResults | ConvertTo-Json
