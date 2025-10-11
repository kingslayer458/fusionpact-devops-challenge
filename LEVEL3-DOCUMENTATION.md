# Level 3 - CI/CD Automation with Jenkins

## Overview
Level 3 implements a complete CI/CD pipeline using Jenkins for the Fusionpact DevOps Challenge. This automated pipeline handles:
- Code checkout and environment setup
- Code quality and security scanning
- Docker image building and testing
- Multi-environment deployment
- Post-deployment verification

## Architecture

### Pipeline Stages
1. **Checkout** - Source code retrieval from Git
2. **Environment Setup** - Build environment preparation
3. **Code Quality & Security Scan** - Parallel linting and validation
4. **Build Docker Images** - Parallel backend/frontend builds
5. **Test** - Unit and integration testing in parallel
6. **Security Scan** - Vulnerability scanning
7. **Push to Registry** - Image publishing (main/develop branches)
8. **Deploy to Staging** - Automatic staging deployment (develop branch)
9. **Deploy to Production** - Manual production deployment (main branch)
10. **Post-Deployment Tests** - Comprehensive verification

### Branch Strategy
- **main**: Production deployments with manual approval
- **develop**: Automatic staging deployments
- **feature/**: Build and test only

## Files Created

### Core Pipeline Files
- `Jenkinsfile` - Complete CI/CD pipeline definition
- `docker-compose.staging.yml` - Staging environment configuration
- `setup-jenkins.ps1` - Automated Jenkins installation and setup
- `run-jenkins.ps1` - Quick Jenkins startup script
- `health-check-level3.ps1` - Comprehensive pipeline validation

### Pipeline Features
- **Parallel Execution**: Linting, building, and testing run in parallel
- **Multi-Environment**: Separate staging and production deployments
- **Quality Gates**: Code quality, security, and testing checkpoints
- **Manual Approval**: Production deployments require manual confirmation
- **Health Checks**: Comprehensive post-deployment verification
- **Cleanup**: Automatic cleanup of old Docker images and artifacts

## Setup Instructions

### Prerequisites
- Java 11+ installed and in PATH
- Docker Desktop running
- Git repository initialized
- PowerShell execution policy allows scripts

### Quick Setup
1. **Install Jenkins**:
   ```powershell
   .\setup-jenkins.ps1
   ```

2. **Start Jenkins**:
   ```powershell
   .\run-jenkins.ps1
   ```

3. **Access Jenkins**:
   - URL: http://localhost:8080
   - Username: admin
   - Password: admin123

### Manual Setup
If automatic setup fails:

1. **Download Jenkins**:
   ```powershell
   # Create directory
   New-Item -ItemType Directory -Path "C:\Jenkins" -Force
   
   # Download Jenkins WAR
   Invoke-WebRequest -Uri "https://get.jenkins.io/war-stable/latest/jenkins.war" -OutFile "C:\Jenkins\jenkins.war"
   ```

2. **Start Jenkins**:
   ```powershell
   $env:JENKINS_HOME = "C:\Jenkins\jenkins_home"
   java -jar C:\Jenkins\jenkins.war --httpPort=8080
   ```

3. **Setup Job Manually**:
   - Create new Pipeline job: "fusionpact-devops-challenge"
   - Set SCM to Git with local repository path
   - Set Script Path to "Jenkinsfile"

## Pipeline Configuration

### Environment Variables
```groovy
DOCKER_REGISTRY = 'docker.io'
DOCKER_REPO = 'fusionpact-devops-challenge'
BACKEND_IMAGE = "${DOCKER_REGISTRY}/${DOCKER_REPO}-backend"
FRONTEND_IMAGE = "${DOCKER_REGISTRY}/${DOCKER_REPO}-frontend"
BUILD_NUMBER = "${env.BUILD_NUMBER}"
GIT_COMMIT_SHORT = "${env.GIT_COMMIT?.take(7)}"
```

### Parallel Stages
The pipeline uses parallel execution for:
- **Code Quality**: Backend linting + Frontend validation
- **Docker Builds**: Backend image + Frontend image
- **Testing**: Unit tests + Integration tests

### Conditional Deployments
- **Registry Push**: Only on main/develop branches
- **Staging Deploy**: Only on develop branch
- **Production Deploy**: Only on main branch with manual approval

## Testing Strategy

### Unit Tests
- Python unit tests for backend API
- Basic test cases for endpoints
- Pytest framework with coverage

### Integration Tests
- Full stack testing with Docker Compose
- API endpoint validation
- Service connectivity verification

### Security Scanning
- Python dependency vulnerability scanning
- Docker image security analysis
- Container security best practices

## Deployment Strategy

### Staging Environment
- Automatic deployment on develop branch
- Simplified service stack (frontend + backend only)
- Health check validation

### Production Environment
- Manual approval required
- Full monitoring stack deployment
- Blue-green deployment simulation
- Comprehensive post-deployment tests

## Monitoring Integration

### Pipeline Metrics
- Build success/failure rates
- Test coverage reporting
- Deployment frequency tracking
- Lead time measurement

### Service Monitoring
- Integration with existing Prometheus/Grafana stack
- Container health monitoring
- Application performance metrics
- Infrastructure monitoring

## Security Features

### Code Security
- Dependency vulnerability scanning
- Docker image security analysis
- Secret management (credentials)
- Access control (authentication)

### Runtime Security
- Container security scanning
- Network security policies
- Resource limits and quotas
- Security best practices

## Troubleshooting

### Common Issues

1. **Jenkins Won't Start**:
   ```powershell
   # Check Java version
   java -version
   
   # Check port availability
   netstat -an | findstr :8080
   
   # Check Jenkins logs
   Get-Job | Receive-Job
   ```

2. **Pipeline Fails**:
   ```powershell
   # Check Docker is running
   docker ps
   
   # Stop conflicting services
   docker-compose down
   
   # Clear Docker cache
   docker system prune -f
   ```

3. **Git Repository Issues**:
   ```powershell
   # Initialize repository
   git init
   git add .
   git commit -m "Initial commit"
   ```

4. **Port Conflicts**:
   ```powershell
   # Find process using port
   netstat -ano | findstr :8080
   
   # Stop process
   taskkill /PID <PID> /F
   ```

### Health Check
Run comprehensive validation:
```powershell
.\health-check-level3.ps1
```

## Performance Optimization

### Pipeline Optimization
- Parallel stage execution
- Docker layer caching
- Incremental builds
- Test result caching

### Resource Management
- Container resource limits
- Build agent optimization
- Disk space management
- Memory usage monitoring

## Best Practices

### Pipeline Design
1. **Fail Fast**: Early validation and quick feedback
2. **Parallel Execution**: Maximize throughput
3. **Quality Gates**: Automated quality checks
4. **Manual Approval**: Production safety
5. **Comprehensive Testing**: Multiple test layers

### Security Best Practices
1. **Credential Management**: Secure credential storage
2. **Image Scanning**: Regular vulnerability scans
3. **Access Control**: Role-based permissions
4. **Audit Logging**: Complete audit trail
5. **Secret Rotation**: Regular credential updates

### Deployment Best Practices
1. **Blue-Green Deployment**: Zero-downtime deployments
2. **Rollback Strategy**: Quick rollback capability
3. **Health Checks**: Comprehensive validation
4. **Monitoring**: Real-time observability
5. **Documentation**: Complete operational docs

## Integration with Previous Levels

### Level 1 Integration
- Uses containerized applications
- Leverages Docker Compose configurations
- Maintains port mappings and networking

### Level 2 Integration
- Deploys full monitoring stack
- Integrates with Prometheus metrics
- Maintains Grafana dashboards
- Preserves monitoring configurations

## Success Criteria

Level 3 is considered complete when:
- [ ] Jenkins is installed and accessible
- [ ] Pipeline job is configured and functional
- [ ] All pipeline stages execute successfully
- [ ] Code quality checks pass
- [ ] Docker images build successfully
- [ ] Tests execute and pass
- [ ] Staging deployment works
- [ ] Production deployment with approval works
- [ ] Post-deployment verification passes
- [ ] Health checks show 90%+ success rate

## Quick Commands

### Start Jenkins
```powershell
.\run-jenkins.ps1
```

### Check Health
```powershell
.\health-check-level3.ps1
```

### Trigger Build
```powershell
# Open pipeline URL
Start-Process "http://localhost:8080/job/fusionpact-devops-challenge/"
```

### View Logs
```powershell
# Jenkins job logs
Get-Job | Receive-Job

# Docker container logs
docker-compose logs
```

### Stop Jenkins
```powershell
# Find Jenkins job
Get-Job

# Stop Jenkins job
Stop-Job <JobID>
```

## Next Steps
After completing Level 3:
1. Consider cloud deployment (AWS/Azure/GCP)
2. Implement advanced monitoring and alerting
3. Add automated testing strategies
4. Explore GitOps workflows
5. Implement infrastructure as code

## Support
- Check health-check-level3.ps1 output for diagnostics
- Review Jenkins console logs for pipeline issues
- Verify Docker Desktop is running
- Ensure all prerequisite tools are installed
