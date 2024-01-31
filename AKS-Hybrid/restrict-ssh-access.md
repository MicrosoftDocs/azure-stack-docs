---
title: Restrict SSH access to virtual machines in AKS enabled by Azure Arc
description: Learn how to restrict SSH access in AKS Arc.
author: sethmanheim
ms.topic: how-to
ms.date: 01/29/2024
ms.author: sethm 
ms.lastreviewed: 04/27/2023
ms.reviewer: oadeniji
zone_pivot_groups: version-select

# Intent: As an IT Pro, I want to restrict access to some IP addresses and CIDRs in AKS enabled by Arc.

---

# Restrict SSH access to virtual machines in AKS enabled by Azure Arc

This article describes a new security feature in AKS Arc that restricts Secure Shell Protocol (SSH) access to underlying virtual machines (VMs). The feature limits access to only certain IP addresses, and restricts the set of commands that you can run over SSH.

## Overview

Currently, anyone with administrator access to AKS enabled by Arc has access to VMs through SSH on any machine. In some scenarios, you might want to limit that access, because unlimited access makes it difficult to pass compliance.

> [!NOTE]
> Currently, this capability is available only for a new installation of AKS Arc, and not for upgrades. Only a new installation of AKS Arc can pass the restricted IPs and restrict the commands that run over SSH.

::: zone pivot="aks-22h2"
## Enable SSH restrictions

To enable SSH restrictions, perform the following steps:

1. Create an SSH configuration using the [New-AksHciSSHConfiguration](reference/ps/new-akshcisshconfiguration.md) cmdlet, with the allowed source IP addresses or CIDR you want to permit access to the VMs:

   ```powershell
   $ssh = New-AksHciSSHConfiguration -name sshConfig -cidr 172.16.0.0/24
   ```

   or

   ```powershell
   $ssh = New-AksHciSSHConfiguration -name sshConfig -ipAddresses 4.4.4.4,8.8.8.8
   ```

   or, to restrict SSH access:

   ```powershell
   $ssh = New-AksHciSSHConfiguration -name sshConfig –restrictSSHCommands 
   ```

   > [!NOTE]
   > If the SSH keys are not passed, the management cluster SSH keys are reused.

1. Add the SSH configuration by running the [Set-AksHciConfig](reference/ps/set-akshciconfig.md) cmdlet, passing in the SSH configuration you created in the previous step:

   ```powershell
   Set-AksHciConfig -ssh $ssh
   ```

### Validation: target cluster

Once you've created the cluster, you can manually validate that the SSH restriction has been added by trying to SSH into one of the VMs. For example:

```powershell
ssh -i (get-MocConfig).sshPrivateKey clouduser@<vm-ipaddress>
```

You can perform this step within the list of IP addresses/CIDRs specified, or outside the list of IP addresses. The SSH from within the range of IP addresses/CIDRs has access. SSH attempts from outside the list do not have access.

You can also run commands directly from SSH. This command returns the date. `Sudo` commands do not work:

```powershell
ssh -i (get-mocconfig).sshPrivateKey clouduser@<ip> date 
```

### Validation: log collection

This command returns the VM logs such as `cloudinit`, `lb` logs, etc.

```powershell
Get-AksHciLogs –virtualMachineLogs
```

### Considerations

- Individual SSH configuration for workload clusters is now available. The configuration for workload clusters uses the [New-AksHciSSHConfiguration](reference/ps/new-akshcisshconfiguration.md) PowerShell cmdlet.
- The restriction is only for Linux. Windows nodes do not have this restriction; you should be able to SSH successfully.
- You can only set the configuration during the installation phase of AKS Arc.
- You must perform a reinstall if you incorrectly configure any SSH settings.
- There is no support for upgrades.
- You can add CIDRs or IP addresses to which the SSH access can be restricted.
- The SSH setting you provide is reused for all target clusters. Individual SSH configuration for workload clusters isn't available.
::: zone-end

::: zone pivot="aks-23h2"
## Enable SSH restrictions

The following command limits the set of hosts that can be authorized to be SSH clients. You can only run the SSH commands on those hosts, and the set of commands that you can run is restricted. The hosts are designed either via IP addresses or via CIDR ranges:

```azurecli
az aksarc create --ssh-authorized-ip-ranges CIDR format
```

The CIDR format is `0.0.0.0/32`.

This command does two things: it limits the scope of the command, and it also limits the hosts from which this command can be run.
::: zone-end

## Next steps

[AKS enabled by Arc overview](aks-overview.md)
