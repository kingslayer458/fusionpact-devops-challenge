# Port Configuration Note

## Frontend Port Change

**Important:** The frontend service has been configured to run on port **8080** instead of port 80 to avoid conflicts with existing web servers (like XAMPP Apache) that may be running on port 80.

### Access URLs:
- **Frontend**: http://localhost:8080 (Fusionpact DevOps Internship page)
- **Backend API**: http://localhost:8000 (FastAPI endpoints)
- **Metrics**: http://localhost:8000/metrics (Prometheus metrics)

### Cloud Deployment:
When deploying to cloud, you can use port 80 for the frontend since there won't be port conflicts on a fresh cloud instance.

### Development:
If you want to use port 80 locally, you can:
1. Stop any existing web servers (XAMPP, IIS, etc.)
2. Update docker-compose.yml to use port 80
3. Restart the containers

### Security Groups (AWS):
- Allow inbound HTTP (8080) for frontend
- Allow inbound Custom TCP (8000) for backend API
- Allow inbound SSH (22) for management
