import psutil
import os
import json

services = ["ServiceName1", "ServiceName2"]
status_results = []

for service in services:
    for p in psutil.win_service_iter():
        if p.name() == service:
            if p.status() == "running":
                status_results.append({"Service": service, "Status": "Up"})
            else:
                status_results.append({"Service": service, "Status": "Down"})

print(json.dumps(status_results))
