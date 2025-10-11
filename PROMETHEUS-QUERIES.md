# Prometheus Query Examples - Fusionpact DevOps Challenge

## 🔍 Basic Health Queries

### 1. Service Availability
```promql
up
```
**What it shows**: All services that are UP (1) or DOWN (0)
**Expected result**: Should show 4 targets all with value 1

### 2. HTTP Request Rate
```promql
rate(http_requests_total[5m])
```
**What it shows**: HTTP requests per second over the last 5 minutes
**Expected result**: Shows request rates for your API endpoints

### 3. HTTP Request Total Count
```promql
http_requests_total
```
**What it shows**: Total number of HTTP requests received
**Expected result**: Shows cumulative request counts by endpoint

## 📊 Infrastructure Monitoring Queries

### 4. Container CPU Usage
```promql
rate(container_cpu_usage_seconds_total{name=~"fusionpact-.*"}[5m]) * 100
```
**What it shows**: CPU usage percentage for Fusionpact containers
**Expected result**: CPU usage graphs for frontend/backend containers

### 5. Container Memory Usage
```promql
container_memory_usage_bytes{name=~"fusionpact-.*"}
```
**What it shows**: Memory usage in bytes for containers
**Expected result**: Memory consumption for each container

### 6. System Load Average
```promql
node_load1
```
**What it shows**: 1-minute system load average
**Expected result**: Current system load

### 7. Available Memory
```promql
node_memory_MemAvailable_bytes
```
**What it shows**: Available system memory in bytes
**Expected result**: Free memory on the host system

## 🚀 Application Performance Queries

### 8. Response Time Percentiles
```promql
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
```
**What it shows**: 95th percentile response time
**Expected result**: How fast 95% of requests are served

### 9. Error Rate
```promql
rate(http_requests_total{status=~"5.."}[5m])
```
**What it shows**: Rate of 5xx HTTP errors
**Expected result**: Should be 0 if no server errors

### 10. Request Duration by Endpoint
```promql
http_request_duration_seconds
```
**What it shows**: Request duration metrics by endpoint
**Expected result**: Timing information for each API endpoint

## 🔧 Container Monitoring Queries

### 11. Container Network Received
```promql
rate(container_network_receive_bytes_total{name=~"fusionpact-.*"}[5m])
```
**What it shows**: Network bytes received per second
**Expected result**: Network input for containers

### 12. Container Network Transmitted
```promql
rate(container_network_transmit_bytes_total{name=~"fusionpact-.*"}[5m])
```
**What it shows**: Network bytes transmitted per second
**Expected result**: Network output for containers

### 13. Filesystem Usage
```promql
(node_filesystem_size_bytes - node_filesystem_free_bytes) / node_filesystem_size_bytes * 100
```
**What it shows**: Filesystem usage percentage
**Expected result**: Disk usage percentage

## 📈 How to Use These Queries

1. **Copy any query** from above
2. **Paste into Prometheus query box** at http://localhost:9090
3. **Click "Execute"** or press Enter
4. **Switch to "Graph" tab** to see time-series visualization
5. **Adjust time range** using the time picker

## 🎯 Expected Results

If everything is working correctly, you should see:
- ✅ `up` query shows 4 targets with value 1
- ✅ `http_requests_total` shows some data (even if small numbers)
- ✅ Container queries show data for fusionpact-frontend and fusionpact-backend
- ✅ Node exporter queries show system metrics

## 🔄 Generate Test Data

If you want to see more interesting metrics, run this to generate API traffic:

```bash
# In PowerShell
for ($i = 1; $i -le 20; $i++) { 
    Invoke-WebRequest -Uri "http://localhost:8000" | Out-Null
    Invoke-WebRequest -Uri "http://localhost:8000/users" | Out-Null
    Start-Sleep -Seconds 1 
}
```

This will create HTTP request metrics that you can then query and visualize!
