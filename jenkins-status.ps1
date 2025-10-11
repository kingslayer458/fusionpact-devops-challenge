Write-Host "Jenkins Configuration Status" -ForegroundColor Green
Write-Host "=============================" -ForegroundColor Green

# Check Jenkins
Write-Host "`nChecking Jenkins..." -NoNewline
try {
    Invoke-WebRequest -Uri "http://localhost:8090" -UseBasicParsing -TimeoutSec 5 | Out-Null
    Write-Host " RUNNING" -ForegroundColor Green
    
    Write-Host "`nJenkins Access:" -ForegroundColor Cyan
    Write-Host "URL: http://localhost:8090" -ForegroundColor White
    Write-Host "Status: Ready for configuration" -ForegroundColor White
    
    Write-Host "`nNext Steps:" -ForegroundColor Yellow
    Write-Host "1. Open: http://localhost:8090" -ForegroundColor White
    Write-Host "2. Create pipeline job named: fusionpact-devops-challenge" -ForegroundColor White
    Write-Host "3. Configure Git repository path" -ForegroundColor White
    Write-Host "4. Run first build" -ForegroundColor White
    
    Write-Host "`nOpening Jenkins..." -ForegroundColor Yellow
    Start-Process "http://localhost:8090"
    
} catch {
    Write-Host " NOT ACCESSIBLE" -ForegroundColor Red
    Write-Host "Try starting Jenkins manually:" -ForegroundColor Yellow
    Write-Host "java -jar C:\Jenkins\jenkins.war --httpPort=8090" -ForegroundColor Gray
}

Write-Host "`nProject Status:" -ForegroundColor Cyan
Write-Host "Level 1: COMPLETE" -ForegroundColor Green
Write-Host "Level 2: COMPLETE" -ForegroundColor Green  
Write-Host "Level 3: JENKINS RUNNING - PIPELINE SETUP NEEDED" -ForegroundColor Yellow
