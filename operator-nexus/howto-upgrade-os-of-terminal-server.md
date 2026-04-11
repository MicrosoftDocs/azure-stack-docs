---
title: "Azure Operator Nexus: How to upgrade the operating system of a Terminal Server"
description: Learn the process for upgrading the operating system of a Terminal Server
author: RaghvendraMandawale
ms.author: rmandawale
ms.date: 02/26/2025
ms.topic: how-to
ms.service: azure-operator-nexus
ms.custom: template-how-to, devx-track-azurecli
---

#  Upgrading the operating system of a Terminal Server

This document provides a step-by-step guide to upgrade the operating system (OS) of a Terminal Server. The outlined procedure is manual and includes essential checks, a backup process, and actions for post-upgrade validation.

## **Prerequisites**

- User must have **root account access** or **sudo root access** for the Terminal Server.

- An **on-premises machine** with access to the Terminal Server for file transfers.

- Download **25.10.0 firmware**: [Opengear Firmware](https://ftp.opengear.com/download/opengear_appliances/OM/). 

- After downloading the firmware, verify the **SHA1 checksum** to ensure integrity before proceeding with the installation.


>[Important]
> If the update fails, restoring from the backup may not be possible if the firmware version has changed.
> In such cases, you may need to rebuild the configuration as if performing a Day 1 deployment of the device.

## Pre-upgrade Checks (Terminal Server)

### Checking Available Disk Space  

To check the available disk space on the terminal server, use the following command:  

```bash
sudo df -h
```

### Sample output:  

The output will display the available space on various partitions, including `/tmp`:  

```bash
root@b37e7ts:~# df -h
Filesystem                       Size  Used Avail Use% Mounted on
tmpfs                            3.9G  299M  3.6G   8% /tmp
/dev/mapper/nvram-crypt           44G  7.0G   35G  17% /mnt/nvram
/dev/mapper/config-active-crypt  1.5G  244M  1.2G  18% /mnt/config_overlay_active_upper
/dev/sda1                        222M   49M  158M  24% /boot
/dev/sda2                        274M  274M     0 100% / 
```


Ensure at least **5 GB** of free space is available in the '/tmp' folder on the Terminal Server before beginning the upgrade process.

## Verifying OS download integrity using SHA1 checksum  

After downloading the OS image on the on-premises machine, verify its integrity using SHA1 checksum validation.  

### Step 1: Download the SHA checksum file  

Use `wget` or any other utility to download the checksum file corresponding to the OS version 25.10.0.

```bash
wget https://ftp.opengear.com/download/opengear_appliances/OM/archive/25.10.0/SHASUMS
```

### Step 2: Compute and compare the SHA1 checksum 

Run the following command to verify the checksum:  

```bash
cat SHASUMS | sha1sum -c
```

### Example Output:  

```bash
$ cat SHASUMS | sha1sum -c
operations_manager-25.10.0-production-signed.raucb: OK
```

Ensure that the output returns **"OK"** to confirm the file integrity before proceeding with installation.  

Would you like additional details on troubleshooting checksum mismatches?

### Step 3: Check current version of Terminal Server

Run the following command on the Terminal Server.

```bash
sudo cat /etc/version
```

```Example output
22.06.0
```
> [!Note]
> Ensure the current OS version is lower than the version you are upgrading to.

### LLDP Service check and enable

Run the following command on the Terminal Server. 

```bash
sudo ogcli update services/lldp enabled=true
sudo ogcli get services/lldp
```

```Expected output
description=""
enabled=true
physifs=[]
platform=""
```

### LLDP neighbor check

Run the following command on the Terminal Server.

```bash
sudo lldpctl
```

```Expected neighbors: 
Mgmt Switch, PE2, PE1
```
> [!Note]
> PE1/PE2 labels in ping output may not map clearly to physical devices — users should use LLDP neighbor output to identify neighbors by IP.


### Ping connectivity check

Run the following command on the Terminal Server.

```bash
default_routes=$(ip route show default | awk '{print $3}')
for ip in $default_routes; do
    echo "Pinging $ip..."
    ping -c 4 $ip
done
```

```Expected output
Pinging 10.103.0.2...
PING 10.103.0.2 (10.103.0.2) 56(84) bytes of data.
64 bytes from 10.103.0.2: icmp_seq=1 ttl=64 time=0.319 ms
64 bytes from 10.103.0.2: icmp_seq=2 ttl=64 time=0.352 ms
64 bytes from 10.103.0.2: icmp_seq=3 ttl=64 time=0.334 ms
64 bytes from 10.103.0.2: icmp_seq=4 ttl=64 time=0.358 ms

--- 10.103.0.2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3071ms
rtt min/avg/max/mdev = 0.319/0.340/0.358/0.015 ms
Pinging 10.103.0.6...
PING 10.103.0.6 (10.103.0.6) 56(84) bytes of data.
64 bytes from 10.103.0.6: icmp_seq=1 ttl=64 time=0.324 ms
64 bytes from 10.103.0.6: icmp_seq=2 ttl=64 time=0.344 ms
64 bytes from 10.103.0.6: icmp_seq=3 ttl=64 time=0.305 ms
64 bytes from 10.103.0.6: icmp_seq=4 ttl=64 time=0.340 ms

--- 10.103.0.6 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3065ms
rtt min/avg/max/mdev = 0.305/0.328/0.344/0.015 ms
```

### Create a backup of current configuration

Run the following command on Terminal Server.

```bash
sudo ogcli export ogcli_export_<date>
```

## **Stage 2: Backup files (on-premises machine)**

### Transfer Backup files to on-premises machine

Run following command on the on-premises machine to copy the Terminal Server configuration and related files to the on-premises machine. 

```bash
mkdir ~/ts_backup
cd ~/ts_backup
scp -o MACs=umac-128-etm@openssh.com root@<ts_ip>:/etc/dhcp/dhcpd.conf ./
scp -r -o MACs=umac-128-etm@openssh.com root@<ts_ip>:/mnt/nvram/files/conf ./
scp -o MACs=umac-128-etm@openssh.com root@<ts_ip>:~/ogcli_export_<date> ./
scp -r -o MACs=umac-128-etm@openssh.com root@<ts_ip>:/mnt/nvram/nexus ./
scp -r -o MACs=umac-128-etm@openssh.com root@<ts_ip>:/mnt/nvram/opengear_provisioning_rev5 ./
```

>[!Note]
> Replace <ts_ip> with the Terminal Server IP.</br>
>If commands don't succeed, try using the ```-o Ciphers=aes256-ctr``` option.

## **Stage 3: Install firmware (Terminal Server)**

### Upload firmware

Upload the latest downloaded firmware from on premise machine to the Terminal Server.

```bash
scp -r -o MACs=umac-128-etm@openssh.com ./operations_manager-25.10.0-production-signed.raucb root@<ts_ip>:/tmp/
```

>[!Note]
> Replace <ts_ip> with the Terminal Server IP.<br>
> Ensure the file name corresponds to the specific firmware version being used. For example, <operations_manager-25.10.0-production-signed.raucb> is the file name for Opengear OS version 25.10.0. Adjust the file name accordingly for your firmware version.

### Initiate installation of firmware

Run the following command on the Terminal Server.

```bash
sudo puginstall --reboot-after /tmp/operations_manager-25.10.0-production-signed.raucb
```
> [!Note]
> The upgrade process takes 5–10 minutes, during which the Terminal Server will reboot automatically

### Check whether on prem device is on expected OS version:
Run the following command on the Terminal Server.
```bash
sudo cat /etc/version
```

### Ping connectivity check for updated OS

Run the following command on the Terminal Server.

```bash
default_routes=$(ip route show default | awk '{print $3}')
for ip in $default_routes; do
    echo "Pinging $ip..."
    ping -c 4 $ip
done
```

```Expected output
Pinging 10.103.0.2...
PING 10.103.0.2 (10.103.0.2) 56(84) bytes of data.
64 bytes from 10.103.0.2: icmp_seq=1 ttl=64 time=0.319 ms
64 bytes from 10.103.0.2: icmp_seq=2 ttl=64 time=0.352 ms
64 bytes from 10.103.0.2: icmp_seq=3 ttl=64 time=0.334 ms
64 bytes from 10.103.0.2: icmp_seq=4 ttl=64 time=0.358 ms

--- 10.103.0.2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3071ms
rtt min/avg/max/mdev = 0.319/0.340/0.358/0.015 ms
Pinging 10.103.0.6...
PING 10.103.0.6 (10.103.0.6) 56(84) bytes of data.
64 bytes from 10.103.0.6: icmp_seq=1 ttl=64 time=0.324 ms
64 bytes from 10.103.0.6: icmp_seq=2 ttl=64 time=0.344 ms
64 bytes from 10.103.0.6: icmp_seq=3 ttl=64 time=0.305 ms
64 bytes from 10.103.0.6: icmp_seq=4 ttl=64 time=0.340 ms

--- 10.103.0.6 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3065ms
rtt min/avg/max/mdev = 0.305/0.328/0.344/0.015 ms
```

## **Stage 4: Cleanup (On-premises machine)**

### Remove backup and firmware

After confirming the successful upgrade, delete temporary files from the on-premises machine. 

```bash
rm -rf ~/ts_backup
rm -rf ./operations_manager-25.10.0-production-signed.raucb
```

>[!Note]
> Perform this action only once the Terminal Server has been upgraded successfully.


### Firmware upgrade failure
If the firmware upgrade fails we advise you to factory reset the Terminal Server and install the latest firmware and then reconfigure your device or restore from the backup. The result of a factory reset will require someone to connect to the Terminal Server using a serial port and following the documentation here to reconfigure or attempt to restore the configuration from a backup: [Azure Operator Nexus Platform Prerequisites](howto-platform-prerequisites.md).

1. Perform a **factory reset**:

    Run the following command on the Terminal Server.

   ```bash
   factory_reset
   ```

   Or, push the Erase button on the port-side panel twice with a bent paper clip while the unit is powered on.

2. Reinstall the latest firmware.

    Repeat the firmware installation process.

3. Reconfigure or restore the device from backup:

    Run the following command on the Terminal Server.

   ```bash
   sudo ogcli restore <file_path>
   ```
