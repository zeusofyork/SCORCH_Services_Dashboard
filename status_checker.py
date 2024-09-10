# status_checker.py
import psutil
import os

# List of services to check
services = ["ServiceName1", "ServiceName2"]  # Replace with actual SCORCH service names

# List of server hostnames or IP addresses
servers = ["Hostname1", "Hostname2"]  # Replace with actual SCORCH server hostnames

# Function to check if a service is running
def check_services():
    service_status = []
    for service in services:
        for p in psutil.win_service_iter():
            if p.name() == service:
                if p.status() == "running":
                    service_status.append({"Service": service, "Status": "Up"})
                else:
                    service_status.append({"Service": service, "Status": "Down"})
    return service_status

# Function to check if a server is reachable
def ping(host):
    response = os.system("ping -n 1 " + host)  # Use 'ping -c 1' for Linux/Mac
    return "Up" if response == 0 else "Down"

# Function to check all server statuses
def check_servers():
    server_status = []
    for server in servers:
        server_status.append({"Server": server, "Status": ping(server)})
    return server_status

# Function to get the overall status (services + servers)
def get_status():
    status = []
    status.extend(check_services())
    status.extend(check_servers())
    return status
