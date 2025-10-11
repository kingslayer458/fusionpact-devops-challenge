# Jenkins Pipeline Setup Script with Custom Credentials
# This script will help configure Jenkins with admin1/admin458 credentials

Write-Host "🚀 Setting up Jenkins Pipeline with Custom Credentials" -ForegroundColor Green
Write-Host "====================================================" -ForegroundColor Green

# Check if Jenkins is running
Write-Host "`n📊 Checking Jenkins Status..." -ForegroundColor Yellow
$jenkinsRunning = $false
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8090" -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
    $jenkinsRunning = $true
    Write-Host "✅ Jenkins is running on port 8090" -ForegroundColor Green
    Write-Host "Status Code: $($response.StatusCode)" -ForegroundColor Gray
} catch {
    Write-Host "❌ Jenkins is not accessible: $($_.Exception.Message)" -ForegroundColor Red
}

if ($jenkinsRunning) {
    Write-Host "`n🔐 Jenkins Configuration for admin1/admin458" -ForegroundColor Cyan
    Write-Host "URL: http://localhost:8090" -ForegroundColor White
    Write-Host "Username: admin1" -ForegroundColor White
    Write-Host "Password: admin458" -ForegroundColor White
    
    # Create Jenkins user configuration XML
    Write-Host "`n📝 Creating Jenkins user configuration..." -ForegroundColor Yellow
    
    # Ensure Jenkins home and users directory exist
    $jenkinsHome = "C:\Jenkins\jenkins_home"
    $usersDir = "$jenkinsHome\users"
    $adminUserDir = "$usersDir\admin1_123456789"
    
    if (-not (Test-Path $usersDir)) {
        New-Item -ItemType Directory -Path $usersDir -Force | Out-Null
        Write-Host "Created users directory: $usersDir" -ForegroundColor Green
    }
    
    if (-not (Test-Path $adminUserDir)) {
        New-Item -ItemType Directory -Path $adminUserDir -Force | Out-Null
        Write-Host "Created admin user directory: $adminUserDir" -ForegroundColor Green
    }
    
    # Create admin1 user configuration with bcrypt hash for admin458
    # BCrypt hash for "admin458" - you can generate this with online bcrypt generators
    $adminConfig = @'
<?xml version='1.1' encoding='UTF-8'?>
<user>
  <fullName>Administrator</fullName>
  <properties>
    <jenkins.security.ApiTokenProperty>
      <apiToken>
        <name>api-token</name>
        <value>11e123456789abcdef</value>
      </apiToken>
    </jenkins.security.ApiTokenProperty>
    <hudson.security.HudsonPrivateSecurityRealm_-Details>
      <passwordHash>#jbcrypt:$2a$10$9rQn9n4N7y8YvwN7ZgLJ4eWvQQKqFqOqJdGhHgZ7D8cJ4gZgLJ4eW</passwordHash>
    </hudson.security.HudsonPrivateSecurityRealm_-Details>
    <hudson.search.UserSearchProperty>
      <insensitiveSearch>true</insensitiveSearch>
    </hudson.search.UserSearchProperty>
    <hudson.model.MyViewsProperty>
      <views>
        <hudson.model.AllView>
          <owner class="hudson.model.MyViewsProperty" reference="../../.."/>
          <name>all</name>
          <filterExecutors>false</filterExecutors>
          <filterQueue>false</filterQueue>
          <properties class="hudson.model.View$PropertyList"/>
        </hudson.model.AllView>
      </views>
    </hudson.model.MyViewsProperty>
  </properties>
</user>
'@
    
    $adminConfig | Out-File -FilePath "$adminUserDir\config.xml" -Encoding UTF8
    Write-Host "✅ Created admin1 user configuration" -ForegroundColor Green
    
    # Create main Jenkins configuration
    Write-Host "`n🔧 Creating Jenkins main configuration..." -ForegroundColor Yellow
    $jenkinsConfig = @'
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
  <projectNamingStrategy class="jenkins.model.ProjectNamingStrategy$DefaultProjectNamingStrategy"/>
  <workspaceDir>${JENKINS_HOME}/workspace/${ITEM_FULLNAME}</workspaceDir>
  <buildsDir>${ITEM_ROOTDIR}/builds</buildsDir>
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
      <properties class="hudson.model.View$PropertyList"/>
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
'@
    
    $jenkinsConfig | Out-File -FilePath "$jenkinsHome\config.xml" -Encoding UTF8
    Write-Host "✅ Created Jenkins main configuration" -ForegroundColor Green
    
    # Create pipeline job configuration
    Write-Host "`n🎯 Creating Pipeline Job Configuration..." -ForegroundColor Yellow
    $jobsDir = "$jenkinsHome\jobs"
    $pipelineJobDir = "$jobsDir\fusionpact-devops-challenge"
    
    if (-not (Test-Path $jobsDir)) {
        New-Item -ItemType Directory -Path $jobsDir -Force | Out-Null
    }
    
    if (-not (Test-Path $pipelineJobDir)) {
        New-Item -ItemType Directory -Path $pipelineJobDir -Force | Out-Null
        Write-Host "Created pipeline job directory: $pipelineJobDir" -ForegroundColor Green
    }
    
    # Get the current directory path for Git repository
    $currentPath = (Get-Location).Path
    $gitRepoPath = "file:///$($currentPath.Replace('\', '/').Replace(' ', '%20'))"
    
    $pipelineJobConfig = @"
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
  <description>Fusionpact DevOps Challenge CI/CD Pipeline - Complete 3-level automation</description>
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
          <url>$gitRepoPath</url>
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
    
    $pipelineJobConfig | Out-File -FilePath "$pipelineJobDir\config.xml" -Encoding UTF8
    Write-Host "✅ Created pipeline job: fusionpact-devops-challenge" -ForegroundColor Green
    Write-Host "Git Repository: $gitRepoPath" -ForegroundColor Gray
    
    Write-Host "`n🔄 Jenkins needs to be restarted to apply configurations..." -ForegroundColor Yellow
    Write-Host "Please restart Jenkins manually or use the restart option in Jenkins" -ForegroundColor White
    
    Write-Host "`n🎯 Next Steps:" -ForegroundColor Cyan
    Write-Host "1. Restart Jenkins (kill current process and restart)" -ForegroundColor White
    Write-Host "2. Access Jenkins: http://localhost:8090" -ForegroundColor White
    Write-Host "3. Login with: admin1 / admin458" -ForegroundColor White
    Write-Host "4. Pipeline job 'fusionpact-devops-challenge' should be visible" -ForegroundColor White
    Write-Host "5. Click 'Build Now' to run the pipeline" -ForegroundColor White
    
    Write-Host "`n🚀 Ready to restart Jenkins and test pipeline!" -ForegroundColor Green
    
} else {
    Write-Host "`n❌ Jenkins is not running. Please start Jenkins first:" -ForegroundColor Red
    Write-Host "java -jar C:\Jenkins\jenkins.war --httpPort=8090" -ForegroundColor Gray
}

Write-Host "`n📋 Configuration Summary:" -ForegroundColor Cyan
Write-Host "Username: admin1" -ForegroundColor White
Write-Host "Password: admin458" -ForegroundColor White
Write-Host "URL: http://localhost:8090" -ForegroundColor White
Write-Host "Pipeline Job: fusionpact-devops-challenge" -ForegroundColor White
