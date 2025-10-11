# Simple Level 3 Health Check
Write-Host "Level 3 CI/CD Health Check" -ForegroundColor Green
Write-Host "=========================" -ForegroundColor Green

$checks = 0
$passed = 0

function Test-Check {
    param($name, $condition)
    $script:checks++
    Write-Host "Testing $name..." -NoNewline
    if ($condition) {
        Write-Host " PASS" -ForegroundColor Green
        $script:passed++
    } else {
        Write-Host " FAIL" -ForegroundColor Red
    }
}

# Check prerequisites
Write-Host "`nPrerequisites:" -ForegroundColor Yellow
Test-Check "Java" (Get-Command java -ErrorAction SilentlyContinue)
Test-Check "Docker" (Get-Command docker -ErrorAction SilentlyContinue)
Test-Check "Git" (Get-Command git -ErrorAction SilentlyContinue)

# Check Jenkins files
Write-Host "`nJenkins Setup:" -ForegroundColor Yellow
Test-Check "Jenkins WAR" (Test-Path "C:\Jenkins\jenkins.war")
Test-Check "Jenkins Home" (Test-Path "C:\Jenkins\jenkins_home")
Test-Check "Startup Script" (Test-Path "C:\Jenkins\start-jenkins.bat")

# Check project files
Write-Host "`nProject Files:" -ForegroundColor Yellow
Test-Check "Jenkinsfile" (Test-Path ".\Jenkinsfile")
Test-Check "Backend Dockerfile" (Test-Path ".\backend\Dockerfile")
Test-Check "Frontend Dockerfile" (Test-Path ".\frontend\Dockerfile")
Test-Check "Monitoring Compose" (Test-Path ".\docker-compose.monitoring.yml")
Test-Check "Staging Compose" (Test-Path ".\docker-compose.staging.yml")

# Check Jenkins service
Write-Host "`nJenkins Service:" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080" -UseBasicParsing -TimeoutSec 5 -ErrorAction Stop
    Test-Check "Jenkins Web Interface" ($response.StatusCode -eq 200)
} catch {
    Test-Check "Jenkins Web Interface" $false
}

# Check Git repository
Write-Host "`nGit Repository:" -ForegroundColor Yellow
Test-Check "Git Repository" (Test-Path ".\.git")
try {
    git status 2>&1 | Out-Null
    Test-Check "Git Status" ($LASTEXITCODE -eq 0)
} catch {
    Test-Check "Git Status" $false
}

# Summary
$successRate = [math]::Round(($passed / $checks) * 100, 1)
Write-Host "`nSUMMARY:" -ForegroundColor Cyan
Write-Host "Passed: $passed/$checks ($successRate%)" -ForegroundColor White

if ($successRate -ge 90) {
    Write-Host "Status: EXCELLENT" -ForegroundColor Green
} elseif ($successRate -ge 75) {
    Write-Host "Status: GOOD" -ForegroundColor Yellow
} else {
    Write-Host "Status: NEEDS WORK" -ForegroundColor Red
}

Write-Host "`nJenkins Access:" -ForegroundColor Cyan
Write-Host "URL: http://localhost:8080" -ForegroundColor White
Write-Host "Default Login: admin / admin123" -ForegroundColor White

if (Test-Path "jenkins-session.json") {
    $session = Get-Content "jenkins-session.json" | ConvertFrom-Json
    Write-Host "`nJenkins Job ID: $($session.JobId)" -ForegroundColor Gray
    Write-Host "Started: $($session.StartTime)" -ForegroundColor Gray
}

Write-Host "`nLevel 3 Health Check Complete!" -ForegroundColor Green
