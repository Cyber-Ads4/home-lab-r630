# Lab 4 — Server Health Check Bash Script

## Date
May 23 2026

## What I Was Trying To Do
Write a bash script that checks the health of my server 
in one command. CPU, RAM, disk, temperature, network — 
all in one shot. This is something I'd run daily on a 
real data center server.

---

## What I Built

A script called `health_check` that I can run from 
anywhere on the server and get a full snapshot of 
system health instantly.

---

## What The Script Checks

| Check | Command Used |
|---|---|
| CPU Load | `uptime` |
| Memory Usage | `free -h` |
| Disk Usage | `df -h /` |
| Temperature | `sensors` |
| Network | `ip addr show eno3` |
| Uptime | `uptime -p` |
| Top Processes | `ps aux --sort=-%cpu` |

---

================================
R630 Server Health Check
Sat May 23 01:43:50 AM CT 2026
--- CPU Load ---
01:43:50 up 40 min,  2 users,  load average: 0.91, 0.34, 0.11
--- Memory Usage ---
total        used        free
Mem:            31Gi       886Mi        30Gi
Swap:          8.0Gi          0B       8.0Gi
--- Disk Usage ---
Filesystem                         Size  Used Avail Use%
/dev/mapper/ubuntu--vg-ubuntu--lv   98G   11G   83G  12%
--- Temperature ---
Package id 0:  +50.0°C  (high = +77.0°C, crit = +87.0°C)
Package id 1:  +46.0°C  (high = +77.0°C, crit = +87.0°C)
All 16 cores reporting between 36°C - 45°C
--- Network ---
inet 10.0.0.1///24 scope global eno3
--- Uptime ---
up 40 minutes

---

---

## How I Built It

### Step 1 — Created The Script
```bash
nano health_check.sh
```

### Step 2 — Made It Executable
```bash
chmod +x health_check.sh
```

### Step 3 — Installed Temperature Sensors
```bash
sudo apt install lm-sensors -y
sudo sensors-detect --auto
sudo modprobe coretemp
```

### Step 4 — Moved To System Path
So it runs from anywhere on the server:
```bash
sudo mv health_check.sh /usr/local/bin/health_check
sudo chmod +x /usr/local/bin/health_check
```

### Step 5 — Run It Anytime
```bash
health_check
```

---

## What I Learned

- Bash scripts automate repetitive tasks
- `sensors` reads real hardware temperature data 
  from the CPU cores
- Moving scripts to `/usr/local/bin` makes them 
  available system-wide
- `ps aux --sort=-%cpu` shows processes sorted 
  by CPU usage — useful for finding resource hogs
- Enterprise servers like the R630 expose detailed 
  per-core temperature data
- Real data center technicians run health checks 
  like this constantly to monitor server status

---

## Key Commands
```bash
# Run health check
health_check

# Check temps manually
sensors

# Check memory
free -h

# Check disk
df -h

# Check top processes
ps aux --sort=-%cpu | head -10

# Check uptime
uptime
```

---

## Next Steps
- [ ] Lab 5 — Set up Grafana + Prometheus monitoring dashboard
- [ ] Lab 6 — Configure iDRAC remote management
- [ ] Lab 7 — Automate health check with cron job
- [ ] Lab 8 — Set up automatic security updates
