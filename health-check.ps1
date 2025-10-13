# PowerShell Health Check Script for Fusionpact DevOps Challenge
# This script monitors the health of both frontend and backend services

Write-Host "Fusionpact DevOps Challenge - Health Check" -ForegroundColor Cyan
Write-Host "==============================================`n" -ForegroundColor Cyan

# Check if Docker is running
try {
    docker info | Out-Null
    Write-Host "Docker is running" -ForegroundColor Green
} catch {
    Write-Host "Docker is not running" -ForegroundColor Red
    exit 1
}

# Check container status
Write-Host "`nContainer Status:" -ForegroundColor Yellow
docker-compose ps

Write-Host ""

# Test Frontend
Write-Host "Testing Frontend Service..." -ForegroundColor Yellow
try {
    $frontendResponse = Invoke-WebRequest -Uri "http://localhost:8070" -Method Head -TimeoutSec 10
    if ($frontendResponse.StatusCode -eq 200) {
        Write-Host "Frontend: HEALTHY (Status: $($frontendResponse.StatusCode))" -ForegroundColor Green
    } else {
        Write-Host "Frontend: UNHEALTHY (Status: $($frontendResponse.StatusCode))" -ForegroundColor Red
    }
} catch {
    Write-Host "Frontend: UNHEALTHY (Error: $($_.Exception.Message))" -ForegroundColor Red
}

# Test Backend API
Write-Host "Testing Backend API..." -ForegroundColor Yellow
try {
    $backendResponse = Invoke-WebRequest -Uri "http://localhost:8070" -TimeoutSec 10
    if ($backendResponse.StatusCode -eq 200) {
        Write-Host "Backend API: HEALTHY (Status: $($backendResponse.StatusCode))" -ForegroundColor Green
        Write-Host "   Response: $($backendResponse.Content)" -ForegroundColor Gray
    } else {
        Write-Host "Backend API: UNHEALTHY (Status: $($backendResponse.StatusCode))" -ForegroundColor Red
    }
} catch {
    Write-Host "Backend API: UNHEALTHY (Error: $($_.Exception.Message))" -ForegroundColor Red
}

# Test Metrics Endpoint
Write-Host "Testing Metrics Endpoint..." -ForegroundColor Yellow
try {
    $metricsResponse = Invoke-WebRequest -Uri "http://localhost:8060/metrics" -Method Head -TimeoutSec 10
    if ($metricsResponse.StatusCode -eq 200) {
        Write-Host "Metrics: HEALTHY (Status: $($metricsResponse.StatusCode))" -ForegroundColor Green
    } else {
        Write-Host "Metrics: UNHEALTHY (Status: $($metricsResponse.StatusCode))" -ForegroundColor Red
    }
} catch {
    Write-Host "Metrics: UNHEALTHY (Error: $($_.Exception.Message))" -ForegroundColor Red
}

# Test Users API
Write-Host "Testing Users API..." -ForegroundColor Yellow
try {
    $usersResponse = Invoke-WebRequest -Uri "http://localhost:8060/users" -TimeoutSec 10
    if ($usersResponse.StatusCode -eq 200) {
        Write-Host "Users GET: HEALTHY (Status: $($usersResponse.StatusCode))" -ForegroundColor Green
        Write-Host "   Current users: $($usersResponse.Content)" -ForegroundColor Gray
    } else {
        Write-Host "Users GET: UNHEALTHY (Status: $($usersResponse.StatusCode))" -ForegroundColor Red
    }
} catch {
    Write-Host "Users GET: UNHEALTHY (Error: $($_.Exception.Message))" -ForegroundColor Red
}

# Test POST endpoint with sample data
Write-Host "Testing Users POST..." -ForegroundColor Yellow
try {
    $postBody = @{
        first_name = "Test"
        last_name = "User"
        age = 25
    } | ConvertTo-Json

    $postResponse = Invoke-WebRequest -Uri "http://localhost:8060/users" -Method Post -Body $postBody -ContentType "application/json" -TimeoutSec 10
    if ($postResponse.StatusCode -eq 200) {
        Write-Host "Users POST: HEALTHY (Status: $($postResponse.StatusCode))" -ForegroundColor Green
        Write-Host "   Response: $($postResponse.Content)" -ForegroundColor Gray
    } else {
        Write-Host "Users POST: UNHEALTHY (Status: $($postResponse.StatusCode))" -ForegroundColor Red
    }
} catch {
    Write-Host "Users POST: UNHEALTHY (Error: $($_.Exception.Message))" -ForegroundColor Red
}

# Check data persistence
Write-Host "Checking Data Persistence..." -ForegroundColor Yellow
$volumeCheck = docker volume ls | Select-String "backend-data"
if ($volumeCheck) {
    Write-Host "Data volume exists" -ForegroundColor Green
    $volumeInfo = docker volume inspect fusionpact-devops-challenge_backend-data --format '{{.Mountpoint}}'
    Write-Host "   Volume location: $volumeInfo" -ForegroundColor Gray
} else {
    Write-Host "Data volume missing" -ForegroundColor Red
}

# Resource usage
Write-Host "`nResource Usage:" -ForegroundColor Yellow
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"

Write-Host "`nHealth check complete!" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
