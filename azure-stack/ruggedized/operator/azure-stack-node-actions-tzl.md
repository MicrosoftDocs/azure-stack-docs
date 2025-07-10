---
title: Scale unit node actions in Azure Stack Hub - Ruggedized
description: Learn about scale unit node actions, including power on, power off, disable, resume, and how to view node status in Azure Stack Hub integrated systems.
services: azure-stack
author: sethmanheim
manager: lizross
ms.service: azure-stack
ms.topic: how-to
ms.date: 10/11/2021
ms.author: sethm
ms.reviewer: alfredop
ms.lastreviewed: 12/20/2020

# Intent: As an Azure Stack operator, I want to learn about the scale unit node actions I can take.
# Keyword: azure stack scale unit node actions

---


# Scale unit node actions in Azure Stack Hub - Ruggedized

This article describes how to view the status of a scale unit. You can view the unit's nodes, or run node actions like power on, power off, shut down, drain, resume, and repair. Typically, you use these node actions during field replacement of parts, or to help recover a node.

> [!IMPORTANT]  
> All node actions described in this article should target one node at a time.

## View the node status

In the administrator portal, you can view the status of a scale unit and its associated nodes.

To view the status of a scale unit:

1. On the **Region management** tile, select the region.
2. On the left, under **Infrastructure resources**, select **Scale units**.
3. In the results, select the scale unit.
4. On the left, under **General**, select **Nodes**.

   View the following information:

   - The list of individual nodes.
   - Operational status (see list below).
   - Power status (running or stopped).
   - Server model.
   - IP address of the baseboard management controller (BMC).
   - Total number of cores.
   - Total amount of memory.

![status of a scale unit](media/azure-stack-node-actions/multinodeactions.png)

### Node operational states

| Status | Description |
|----------------------|-------------------------------------------------------------------|
| Running | The node is actively participating in the scale unit. |
| Stopped | The node is unavailable. |
| Adding | The node is actively being added to the scale unit. |
| Repairing | The node is actively being repaired. |
| Maintenance | The node is paused, and no active user workload is running. |
| Requires Remediation | An error has been detected that requires the node to be repaired. |

## Scale unit node actions

When you view information about a scale unit node, you can also perform node actions such as:

- Start and stop (depending on current power status)
- Disable and resume (depending on operations status)
- Repair
- Shut down

The operational state of the node determines which options are available.

To perform these actions, you must install Azure Stack Hub PowerShell modules. The cmdlets are in the **Azs.Fabric.Admin** module. To install or verify your installation of PowerShell for Azure Stack Hub, see [Install PowerShell for Azure Stack Hub](../../operator/azure-stack-powershell-install.md).

## Stop

The **stop** action turns off the node. It's the same as pressing the power button. It does not send a shutdown signal to the operating system. For planned stop operations, always try the shutdown operation first.

This action is typically used when a node no longer responds to requests.

To run the stop action, open an elevated PowerShell prompt, and run the following cmdlet:

```powershell  
Stop-AzsScaleUnitNode -Location <RegionName> -Name <NodeName>
```

In the unlikely case that the stop action does not work, retry the operation and if it fails a second time, use the BMC web interface instead.

For more information, see [Stop-AzsScaleUnitNode](/powershell/module/azs.fabric.admin/stop-azsscaleunitnode).

## Start

The **start** action turns on the node. It's the same as pressing the power button.

To run the start action, open an elevated PowerShell prompt, and run the following cmdlet:

```powershell
Start-AzsScaleUnitNode -Location <RegionName> -Name <NodeName>
```

In the unlikely case that the start action does not work, retry the operation. If it fails a second time, use the BMC web interface instead.

For more information, see [Start-AzsScaleUnitNode](/powershell/module/azs.fabric.admin/start-azsscaleunitnode).

## Drain

The **drain** action moves all active workloads to the remaining nodes in that particular scale unit.

This action is typically used during field replacement of parts, like the replacement of an entire node.

> [!IMPORTANT]
> Make sure you use a drain operation on a node during a planned maintenance window, where users have been notified. Under some conditions, active workloads can experience interruptions.

To run the drain action, open an elevated PowerShell prompt, and run the following cmdlet:

```powershell  
Disable-AzsScaleUnitNode -Location <RegionName> -Name <NodeName>
```

For more information, see [Disable-AzsScaleUnitNode](/powershell/module/azs.fabric.admin/disable-azsscaleunitnode).

## Resume

The **resume** action resumes a disabled node and marks it as active for workload placement. Earlier workloads that were running on the node do not fail back. If you use a drain operation on a node, be sure to power off. When you power the node back on, it's not marked as active for workload placement. When ready, you must use the **resume** action to mark the node as active.

To run the resume action, open an elevated PowerShell prompt, and run the following cmdlet:

```powershell  
  Enable-AzsScaleUnitNode -Location <RegionName> -Name <NodeName>
```

For more information, see [Enable-AzsScaleUnitNode](/powershell/module/azs.fabric.admin/enable-azsscaleunitnode).

## Repair

The **repair** action repairs a node. Use it only for either of the following scenarios:

- Full node replacement (with or without new data disks).
- After hardware component failure and replacement (if advised in the field replaceable unit (FRU) documentation).

> [!IMPORTANT]  
> See your OEM hardware vendor's FRU documentation for exact steps when you need to replace a node or individual hardware components. The FRU documentation specifies whether you need to run the repair action after replacing a hardware component.

When you run the repair action, specify the BMC IP address.

To run the repair action, open an elevated PowerShell prompt, and run the following cmdlet:

  ```powershell
  Repair-AzsScaleUnitNode -Location <RegionName> -Name <NodeName> -BMCIPv4Address <BMCIPv4Address>
  ```

## Shutdown

The **shutdown** action first moves all active workloads to the remaining nodes in the same scale unit. Then the action gracefully shuts down the scale unit node.

After you start a node that was shut down, run the [resume](#resume) action. Earlier workloads that were running on the node do not fail back.

If the shutdown operation fails, attempt the [drain](#drain) operation, followed by the shutdown operation.

To run the shutdown action, open an elevated PowerShell prompt, and run the following cmdlet:

  ```powershell
  Stop-AzsScaleUnitNode -Location <RegionName> -Name <NodeName> -Shutdown
  ```

## Next steps

[Learn about the Azure Stack Hub Fabric operator module](/powershell/module/azs.fabric.admin/).
