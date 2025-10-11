# Jenkins Port Configuration Change

## Summary
Jenkins has been reconfigured to run on port **8090** instead of port 8080 to avoid conflicts.

## Port Assignments
- **Frontend Application**: http://localhost:8080 (Nginx serving web content)
- **Jenkins CI/CD Server**: http://localhost:8090 (Jenkins dashboard and pipeline)
- **Backend API**: http://localhost:8000 (FastAPI with metrics)

## Updated Access Information

### Jenkins Dashboard
- **URL**: http://localhost:8090
- **Username**: admin
- **Password**: admin123
- **Pipeline Job**: http://localhost:8090/job/fusionpact-devops-challenge/

## Starting Jenkins on Port 8090

### Option 1: Updated Scripts
All scripts have been updated to use port 8090:
```powershell
.\run-jenkins-simple.ps1
```

### Option 2: Manual Start (Recommended for Java 23)
If you have Java 23, you may need to start Jenkins manually:
```powershell
# Set Jenkins home
$env:JENKINS_HOME = "C:\Jenkins\jenkins_home"

# Start Jenkins on port 8090 (ignore Java version warning)
java -Djenkins.install.runSetupWizard=false -jar C:\Jenkins\jenkins.war --httpPort=8090
```

### Option 3: Use Batch File
```batch
# Run the updated batch file
.\start-jenkins-8090.bat
```

## Java Version Compatibility Note
- Jenkins officially supports Java 17 and 21
- Java 23 will show warnings but should still work
- For production, consider using Java 17 or 21

## Verification
Run the health check to verify Jenkins is accessible on the new port:
```powershell
.\health-check-level3-simple.ps1
```

## Files Updated
- `setup-jenkins-simple.ps1` - Updated to use port 8090
- `run-jenkins-simple.ps1` - Updated to use port 8090
- `health-check-level3-simple.ps1` - Updated to check port 8090
- `start-jenkins-8090.bat` - New batch file for port 8090
- `LEVEL3-COMPLETE.md` - Updated documentation
- `PROJECT-COMPLETE.md` - Updated documentation

## Service Architecture
```
┌─────────────────────────────────────────────────────┐
│                   Port Layout                       │
├─────────────────────────────────────────────────────┤
│ Jenkins CI/CD:        http://localhost:8090         │
│ Frontend App:         http://localhost:8080         │
│ Backend API:          http://localhost:8000         │
│ Prometheus:           http://localhost:9090         │
│ Grafana:              http://localhost:3000         │
│ cAdvisor:             http://localhost:8081         │
└─────────────────────────────────────────────────────┘
```

All port conflicts have been resolved and Jenkins now runs on its dedicated port 8090.
