---
title: Known issues in Azure Stack HCI supplemental package (preview)
description: Read about the known issues in Azure Stack HCI supplemental package
author: alkohli
ms.topic: conceptual
ms.date: 10/08/2022
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# View known issues in Azure Stack HCI supplemental package (preview)

> Applies to: Azure Stack HCI supplemental package

This article identifies the critical known issues and their workarounds in Azure Stack HCI supplemental package.

The release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Stack HCI, carefully review the information contained in the release notes.

<!--This article applies to Azure Stack HCI, version 22H2, which maps to software version number **10.2208.0.29**. The Azure Stack HCI, version 21H2 existing software deployments can be updated to this release. This release also supports brand new software installation using a deployment tool. For more information, see [What's new in 22H2](whats-new.md).-->

[!INCLUDE [important](../includes/hci-preview.md)]

## Known issues in Azure Stack HCI supplemental package

Here are the known issues in Azure Stack HCI supplemental package:

|#|Feature|Issue|Workaround|
|-|------|------|----------|
|1|Deployment |Failure in ECE – *Set-RoleDefinition: Can't find the element ‘NodeDefinition’ for the role NC*|Make sure that a DVD isn't inserted in the physical machine or mounted via the Baseboard Management Controller (BMC).|
|2|Deployment |Only the first host can be the staging server.|There's no workaround for this issue in this preview release.|
|3|Deployment |During deployment, an error is seen in Windows Admin Center: Remote Exception “GetCredential” with “1”.|Reboot the staging server and run the bootstrap script again. Make sure that the Azure credentials for the subscription haven't expired and are correct.|
|4|Deployment |Renaming the network adapter in the deployment tool and using the **Back** and **Next** buttons causes it to hang.|There's no workaround for this is in the preview release.|
|5|Arc VM and AKS-HCI workload deployment |In this release, Windows Defender App Control (WDAC) is enabled by default on Azure Stack HCI servers. The following post-deployment scenarios are affected: <br>- Windows Admin Center in Azure portal won't work because WDAC is enabled by default.  <br>- If you are deploying Arc VM or AKS-HCI workloads, you would see an error while importing Arc Resource Bridge PowerShell module. |The workaround is to switch WDAC policy mode to `Audit` instead of `Enforced`. For more information, see [Switch WDAC policy mode](./concepts/security-windows-defender-application-control.md#switch-wdac-policy-modes). <br> After the workload deployment is complete, you can run the cmdlet to switch WDAC policy mode back to the default enforced mode.|
|6|Deployment |If you have an Azure policy assigned to the Azure subscription that enforces tags, the deployment fails.||