# Jenkins Setup Script for Fusionpact DevOps Challenge Level 3
# Run this script as Administrator in PowerShell

Write-Host "🚀 Setting up Jenkins for Fusionpact DevOps Challenge Level 3..." -ForegroundColor Green

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ This script needs to be run as Administrator!" -ForegroundColor Red
    Write-Host "Please right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

# Function to check if a command exists
function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Check prerequisites
Write-Host "📋 Checking prerequisites..." -ForegroundColor Yellow

if (-not (Test-Command "java")) {
    Write-Host "❌ Java is not installed!" -ForegroundColor Red
    Write-Host "Please install Java 11 or later from: https://adoptium.net/" -ForegroundColor Yellow
    exit 1
} else {
    $javaVersion = java -version 2>&1 | Select-String -Pattern '\d+\.\d+' | ForEach-Object { $_.Matches[0].Value }
    Write-Host "✅ Java found: $javaVersion" -ForegroundColor Green
}

if (-not (Test-Command "docker")) {
    Write-Host "❌ Docker is not installed!" -ForegroundColor Red
    Write-Host "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "✅ Docker found" -ForegroundColor Green
}

if (-not (Test-Command "docker-compose")) {
    Write-Host "❌ Docker Compose is not installed!" -ForegroundColor Red
    exit 1
} else {
    Write-Host "✅ Docker Compose found" -ForegroundColor Green
}

if (-not (Test-Command "git")) {
    Write-Host "❌ Git is not installed!" -ForegroundColor Red
    Write-Host "Please install Git from: https://git-scm.com/" -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "✅ Git found" -ForegroundColor Green
}

# Create Jenkins directory
$jenkinsDir = "C:\Jenkins"
if (-not (Test-Path $jenkinsDir)) {
    New-Item -ItemType Directory -Path $jenkinsDir -Force
    Write-Host "📁 Created Jenkins directory: $jenkinsDir" -ForegroundColor Green
}

