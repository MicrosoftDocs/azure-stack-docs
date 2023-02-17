---
title: Restrict SSH access in AKS hybrid
description: Learn how to restrict SSH access in AKS hybrid.
author: sethmanheim
ms.topic: how-to
ms.date: 02/17/2023
ms.author: sethm 
ms.lastreviewed: 02/17/2023
ms.reviewer: oadeniji

# Intent: As an IT Pro, I want to ue Active Directory Authentication to securely connect to the Kubernetes API server with SSO credentials.
# Keyword: secure connection to Kubernetes API server

---

# Restrict SSH access to virtual machines

This article describes a new security feature in AKS hybrid that restricts Secure Shell Protocol (SSH) access to underlying virtual machines (VMs), to only certain IP addresses.

## Overview

Currently, anyone with administrator access to AKS hybrid has access to VMs through SSH on any machine. In some scenarios you might want to reduce that access, which makes it difficult to pass compliance.

> [!NOTE]
> Currently, this capability is available only for a new installation of AKS hybrid, and not for upgrades. Only a new installation of AKS hybrid can pass the restricted IPs.

## Enable SSH restriction

To enable SSH restrictions, perform the following steps:

1. Create an SSH configuration using the `New-AksHciSSHConfiguration` cmdlet, with the allowed source IP addresses or CIDR you want to permit access to the VMs:

   ```powershell
   $ssh = New-AksHciSSHConfiguration -name sshConfig -cidr 172.16.0.0/24
   ```

   or

   ```powershell
   $ssh = New-AksHciSSHConfiguration -name sshConfig -ipAddresses 4.4.4.4,8.8.8.8
   ```

1. Add the SSH configuration by running the [Set-AksHciConfig](reference/ps/set-akshciconfig.md) cmdlet, passing in the SSH configuration you created in the previous step:

   ```powershell
   Set-AksHciConfig -ssh $ssh
   ```

### Validation

Once you've created the cluster, you can manually validate that the SSH restriction has been added by trying to SSH into one of the VMs. For example:

```powershell
ssh -i (get-MocConfig).sshPrivateKey clouduser@<vm-ipaddress>
```

You can perform this step within the list of IP addresses/CIDRs specified, or outside the list of IP addresses. The SSH from within the range of IP addresses/CIDRs should have access. SSH attempts from outside the list should not have access.

### Considerations

- You can only set the configuration during the installation phase of AKS hybrid.
- There is no support for upgrades.
- The SSH setting you provide is reused for all target clusters. Individual SSH configuration for workload clusters isn't available.

## Next steps

[AKS hybrid overview](aks-hybrid-options-overview.md)
