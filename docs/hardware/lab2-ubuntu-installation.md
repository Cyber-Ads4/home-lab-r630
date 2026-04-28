# Lab 2 — Ubuntu Server 24.04 Installation

## Date
April 27 2026

## Objective
Install Ubuntu Server 24.04 LTS on the Dell PowerEdge R630 
with RAID 1 configuration across two 600GB SAS drives.

---

## Hardware Used
| Component | Detail |
|---|---|
| Server | Dell PowerEdge R630 |
| RAID Controller | Dell PERC H730 Mini |
| Drives | 2x Dell 600GB 10K SAS 2.5" |
| RAID Level | RAID 1 (Mirrored) |
| USB Drive | SanDisk 32GB USB 3.0 |
| OS | Ubuntu Server 24.04 LTS |

---

## Pre-Installation Steps

### 1. Created Bootable USB
- Downloaded Ubuntu Server 24.04 LTS ISO from ubuntu.com
- Used Rufus 4.13 on Windows 11 to flash ISO to SanDisk USB
- Selected "Write in ISO Image mode" when prompted

### 2. Configured BIOS Boot Mode
- Pressed F2 during POST to enter System Setup
- Navigated to System BIOS → Boot Settings
- Confirmed Boot Mode was set to UEFI

### 3. Configured RAID via Lifecycle Controller
- Pressed F10 during POST to enter Lifecycle Controller
- Navigated to Hardware Configuration → Configuration Wizards → RAID Configuration
- Selected PERC H730 Mini as controller
- Cleared foreign configuration from previous server use
- Selected RAID Level: RAID 1 (mirrored for redundancy)
- Selected both physical disks: Physical Disk 0:b0 and 0:b1 (558GB each)
- Named virtual disk: "OS"
- Successfully created RAID 1 virtual disk

---

## Installation Process

### 4. Booted From USB
- Pressed F11 during POST to enter Boot Manager
- Selected One-shot BIOS Boot Menu
- Selected SanDisk USB drive
- Ubuntu GRUB menu appeared

### 5. Ubuntu Installer — Language & Network
- Selected English
- Network detected on eno3 with IP: 10.0.123.24 via DHCP
- Selected "Continue without updating" on installer update prompt
- Left proxy configuration blank

### 6. Storage Configuration
- Ubuntu installer initially showed "No disks found"
- Root cause: PERC H730 RAID controller requires virtual disk 
  to be configured before Ubuntu can detect storage
- Solution: Used Lifecycle Controller to create RAID virtual disk
- After RAID configuration Ubuntu detected 558.375GB virtual disk

### 7. Partition Layout
- Selected "Use entire disk" with LVM
- Installer created:
  - /boot/efi — 1.04GB fat32
  - /boot — 2GB ext4
  - / (root) — 100GB LVM logical volume
  - ubuntu-vg free space — 455GB

---

## Issues Encountered & Solutions

### Issue 1 — GRUB Bootloader Installation Failure
**Problem:** Installation completed but showed error at final step.
GRUB bootloader failed to register with UEFI firmware.
Server could not boot from RAID drives after installation.

**Error:** Server showed "No boot device available" after reboot.
UEFI Boot Sequence did not include Ubuntu boot entry.

**Troubleshooting Steps:**
1. Booted back into USB installer
2. Used GRUB command line (pressed 'c' at GRUB menu)
3. Used `ls` command to identify drive partitions
4. Confirmed Ubuntu files installed on hd0 but EFI partition was empty
5. Booted into initramfs rescue shell using `break=bottom` parameter
6. Activated LVM with `vgchange -ay`
7. Mounted partitions manually
8. Attempted manual grub-install — failed due to missing modinfo.sh
9. Identified root cause: BIOS version 1.3.6 had UEFI compatibility issues

**Solution:** Updated BIOS from version 1.3.6 to 2.19.0 via 
Lifecycle Controller. Reinstalled Ubuntu Server after BIOS update.
New BIOS version correctly registered GRUB with UEFI firmware.

### Issue 2 — Ethernet Cable Failure
**Problem:** Ethernet cable failed during installation process.
Network connectivity lost mid-installation.

**Diagnosis:** Tested cable with separate device — no connectivity confirmed.
Cable hardware failure, not server NIC issue.

**Solution:** Replaced ethernet cable. Server NIC (eno3) 
confirmed working on replacement cable.

---

## Successful Installation Configuration

| Setting | Value |
|---|---|
| Hostname | r630-homelab |
| Username | rodrigo |
| SSH | OpenSSH installed and enabled |
| Storage | RAID 1, LVM, 558GB virtual disk |
| OS | Ubuntu Server 24.04 LTS |
| BIOS Version | 2.19.0 (updated during troubleshooting) |
| Network | eno3 — Intel I350 1Gbps RJ45 |

---

## Key Learnings

- Enterprise RAID controllers (PERC H730) must be configured 
  before OS installation can detect storage
- BIOS/UEFI firmware version directly affects bootloader 
  compatibility — always check for updates
- RAID 1 mirrors data across both drives — if one drive fails 
  the system continues running automatically
- Physical layer troubleshooting (bad cable diagnosis) is 
  a fundamental data center skill
- LVM provides flexible storage management for enterprise servers
- chroot environments allow system repair without booting the OS
- GRUB command line can be used for advanced boot troubleshooting

---

## Commands Used During Troubleshooting
```bash
# Activate LVM volumes
vgchange -ay

# Mount root partition
mount /dev/ubuntu-vg/ubuntu-lv /mnt

# Mount boot partitions
mount /dev/sda2 /mnt/boot
mount /dev/sda1 /mnt/boot/efi

# Bind mount system directories
mount --bind /dev /mnt/dev
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys

# Chroot into installed system
chroot /mnt

# Check partition layout
ls (hd0,gpt2)/
ls (hd0,gpt1)/

# Check mounted filesystems
mount | grep efi
```

---

## Next Steps
- [ ] Connect replacement ethernet cable
- [ ] Verify network connectivity
- [ ] Configure SSH access from MacBook
- [ ] Set up static IP address
- [ ] Update system packages
- [ ] Configure iDRAC remote management
