---
title: Known issues in Azure Stack HCI 2306.2 Supplemental Package (preview)
description: Read about the known issues in Azure Stack HCI 2306.2 Supplemental Package (preview).
author: alkohli
ms.topic: conceptual
ms.date: 08/20/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# View known issues in Azure Stack HCI, 2306.2 Supplemental Package release (preview)

[!INCLUDE [applies-to](../includes/hci-applies-to-supplemental-package.md)]

This article identifies the critical known issues and their workarounds in Azure Stack HCI.

The release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy Azure Stack HCI, carefully review the information contained in the release notes.

This article applies to Azure Stack HCI, Supplemental Package, for 2306.2 patch update release. This release maps to software version number **10.2306.2.6**. This release supports only updating Azure Stack HCI deployments running 2306 Supplemental Package and later.

For more information, see [What's new in 22H2](whats-new-in-hci-22h2.md#azure-stack-hci-supplemental-package-preview) and [What's in preview](./manage/whats-new-2306-1-preview.md).

[!INCLUDE [important](../includes/hci-preview.md)]

## Known issues in this release

Microsoft is not currently aware of any issues with this release. All the known issues are carried over from previous releases.

## Known issues from previous releases

Here are the known issues that have carried over from the previous releases in Azure Stack HCI supplemental package:

|#|Feature|Issue|Workaround|
|-|------|------|----------|
|1|Deployment |Failure in ECE – *Set-RoleDefinition: Can't find the element 'NodeDefinition' for the role NC*|Make sure that a DVD isn't inserted in the physical machine or mounted via the Baseboard Management Controller (BMC).|
|2|Deployment |During deployment, an error is seen in Windows Admin Center: Remote Exception "GetCredential" with "1".|Reboot the staging server and run the bootstrap script again. Make sure that the Azure credentials for the subscription haven't expired and are correct.|
|3|Deployment |Renaming the network adapter in the deployment tool and using the **Back** and **Next** buttons causes it to hang.|There's no workaround for this is in the preview release.|
|4|Arc VM and AKS hybrid workload deployment |In this release, Windows Defender App Control (WDAC) is enabled by default on Azure Stack HCI servers. If you're deploying Arc VM or AKS hybrid workloads, you would see an error while importing the Arc Resource Bridge PowerShell module. |The workaround is to switch WDAC policy mode to `Audit` instead of `Enforced`. For more information, see [Enable WDAC policy modes](./concepts/security-windows-defender-application-control.md#enable-wdac-policy-modes). <br> After the workload deployment is complete, you can run the cmdlet to switch WDAC policy mode back to the default enforced mode.|
|5|Deployment |If you have an Azure policy assigned to the Azure subscription that enforces tags, the deployment fails.||
|6|OS update|After deployment, scanning for OS updates using *SConfig* or Cluster-Aware Updating may fail to scan Windows Update.|Manually enable and start the *wuauserv* service. Run the following PowerShell commands: <br>`Set-Service -Name WUAUServ -StartupType Auto -Verbose`<br/>`Start-Service -Name WUAUServ`|
|7|Environment Checker| If SSL inspection is turned on in your Azure Stack HCI system, the connectivity validator fails with the certificate validation error message.  | For information about the error and how to troubleshoot it, see [Potential failure scenario for connectivity validator](./manage/use-environment-checker.md#potential-failure-scenario-for-connectivity-validator).|
|8|Diagnostics | Deployment was configured with **Diagnostic data** set to ON in the deployment tool. However during the deployment and after the deployment is complete, the diagnostic data isn't collected.|You can run the `Send-DiagnosticsData`command on Azure Stack HCI cluster node to collect diagnostic logs. |
|9|Host networking |Defining overrides for Network ATC intents fail due to Constrained Language mode. |Make sure to configure overrides to default values during the network intent creation. After your cluster is deployed, you can create a network intent that uses a customized value for the property. <br><br> If the cluster is in Windows Defender Application Control (WDAC) enforcement mode, switch the node from where you set the override in `Audit` mode. To switch the local node to audit, run the following command: <br> `Enable-ASLocalWDACPolicy -Mode Audit` <br>For more information, see [Enable WDAC policy modes](./concepts/security-windows-defender-application-control.md#enable-wdac-policy-modes). <br/><br>You can now modify an existing compute intent with a customized value for any object property. For example, to modify a compute intent on adapters that use `JumboPacket` property as **9014**, run the following commands:<br/><br> `$adapterOverrides = New-NetIntentAdapterPropertyOverrides`<br><br>`$adapterOverrides.JumboPacket = 9014`<br><br>`Set-NetIntent -Name ExistingIntentName -AdapterPropertyOverrides $adapterOverrides`<br> |
|10|Security |In this release, when you run `Get-AsWDACPolicy` cmdlet on a two-node Azure Stack HCI cluster, the cmdlet returns `Unable to determine` as opposed to an integer (0, 1 or 2). |The `Get-ASWDACPolicyMode` cmdlet fetches information related to WDAC policy from the CodeIntegrity events and is unable to get the information as the CodeIntegrity event logs are flushed with 3114 events. <br> A workaround is provided in the output of the cmdlet that instructs you to run `Invoke-RefreshWDACPolicyTool` to refresh the policy on the nodes to generate new CodeIntegrity events.|
|11|Azure Arc|After update, the Azure Stack HCI cluster servers show as not registered with Azure Arc.|To mitigate this issue, follow these steps: <br> 1. *Azcmamnet.exe* connect on each **Not registered** server <br>2. Register the servers again. Run this cmdlet on each server that isn't registered: <br>`Register-AzStackHCI`   |
|12|Arc Resource Bridge  |In this release, a custom location isn't created during Arc Resource Bridge deployment.|This issue is seen in switchless configurations only.|

## Next steps

- Read the [Deployment overview](./deploy/deployment-tool-introduction.md)
