# Fusionpact DevOps Challenge - Level 3 CI/CD Health Check
# Validates Jenkins setup and pipeline functionality

Write-Host "🎯 Fusionpact DevOps Challenge - Level 3 Health Check" -ForegroundColor Green
Write-Host "====================================================" -ForegroundColor Green
Write-Host ""

$totalChecks = 0
$passedChecks = 0

function Test-Service {
    param(
        [string]$Name,
        [string]$URL,
        [int]$ExpectedStatus = 200,
        [string]$ExpectedContent = $null
    )
    
    $global:totalChecks++
    Write-Host "🔍 Testing $Name..." -NoNewline
    
    try {
        $response = Invoke-WebRequest -Uri $URL -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
        
        if ($response.StatusCode -eq $ExpectedStatus) {
            if ($ExpectedContent -and $response.Content -notlike "*$ExpectedContent*") {
                Write-Host " ❌ (Wrong content)" -ForegroundColor Red
                Write-Host "   Expected: $ExpectedContent" -ForegroundColor Gray
                return $false
            }
            Write-Host " ✅" -ForegroundColor Green
            $global:passedChecks++
            return $true
        } else {
            Write-Host " ❌ (Status: $($response.StatusCode))" -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host " ❌ (Error: $($_.Exception.Message))" -ForegroundColor Red
        return $false
    }
}

function Test-Port {
    param(
        [string]$Name,
        [string]$HostName = "localhost",
        [int]$Port
    )
    
    $global:totalChecks++
    Write-Host "🔌 Testing $Name port ($Port)..." -NoNewline
    
    try {
        $tcpClient = New-Object System.Net.Sockets.TcpClient
        $tcpClient.ConnectAsync($HostName, $Port).Wait(5000)
        
        if ($tcpClient.Connected) {
            Write-Host " ✅" -ForegroundColor Green
            $tcpClient.Close()
            $global:passedChecks++
            return $true
        } else {
            Write-Host " ❌" -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host " ❌" -ForegroundColor Red
        return $false
    }
}

function Test-Command {
    param(
        [string]$Name,
        [string]$Command
    )
    
    $global:totalChecks++
    Write-Host "⚡ Testing $Name..." -NoNewline
    
    try {
        $null = Invoke-Expression $Command 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host " ✅" -ForegroundColor Green
            $global:passedChecks++
            return $true
        } else {
            Write-Host " ❌" -ForegroundColor Red
            return $false
        }
    } catch {
        Write-Host " ❌ (Error: $($_.Exception.Message))" -ForegroundColor Red
        return $false
    }
}

function Test-FileExists {
    param(
        [string]$Name,
        [string]$Path
    )
    
    $global:totalChecks++
    Write-Host "📁 Testing $Name..." -NoNewline
    
    if (Test-Path $Path) {
        Write-Host " ✅" -ForegroundColor Green
        $global:passedChecks++
        return $true
    } else {
        Write-Host " ❌ (Not found: $Path)" -ForegroundColor Red
        return $false
    }
}

# Banner
Write-Host "🚀 Level 3: CI/CD Automation with Jenkins" -ForegroundColor Cyan
Write-Host "Timestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host ""

# 1. Prerequisites Check
Write-Host "📋 STEP 1: Prerequisites Check" -ForegroundColor Yellow
Write-Host "-----------------------------" -ForegroundColor Yellow

Test-Command "Java Runtime" "java -version"
Test-Command "Docker Engine" "docker --version"
Test-Command "Docker Compose" "docker-compose --version"
Test-Command "Git" "git --version"

Write-Host ""

# 2. Jenkins Setup Check
Write-Host "🏗️ STEP 2: Jenkins Setup Check" -ForegroundColor Yellow
Write-Host "------------------------------" -ForegroundColor Yellow

Test-FileExists "Jenkins WAR file" "C:\Jenkins\jenkins.war"
Test-FileExists "Jenkins startup script" "C:\Jenkins\start-jenkins.bat"
Test-FileExists "Jenkins home directory" "C:\Jenkins\jenkins_home"
Test-FileExists "Jenkins configuration" "C:\Jenkins\jenkins_home\config.xml"
Test-FileExists "Project job configuration" "C:\Jenkins\jenkins_home\jobs\fusionpact-devops-challenge\config.xml"

Write-Host ""

# 3. Jenkins Service Check
Write-Host "🔧 STEP 3: Jenkins Service Check" -ForegroundColor Yellow
Write-Host "--------------------------------" -ForegroundColor Yellow

Test-Port "Jenkins HTTP" -Port 8080
Test-Service "Jenkins Web Interface" "http://localhost:8080"

# Check if Jenkins login page is accessible
$global:totalChecks++
Write-Host "🔐 Testing Jenkins authentication..." -NoNewline
try {
    $loginResponse = Invoke-WebRequest -Uri "http://localhost:8080/login" -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
    if ($loginResponse.StatusCode -eq 200 -and $loginResponse.Content -like "*Jenkins*") {
        Write-Host " ✅" -ForegroundColor Green
        $global:passedChecks++
    } else {
        Write-Host " ❌" -ForegroundColor Red
    }
} catch {
    Write-Host " ❌ (Error: $($_.Exception.Message))" -ForegroundColor Red
}

Write-Host ""

# 4. Pipeline Configuration Check
Write-Host "📊 STEP 4: Pipeline Configuration Check" -ForegroundColor Yellow
Write-Host "---------------------------------------" -ForegroundColor Yellow

Test-FileExists "Jenkinsfile" ".\Jenkinsfile"
Test-FileExists "Docker Compose (Production)" ".\docker-compose.monitoring.yml"
Test-FileExists "Docker Compose (Staging)" ".\docker-compose.staging.yml"
Test-FileExists "Backend Dockerfile" ".\backend\Dockerfile"
Test-FileExists "Frontend Dockerfile" ".\frontend\Dockerfile"

Write-Host ""

# 5. Git Repository Check
Write-Host "📚 STEP 5: Git Repository Check" -ForegroundColor Yellow
Write-Host "-------------------------------" -ForegroundColor Yellow

$global:totalChecks++
Write-Host "🔍 Testing Git repository..." -NoNewline
try {
    $null = git status 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host " ✅" -ForegroundColor Green
        $global:passedChecks++
    } else {
        Write-Host " ❌ (Not a Git repository)" -ForegroundColor Red
    }
} catch {
    Write-Host " ❌ (Git error)" -ForegroundColor Red
}

