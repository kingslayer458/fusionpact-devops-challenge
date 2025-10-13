# Quick Jenkins Runner for Fusionpact DevOps Challenge
# This script starts Jenkins in the background and opens the web interface

Write-Host "🚀 Starting Jenkins for Fusionpact DevOps Challenge Level 3..." -ForegroundColor Green

# Check if Jenkins is already running
$jenkinsProcess = Get-Process -Name "java" -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -like "*jenkins.war*" }

if ($jenkinsProcess) {
    Write-Host "✅ Jenkins is already running!" -ForegroundColor Green
    Write-Host "🌐 Opening Jenkins Dashboard..." -ForegroundColor Yellow
    Start-Process "http://localhost:8080"
    exit 0
}

# Check if Java is available
try {
    $javaVersion = java -version 2>&1 | Select-String -Pattern '\d+\.\d+'
    Write-Host "✅ Java found: $($javaVersion.Matches[0].Value)" -ForegroundColor Green
} catch {
    Write-Host "❌ Java is not installed or not in PATH!" -ForegroundColor Red
    Write-Host "Please install Java 11+ from: https://adoptium.net/" -ForegroundColor Yellow
    exit 1
}

# Check if Jenkins WAR exists
$jenkinsWar = "C:\Jenkins\jenkins.war"
if (-not (Test-Path $jenkinsWar)) {
    Write-Host "❌ Jenkins WAR file not found!" -ForegroundColor Red
    Write-Host "Please run setup-jenkins.ps1 first to install Jenkins" -ForegroundColor Yellow
    exit 1
}

# Set Jenkins environment
$env:JENKINS_HOME = "C:\Jenkins\jenkins_home"

# Create Jenkins home directory if it doesn't exist
if (-not (Test-Path $env:JENKINS_HOME)) {
    New-Item -ItemType Directory -Path $env:JENKINS_HOME -Force
    Write-Host "📁 Created Jenkins home directory" -ForegroundColor Green
}

Write-Host "🏠 Jenkins Home: $env:JENKINS_HOME" -ForegroundColor Cyan
Write-Host "📦 Jenkins WAR: $jenkinsWar" -ForegroundColor Cyan

# Start Jenkins in background
Write-Host "⚡ Starting Jenkins server..." -ForegroundColor Yellow

$jenkinsArgs = @(
    "-Djenkins.install.runSetupWizard=false",
    "-Djava.awt.headless=true",
    "-Djenkins.security.ApiTokenProperty.adminCanGenerateNewTokens=true",
    "-jar", $jenkinsWar,
    "--httpPort=8080",
    "--ajp13Port=-1"
)

# Start Jenkins process in background
$jenkinsJob = Start-Job -ScriptBlock {
    param($jenkinsWar, $jenkinsHome, $jenkinsArgs)
    $env:JENKINS_HOME = $jenkinsHome
    & java @jenkinsArgs
} -ArgumentList $jenkinsWar, $env:JENKINS_HOME, $jenkinsArgs

Write-Host "🔄 Jenkins is starting up..." -ForegroundColor Yellow
Write-Host "📊 Job ID: $($jenkinsJob.Id)" -ForegroundColor Cyan

# Wait for Jenkins to start
$maxWaitTime = 120 # 2 minutes
$waitTime = 0
$jenkinsReady = $false

Write-Host "⏳ Waiting for Jenkins to be ready (max 2 minutes)..." -ForegroundColor Yellow

while ($waitTime -lt $maxWaitTime -and -not $jenkinsReady) {
    Start-Sleep -Seconds 5
    $waitTime += 5
    
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8080" -UseBasicParsing -TimeoutSec 5 -ErrorAction SilentlyContinue
        if ($response.StatusCode -eq 200) {
            $jenkinsReady = $true
        }
    } catch {
        # Jenkins not ready yet, continue waiting
        Write-Host "." -NoNewline -ForegroundColor Gray
    }
}

Write-Host "" # New line after dots

if ($jenkinsReady) {
    Write-Host "✅ Jenkins is ready!" -ForegroundColor Green
    Write-Host "" -ForegroundColor White
    Write-Host "🎯 JENKINS ACCESS INFO:" -ForegroundColor Cyan
    Write-Host "   URL: http://localhost:8080" -ForegroundColor White
    Write-Host "   Username: admin" -ForegroundColor White
    Write-Host "   Password: admin123" -ForegroundColor White
    Write-Host "" -ForegroundColor White
    Write-Host "🔧 PIPELINE JOB:" -ForegroundColor Cyan
    Write-Host "   Job: fusionpact-devops-challenge" -ForegroundColor White
    Write-Host "   URL: http://localhost:8080/job/fusionpact-devops-challenge/" -ForegroundColor White
    Write-Host "" -ForegroundColor White
    Write-Host "🌐 Opening Jenkins Dashboard..." -ForegroundColor Yellow
    
    # Open Jenkins in default browser
    Start-Process "http://localhost:8080"
    
    Write-Host "" -ForegroundColor White
    Write-Host "💡 QUICK ACTIONS:" -ForegroundColor Green
    Write-Host "   • Build Pipeline: http://localhost:8080/job/fusionpact-devops-challenge/build" -ForegroundColor White
    Write-Host "   • View Console: Get-Job $($jenkinsJob.Id) | Receive-Job" -ForegroundColor White
    Write-Host "   • Stop Jenkins: Stop-Job $($jenkinsJob.Id)" -ForegroundColor White
    Write-Host "" -ForegroundColor White
    
    # Store job info for later reference
    $jobInfo = @{
        JobId = $jenkinsJob.Id
        StartTime = Get-Date
        URL = "http://localhost:8080"
        PipelineURL = "http://localhost:8080/job/fusionpact-devops-challenge/"
    }
    
    $jobInfo | ConvertTo-Json | Out-File -FilePath "jenkins-session.json" -Encoding UTF8
    
    Write-Host "📄 Session info saved to: jenkins-session.json" -ForegroundColor Cyan
    
} else {
    Write-Host "❌ Jenkins failed to start within 2 minutes!" -ForegroundColor Red
    Write-Host "🔍 Check the job output for errors:" -ForegroundColor Yellow
    Write-Host "   Get-Job $($jenkinsJob.Id) | Receive-Job" -ForegroundColor White
    
    # Show any job output
    $jobOutput = Receive-Job -Job $jenkinsJob -Keep
    if ($jobOutput) {
        Write-Host "📋 Jenkins Output:" -ForegroundColor Yellow
        $jobOutput | Write-Host -ForegroundColor Gray
    }
}

Write-Host "" -ForegroundColor White
Write-Host "🎮 Jenkins is running in the background!" -ForegroundColor Green
Write-Host "💻 Check job status: Get-Job $($jenkinsJob.Id)" -ForegroundColor Cyan
Write-Host "🛑 To stop Jenkins: Stop-Job $($jenkinsJob.Id)" -ForegroundColor Cyan
