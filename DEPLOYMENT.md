# Fusionpact DevOps Challenge - Level 1 Deployment Guide

## Overview
This guide provides step-by-step instructions for deploying the Fusionpact DevOps Challenge application to the cloud using Docker containers.

## Application Architecture
- **Frontend**: HTML landing page served by Nginx (Port 80)
- **Backend**: FastAPI application with Prometheus metrics (Port 8000)
- **Data Persistence**: JSON file storage with Docker volumes

## Prerequisites
- Docker installed on local machine
- Cloud platform account (AWS, GCP, or Azure)
- Docker Hub account (for image registry)

## Local Development Setup

### 1. Build and Run Locally
```bash
# Build the images
docker-compose build

# Start the services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

### 2. Test the Application
- Frontend: http://localhost:8080
- Backend API: http://localhost:8000
- Metrics Endpoint: http://localhost:8000/metrics

### 3. API Endpoints
- `GET /` - Welcome message
- `POST /users` - Add user data
- `GET /users` - Retrieve user data
- `GET /metrics` - Prometheus metrics

## Cloud Deployment Options

### Option 1: AWS Deployment
1. **EC2 Instance with Docker**
   - Launch EC2 instance (t3.medium recommended)
   - Install Docker and Docker Compose
   - Upload files and run docker-compose

2. **AWS ECS (Elastic Container Service)**
   - Push images to ECR
   - Create ECS cluster
   - Define task definitions and services

3. **AWS App Runner**
   - Push to GitHub
   - Create App Runner service from repository

### Option 2: Google Cloud Platform
1. **Compute Engine with Docker**
   - Create VM instance
   - Install Docker
   - Run containers

2. **Cloud Run**
   - Push images to Container Registry
   - Deploy as Cloud Run services

### Option 3: Microsoft Azure
1. **Azure Container Instances**
   - Push to Azure Container Registry
   - Deploy container groups

2. **Azure App Service**
   - Deploy containers to App Service

## Production Considerations
1. **Security**: Use environment variables for sensitive data
2. **Monitoring**: Prometheus metrics are already configured
3. **Persistence**: Volume mounts ensure data persistence
4. **Scaling**: Services can be scaled independently
5. **Load Balancing**: Add reverse proxy for production

## Docker Images
- Frontend: nginx:alpine based
- Backend: python:3.11-slim based

## Ports
- Frontend: 8080 (HTTP)
- Backend: 8000 (HTTP API + Metrics)

## Volume Mounts
- `backend-data`: Persists user data JSON file

## Network
- Custom bridge network for inter-service communication

## Troubleshooting
1. Check container logs: `docker-compose logs [service-name]`
2. Verify network connectivity: `docker network ls`
3. Check volume mounts: `docker volume inspect fusionpact-devops-challenge_backend-data`
4. Test API endpoints individually
5. Verify port accessibility on cloud instances
