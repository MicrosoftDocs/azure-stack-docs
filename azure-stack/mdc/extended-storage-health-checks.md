---
title: Azure Stack - Health checks in extended storage for Modular Data Center blob storage
description: This article provides guidance for how to perform health checks in the extended storage for the Modular Data Center blob storage.
services: azure-stack
documentationcenter: ''
author: justinha
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: app-service
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 10/01/2020
ms.author: justinha
ms.reviewer: karlt
ms.lastreviewed: 10/01/2020 

---
# Extended storage health checks

This article provides guidance for checking the health of the datacenter extended storage hardware and the Azure Stack Hub deployment.

Before you start, review and follow the steps in [Updating firmware for the extended storage](extended-storage-firmware-updates.md).

The final step before shipping the system is shutting it down. Follow the steps in the Quick Start Guide.

## Extended storage health

This section provides guidance on checking the health of the extended storage hardware.
Check events and notify the administrator if there are issues to be resolved. 


To check the health of the cluster storage pool, run the following command:
```console
isi storagepool health
```

For example, if healthy, the command results look like this:
```console
All pools are healthy.
Unprovisioned drives: none
```

If unhealthy, or drives missing, the command results look like this:

```console
SmartPools Health
Name                  Health  Type Prot   Members          Down          Smartfailed
--------------------- ------- ---- ------ ---------------- ------------- -------------
a2000_200tb_800gb-    -M---
ssd-sed_16gb
 a2000_200tb_800gb-   -M---   HDD  3x     3,11,14,19,23,30 Nodes:        Nodes:
ssd-sed_16gb:24                           ,38,41,46:bay6,1 Drives:       Drives:
                                          0-11,16,19,
                                          25:bay6,10-11,16

OK = Ok, U = Too few nodes, M = Missing drives,
D = Some nodes or drives are down, S = Some nodes or drives are smartfailed,
R = Some nodes or drives need repair
Unprovisioned drives: none
```

Contact Microsoft Support for help with any issues.

The next command checks the overall health of the cluster, in a simplified view:
```console
isi status
```

If everything is healthy, a green **OK** appears, otherwise yellow warnings or red errors appear either on the **Cluster Health** line, or on one or more of the Cluster Node ID lines in the table that follows.

If more information about the health of the cluster is needed, a more verbose command can be run, in an expanded view:
```console
isi status -a
```

Contact Microsoft Support for help with any issues.

## Azure Stack Hub health

This section provides guidance on checking the health of the Azure Stack Hub deployment.

To get an overall view of the Azure Stack deployment integrated with the extended storage system, run the following script, which is is a wrapper for the following:
- Connection to an ERCS VM, using the credentials provided
- Execution of the Test-AzureStack -Debug command (which outputs detailed health information directly as an output on the screen)

The prerequisites for this script are as follows:
- .\Invoke-ExtendedStorageConfiguration.ps1 script file, found in the C:\OEMSoftware\ExtendedStorage\ folder of the Hardware Lifecycle Host (HLH)
- $AzScred Credential Variable, which should be populated with the *DOMAIN*\cloudadmin credentials. Replace *DOMAIN* with the actual domain name, such as CONTOSO.


```powershell
$AzScred = Get-Credential -Credential 'DOMAIN\cloudadmin'
.\Invoke-ExtendedStorageConfiguration.ps1 -TestAzureStack -AzureStackCred $AzScred
```

Review the output and verify the overall heath state of the Azure Stack deployment, as well as the **NAS** specific sections of the results for the specific health state of the Extended Storage integration with Azure Stack.

For a more in-depth look at Azure Stack diagnostics, see [Validate Azure Stack Hub system state](../operator/azure-stack-diagnostic-test.md).

Contact Microsoft Support for help with any issues.

## Technical support

Contact Microsoft Support for help with any issues.

## Next steps

- [Update firmware](extended-storage-firmware-updates.md)
