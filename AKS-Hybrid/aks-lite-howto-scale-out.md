---
title: AKS-IoT Scale #Required; page title is displayed in search results. Include the brand.
description: You can scale out your applications to multiple nodes #Required; article description that is displayed in search results. 
author: rcheeran #Required; your GitHub user alias, with correct capitalization.
ms.author: rcheeran #Required; microsoft alias of author; optional team alias.
#ms.service: #Required; service per approved list. slug assigned by ACOM.
ms.topic: how-to #Required; leave this attribute/value as-is.
ms.date: 10/01/2022 #Required; mm/dd/yyyy format.
ms.custom: template-how-to #Required; leave this attribute/value as-is.
---


# Scaling out on multiple nodes

## Scaling workload nodes

> [!IMPORTANT]
> Make sure you execute the below commands on your **primary machine**.

Now that AKS on Windows IoT is installed on your **primary machine**, you can scale out your cluster to **secondary machines**. Remember to specify [workload type](./aks-lite-concept.md) and [reserve enough memory for the Windows host](./aks-lite-concept.md).

The **secondary machine** we are adding in this example has an IP of "192.168.1.11" and a hostname of “machine-b”.

> [!TIP]
> **Run diagnostic before scaling**. To ensure your other machines are prepped and that your networking configurations are valid, we recommend you run a diagnostic check.

### Step 1: Diagnostic check

```powershell
Test-AksIotSetup -targetMachine 192.168.1.11 -targetUser "aksiot"
```

![diagnostic](media/aks-lite/diagnostic-test.png)

<!-- > > [!NOTE] If your secondary machine(s) did not pass the diagnostic, make sure you have followed the [steps to prep your secondary machine(s)](#set-up-secondary-machines-for-scale-out). -->

### Step 2: Scaling to a secondary machine

- `-Fqdns`: specify the IP address or hostname of your secondary machine that you want to scale-out to. You must indicate the same when removing the machine.
- `-WorkloadType`: specify `Linux`, `Windows`, or `LinuxAndWindows`
- `-ReserveMemoryMb`: specify the memory reserved for the Windows host using `(XGb/1MB)`

```powershell
New-AksIotNode `
  -Fqdns 192.168.1.11 `
  -WorkloadType Windows `
  -ReservedMemoryMb (6Gb/1MB) `
  -Verbose
```

### Step 3: Verify scaling

Confirm that your additional nodes are showing up.

```powershell
# Using PS commandlets
Get-AksIotNode

# Or

# Using kubectl
kubectl get nodes -o wide
```

### Step 4: Remove a machine

```powershell
Remove-AksIotNode -Fqdn 192.168.1.11
```

## Scaling control plane nodes

These are the supported control plane-scaling scenarios.

The control plane VMs need to have the same memory and logical processors, so if all physical machines have the same memory and logical processors, then these will work. If your physical machines have different memory or logical processors, then adjust the `-ReservedMemoryMb` and `-ReservedCpu` parameters to craft the same control plane VM size across your machines.

> [!IMPORTANT]
> Control plane scaling is only supported for `-WorkloadType Linux`.

The control plane can only be comprised of 1, 3, or 5 nodes. This can be accomplished in **two ways**:

**Option A:** Creating 1 node (no high availability) then scaling out to 3 or 5

```powershell
# Create one control plane
New-AksIotNode -Fqdns 'node1' -WorkloadType Linux -ControlPlane
​
# Scale control plane to 3
New-AksIotNode -Fqdns 'node2','node3' -WorkloadType Linux -ControlPlane
​
# Scale control plane to 5
New-AksIotNode -Fqdns 'node4','node5' -WorkloadType Linux -ControlPlane
```

**Option B:** Initially creating 3 nodes or 5 nodes

```powershell
# Three-node control plane
New-AksIotNode -Fqdns 'node1','node2','node3' -WorkloadType Linux -ControlPlane

# Five-node control plane
New-AksIotNode -Fqdns 'node1','node2','node3','node4','node5' -WorkloadType Linux -ControlPlane
```

> [!NOTE]
> You will have to adapt `AksIoT-SetupNodes.ps1` with these commands for control-plane scaling.

## Next

- You can now [deploy your application](/docs/deploying-workloads.md) or [connect to Arc](/docs/connect-to-arc.md)
- [Overview](aks-lite-overview.md)
- [Uninstall AKS cluster](aks-lite-howto-uninstall.md)

<!--
Remove all the comments in this template before you sign-off or merge to the 
main branch.
-->
