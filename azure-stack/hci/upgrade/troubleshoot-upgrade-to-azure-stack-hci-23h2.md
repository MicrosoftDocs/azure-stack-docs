---
title: Troubleshoot upgrade to Azure Stack HCI, version 23H2
description: Learn how to troubleshoot upgrade on your Azure Stack HCI system. 
author: alkohli
ms.topic: how-to
ms.date: 08/02/2024
ms.author: alkohli
ms.reviewer: alkohli
---

# Troubleshoot upgrade to Azure Stack HCI, version 23H2

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to troubleshoot upgrade-related issues on your Azure Stack HCI, version 23H2 system.

## Operating system upgrade

### Registration failures

Run the following PowerShell command to verify that the cluster is registered with Azure:

```powershell
PS C:\> Get-AzureStackHci
```

Here's a sample output:

```powershell
ClusterStatus : Clustered
RegistrationStatus : Registered
RegistrationDate : 8/1/2024 9:15:12 AM
AzureResourceName : Redmond
AzureResourceUri : /Subscriptions/fbaf508b-cb61-4383-9cda-a42bfa0c7bc9/resourceGroups/Redmond/providers/Microsoft.AzureStackHCI/clusters/Redmond
ConnectionStatus : Connected
LastConnected : 8/1/2024 11:30:42 AM
NextSync :
IMDSAttestation : Disabled
DiagnosticLevel : Basic
Region :
```

If `RegistrationStatus` is **Not registered**, follow troubleshooting steps in [Troubleshoot Azure Stack HCI registration](./troubleshoot-hci-registration.md).

### Network ATC intent health state

Run the following PowerShell command to verify Network ATC intent health state:

```powershell
PS C:\> Get-netintentstatus
```

Here's a sample output:

```powershell
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

```powershell
IntentName : converged
Host : win-u7gk840mvm0
IsComputeIntentSet : True
IsManagementIntentSet : True 
IsStorageIntentSet : True
IsStretchIntentSet : False
LastUpdated : 08/01/2024 17:34:02
LastSuccess : 08/01/2024 17:34:02 
RetryCount : 0
LastConfigApplied : 1
Error :
Progress : 1 of 1
ConfigurationStatus : Success
ProvisioningStatus : Completed
```

If the `ConfigurationStatus` isn't healthy, verify that the VM network adapter name is the same as the network adapter name.

Run the following PowerShell commands to verify that the network adapter name for `vManagement` matches the VM network adapter name:

```powershell
PS C:\> Get-netadapter
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

```powershell
PS C:\> get-vmnetworkadapter -ManagementOS 
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

```powershell
Rename-netadapter -Name "badname" -NewName "VMNetworkadapterName"
```

Run the following PowerShell command to force a network ATC intent update:

```powershell
Set-NetIntentRetryState -Name "YourIntentName"
```

## Solution upgrade

### Solution upgrade logs

| File              | Directory       | Description |
|-------------------|-----------------|-------------|
| FullCloudUpgrade.date.time.log | C:\clouddeployment\logs | Solution upgrade logs |

### Solution validation logs

| File              | Directory       | Description |
|-------------------|-----------------|-------------|
| InvokeCloudUpgradeEnvironmentChecker.date.time.log | C:\maslogs\lcmecelitelogs | Solution validation logs |
