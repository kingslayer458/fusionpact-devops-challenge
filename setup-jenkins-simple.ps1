# Jenkins Setup Script for Fusionpact DevOps Challenge Level 3
Write-Host "SeWrite-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Start Jenkins: $jenkinsDir\start-jenkins.bat" -ForegroundColor White
Write-Host "2. Access Jenkins: http://localhost:8090" -ForegroundColor White
Write-Host "3. Default credentials: admin / admin123" -ForegroundColor White
Write-Host ""
Write-Host "To start Jenkins now, run: .\run-jenkins-simple.ps1" -ForegroundColor Yellowup Jenkins for Level 3 CI/CD Pipeline..." -ForegroundColor Green

# Check prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Yellow

# Check Java
try {
    $javaVersion = java -version 2>&1 | Select-String -Pattern '\d+\.\d+'
    Write-Host "Java found: $($javaVersion.Matches[0].Value)" -ForegroundColor Green
} catch {
    Write-Host "Java not found! Please install Java 11+" -ForegroundColor Red
    exit 1
}

# Check Docker
try {
    docker --version | Out-Null
    Write-Host "Docker found" -ForegroundColor Green
} catch {
    Write-Host "Docker not found! Please install Docker Desktop" -ForegroundColor Red
    exit 1
}

# Create Jenkins directory
$jenkinsDir = "C:\Jenkins"
if (-not (Test-Path $jenkinsDir)) {
    New-Item -ItemType Directory -Path $jenkinsDir -Force
    Write-Host "Created Jenkins directory: $jenkinsDir" -ForegroundColor Green
}

# Download Jenkins if not exists
$jenkinsWar = "$jenkinsDir\jenkins.war"
if (-not (Test-Path $jenkinsWar)) {
    Write-Host "Downloading Jenkins..." -ForegroundColor Yellow
    $url = "https://get.jenkins.io/war-stable/latest/jenkins.war"
    try {
        Invoke-WebRequest -Uri $url -OutFile $jenkinsWar -UseBasicParsing
        Write-Host "Jenkins downloaded successfully" -ForegroundColor Green
    } catch {
        Write-Host "Failed to download Jenkins: $_" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Jenkins WAR file already exists" -ForegroundColor Green
}

# Create startup batch file
$batContent = @'
@echo off
echo Starting Jenkins for Fusionpact DevOps Challenge...
set JENKINS_HOME=C:\Jenkins\jenkins_home
if not exist "%JENKINS_HOME%" mkdir "%JENKINS_HOME%"
echo Jenkins will be available at: http://localhost:8090
java -Djenkins.install.runSetupWizard=false -jar C:\Jenkins\jenkins.war --httpPort=8090
pause
'@

$batContent | Out-File -FilePath "$jenkinsDir\start-jenkins.bat" -Encoding ASCII
Write-Host "Created startup script: $jenkinsDir\start-jenkins.bat" -ForegroundColor Green

# Create Jenkins home and basic config
$jenkinsHome = "$jenkinsDir\jenkins_home"
if (-not (Test-Path $jenkinsHome)) {
    New-Item -ItemType Directory -Path $jenkinsHome -Force
}

# Create jobs directory
$jobsDir = "$jenkinsHome\jobs"
$projectJobDir = "$jobsDir\fusionpact-devops-challenge"
if (-not (Test-Path $projectJobDir)) {
    New-Item -ItemType Directory -Path $projectJobDir -Force
}

Write-Host ""
Write-Host "Jenkins Setup Complete!" -ForegroundColor Green
Write-Host "========================" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Cyan
Write-Host "1. Start Jenkins: $jenkinsDir\start-jenkins.bat" -ForegroundColor White
Write-Host "2. Access Jenkins: http://localhost:8080" -ForegroundColor White
Write-Host "3. Default credentials: admin / admin123" -ForegroundColor White
Write-Host ""
Write-Host "To start Jenkins now, run: .\run-jenkins.ps1" -ForegroundColor Yellow
