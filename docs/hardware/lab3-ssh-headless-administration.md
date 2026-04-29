# Lab 3 — SSH Setup & Headless Server Administration

## Date
April 2026

## What I Was Trying To Do
Get my server connected to the network and SSH into it 
from my MacBook so I never have to touch the monitor 
or keyboard again. That was the goal.

---

## Environment
| Component | Detail |
|---|---|
| Server | Dell PowerEdge R630 |
| OS | Ubuntu Server 24.04 LTS |
| NIC | eno3 — Intel I350 1Gbps |
| Router | Xfinity (10.0.0.1) |
| Client | MacBook Pro |
| Final IP | 10.0.0.132 (static) |

---

## What Actually Happened

Honestly this lab tested my patience more than anything 
else so far. I was locked in and motivated but there 
were moments where I felt like nothing was going to work. 
Every time I thought I fixed it something else came up. 
But I kept pushing and figured it out.

### Problem 1 — Cable Was In The Wrong Port
This was the first one that got me. I plugged the 
ethernet cable into what I thought was a regular 
network port but it was actually the iDRAC port. 
The iDRAC port is a dedicated management interface — 
it's completely separate from the regular data ports 
and doesn't carry normal network traffic.

Once I moved the cable to eno3 (one of the Intel I350 
RJ45 ports) things started moving in the right direction.

The R630 has these ports on the back:
- iDRAC port — remote management only, separate network
- eno1/eno2 — 10Gbps SFP+ ports, need special cables
- eno3/eno4 — standard 1Gbps RJ45 ethernet ports

Lesson learned — know your ports before you plug anything in.

### Problem 2 — Bad Ethernet Cable
After moving to the right port I still had no connection. 
Tested the cable on another device and confirmed it was 
dead. Replaced it with a new Cat6 cable and the green 
light came on immediately.

Physical layer troubleshooting is real. Always test 
your cables first before assuming it's a software problem.

### Problem 3 — No IPv4 Address
Even with the right port and a working cable, the server 
was only getting an IPv6 address — no IPv4. I checked 
the Xfinity router admin page at 10.0.0.1 and found 
the server listed as "ubuntu-server-669" with an IP 
assigned but showing offline.

I had to manually configure a static IP using Netplan 
to get things working properly.

### Problem 4 — No Netplan Config Existed
Ubuntu didn't create a netplan config during installation. 
Had to create one from scratch. Got a permissions warning 
but fixed it with chmod 600.

---

## How I Fixed It — Step By Step

### Step 1 — Bring The Interface Up
```bash
sudo ip link set eno3 up
```

### Step 2 — Create The Netplan Config
```bash
sudo nano /etc/netplan/00-installer-config.yaml
```

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eno3:
      dhcp4: false
      addresses:
        - 10.0.0.132/24
      routes:
        - to: default
          via: 10.0.0.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
```

```bash
sudo chmod 600 /etc/netplan/00-installer-config.yaml
sudo netplan apply
```

### Step 3 — Enable Network Services On Boot
```bash
sudo systemctl enable systemd-networkd
sudo systemctl enable systemd-resolved
```

### Step 4 — Enable SSH
```bash
sudo systemctl enable ssh
sudo systemctl start ssh
sudo systemctl status ssh
```

### Step 5 — Test Connectivity
```bash
# Ping the router
ping 10.0.0.1

# Check the IP
ip addr show eno3

# Verify SSH is listening
sudo ss -tlnp | grep ssh
```

### Step 6 — SSH From MacBook
Opened Terminal on my MacBook and typed:
```bash
ssh rodrigo@10.0.0.132
```

IPv4 timed out so I used the IPv6 address instead:
```bash
ssh rodrigo@2601:243:d88:6470:eef4:bbff:fee7:964
```

It connected. That feeling was unreal.

### Step 7 — Created SSH Shortcut
Didn't want to type that long IPv6 address every time 
so I created a shortcut:

```bash
nano ~/.ssh/config
```
Host r630
HostName 2601:243:d88:6470:eef4:bbff:fee7:964
User rodrigo
Now all I type is:
```bash
ssh r630
```

And I'm in. No monitor. No keyboard. Just my Mac.

---

## Final Setup

| Setting | Value |
|---|---|
| Interface | eno3 |
| IP Address | 10.0.0.132 (static) |
| Gateway | 10.0.0.1 |
| DNS | 8.8.8.8, 8.8.4.4 |
| SSH | Port 22, enabled on boot |
| SSH Shortcut | ssh r630 |

---

## What I Learned

- Always check which port you're plugging into — 
  iDRAC and data ports are completely different
- Test your cables before troubleshooting software
- Netplan is Ubuntu's network config tool — YAML syntax, 
  spacing matters
- Static IP is essential for a server so the address 
  never changes on reboot
- SSH config shortcuts make life way easier
- Headless administration is how real data centers 
  operate — no one sits in front of every server

---

## How To Shut Down
```bash
sudo shutdown now
```

## How To Connect Next Time
```bash
ssh r630
```

That's it.

---

## What's Next
- [ ] Lab 4 — Grafana + Prometheus monitoring dashboard
- [ ] Lab 5 — iDRAC remote management setup
- [ ] Lab 6 — Automatic security updates
- [ ] Lab 7 — Bash scripts for system health checks
