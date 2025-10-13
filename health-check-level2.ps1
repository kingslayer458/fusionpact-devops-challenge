# PowerShell Health Check Script for Fusionpact DevOps Challenge - Level 2
# This script monitors all services including Prometheus and Grafana

Write-Host "Fusionpact DevOps Challenge - Level 2 Health Check" -ForegroundColor Cyan
Write-Host "=====================================================`n" -ForegroundColor Cyan

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
docker-compose -f docker-compose.monitoring.yml ps

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
    $backendResponse = Invoke-WebRequest -Uri "http://localhost:8060" -TimeoutSec 10
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
Write-Host "Testing Backend Metrics Endpoint..." -ForegroundColor Yellow
try {
    $metricsResponse = Invoke-WebRequest -Uri "http://localhost:8060/metrics" -TimeoutSec 10
    if ($metricsResponse.StatusCode -eq 200) {
        Write-Host "Backend Metrics: HEALTHY (Status: $($metricsResponse.StatusCode))" -ForegroundColor Green
    } else {
        Write-Host "Backend Metrics: UNHEALTHY (Status: $($metricsResponse.StatusCode))" -ForegroundColor Red
    }
} catch {
    Write-Host "Backend Metrics: UNHEALTHY (Error: $($_.Exception.Message))" -ForegroundColor Red
}

# Test Prometheus
Write-Host "Testing Prometheus..." -ForegroundColor Yellow
try {
    $prometheusResponse = Invoke-WebRequest -Uri "http://localhost:9090" -Method Head -TimeoutSec 10
    if ($prometheusResponse.StatusCode -eq 200) {
        Write-Host "Prometheus: HEALTHY (Status: $($prometheusResponse.StatusCode))" -ForegroundColor Green
    } else {
        Write-Host "Prometheus: UNHEALTHY (Status: $($prometheusResponse.StatusCode))" -ForegroundColor Red
    }
} catch {
    Write-Host "Prometheus: UNHEALTHY (Error: $($_.Exception.Message))" -ForegroundColor Red
}

# Test Grafana
Write-Host "Testing Grafana..." -ForegroundColor Yellow
try {
    $grafanaResponse = Invoke-WebRequest -Uri "http://localhost:3000" -Method Head -TimeoutSec 10
    if ($grafanaResponse.StatusCode -eq 200) {
        Write-Host "Grafana: HEALTHY (Status: $($grafanaResponse.StatusCode))" -ForegroundColor Green
    } else {
        Write-Host "Grafana: UNHEALTHY (Status: $($grafanaResponse.StatusCode))" -ForegroundColor Red
    }
} catch {
    Write-Host "Grafana: UNHEALTHY (Error: $($_.Exception.Message))" -ForegroundColor Red
}

# Test cAdvisor
Write-Host "Testing cAdvisor..." -ForegroundColor Yellow
try {
    $cadvisorResponse = Invoke-WebRequest -Uri "http://localhost:8081" -Method Head -TimeoutSec 10
    if ($cadvisorResponse.StatusCode -eq 200) {
        Write-Host "cAdvisor: HEALTHY (Status: $($cadvisorResponse.StatusCode))" -ForegroundColor Green
    } else {
        Write-Host "cAdvisor: UNHEALTHY (Status: $($cadvisorResponse.StatusCode))" -ForegroundColor Red
    }
} catch {
    Write-Host "cAdvisor: UNHEALTHY (Error: $($_.Exception.Message))" -ForegroundColor Red
}

# Test Node Exporter
Write-Host "Testing Node Exporter..." -ForegroundColor Yellow
try {
    $nodeResponse = Invoke-WebRequest -Uri "http://localhost:9100" -Method Head -TimeoutSec 10
    if ($nodeResponse.StatusCode -eq 200) {
        Write-Host "Node Exporter: HEALTHY (Status: $($nodeResponse.StatusCode))" -ForegroundColor Green
    } else {
        Write-Host "Node Exporter: UNHEALTHY (Status: $($nodeResponse.StatusCode))" -ForegroundColor Red
    }
} catch {
    Write-Host "Node Exporter: UNHEALTHY (Error: $($_.Exception.Message))" -ForegroundColor Red
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

# Check data persistence
Write-Host "Checking Data Persistence..." -ForegroundColor Yellow
$volumeCheck = docker volume ls | Select-String "backend-data"
if ($volumeCheck) {
    Write-Host "Data volume exists" -ForegroundColor Green
} else {
    Write-Host "Data volume missing" -ForegroundColor Red
}

# Resource usage
Write-Host "`nResource Usage:" -ForegroundColor Yellow
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"

Write-Host "`nAccess URLs:" -ForegroundColor Cyan
Write-Host "Frontend:        http://localhost:8080" -ForegroundColor White
Write-Host "Backend API:     http://localhost:8000" -ForegroundColor White
Write-Host "Prometheus:      http://localhost:9090" -ForegroundColor White
Write-Host "Grafana:         http://localhost:3000 (admin/admin123)" -ForegroundColor White
Write-Host "cAdvisor:        http://localhost:8081" -ForegroundColor White
Write-Host "Node Exporter:   http://localhost:9100" -ForegroundColor White

Write-Host "`nLevel 2 Health check complete!" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
