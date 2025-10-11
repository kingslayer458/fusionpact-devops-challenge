# 🎯 Jenkins Setup Final Steps - Port 8090

## Current Status ✅
- ✅ Jenkins is **RUNNING** on port 8090
- ✅ Port is listening and accessible
- ✅ All project files are configured for port 8090
- 🔧 **Need to complete Jenkins initial configuration**

## Why 403 Forbidden?
Jenkins is running but needs initial setup/authentication. This is normal for a fresh Jenkins installation.

## Complete Jenkins Setup - Manual Steps

### Step 1: Access Jenkins Setup
1. **Open your browser** and go to: **http://localhost:8090**
2. You should see one of these screens:
   - Jenkins setup wizard (if first time)
   - Login page (if already configured)
   - Dashboard (if setup is complete)

### Step 2: Handle Setup Scenarios

#### Scenario A: Setup Wizard Appears
If you see "Unlock Jenkins" screen:
1. Find the initial admin password in one of these locations:
   ```
   C:\jenkins\secrets\initialAdminPassword
   C:\Users\<username>\.jenkins\secrets\initialAdminPassword
   C:\Jenkins\jenkins_home\secrets\initialAdminPassword
   ```
2. Or check the Jenkins console output where it started
3. Enter the password and continue setup
4. Choose "Install suggested plugins"
5. Create admin user: admin / admin123

#### Scenario B: Login Page Appears
If you see a login form:
1. Try: admin / admin (default)
2. Or: admin / admin123
3. Or check Jenkins documentation for default credentials

#### Scenario C: Direct Dashboard Access
If you see the Jenkins dashboard directly:
1. Great! Jenkins is ready to use
2. Proceed to Step 3

### Step 3: Create Pipeline Job
1. **Click "New Item"** in Jenkins dashboard
2. **Enter name**: `fusionpact-devops-challenge`
3. **Select**: "Pipeline" project type
4. **Click "OK"**

### Step 4: Configure Pipeline
In the job configuration:

1. **Description**: `Fusionpact DevOps Challenge CI/CD Pipeline`

2. **Build Triggers**: 
   - ☑️ Check "Poll SCM"
   - Schedule: `H/5 * * * *` (poll every 5 minutes)

3. **Pipeline Definition**:
   - Definition: "Pipeline script from SCM"
   - SCM: Git
   - Repository URL: 
     ```
     file:///C:/Users/manoj/OneDrive/Desktop/devops%20intern/fusionpact-devops-challenge
     ```
   - Branch Specifier: `*/main`
   - Script Path: `Jenkinsfile`

4. **Click "Save"**

### Step 5: Run First Build
1. **Go to your job**: http://localhost:8090/job/fusionpact-devops-challenge/
2. **Click "Build Now"**
3. **Monitor progress** in "Build History" section
4. **Click on build number** to see console output

## Expected Pipeline Execution

Your pipeline will execute these stages:
1. ✅ **Checkout** - Get source code
2. ✅ **Environment Setup** - Prepare build environment  
3. ✅ **Code Quality & Security Scan** - Lint code (parallel)
4. ✅ **Build Docker Images** - Build containers (parallel)
5. ✅ **Test** - Run unit and integration tests (parallel)
6. ✅ **Security Scan** - Check for vulnerabilities
7. ✅ **Deploy to Staging** - Deploy services
8. ✅ **Deploy to Production** - Manual approval required
9. ✅ **Post-Deployment Tests** - Verify deployment

## Troubleshooting

### If You Can't Access Jenkins
```powershell
# Check if Jenkins is running
netstat -an | findstr :8090

# Check Java processes
Get-Process -Name "java" | Where-Object { $_.CommandLine -like "*jenkins*" }

# Restart Jenkins if needed
# Kill the process and restart
```

### If Pipeline Fails
```powershell
# Ensure Docker is running
docker ps

# Stop conflicting services
docker-compose down

# Check Git repository
git status
```

## Quick Access Links

- **Jenkins Dashboard**: http://localhost:8090
- **Pipeline Job**: http://localhost:8090/job/fusionpact-devops-challenge/
- **Create New Job**: http://localhost:8090/view/all/newJob

## Final Verification

After successful setup, run health check:
```powershell
.\health-check-level3-simple.ps1
```

Expected result: **14/14 checks PASS** (100% success)

---

## 🏆 SUCCESS CRITERIA

Level 3 is **COMPLETE** when:
- ✅ Jenkins accessible on port 8090
- ✅ Pipeline job created and configured
- ✅ First build runs successfully
- ✅ All 10 pipeline stages execute
- ✅ Services deployed and healthy
- ✅ Health check shows 100% success

## 🎉 You're Almost Done!

**Jenkins is running on port 8090** - just complete the web setup and create your pipeline job!

**All three levels of the Fusionpact DevOps Challenge will then be COMPLETE! 🚀**
