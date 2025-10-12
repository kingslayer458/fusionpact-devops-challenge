# 🗂️ FILE CLEANUP SCRIPT - CI/CD Project
# This script helps identify and delete unnecessary files while keeping essential ones

Write-Host "🗂️ CI/CD PROJECT FILE CLEANUP" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Yellow
Write-Host ""

# Essential files that MUST be kept
$essentialFiles = @(
    "README.md",
    "Jenkinsfile", 
    "docker-compose.yml",
    "docker-compose.monitoring.yml",
    "prometheus.yml",
    ".gitignore",
    "backend/",
    "frontend/",
    "grafana/"
)

Write-Host "✅ ESSENTIAL FILES (KEEP):" -ForegroundColor Green
$essentialFiles | ForEach-Object { Write-Host "   $_" -ForegroundColor White }
Write-Host ""

# Documentation files that can be deleted
$docFiles = @(
    "BUILD-2-SUCCESS-ANALYSIS.md",
    "CICD-OUTPUTS-COMPLETE.md", 
    "CICD-VERIFICATION-GUIDE.md",
    "COMPLETE-JENKINS-SETUP.md",
    "DEPLOYMENT-ANALYSIS.md",
    "DEPLOYMENT.md",
    "GITHUB-TOKEN-CHECKLIST.md",
    "github-token-setup.md", 
    "JENKINS-PORT-CONFIG.md",
    "JENKINS-SETUP-NEXT-STEPS.md",
    "LEVEL1-COMPLETE.md",
    "LEVEL2-COMPLETE.md",
    "LEVEL2-MONITORING.md",
    "LEVEL3-CHALLENGE-OVERVIEW.md",
    "LEVEL3-COMPLETE.md",
    "LEVEL3-DOCUMENTATION.md",
    "MISSION-ACCOMPLISHED.md",
    "PIPELINE-READY.md",
    "PORT-CONFIG.md",
    "PORT-CONFLICT-FIX.md",
    "PROJECT-COMPLETE.md",
    "PROMETHEUS-QUERIES.md",
    "SYSTEM-STATUS.md",
    "WINDOWS-FIX-COMPLETE.md"
)

Write-Host "📄 DOCUMENTATION FILES (CAN DELETE):" -ForegroundColor Yellow
$docFiles | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }
Write-Host ""

# Setup/utility scripts that can be deleted
$setupFiles = @(
    "configure-jenkins.ps1",
    "fix-status.ps1",
    "health-check-level2.ps1",
    "health-check-level3-simple.ps1", 
    "health-check-level3.ps1",
    "health-check.ps1",
    "health-check.sh",
    "jenkins-status.ps1",
    "quick-jenkins-setup.ps1",
    "run-jenkins-simple.ps1",
    "run-jenkins.ps1",
    "setup-github-token.ps1",
    "setup-jenkins-pipeline.ps1",
    "setup-jenkins-simple.ps1", 
    "setup-jenkins.ps1",
    "start-jenkins-8090.bat",
    "windows-fix-monitor.ps1"
)

Write-Host "🔧 SETUP SCRIPTS (CAN DELETE):" -ForegroundColor Yellow
$setupFiles | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }
Write-Host ""

# Redundant/backup files
$redundantFiles = @(
    "Jenkinsfile.windows",
    "docker-compose.prod.yml",
    "docker-compose.staging.yml", 
    "aws-deploy.sh",
    "jenkins-session.json",
    "IMPORTANT-COMMANDS.txt",
    "SOP CREATE HOME WEBPAGE USING NGINX SERVER.pdf"
)

Write-Host "🗃️ REDUNDANT FILES (CAN DELETE):" -ForegroundColor Yellow
$redundantFiles | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }
Write-Host ""

# Count files for deletion
$totalToDelete = $docFiles.Count + $setupFiles.Count + $redundantFiles.Count
Write-Host "📊 CLEANUP SUMMARY:" -ForegroundColor Cyan
Write-Host "   Essential files to keep: $($essentialFiles.Count)" -ForegroundColor Green
Write-Host "   Files that can be deleted: $totalToDelete" -ForegroundColor Yellow
Write-Host ""

$confirm = Read-Host "Do you want to DELETE all non-essential files? (y/N)"

if ($confirm -eq 'y' -or $confirm -eq 'Y') {
    Write-Host ""
    Write-Host "🗑️ DELETING FILES..." -ForegroundColor Red
    
    $deletedCount = 0
    $allFilesToDelete = $docFiles + $setupFiles + $redundantFiles
    
    foreach ($file in $allFilesToDelete) {
        if (Test-Path $file) {
            try {
                Remove-Item $file -Force
                Write-Host "   ✅ Deleted: $file" -ForegroundColor Green
                $deletedCount++
            } catch {
                Write-Host "   ❌ Failed to delete: $file" -ForegroundColor Red
            }
        } else {
            Write-Host "   ⚠️ Not found: $file" -ForegroundColor Yellow
        }
    }
    
    Write-Host ""
    Write-Host "🎉 CLEANUP COMPLETE!" -ForegroundColor Green
    Write-Host "   Files deleted: $deletedCount" -ForegroundColor White
    Write-Host "   Essential files preserved" -ForegroundColor White
    Write-Host ""
    Write-Host "📋 REMAINING FILES:" -ForegroundColor Cyan
    Get-ChildItem -Name | Sort-Object | ForEach-Object { Write-Host "   $_" -ForegroundColor White }
    
} else {
    Write-Host ""
    Write-Host "❌ CLEANUP CANCELLED" -ForegroundColor Yellow
    Write-Host "   No files were deleted" -ForegroundColor White
}

Write-Host ""
Write-Host "ℹ️ NOTE: Your CI/CD pipeline will continue working with essential files!" -ForegroundColor Cyan
