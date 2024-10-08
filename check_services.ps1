# List of SCORCH servers and their corresponding services
$servers = @("Server1", "Server2")  # Replace with actual SCORCH server names
$services = @("OrchestratorRunbookService", "OrchestratorManagementService")  # Replace with actual SCORCH service names
$serverResults = @()

# Loop through each server
foreach ($server in $servers) {
    # Create a hashtable for the server and an empty array for services
    $serverData = @{
        Server = $server
        Services = @()  # This will hold the list of service status objects
    }
    
    # Test if the server is reachable
    if (Test-Connection -ComputerName $server -Count 1 -Quiet) {
        # Loop through each service and check its status on the remote server
        foreach ($service in $services) {
            try {
                # Get the service status on the remote server
                $serviceStatus = Get-Service -Name $service -ComputerName $server -ErrorAction Stop
                if ($serviceStatus.Status -eq "Running") {
                    $serverData.Services += [PSCustomObject]@{
                        Service = $service
                        Status = "Up"
                    }
                } else {
                    $serverData.Services += [PSCustomObject]@{
                        Service = $service
                        Status = "Down"
                    }
                }
            } catch {
                # If there's an error, such as the service not existing or server unreachable
                $serverData.Services += [PSCustomObject]@{
                    Service = $service
                    Status = "Service Not Found or Error"
                }
            }
        }
    } else {
        # If the server is not reachable, add an entry to indicate that
        foreach ($service in $services) {
            $serverData.Services += [PSCustomObject]@{
                Service = $service
                Status = "Server Unreachable"
            }
        }
    }
    
    # Add the server data to the final results
    $serverResults += [PSCustomObject]$serverData
}

# Output the results as JSON for integration with other scripts
$serverResults | ConvertTo-Json -Depth 3
