# List of SCORCH servers and their corresponding services
$servers = @("Server1", "Server2")  # Replace with actual SCORCH server names
$services = @("OrchestratorRunbookService", "OrchestratorManagementService")  # Replace with actual SCORCH service names
$statusResults = @()

# Loop through each server
foreach ($server in $servers) {
    
    # Test if the server is reachable (optional but recommended)
    if (Test-Connection -ComputerName $server -Count 1 -Quiet) {
        # Loop through each service and check its status on the remote server
        foreach ($service in $services) {
            try {
                # Get the service status on the remote server
                $serviceStatus = Get-Service -Name $service -ComputerName $server -ErrorAction Stop
                if ($serviceStatus.Status -eq "Running") {
                    $statusResults += @{
                        Server = $server
                        Service = $service
                        Status = "Up"
                    }
                } else {
                    $statusResults += @{
                        Server = $server
                        Service = $service
                        Status = "Down"
                    }
                }
            } catch {
                # If there's an error, such as the service not existing or server unreachable
                $statusResults += @{
                    Server = $server
                    Service = $service
                    Status = "Service Not Found or Error"
                }
            }
        }
    } else {
        # If the server is not reachable, add an entry to indicate that
        foreach ($service in $services) {
            $statusResults += @{
                Server = $server
                Service = $service
                Status = "Server Unreachable"
            }
        }
    }
}

# Output the results as JSON for integration with other scripts
$statusResults | ConvertTo-Json
