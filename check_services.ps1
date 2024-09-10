# Loop through each server
foreach ($server in $servers) {
    $serverData = @{
        Server = $server
        Services = @()
    }
    
    # Test if the server is reachable
    if (Test-Connection -ComputerName $server -Count 1 -Quiet) {
        # Loop through each service and check its status on the remote server
        foreach ($service in $services) {
            try {
                # Get the service status on the remote server
                $serviceStatus = Get-Service -Name $service -ComputerName $server -ErrorAction Stop
                if ($serviceStatus.Status -eq "Running") {
                    $serverData.Services += @{
                        Service = $service
                        Status = "Up"
                    }
                } else {
                    $serverData.Services += @{
                        Service = $service
                        Status = "Down"
                    }
                }
            } catch {
                # If there's an error, such as the service not existing or server unreachable
                $serverData.Services += @{
                    Service = $service
                    Status = "Service Not Found or Error"
                }
            }
        }
    } else {
        # If the server is not reachable, add an entry to indicate that
        foreach ($service in $services) {
            $serverData.Services += @{
                Service = $service
                Status = "Server Unreachable"
            }
        }
    }
    
    # Add the server data to the final results
    $serverResults += $serverData
}

# Output the results as JSON for integration with other scripts
$serverResults | ConvertTo-Json
