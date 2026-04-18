# Lab 1 — Hardware Identification & Component Overview

## Date
April 2026

## Objective
Unbox and identify all major components of the Dell PowerEdge R630 
enterprise server. Document each component by name, function, and 
location inside the chassis.

---

## Server Overview

| Spec | Detail |
|---|---|
| Model | Dell PowerEdge R630 1U Rack Server |
| Form Factor | 1U Rack Mount |
| CPUs | 2x Intel Xeon E5-2640 v3 2.60GHz 8-Core |
| RAM | 32GB DDR4 ECC RDIMM (expandable to 768GB) |
| RAID | Dell PERC H730 12Gbps Mini |
| NIC | Intel X520/I350 Quad Port 10Gbps SFP+ |
| PSU | 2x Dell 750W Platinum Redundant |
| Drive Bays | 8x 2.5" SFF Hot Swap |

---

## Components Identified

### CPUs — Intel Xeon E5-2640 v3
- Location: Center of motherboard under two large copper heatsinks
- Function: Primary compute processors handling all server operations
- Quantity: 2 (dual socket configuration)
- Cores: 8 cores each / 16 cores total

### RAM Slots
- Location: On both sides of the CPUs along the motherboard
- Function: System memory for running OS and virtual machines
- Status: Empty — DDR4 ECC RDIMM modules arriving Tuesday (4/18/26)

### Cooling Fans
- Location: Front section behind drive bays
- Quantity: 7 hot swap fan modules
- Function: Maintain airflow and temperature across all components
- Note: Orange tabs indicate hot swap capability

### PERC H730 RAID Controller
- Location: Lower left section of motherboard
- Function: Manages all hard drives and RAID configurations
- Specs: 12Gbps Mini, 1GB cache

### Intel X520/I350 Daughter Card
- Location: Riser card slot
- Function: Network connectivity
- Ports: 2x 10Gbps SFP+ and 2x 1Gbps RJ45

### Power Supplies
- Location: Rear right of chassis
- Quantity: 2x 750W Platinum
- Function: Redundant power — if one fails the other takes over
- Note: Redundant PSU is standard in enterprise data centers

### Drive Bays
- Location: Front of server
- Quantity: 8x 2.5" SFF hot swap bays
- Status: Empty — drives to be added in future lab

---

## Photos
- [Server unboxing](../../photos/unboxing/IMG_0527.jpeg)
- [Internal components](../../photos/unboxing/IMG_0528.jpeg)

---

## Key Learnings
- Enterprise servers use redundant components (PSU, fans) for maximum uptime
- Hot swap capability allows replacing components without powering down
- iDRAC provides remote management without needing physical access
- Dual socket CPUs dramatically increase compute capacity

---

## Next Steps
- [ ] Install RAM when it arrives Tuesday
- [ ] Power on server and access iDRAC
- [ ] Configure iDRAC network settings
- [ ] Install Ubuntu Server 24.04
