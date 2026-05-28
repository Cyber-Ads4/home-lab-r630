# Lab 5 — Server Monitoring with Grafana + Prometheus

## 27
May 2026

## What I Was Trying to Do
Set up a real-time monitoring dashboard on my R630 so I can 
see CPU, RAM, disk, and network stats live — the same kind 
of setup used in actual data centers.

## What I Installed
- **Prometheus** — collects metrics from the server
- **Node Exporter** — pulls hardware stats (CPU, RAM, disk, 
  network) and feeds them to Prometheus
- **Grafana** — the dashboard UI that visualizes everything

## How I Did It

### Step 1 — Update packages
```bash
sudo apt update && sudo apt upgrade -y
```

### Step 2 — Install Prometheus
```bash
sudo apt install -y prometheus
sudo systemctl enable prometheus
sudo systemctl start prometheus
```

### Step 3 — Install Node Exporter
```bash
sudo apt install -y prometheus-node-exporter
sudo systemctl enable prometheus-node-exporter
sudo systemctl start prometheus-node-exporter
```

### Step 4 — Install Grafana
```bash
sudo apt install -y apt-transport-https software-properties-common
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | \
  sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt update
sudo apt install -y grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
```

### Step 5 — Connect Grafana to Prometheus
- Opened Grafana at `http://10.0.0.132:3000`
- Logged in (default: admin/admin)
- Went to Connections → Data Sources → Add data source
- Selected Prometheus
- Set URL to `http://localhost:9090`
- Clicked Save & Test — got green checkmark

### Step 6 — Import the Node Exporter Dashboard
- Clicked "+" → Import dashboard
- Entered dashboard ID: `1860`
- Selected my Prometheus data source
- Clicked Import

## Result
Live dashboard showing real-time CPU usage, RAM, disk I/O, 
network traffic, and system load on my R630. Data updates 
every few seconds automatically.

## What I Learned
- **Prometheus** scrapes and stores time-series metrics
- **Node Exporter** is the agent that collects hardware stats
- **Grafana** is just the visualization layer — it doesn't 
  store data itself
- Port 3000 = Grafana UI, Port 9090 = Prometheus UI
- This is the actual monitoring stack used in production 
  data centers and cloud environments

## Commands Reference
```bash
sudo systemctl status prometheus
sudo systemctl status prometheus-node-exporter
sudo systemctl status grafana-server
```

## Next Steps
- [ ] Lab 6 — iDRAC remote management setup
- [ ] Lab 7 — Automated system health check scripts
- [ ] Lab 8 — User management and permissions
