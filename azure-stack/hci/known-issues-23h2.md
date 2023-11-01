---
title: Release notes with known issues in Azure Stack HCI 23H2 2310 release (preview)
description: Read about the known issues in Azure Stack HCI 2310 public preview release (preview).
author: alkohli
ms.topic: conceptual
ms.date: 10/31/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# View known issues in Azure Stack HCI, version 23H2 release (preview)

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article identifies the critical known issues and their workarounds in Azure Stack HCI.

The release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Stack HCI, carefully review the information contained in the release notes.

This software release maps to software version number **10.2310.0.27**. This release only supports new deployments.

For more information about the new features in this release, see [What's new in 23H2](whats-new.md).

[!INCLUDE [important](../includes/hci-preview.md)]

## Known issues for version 2310

Here are the known issues in version 2310 release:

|Release|Feature|Issue|Workaround|
|-|------|------|----------|
|2310 <br> 10.2310.0.27| Deployment |Servers with USB network interfaces fail the deployment. |Make sure to disable those network adapters before you begin cloud deployment. |
|2310 <br> 10.2310.0.27| Deployment |A new storage accounts is created for each run of the deployment. Existing storage accounts aren't supported in this release.| |
|2310 <br> 10.2310.0.27| Deployment |A new key vault is created for each run of the deployment. Existing key vaults aren't supported in this release.| |
|2310 <br> 10.2310.0.27| Deployment |Some intent overrides defined on the template aren't working in this release.|There's no known workaround for this behavior. |
|2310 <br> 10.2310.0.27| Deployment |Deployments via Azure Resource Manager time out after 2 hours. Deployments that exceed 2 hours show up as failed in the resource group though the cluster is successfully created.|There's no known workaround in this release. |
|2310 <br> 10.2310.0.27| Deployment |If you select **Review + Create** and you haven't filled out all the tabs, the deployment begins and then eventually fails.|There's no known workaround in this release. |
|2310 <br> 10.2310.0.27| Deployment |A failed deployment can't be run from the device. |If a deployment has failed, resolve the issues and then rerun the deployment from the Azure portal. |
|2310 <br> 10.2310.0.27 <!--25420275-->|Security |When using the `Get-AzsSyslogForwarder` cmdlet with `-PerNode` parameter, an exception is thrown. You aren't able to retrieve the `SyslogForwarder` configuration information of multiple nodes. |The workaround is to go to each server and check the local configuration state of the Syslog component.|
|2310 <br> 10.2310.0.27|Host networking|Defining overrides for Network ATC intents fail due to Constrained Language mode.|Make sure to configure overrides to default values during the network intent creation. After your cluster is deployed, you can modify an existing network intent so that it uses a customized value for the property. <br> <br>If the cluster is in Windows Defender Application Control (WDAC) enforcement mode, switch the node from where you set the override in Audit mode. To switch the local node to audit, run the following command: <br><br>`Enable-ASLocalWDACPolicy -Mode Audit` <br> <br>For more information, see [Enable WDAC policy modes](./concepts/security-windows-defender-application-control.md#enable-wdac-policy-modes). <br><br> You can now modify an existing compute intent with a customized value for any object property. For example, to modify a compute intent `NewComputeIntent` on adapters `NIC1` and `NIC2` that uses `JumboPacket` property as **9014**, run the following commands: <br> <br>`$adapterOverrides = New-NetIntentAdapterPropertyOverrides` <br><br> `$adapterOverrides.JumboPacket = 9014` <br><br> `Set-NetIntent -Name <Existing intent name> -AdapterPropertyOverrides $adapterOverrides`|

## Next steps

- Read the [Deployment overview](./deploy/deployment-introduction.md).