# Download Jenkins WAR file
$jenkinsWar = "$jenkinsDir\jenkins.war"
if (-not (Test-Path $jenkinsWar)) {
    Write-Host "📥 Downloading Jenkins..." -ForegroundColor Yellow
    $url = "https://get.jenkins.io/war-stable/latest/jenkins.war"
    try {
        Invoke-WebRequest -Uri $url -OutFile $jenkinsWar -UseBasicParsing
        Write-Host "✅ Jenkins downloaded successfully" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to download Jenkins: $_" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "✅ Jenkins WAR file already exists" -ForegroundColor Green
}

# Create Jenkins service script
$jenkinsServiceScript = @"
@echo off
echo Starting Jenkins for Fusionpact DevOps Challenge...
set JENKINS_HOME=C:\Jenkins\jenkins_home
if not exist "%JENKINS_HOME%" mkdir "%JENKINS_HOME%"

echo Jenkins Home: %JENKINS_HOME%
echo Jenkins WAR: C:\Jenkins\jenkins.war
echo.
echo Jenkins will be available at: http://localhost:8080
echo.

java -Djenkins.install.runSetupWizard=false -Djava.awt.headless=true -jar C:\Jenkins\jenkins.war --httpPort=8080 --ajp13Port=-1

pause
"@

$jenkinsServiceScript | Out-File -FilePath "$jenkinsDir\start-jenkins.bat" -Encoding ASCII
Write-Host "✅ Created Jenkins startup script: $jenkinsDir\start-jenkins.bat" -ForegroundColor Green

# Create Jenkins configuration
$jenkinsHome = "$jenkinsDir\jenkins_home"
if (-not (Test-Path $jenkinsHome)) {
    New-Item -ItemType Directory -Path $jenkinsHome -Force
}

# Create initial admin user config to skip setup wizard
$usersDir = "$jenkinsHome\users"
$adminDir = "$usersDir\admin_1234567890"
if (-not (Test-Path $adminDir)) {
    New-Item -ItemType Directory -Path $adminDir -Force
}

# Create admin user config
$adminConfig = @"
<?xml version='1.1' encoding='UTF-8'?>
<user>
  <fullName>Administrator</fullName>
  <properties>
    <jenkins.security.ApiTokenProperty>
      <apiToken>
        <name>fusionpact-token</name>
        <value>fusionpact123</value>
      </apiToken>
    </jenkins.security.ApiTokenProperty>
    <hudson.security.HudsonPrivateSecurityRealm_-Details>
      <passwordHash>#jbcrypt:$2a$10$DdaWzN64JgUtLdvxWIflXuQEcstdMaV0mKPOm7zt8ooMDv9J7NKCu</passwordHash>
    </hudson.security.HudsonPrivateSecurityRealm_-Details>
  </properties>
</user>
"@

$adminConfig | Out-File -FilePath "$adminDir\config.xml" -Encoding UTF8

# Create Jenkins main config
$jenkinsConfig = @"
<?xml version='1.1' encoding='UTF-8'?>
<hudson>
  <disabledAdministrativeMonitors/>
  <version>2.401.3</version>
  <installStateName>RUNNING</installStateName>
  <numExecutors>2</numExecutors>
  <mode>NORMAL</mode>
  <useSecurity>true</useSecurity>
  <authorizationStrategy class="hudson.security.FullControlOnceLoggedInAuthorizationStrategy">
    <denyAnonymousReadAccess>true</denyAnonymousReadAccess>
  </authorizationStrategy>
  <securityRealm class="hudson.security.HudsonPrivateSecurityRealm">
    <disableSignup>true</disableSignup>
    <enableCaptcha>false</enableCaptcha>
  </securityRealm>
  <disableRememberMe>false</disableRememberMe>
  <projectNamingStrategy class="jenkins.model.ProjectNamingStrategy\$DefaultProjectNamingStrategy"/>
  <workspaceDir>\${JENKINS_HOME}/workspace/\${ITEM_FULLNAME}</workspaceDir>
  <buildsDir>\${ITEM_ROOTDIR}/builds</buildsDir>
  <markupFormatter class="hudson.markup.PlainTextMarkupFormatter"/>
  <jdks/>
  <viewsTabBar class="hudson.views.DefaultViewsTabBar"/>
  <myViewsTabBar class="hudson.views.DefaultMyViewsTabBar"/>
  <clouds/>
  <quietPeriod>5</quietPeriod>
  <scmCheckoutRetryCount>0</scmCheckoutRetryCount>
  <views>
    <hudson.model.AllView>
      <owner class="hudson" reference="../../.."/>
      <name>all</name>
      <filterExecutors>false</filterExecutors>
      <filterQueue>false</filterQueue>
      <properties class="hudson.model.View\$PropertyList"/>
    </hudson.model.AllView>
  </views>
  <primaryView>all</primaryView>
  <slaveAgentPort>50000</slaveAgentPort>
  <label></label>
  <crumbIssuer class="hudson.security.csrf.DefaultCrumbIssuer">
    <excludeClientIPFromCrumb>false</excludeClientIPFromCrumb>
  </crumbIssuer>
  <nodeProperties/>
  <globalNodeProperties/>
</hudson>
"@

$jenkinsConfig | Out-File -FilePath "$jenkinsHome\config.xml" -Encoding UTF8

# Create plugins list
$pluginsDir = "$jenkinsHome\plugins"
if (-not (Test-Path $pluginsDir)) {
    New-Item -ItemType Directory -Path $pluginsDir -Force
}

# Create Jenkins job for the project
$jobsDir = "$jenkinsHome\jobs"
$projectJobDir = "$jobsDir\fusionpact-devops-challenge"
if (-not (Test-Path $projectJobDir)) {
    New-Item -ItemType Directory -Path $projectJobDir -Force
}

$jobConfig = @"
<?xml version='1.1' encoding='UTF-8'?>
<flow-definition plugin="workflow-job@2.42">
  <actions>
    <org.jenkinsci.plugins.pipeline.modeldefinition.actions.DeclarativeJobAction plugin="pipeline-model-definition@2.2086.v12b_420f036e5"/>
    <org.jenkinsci.plugins.pipeline.modeldefinition.actions.DeclarativeJobPropertyTrackerAction plugin="pipeline-model-definition@2.2086.v12b_420f036e5">
      <jobProperties/>
      <triggers/>
      <parameters/>
      <options/>
    </org.jenkinsci.plugins.pipeline.modeldefinition.actions.DeclarativeJobPropertyTrackerAction>
  </actions>
  <description>Fusionpact DevOps Challenge CI/CD Pipeline</description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty>
      <triggers>
        <hudson.triggers.SCMTrigger>
          <spec>H/5 * * * *</spec>
          <ignorePostCommitHooks>false</ignorePostCommitHooks>
        </hudson.triggers.SCMTrigger>
      </triggers>
    </org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty>
  </properties>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition" plugin="workflow-cps@2.92">
    <scm class="hudson.plugins.git.GitSCM" plugin="git@4.8.3">
      <configVersion>2</configVersion>
      <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
          <url>file:///C:/Users/manoj/OneDrive/Desktop/devops%20intern/fusionpact-devops-challenge</url>
        </hudson.plugins.git.UserRemoteConfig>
      </userRemoteConfigs>
      <branches>
        <hudson.plugins.git.BranchSpec>
          <name>*/main</name>
        </hudson.plugins.git.BranchSpec>
      </branches>
      <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
      <submoduleCfg class="list"/>
      <extensions/>
    </scm>
    <scriptPath>Jenkinsfile</scriptPath>
    <lightweight>true</lightweight>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
"@

$jobConfig | Out-File -FilePath "$projectJobDir\config.xml" -Encoding UTF8

# Create startup instructions
$instructions = @"
🎉 Jenkins Setup Complete for Fusionpact DevOps Challenge Level 3!

NEXT STEPS:
===========

1. Start Jenkins:
   - Double-click: C:\Jenkins\start-jenkins.bat
   - Or run: java -jar C:\Jenkins\jenkins.war --httpPort=8080

2. Access Jenkins:
   - URL: http://localhost:8080
   - Username: admin
   - Password: admin123

3. Jenkins Dashboard:
   - Job already created: 'fusionpact-devops-challenge'
   - Pipeline configured to run from your Jenkinsfile
   - SCM polling enabled (checks for changes every 5 minutes)

4. Manual Build:
   - Go to: http://localhost:8080/job/fusionpact-devops-challenge/
   - Click "Build Now" to trigger the pipeline

5. Pipeline Features:
   ✅ Code checkout from local Git repository
   ✅ Parallel linting (Python + HTML)
   ✅ Docker image building (Backend + Frontend)
   ✅ Unit and integration testing
   ✅ Security scanning
   ✅ Multi-environment deployment (Staging/Production)
   ✅ Post-deployment verification
   ✅ Comprehensive health checks

6. Pipeline Stages:
   - Checkout & Environment Setup
   - Code Quality & Security Scan
   - Build Docker Images (Parallel)
   - Test (Unit + Integration, Parallel)
   - Security Scan
   - Push to Registry (main/develop branches only)
   - Deploy to Staging (develop branch)
   - Deploy to Production (main branch with approval)
   - Post-Deployment Tests

7. Branch Strategy:
   - main: Production deployments with manual approval
   - develop: Automatic staging deployments
   - feature/*: Build and test only

TROUBLESHOOTING:
===============

If Jenkins fails to start:
- Check Java is installed: java -version
- Check port 8080 is available
- Check Jenkins logs in the console

If pipeline fails:
- Ensure Docker is running
- Check all services are stopped: docker-compose down
- Verify Git repository is initialized in project directory

SECURITY NOTES:
==============
- Default admin password: admin123
- Change password after first login
- Configure proper authentication for production use
- Set up Docker Hub credentials for image pushing

Ready to run Level 3 CI/CD Pipeline! 🚀
"@

Write-Host $instructions -ForegroundColor Cyan

# Save instructions to file
$instructions | Out-File -FilePath "$jenkinsDir\JENKINS-SETUP-INSTRUCTIONS.txt" -Encoding UTF8

Write-Host "📄 Instructions saved to: $jenkinsDir\JENKINS-SETUP-INSTRUCTIONS.txt" -ForegroundColor Green
Write-Host "" -ForegroundColor White
Write-Host "🎯 To start Jenkins now, run: $jenkinsDir\start-jenkins.bat" -ForegroundColor Yellow
Write-Host "🌐 Then visit: http://localhost:8080" -ForegroundColor Yellow
Write-Host "" -ForegroundColor White
