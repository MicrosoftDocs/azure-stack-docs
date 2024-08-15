---
title: Troubleshoot Azure Stack HCI upgrade
description: Learn how to troubleshoot upgrade on your Azure Stack HCI system. 
author: alkohli
ms.topic: how-to
ms.date: 08/12/2024
ms.author: alkohli
ms.reviewer: alkohli
---

# Troubleshoot Azure Stack HCI upgrade

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to identify and troubleshoot common Azure Stack HCI upgrade issues.

## Operating system upgrade

When you [Upgrade the OS](./upgrade-22h2-to-23h2-powershell.md), you may encounter registration failures or Network ATC intent health state issues. This section provides steps to troubleshoot these issues.

### Registration failures

Run the following PowerShell command to verify that the cluster is registered with Azure:

```PowerShell
PS C:\> Get-AzureStackHCI
```

Here's a sample output:

```output
ClusterStatus : Clustered
RegistrationStatus : Registered
RegistrationDate : 8/1/2024 9:15:12 AM
AzureResourceName : Redmond
AzureResourceUri : /Subscriptions/<Subscription ID>/resourceGroups/Redmond/providers/Microsoft.AzureStackHCI/clusters/Redmond
ConnectionStatus : Connected
LastConnected : 8/1/2024 11:30:42 AM
NextSync :
IMDSAttestation : Disabled
DiagnosticLevel : Basic
Region :
```

If `RegistrationStatus` is **Not registered**, follow troubleshooting steps in [Troubleshoot Azure Stack HCI registration](../deploy/troubleshoot-hci-registration.md).

### Network ATC intent health state

Run the following PowerShell command to verify Network ATC intent health state:

```PowerShell
PS C:\> Get-NetIntentStatus
```

Here's a sample output:

```output
IntentName : converged
Host : win-llbl239crrl
IsComputeIntentSet : True
IsManagementIntentSet : True
IsStorageIntentSet : True
IsStretchIntentSet : False
LastUpdated : 08/01/2024 17:34:09
LastSuccess : 08/01/2024 17:34:09 
RetryCount : 0
LastConfigApplied : 1
Error :
Progress : 1 of 1
ConfigurationStatus : Success
ProvisioningStatus : Completed
```

If the `ConfigurationStatus` isn't healthy, verify the following:

- The VM network adapter name is the same as the network adapter name.  Both adapters must be named `vManagement(IntentName)` where `IntentName` matches the name of the management intent.
- The virtual switch was renamed on each node.

Run the following PowerShell commands to verify that the network adapter name for `vManagement` matches the VM network adapter name:

```PowerShell
PS C:\> Get-NetAdapter
```

Here's a sample output:

```output
Name                      InterfaceDescription                    ifIndex Status       MacAddress             LinkSpeed 

----                      --------------------                    ------- ------       ----------             --------- 

Embedded FlexibleLOM ...1 HPE Ethernet 10/25Gb 2-port 640FLR-S...       7 Up           B8-83-03-58-91-88        25 Gbps 

Embedded FlexibleLOM ...2 HPE Ethernet 10/25Gb 2-port 640FLR...#2       6 Up           B8-83-03-58-91-89        25 Gbps 

vSMB(converged#Embedde... Hyper-V Virtual Ethernet Adapter #2          20 Up           00-15-5D-20-40-02        25 Gbps 

vManagement(converged)    Hyper-V Virtual Ethernet Adapter             14 Up           B8-83-03-58-91-88        25 Gbps 

vSMB(converged#Embedde... Hyper-V Virtual Ethernet Adapter #3          24 Up           00-15-5D-20-40-03        25 Gbps 
```

```PowerShell
PS C:\> Get-VmNetworkAdapter -ManagementOS 
```

Here's a sample output:

```output
Name                                          IsManagementOs VMName SwitchName                 MacAddress   Status IPAddresses 

----                                          -------------- ------ ----------                 ----------   ------ ----------- 

vManagement(converged)                        True                  ConvergedSwitch(converged) B88303589188 {Ok} 

vSMB(converged#Embedded FlexibleLOM 1 Port 1) True                  ConvergedSwitch(converged) 00155D204002 {Ok} 

vSMB(converged#Embedded FlexibleLOM 1 Port 2) True                  ConvergedSwitch(converged) 00155D204003 {Ok} 
```

Both names must match. If names don't match, run the following PowerShell command to rename the network adapter:

```PowerShell
Rename-NetAdapter -Name "badname" -NewName "VMNetworkadapterName"
```

Run the following PowerShell command to verify that the virtual switch is named correctly.  The virtual switch must be named `ConvergedSwitch(IntentName)` where `IntentName` matches the name of the corresponding intent.

```PowerShell
Get-VMSwitch
```

Run the following PowerShell command to force a network ATC intent update:

```PowerShell
Set-NetIntentRetryState -Name "YourIntentName" -NodeName "NodeName"
```

> [!NOTE]
> You must run the `Set-NetIntentRetryState` command once for each node and intent.

If the names above match correctly and the intent remains in a `Failed` state, you can review the Microsoft-Windows-Networking-NetworkATC/Admin event logs for more details on why the intent failed.

## Solution upgrade

When you [Install the solution upgrade](./install-solution-upgrade.md), you may encounter issues. This section describes the location of the solution upgrade and solution validation logs that you can use to troubleshoot upgrade-related issues.

### Solution upgrade logs

| File              | Directory       | Description |
|-------------------|-----------------|-------------|
| FullCloudUpgrade.date.time.log | C:\clouddeployment\logs | Solution upgrade logs |

### Solution validation logs

| File              | Directory       | Description |
|-------------------|-----------------|-------------|
| InvokeCloudUpgradeEnvironmentChecker.date.time.log | C:\maslogs\lcmecelitelogs | Solution validation logs |

## Next steps

- [Open a Support ticket.](../manage/get-support.md)
