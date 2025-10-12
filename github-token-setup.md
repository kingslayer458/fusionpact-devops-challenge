# 🔑 GITHUB TOKEN CONFIGURATION FOR JENKINS

## 🎯 **WHY YOU NEED A GITHUB TOKEN**

**Issue**: Jenkins needs authentication to access your GitHub repository for:
- Automatic polling for changes
- Cloning/pulling latest code
- Webhook triggers (if configured)
- Private repository access

**Solution**: Configure GitHub Personal Access Token in Jenkins

---

## 📝 **STEP 1: CREATE GITHUB PERSONAL ACCESS TOKEN**

### **1.1 Generate Token on GitHub**
1. Go to **GitHub.com** → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
2. Click **"Generate new token (classic)"**
3. **Token name**: `Jenkins-DevOps-Challenge`
4. **Expiration**: 90 days (or No expiration for testing)
5. **Select scopes**:
   ```
   ✅ repo (Full control of private repositories)
   ✅ workflow (Update GitHub Action workflows)
   ✅ admin:repo_hook (Full control of repository hooks)
   ```

### **1.2 Copy Your Token**
```
⚠️ IMPORTANT: Copy the token immediately - you won't see it again!
Example format: ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## 🔧 **STEP 2: CONFIGURE TOKEN IN JENKINS**

### **2.1 Access Jenkins Credentials**
1. Open **Jenkins**: http://localhost:8090
2. Login: **admin1** / **admin458**
3. Go to: **Manage Jenkins** → **Manage Credentials**
4. Click: **System** → **Global credentials (unrestricted)**
5. Click: **Add Credentials**

### **2.2 Add GitHub Token Credential**
```
Kind: Username with password
Username: your-github-username
Password: [paste your GitHub token here]
ID: github-token
Description: GitHub Personal Access Token for DevOps Challenge
```

### **2.3 Update Pipeline Job Configuration**
1. Go to: **Dashboard** → **fusionpact-devops-challenge** → **Configure**
2. In **Source Code Management** section:
3. Find **Repository URL**: `https://github.com/kingslayer458/fusionpact-devops-challenge.git`
4. In **Credentials** dropdown: Select **github-token**
5. Click **Save**

---

## 🚀 **STEP 3: AUTOMATED SETUP SCRIPT**

I'll create a script to help configure this:

```powershell
# GitHub Token Configuration Script
Write-Host "🔑 GITHUB TOKEN SETUP FOR JENKINS" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Yellow
Write-Host ""

# Check if Jenkins is running
$jenkinsRunning = Get-Process -Name java -ErrorAction SilentlyContinue
if (!$jenkinsRunning) {
    Write-Host "❌ Jenkins not running. Start Jenkins first!" -ForegroundColor Red
    exit
}

Write-Host "📋 SETUP INSTRUCTIONS:" -ForegroundColor Magenta
Write-Host ""
Write-Host "1. 🌐 Create GitHub Token:" -ForegroundColor Cyan
Write-Host "   • Go to: https://github.com/settings/tokens" -ForegroundColor White
Write-Host "   • Generate new token (classic)" -ForegroundColor White
Write-Host "   • Scopes: repo, workflow, admin:repo_hook" -ForegroundColor White
Write-Host ""

Write-Host "2. 🔧 Configure in Jenkins:" -ForegroundColor Cyan
Write-Host "   • URL: http://localhost:8090/credentials/" -ForegroundColor White
Write-Host "   • Add Credentials → Username with password" -ForegroundColor White
Write-Host "   • Username: your-github-username" -ForegroundColor White
Write-Host "   • Password: [your-github-token]" -ForegroundColor White
Write-Host "   • ID: github-token" -ForegroundColor White
Write-Host ""

Write-Host "3. 🔄 Update Pipeline Job:" -ForegroundColor Cyan
Write-Host "   • URL: http://localhost:8090/job/fusionpact-devops-challenge/configure" -ForegroundColor White
Write-Host "   • Source Code Management → Credentials → github-token" -ForegroundColor White
Write-Host ""

$token = Read-Host "Enter your GitHub token (or press Enter to open setup URLs)"

if ($token) {
    Write-Host "✅ Token received. Follow Jenkins configuration steps above." -ForegroundColor Green
    Write-Host "🔗 Opening Jenkins credentials page..." -ForegroundColor Yellow
    Start-Process "http://localhost:8090/credentials/"
} else {
    Write-Host "🔗 Opening GitHub token creation page..." -ForegroundColor Yellow
    Start-Process "https://github.com/settings/tokens"
    Start-Sleep 2
    Write-Host "🔗 Opening Jenkins credentials page..." -ForegroundColor Yellow
    Start-Process "http://localhost:8090/credentials/"
}

Write-Host ""
Write-Host "🎯 After configuration, test with:" -ForegroundColor Green
Write-Host "   git commit --allow-empty -m 'Test token auth'" -ForegroundColor White
Write-Host "   git push origin main" -ForegroundColor White
```

---

## 🧪 **STEP 4: VERIFY TOKEN CONFIGURATION**

### **4.1 Test Authentication**
```powershell
# Test commit to verify auto-trigger works
git commit --allow-empty -m "🔑 Test GitHub token authentication"
git push origin main
```

### **4.2 Check Jenkins Logs**
- Go to **Jenkins** → **fusionpact-devops-challenge** → **Build History**
- Click on latest build → **Console Output**
- Look for: `No credentials specified` (should be gone)
- Should see: `Fetching upstream changes from https://github.com/...`

### **4.3 Verify Polling**
1. Go to **Job Configuration** → **Build Triggers**
2. Enable: **Poll SCM**
3. Schedule: `H/5 * * * *` (every 5 minutes)
4. **Save**

---

## ⚡ **QUICK SETUP SCRIPT**

Let me create a quick setup script for you:
