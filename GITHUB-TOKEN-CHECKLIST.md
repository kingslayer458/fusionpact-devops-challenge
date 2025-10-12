# 🔑 GITHUB TOKEN SETUP - QUICK CHECKLIST

## ✅ **STEP-BY-STEP SETUP**

### **STEP 1: Create GitHub Token** 🌐
**Page opened**: https://github.com/settings/tokens

1. Click **"Generate new token (classic)"**
2. **Token name**: `Jenkins-DevOps-Challenge`
3. **Expiration**: 90 days (or No expiration)
4. **Select these scopes**:
   - ✅ **repo** (Full control of private repositories)
   - ✅ **workflow** (Update GitHub Action workflows)  
   - ✅ **admin:repo_hook** (Full control of repository hooks)
5. Click **"Generate token"**
6. **⚠️ COPY THE TOKEN IMMEDIATELY** (you won't see it again!)

**Token format**: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

---

### **STEP 2: Add Token to Jenkins** 🔧
**Page opened**: http://localhost:8090/credentials/

1. Click **"System"** → **"Global credentials (unrestricted)"**
2. Click **"Add Credentials"**
3. Fill in the form:
   - **Kind**: `Username with password`
   - **Username**: `kingslayer458`
   - **Password**: `[paste your GitHub token here]`
   - **ID**: `github-token`
   - **Description**: `GitHub Token for DevOps Challenge`
4. Click **"OK"**

---

### **STEP 3: Configure Pipeline Job** 🔄
**Page opened**: http://localhost:8090/job/fusionpact-devops-challenge/configure

1. Scroll to **"Source Code Management"** section
2. Find **"Repository URL"**: 
   ```
   https://github.com/kingslayer458/fusionpact-devops-challenge.git
   ```
3. In **"Credentials"** dropdown: Select **"kingslayer458/****** (GitHub Token for DevOps Challenge)"**
4. Scroll down and click **"Save"**

---

### **STEP 4: Enable Auto-Polling** ⏰
**While in job configuration**:

1. Scroll to **"Build Triggers"** section
2. Check ✅ **"Poll SCM"**
3. In **"Schedule"** field, enter:
   ```
   H/5 * * * *
   ```
   (This polls GitHub every 5 minutes for changes)
4. Click **"Save"**

---

## 🧪 **STEP 5: TEST THE SETUP**

**Run this test**:
```powershell
cd "c:\Users\manoj\OneDrive\Desktop\devops intern\fusionpact-devops-challenge"

# Create test commit
git commit --allow-empty -m "🔑 Test GitHub token authentication"

# Push to trigger build
git push origin main
```

**Expected Result**:
- ✅ No "No credentials specified" error
- ✅ Jenkins should start a new build automatically
- ✅ Build should complete successfully

---

## 🔍 **VERIFICATION CHECKLIST**

After setup, check these:

**✅ GitHub Token Created**
- Token has correct scopes (repo, workflow, admin:repo_hook)
- Token copied and saved securely

**✅ Jenkins Credentials Added**
- Username: kingslayer458
- Password: GitHub token
- ID: github-token
- Visible in credentials list

**✅ Pipeline Job Updated**  
- Repository URL configured
- Credentials dropdown shows your token
- Build triggers enabled (Poll SCM every 5 minutes)

**✅ Auto-Trigger Working**
- Test commit triggers new build
- No authentication errors in console
- Build completes successfully

---

## ⚠️ **COMMON ISSUES & SOLUTIONS**

**Problem**: "No credentials specified"
**Solution**: Make sure you selected the credential in job configuration

**Problem**: "Authentication failed"  
**Solution**: Verify GitHub token has correct scopes and hasn't expired

**Problem**: "403 Forbidden"
**Solution**: Check token permissions and repository access

**Problem**: No auto-trigger
**Solution**: Enable "Poll SCM" in Build Triggers with schedule `H/5 * * * *`

---

## 🎯 **FINAL RESULT**

**After successful setup**:
- ✅ Every Git push will automatically trigger Jenkins build
- ✅ No more manual build triggering needed
- ✅ Full CI/CD automation working
- ✅ Build #3 should trigger from your next commit!

**Your CI/CD pipeline will be truly automated! 🚀**
