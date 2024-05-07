---
title: Restrict SSH access to virtual machines in AKS enabled by Azure Arc (AKS on Azure Stack HCI 22H2)
description: Learn how to restrict SSH access in AKS Arc on HCI 22H2.
author: sethmanheim
ms.topic: how-to
ms.date: 02/14/2024
ms.author: sethm 
ms.lastreviewed: 04/27/2023
ms.reviewer: oadeniji


# Intent: As an IT Pro, I want to restrict access to some IP addresses and CIDRs in AKS enabled by Arc.

---

# Restrict SSH access to virtual machines in AKS enabled by Azure Arc (AKS on Azure Stack HCI 22H2)

[!INCLUDE [aks-hybrid-applies-to-azure-stack-hci-windows-server-sku](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

This article describes a new security feature in AKS Arc that restricts Secure Shell Protocol (SSH) access to underlying virtual machines (VMs). The feature limits access to only certain IP addresses, and restricts the set of commands that you can run over SSH.

## Overview

Currently, anyone with administrator access to AKS enabled by Arc has access to VMs through SSH on any machine. In some scenarios, you might want to limit that access, because unlimited access makes it difficult to pass compliance.

> [!NOTE]
> Currently, this capability is available only for a new installation of AKS Arc, and not for upgrades. Only a new installation of AKS Arc can pass the restricted IPs and restrict the commands that run over SSH.

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

## Next steps

- [Restrict SSH access (AKS on Azure Stack HCI 23H2)](restrict-ssh-access.md)
- [AKS on Windows Server overview](aks-overview.md)