$global:totalChecks++
Write-Host "📝 Testing Git commit history..." -NoNewline
try {
    $null = git log --oneline -n 1 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host " ✅" -ForegroundColor Green
        $global:passedChecks++
    } else {
        Write-Host " ❌ (No commits found)" -ForegroundColor Red
    }
} catch {
    Write-Host " ❌ (Git error)" -ForegroundColor Red
}

Write-Host ""

# 6. Level 1 & 2 Dependencies Check
Write-Host "🏢 STEP 6: Previous Levels Check" -ForegroundColor Yellow
Write-Host "--------------------------------" -ForegroundColor Yellow

# Check if previous level services are available
Test-Port "Frontend" -Port 8080
Test-Port "Backend API" -Port 8000
Test-Port "Prometheus" -Port 9090
Test-Port "Grafana" -Port 3000

Write-Host ""

# 7. Jenkins Job Check
Write-Host "🎯 STEP 7: Jenkins Job Verification" -ForegroundColor Yellow
Write-Host "-----------------------------------" -ForegroundColor Yellow

$global:totalChecks++
Write-Host "🔍 Testing Jenkins job accessibility..." -NoNewline
try {
    $jobResponse = Invoke-WebRequest -Uri "http://localhost:8080/job/fusionpact-devops-challenge/" -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
    if ($jobResponse.StatusCode -eq 200) {
        Write-Host " ✅" -ForegroundColor Green
        $global:passedChecks++
    } else {
        Write-Host " ❌" -ForegroundColor Red
    }
} catch {
    Write-Host " ❌ (Error: $($_.Exception.Message))" -ForegroundColor Red
}

