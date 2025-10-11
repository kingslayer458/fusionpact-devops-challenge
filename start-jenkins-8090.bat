@echo off
echo Starting Jenkins for Fusionpact DevOps Challenge...
set JENKINS_HOME=C:\Jenkins\jenkins_home
if not exist "%JENKINS_HOME%" mkdir "%JENKINS_HOME%"
echo.
echo Jenkins Home: %JENKINS_HOME%
echo Jenkins WAR: C:\Jenkins\jenkins.war
echo.
echo Jenkins will be available at: http://localhost:8090
echo.

java -Djenkins.install.runSetupWizard=false -Djava.awt.headless=true -jar C:\Jenkins\jenkins.war --httpPort=8090 --ajp13Port=-1

pause
