# 🚀 Jenkins Pipeline Setup Guide

## Current Status
✅ Jenkins is running on port 8090  
✅ All prerequisites are met (13/14 health checks passed)  
🔧 Need to complete initial Jenkins setup and pipeline configuration  

## Next Steps to Complete Level 3

### Step 1: Access Jenkins Dashboard
Jenkins is now accessible at: **http://localhost:8090**

### Step 2: Initial Jenkins Setup
When you first access Jenkins, you'll need to:

1. **Get the Initial Admin Password**:
   ```powershell
   # The password is usually in this file:
   Get-Content "C:\Jenkins\jenkins_home\secrets\initialAdminPassword" -ErrorAction SilentlyContinue
   ```
   
   If that doesn't exist, Jenkins may be in setup mode. Look for the password in the Jenkins console output.

2. **Choose Setup Option**:
   - Select "Install suggested plugins" for a complete setup
   - Or select "Select plugins to install" for custom installation

3. **Create Admin User**:
   - Username: `admin`
   - Password: `admin123`
   - Full Name: `Administrator`
   - Email: `admin@fusionpact.local`

### Step 3: Create the Pipeline Job

1. **Create New Job**:
   - Click "New Item" in Jenkins dashboard
   - Name: `fusionpact-devops-challenge`
   - Type: "Pipeline"
   - Click "OK"

2. **Configure Pipeline**:
   - In "Definition" section, select "Pipeline script from SCM"
   - SCM: Git
   - Repository URL: Use the full path to your project:
     ```
     file:///C:/Users/manoj/OneDrive/Desktop/devops%20intern/fusionpact-devops-challenge
     ```
   - Branch: `*/main`
   - Script Path: `Jenkinsfile`

3. **Save Configuration**

### Step 4: Enable Git Repository
Make sure your local Git repository is properly configured:
```powershell
# Verify Git status
git status

# If needed, add and commit current changes
git add .
git commit -m "Jenkins pipeline configuration"
```

### Step 5: Run Your First Build
1. Go to your pipeline job: http://localhost:8090/job/fusionpact-devops-challenge/
2. Click "Build Now"
3. Monitor the build progress in "Build History"
4. Check console output for detailed logs

## Pipeline Features Ready to Execute

Your `Jenkinsfile` includes these stages:
1. **Checkout** - Get source code from Git
2. **Environment Setup** - Prepare build environment
3. **Code Quality & Security Scan** - Parallel linting (Python + HTML)
4. **Build Docker Images** - Parallel builds (Backend + Frontend)
5. **Test** - Unit and integration testing
6. **Security Scan** - Vulnerability assessment
7. **Push to Registry** - Image publishing (conditional)
8. **Deploy to Staging** - Automatic staging deployment
9. **Deploy to Production** - Manual production deployment
10. **Post-Deployment Tests** - Comprehensive verification

## Expected Results

When the pipeline runs successfully, you'll have:
- ✅ Code quality validation
- ✅ Docker images built and tested
- ✅ Security scanning completed
- ✅ Services deployed and verified
- ✅ Full monitoring stack operational

## Troubleshooting

### If Jenkins Setup Fails:
```powershell
# Check Jenkins logs
Get-Process -Name "java" | Where-Object { $_.CommandLine -like "*jenkins*" }

# Restart Jenkins if needed
# Stop current instance and restart
```

### If Pipeline Fails:
```powershell
# Ensure Docker is running
docker ps

# Stop any conflicting services
docker-compose down

# Check Git repository
git status
```

### If Port Issues:
- Jenkins: http://localhost:8090
- Frontend: http://localhost:8080
- Backend: http://localhost:8000

## Quick Commands

### Health Check
```powershell
.\health-check-level3-simple.ps1
```

### Start Monitoring Stack
```powershell
docker-compose -f docker-compose.monitoring.yml up -d
```

### View Services
```powershell
docker-compose ps
netstat -an | findstr ":80"
```

## Success Criteria

Level 3 is complete when:
- [ ] Jenkins dashboard is accessible on port 8090
- [ ] Pipeline job is created and configured
- [ ] First build runs successfully
- [ ] All pipeline stages execute
- [ ] Services are deployed and healthy
- [ ] Health check shows 100% success

## Ready to Proceed! 🎯

1. **Open Jenkins**: http://localhost:8090
2. **Complete initial setup**
3. **Create pipeline job**
4. **Run first build**
5. **Verify deployment**

Your Fusionpact DevOps Challenge Level 3 CI/CD automation is ready to go! 🚀