Write-Host ""

# Summary
Write-Host "📊 HEALTH CHECK SUMMARY" -ForegroundColor Cyan
Write-Host "======================" -ForegroundColor Cyan
Write-Host ""

$successRate = [math]::Round(($passedChecks / $totalChecks) * 100, 1)

if ($successRate -ge 90) {
    Write-Host "🎉 EXCELLENT! ($passedChecks/$totalChecks checks passed - $successRate%)" -ForegroundColor Green
    $status = "READY"
    $statusColor = "Green"
} elseif ($successRate -ge 75) {
    Write-Host "✅ GOOD ($passedChecks/$totalChecks checks passed - $successRate%)" -ForegroundColor Yellow
    $status = "MOSTLY READY"
    $statusColor = "Yellow"
} elseif ($successRate -ge 50) {
    Write-Host "⚠️ NEEDS WORK ($passedChecks/$totalChecks checks passed - $successRate%)" -ForegroundColor Red
    $status = "NEEDS FIXES"
    $statusColor = "Red"
} else {
    Write-Host "❌ CRITICAL ISSUES ($passedChecks/$totalChecks checks passed - $successRate%)" -ForegroundColor Red
    $status = "NOT READY"
    $statusColor = "Red"
}

Write-Host ""
Write-Host "🏁 Level 3 Status: $status" -ForegroundColor $statusColor
Write-Host ""

# Action Items
if ($successRate -lt 100) {
    Write-Host "🔧 RECOMMENDED ACTIONS:" -ForegroundColor Yellow
    Write-Host ""
    
    if (-not (Test-Path "C:\Jenkins\jenkins.war")) {
        Write-Host "   • Run setup-jenkins.ps1 to install Jenkins" -ForegroundColor White
    }
    
    if (-not (Get-Process -Name "java" -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -like "*jenkins.war*" })) {
        Write-Host "   • Start Jenkins: .\run-jenkins.ps1" -ForegroundColor White
    }
    
    if (-not (Test-Path ".\.git")) {
        Write-Host "   • Initialize Git repository: git init" -ForegroundColor White
        Write-Host "   • Add files: git add ." -ForegroundColor White
        Write-Host "   • Commit: git commit -m 'Initial commit'" -ForegroundColor White
    }
    
    try {
        $null = docker ps 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Host "   • Start Docker Desktop application" -ForegroundColor White
        }
    } catch {
        Write-Host "   • Start Docker Desktop application" -ForegroundColor White
    }
    
    Write-Host ""
}

# Quick Access URLs
if ($successRate -ge 75) {
    Write-Host "🌐 QUICK ACCESS:" -ForegroundColor Cyan
    Write-Host "   Jenkins: http://localhost:8080" -ForegroundColor White
    Write-Host "   Pipeline: http://localhost:8080/job/fusionpact-devops-challenge/" -ForegroundColor White
    Write-Host "   Credentials: admin / admin123" -ForegroundColor White
    Write-Host ""
    Write-Host "🚀 TO START PIPELINE:" -ForegroundColor Green
    Write-Host "   1. Open: http://localhost:8080/job/fusionpact-devops-challenge/" -ForegroundColor White
    Write-Host "   2. Click 'Build Now'" -ForegroundColor White
    Write-Host "   3. Monitor progress in 'Build History'" -ForegroundColor White
    Write-Host ""
}

# Save results
$healthCheckResult = @{
    Timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Level = "Level 3 - CI/CD Automation"
    TotalChecks = $totalChecks
    PassedChecks = $passedChecks
    SuccessRate = $successRate
    Status = $status
    JenkinsURL = "http://localhost:8080"
    PipelineURL = "http://localhost:8080/job/fusionpact-devops-challenge/"
}

$healthCheckResult | ConvertTo-Json -Depth 3 | Out-File -FilePath "level3-health-check-results.json" -Encoding UTF8

Write-Host "📄 Results saved to: level3-health-check-results.json" -ForegroundColor Cyan
Write-Host "🎯 Level 3 Health Check Complete!" -ForegroundColor Green
