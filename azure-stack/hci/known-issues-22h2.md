---
title: Known issues for Azure Stack HCI version 22H2 (preview)
description: Read about the known issues for Azure Stack HCI version 22H2 (preview)
author: alkohli
ms.topic: how-to
ms.date: 08/30/2022
ms.author: alkohli
ms.reviewer: alkohli
---

# Known issues for Azure Stack HCI version 22H2 (preview)

> Applies to: Azure Stack HCI, version 22H2 (preview)

This article identifies the critical open issues and the resolved issues for the preview release for your Azure Stack HCI, version 22H2. 

The release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Stack HCI, carefully review the information contained in the release notes.

This article applies to the Azure Stack HCI, version 22H2 preview release, which maps to software version number **10.2208.0.29**. The Azure Stack HCI, version 21H2 existing software deployments can be updated to this release. This release also supports brand new software installation using a deployment tool. For more information, see [What's new in 22H2](whats-new.md).

Here are the known issues for Azure Stack HCI, version 22H2:

|#|Feature|Issue|Workaround|
|-|------|------|----------|
|1|Deployment |Failure in ECE – *Set-RoleDefinition: Can't find the element ‘NodeDefinition’ for the role NC*|Make sure that a DVD isn't inserted in the physical machine or mounted via the Baseboard Management Controller (BMC).|
|2|Deployment |Only the first host can be the staging server.|There's no workaround for this issue in this preview release.|
|3|Deployment |Some of the Learn more links aren't functional in the deployment tool.|These links will be functional in a future release.|
|4|Deployment |During deployment, an error is seen in Windows Admin Center: Remote Exception “GetCredential” with “1”.|Reboot the staging server and run the bootstrap script again. Make sure that the Azure credentials for the subscription haven't expired and are correct.|
|5|Deployment |Renaming the network adapter in the deployment tool and using the **Back** and **Next** buttons causes it to hang.|There's no workaround for this is in the preview release.|
|6|Deployment |Deployment UI does not show the actual progress even after the staging server has restarted. |Refresh the browser once. For the remainder of the deployment, the page will refresh automatically.|
|7|Windows Admin Center in Azure |In this release, Windows Admin Center in Azure portal doesn't work because Windows Defender App Control (WDAC) is enabled by default on Azure Stack HCI servers. |The workaround is to switch WDAC policy mode to `Audit` instead of '`Enforce`. For more information, see [Switch WDAC policy mode](./concepts/security-windows-defender-application-control.md).|