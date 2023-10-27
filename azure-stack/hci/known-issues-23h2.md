---
title: Release notes with known issues in Azure Stack HCI 23H2 2310 release (preview)
description: Read about the known issues in Azure Stack HCI 2310 public preview release (preview).
author: alkohli
ms.topic: conceptual
ms.date: 10/26/2023
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
|2310 <br> 10.2310.0.27| Deployment |A new storage accounts is created for each run of the deployment. Existing storage accounts are not supported in this release.|This behavior will change in a future release. |
|2310 <br> 10.2310.0.27| Deployment |A new key vault is created for each run of the deployment. Existing key vaults are not supported in this release.|This behavior will change in a future release.  |
|2310 <br> 10.2310.0.27| Deployment |Some intent overrides defined on the template are not working in this release.|There is no known workaround for this behavior. |
|2310 <br> 10.2310.0.27| Deployment |Deployments via Azure Resource Manager can't last more than 2 hours. Deployments that exceed 2 hours show up as failed in the resource group though the cluster is successfully created.|There is no known workaround in this release. |
|2310 <br> 10.2310.0.27| Deployment |If you select **Review + Create** and you haven't filled out all the tabs, the deployment begins and then eventually fails.|There is no known workaround in this release. |
|2310 <br> 10.2310.0.27| Deployment |A failed deployment can't be run from the device. |If a deployment has failed, resolve the issues and then rerun the deployment from the Azure portal. |
|2310 <br> 10.2310.0.27 <!--25420275-->|Security |When using the `Get-AzsSyslogForwarder` cmdlet with `-PerNode` parameter, an exception is thrown. You are not able to retrieve the `SyslogForwarder` configuration information of multiple nodes. |The workaround is to go to each server and check the local configuration state of the Syslog component.|
|2310 <br> 10.2310.0.27|Deployment |Failure in ECE – `Set-RoleDefinition: Can't find the element 'NodeDefinition' for the role NC`. |Make sure that a DVD isn't inserted in the physical machine or mounted via the Baseboard Management Controller (BMC).|
|2310 <br> 10.2310.0.27| Deployment |If you have an Azure policy assigned to the Azure subscription that enforces tags, the deployment fails.| |
|2310 <br> 10.2310.0.27|Diagnostics  |Deployment was configured with **Diagnostic data** set to ON in the deployment tool. However during the deployment and after the deployment is complete, the diagnostic data isn't collected. | You can run the `Send-DiagnosticsData` command on Azure Stack HCI cluster node to collect diagnostic logs. |
|2310 <br> 10.2310.0.27|Host networking|Defining overrides for Network ATC intents fail due to Constrained Language mode.|Make sure to configure overrides to default values during the network intent creation. After your cluster is deployed, you can modify an existing network intent so that it uses a customized value for the property. <br> <br>If the cluster is in Windows Defender Application Control (WDAC) enforcement mode, switch the node from where you set the override in Audit mode. To switch the local node to audit, run the following command: <br><br>`Enable-ASLocalWDACPolicy -Mode Audit` <br> <br>For more information, see [Enable WDAC policy modes](./concepts/security-windows-defender-application-control.md#enable-wdac-policy-modes). <br><br> You can now modify an existing compute intent with a customized value for any object property. For example, to modify a compute intent `NewComputeIntent` on adapters `NIC1` and `NIC2` that uses `JumboPacket` property as **9014**, run the following commands: <br> <br>`$adapterOverrides = New-NetIntentAdapterPropertyOverrides` <br><br> `$adapterOverrides.JumboPacket = 9014` <br><br> `Set-NetIntent -Name <Existing intent name> -AdapterPropertyOverrides $adapterOverrides`|
|2310 <br> 10.2310.0.27|Security | In this release, when you run `Get-AsWDACPolicy` cmdlet on a two-node Azure Stack HCI cluster, the cmdlet returns `Unable to determine as opposed to an integer (0, 1 or 2)`. | The `Get-ASWDACPolicyMode` cmdlet fetches information related to WDAC policy from the `CodeIntegrity` events and is unable to get the information as the `CodeIntegrity` event logs are flushed with 3114 events. <br> A workaround is provided in the output of the cmdlet that instructs you to run `Invoke-RefreshWDACPolicyTool` to refresh the policy on the nodes to generate new `CodeIntegrity` events. |
|2310 <br> 10.2310.0.27|Registration |In this release, a sporadic issue might occur where the deployment fails as the resource provider is not registered during the deployment.|To work around this issue, follow these steps:<br> <br>Manually register the resource provider via Azure CLI before you start the deployment. If you are deploying multiple clusters to the same subscription, you need to register a subscription with resource providers only once. <br> <br> Before you begin, make sure that you have installed both the `Az.accounts` and `Az.resources` PowerShell modules on atleast one node of your cluster.<br> <br>1. Connect via RDP to one of the servers of your Azure Stack HCI cluster.<br><br>2. Use option 15 of `Sconfig` to launch a PowerShell session.<br><br>3. Sign into your subscription.<br><br>`Connect-AzAccount`<br><br>4. Register with the resource provider.<br>`Register-AzResourceProvider -ProviderNamespace Microsoft.ResourceConnector` |
|2310 <br> 10.2310.0.27|Arc VM management| In this release, when provisioning VMs, you might run out of available storage space. <br><br>The reason for the above issue is that the default storage path is set to the infrastructure volume which is only 100GB and can’t be changed until the deployment is complete. | First, expand the infrastructure volume. Next, change the storage path from infrastructure volume to user volume. Repeat this for all user volumes. For detailed instructions, see [Post deployment steps](./manage/preview-post-installation.md). |
|2310 <br> 10.2310.0.27|Arc VM management|In this release, if you use the optional `RegistrationRegion` parameter, make sure to specify the region in the supported format. Region names are typically formatted without any spaces. For example, use `eastus` and `westeurope`. <br> <br>If the region name is specified as East US, or West Europe, then the validation would succeed. However, actual deployment fails at the Arc Resource Bridge installation step and you will need to redeploy the cluster. |
|2310 <br> 10.2310.0.27|Networking |In this release, VLANs are not supported for hosts and Arc Resource Bridge virtual machine.|

## Next steps

- Read the [Deployment overview](./index.yml)
