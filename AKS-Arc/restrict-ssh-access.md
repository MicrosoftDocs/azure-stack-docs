---
title: Restrict SSH access to virtual machines in AKS enabled by Azure Arc on Azure Local
description: Learn how to restrict SSH access in AKS enabled by Arc on Azure Local.
author: sethmanheim
ms.topic: how-to
ms.date: 01/29/2024
ms.author: sethm 
ms.lastreviewed: 04/27/2023
ms.reviewer: oadeniji


# Intent: As an IT Pro, I want to restrict access to some IP addresses and CIDRs in AKS enabled by Arc.

---

# Restrict SSH access to virtual machines in AKS enabled by Azure Arc on Azure Local

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

This article describes a new security feature in AKS Arc that restricts Secure Shell Protocol (SSH) access to underlying virtual machines (VMs). The feature limits access to only certain IP addresses, and restricts the set of commands that you can run over SSH.

## Overview

Currently, anyone with administrator access to AKS enabled by Arc has access to VMs through SSH on any machine. In some scenarios, you might want to limit that access, because unlimited access makes it difficult to pass compliance.

> [!NOTE]
> Currently, this capability is available only for a new installation of AKS Arc, and not for upgrades. Only a new installation of AKS Arc can pass the restricted IPs and restrict the commands that run over SSH.

## Enable SSH restrictions

The following command limits the set of hosts that can be authorized to be SSH clients. You can only run the SSH commands on those hosts, and the set of commands that you can run is restricted. The hosts are designed either via IP addresses or via CIDR ranges:

```azurecli
az aksarc create --ssh-authorized-ip-ranges CIDR format
```

The CIDR format is `0.0.0.0/32`.

This command does two things: it limits the scope of the command, and it also limits the hosts from which this command can be run.

## Next steps

- [Restrict SSH access (AKS on Azure Local 22H2)](restrict-ssh-access-22h2.md)
- [AKS enabled by Arc overview](aks-overview.md)
- Help to protect your cluster in other ways by following the guidance in the [security book for AKS enabled by Azure Arc](/azure/azure-arc/kubernetes/conceptual-security-book?toc=/azure/aks/aksarc/toc.json&bc=/azure/aks/aksarc/breadcrumb/toc.json).
