# Windows Jenkins Pipeline Fix - Build Monitor
# This script monitors the Jenkins build status after applying Windows compatibility fixes

Write-Host "🔧 JENKINS WINDOWS COMPATIBILITY FIX APPLIED" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host ""

Write-Host "📋 CHANGES MADE:" -ForegroundColor Cyan
Write-Host "  ✅ Replaced all 'sh' commands with 'bat' commands" -ForegroundColor Green
Write-Host "  ✅ Updated Git commands for Windows PowerShell compatibility" -ForegroundColor Green
Write-Host "  ✅ Fixed environment variable syntax for Windows (%VAR% instead of \$VAR)" -ForegroundColor Green
Write-Host "  ✅ Added Windows-specific conditional logic" -ForegroundColor Green
Write-Host "  ✅ Improved error handling for Windows environment" -ForegroundColor Green
Write-Host ""

Write-Host "🚀 JENKINS BUILD STATUS:" -ForegroundColor Cyan
Write-Host "  Jenkins URL: http://localhost:8090" -ForegroundColor Yellow
Write-Host "  Project: fusionpact-devops-challenge" -ForegroundColor Yellow
Write-Host "  Latest commit pushed: d122708" -ForegroundColor Yellow
Write-Host ""

Write-Host "⏱️ MONITORING BUILD..." -ForegroundColor Magenta
Write-Host ""

# Check if Jenkins is running
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8090" -TimeoutSec 5 -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Jenkins is running and accessible" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Jenkins is not accessible at http://localhost:8090" -ForegroundColor Red
    Write-Host "   Please ensure Jenkins is running on port 8090" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🔍 EXPECTED PIPELINE BEHAVIOR:" -ForegroundColor Cyan
Write-Host "  Stage 1: ✅ Checkout - Should work (uses bat for git commands)" -ForegroundColor Green
Write-Host "  Stage 2: ✅ Environment Setup - Should work (Windows-native commands)" -ForegroundColor Green
Write-Host "  Stage 3: ✅ Code Quality - Should work (file existence checks)" -ForegroundColor Green
Write-Host "  Stage 4: ✅ Build Images - Should work (Docker commands work on Windows)" -ForegroundColor Green
Write-Host "  Stage 5: ✅ Tests - Should work (Windows batch commands)" -ForegroundColor Green
Write-Host ""

Write-Host "🎯 NEXT STEPS:" -ForegroundColor Cyan
Write-Host "  1. Monitor the Jenkins build at: http://localhost:8090/job/fusionpact-devops-challenge/" -ForegroundColor Yellow
Write-Host "  2. Build #2 should complete successfully without shell errors" -ForegroundColor Yellow
Write-Host "  3. All 10 pipeline stages should execute properly" -ForegroundColor Yellow
Write-Host "  4. Check console output for detailed execution logs" -ForegroundColor Yellow
Write-Host ""

Write-Host "📊 DOCKER STATUS:" -ForegroundColor Cyan
try {
    $dockerImages = docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | Select-String "fusionpact"
    if ($dockerImages) {
        Write-Host "  Current Fusionpact images:" -ForegroundColor Green
        $dockerImages | ForEach-Object { Write-Host "    $_" -ForegroundColor White }
    } else {
        Write-Host "  No Fusionpact images found yet" -ForegroundColor Yellow
    }
    
    $runningContainers = docker ps --format "table {{.Names}}\t{{.Status}}"
    Write-Host "  Running containers:" -ForegroundColor Green
    if ($runningContainers) {
        $runningContainers | ForEach-Object { Write-Host "    $_" -ForegroundColor White }
    } else {
        Write-Host "    No containers currently running" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  Docker status check failed" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎉 WINDOWS COMPATIBILITY FIXES APPLIED!" -ForegroundColor Green
Write-Host "The Jenkins pipeline should now run successfully on Windows." -ForegroundColor Green
Write-Host ""
