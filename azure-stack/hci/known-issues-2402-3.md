---
title: Release notes with fixed and known issues in Azure Stack HCI 2402.3 update release
description: Read about the known issues and fixed issues in Azure Stack HCI 2402.3 release.
author: ronmiab
ms.topic: conceptual
ms.date: 05/17/2024
ms.author: robess
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# View known issues in Azure Stack HCI 2402.3 release

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article identifies the critical known issues and their workarounds in Azure Stack HCI 2402.3 release.

The release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Stack HCI, carefully review the information contained in the release notes.

> [!NOTE]
> To understand the supported update paths for this release, see [Azure Stack HCI, version 23H2 releases](./release-information-23h2.md#about-azure-stack-hci-version-23h2-releases).

For more information about the new features in this release, see [What's new in 23H2](whats-new.md).

## Issues for version 2402.3

This software release maps to software version number **2402.3.10**.

Release notes for this version include the issues fixed in this release, known issues in this release, and release noted issues carried over from previous versions.

## Fixed issues

Microsoft isn't aware of any fixed issues in this release.

## Known issues in this release

Microsoft isn't aware of any known issues in this release.

<!-- Here are the known issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------| -->

## Known issues from previous releases

Here are the known issues from previous releases:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| AKS on HCI <!--27081563--> |AKS cluster creation fails with the `Error: Invalid AKS network resource id`. This issue can occur when the associated logical network name has an underscore. |Underscores aren't supported in logical network names. Make sure to not use underscore in the names for logical networks deployed on your Azure Stack HCI. |
| Repair server <!--27053788--> |In rare instances, the `Repair-Server` operation fails with the `HealthServiceWaitForDriveFW` error. In these cases, the old drives from the repaired node aren't removed and new disks are stuck in the maintenance mode. |To prevent this issue, make sure that you DO NOT drain the node either via the Windows Admin Center or using the `Suspend-ClusterNode -Drain` PowerShell cmdlet before you start `Repair-Server`. <br> If the issue occurs, contact Microsoft Support for next steps. |
| Repair server <!--27152397--> |This issue is seen when the single server Azure Stack HCI is updated from 2311 to 2402 and then the `Repair-Server` is performed. The repair operation fails. |Before you repair the single node, follow these steps:<br>1. Run version 2402 for the *ADPrepTool*. Follow the steps in [Prepare Active Directory](./deploy/deployment-prep-active-directory.md). This action is quick and adds the required permissions to the Organizational Unit (OU).<br>2. Move the computer object from **Computers** segment to the root OU. Run the following command:<br>`Get-ADComputer <HOSTNAME>` \| `Move-ADObject -TargetPath "<OU path>"`|
| Deployment <!--27118224--> |If you prepare the Active Directory on your own (not using the script and procedure provided by Microsoft), your Active Directory validation could fail with missing `Generic All` permission. This is due to an issue in the validation check that checks for a dedicated permission entry for `msFVE-RecoverInformationobjects – General – Permissions Full control`, which is required for BitLocker recovery. |Use the [Prepare AD script method](./deploy/deployment-prep-active-directory.md) or if using your own method, make sure to assign the specific permission `msFVE-RecoverInformationobjects – General – Permissions Full control`.  |
| Deployment <!--26654488--> |There's a rare issue in this release where the DNS record is deleted during the Azure Stack HCI deployment. When that occurs, the following exception is seen: <br> ```Type 'PropagatePublicRootCertificate' of Role 'ASCA' raised an exception:<br>The operation on computer 'ASB88RQ22U09' failed: WinRM cannot process the request. The following error occurred while using Kerberos authentication: Cannot find the computer ASB88RQ22U09.local. Verify that the computer exists on the network and that the name provided is spelled correctly at PropagatePublicRootCertificate, C:\NugetStore\Microsoft.AzureStack, at Orchestration.Roles.CertificateAuthority.10.2402.0.14\content\Classes\ASCA\ASCA.psm1: line 38, at C:\CloudDeployment\ECEngine\InvokeInterfaceInternal.psm1: line 127,at Invoke-EceInterfaceInternal, C:\CloudDeployment\ECEngine\InvokeInterfaceInternal.psm1: line 123.```|Check the DNS server to see if any DNS records of the cluster nodes are missing. Apply the following mitigation on the nodes where its DNS record is missing.<br><br>Restart the DNS client service. Open a PowerShell session and run the following cmdlet on the affected node: <br>```Taskkill /f /fi "SERVICES eq dnscache"```|
| Deployment <!--26852606--> |In this release, there's a remote task failure on a multi-node deployment that results in the following exception:<br>```ECE RemoteTask orchestration failure with ASRR1N42R01U31 (node pingable - True): A WebException occurred while sending a RestRequest. WebException.Status: ConnectFailure on [https://<URL>](https://<URL>).```  |The mitigation is to restart the ECE agent on the affected node. On your server, open a PowerShell session and run the following command:<br>```Restart-Service ECEAgent```. |
| Add/Repair server <!--26852600--> |In this release, when adding or repairing a server, a failure is seen when the software load balancer or network controller VM certificates are being copied from the existing nodes. The failure is because these certificates weren't generated during the deployment/update. |There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps.|
| Deployment <!--26737110--> |In this release, there's a transient issue resulting in the deployment failure with the following exception:<br>```Type 'SyncDiagnosticLevel' of Role 'ObservabilityConfig' raised an exception:*<br>*Syncing Diagnostic Level failed with error: The Diagnostic Level does not match. Portal was not set to Enhanced, instead is Basic.``` |As this is a transient issue, retrying the deployment should fix this. For more information, see how to [Rerun the deployment](./deploy/deploy-via-portal.md#rerun-deployment). |
| Deployment <!--26376120--> |In this release, there's an issue with the Secrets URI/location field. This is a required field that is marked *Not mandatory* and results in Azure Resource Manager template deployment failures. |Use the sample parameters file in the [Deploy Azure Stack HCI, version 23H2 via Azure Resource Manager template](./deploy/deployment-azure-resource-manager-template.md) to ensure that all the inputs are provided in the required format and then try the deployment. <br>If there's a failed deployment, you must also clean up the following resources before you [Rerun the deployment](./deploy/deploy-via-portal.md#rerun-deployment): <br>1.  Delete `C:\EceStore`. <br>2.  Delete `C:\CloudDeployment`. <br>3.  Delete `C:\nugetstore`. <br>4.  `Remove-Item HKLM:\Software\Microsoft\LCMAzureStackStampInformation`.|
| Security <!--26865704--> |For new deployments, Secured-core capable devices won't have Dynamic Root of Measurement (DRTM) enabled by default. If you try to enable (DRTM) using the Enable-AzSSecurity cmdlet, you see an error that DRTM setting isn't supported in the current release.<br> Microsoft recommends defense in depth, and UEFI Secure Boot still protects the components in the Static Root of Trust (SRT) boot chain by ensuring that they're loaded only when they're signed and verified.  |DRTM isn't supported in this release.|
|Networking <!--28106559--> | An environment check fails when a proxy server is used. By design, the bypass list is different for winhttp and wininet, which causes the validation check to fail. | Follow these workaround steps: </br><br> 1. Clear the proxy bypass list prior to the health check and before starting the deployment or the update. </br><br> 2. After passing the check, wait for the deployment or update to fail. </br><br> 3. Set your proxy bypass list again. |
| Arc VM management <!--26100653--> |Deployment or update of Arc Resource Bridge could fail when the automatically generated temporary SPN secret during this operation, starts with a hyphen.|Retry the deployment/update. The retry should regenerate the SPN secret and the operation will likely succeed.  |
| Arc VM management <!--X--> |Arc Extensions on Arc VMs stay in "Creating" state indefinitely. | Sign in to the VM, open a command prompt, and type the following: <br> **Windows**: <br> `notepad C:\ProgramData\AzureConnectedMachineAgent\Config\agentconfig.json` <br> **Linux**: <br> `sudo vi /var/opt/azcmagent/agentconfig.json` <br>  Next, find the `resourcename` property. Delete the GUID that is appended to the end of the resource name, so this property matches the name of the VM. Then restart the VM.|
| Arc VM management <!--26066222--> |When a new server is added to an Azure Stack HCI cluster, storage path isn't created automatically for the newly created volume.| You can manually create a storage path for any new volumes. For more information, see [Create a storage path](./manage/create-storage-path.md).  |
| Arc VM management <!--X--> |Restart of Arc VM operation completes after approximately 20 minutes although the VM itself restarts in about a minute.| There's no known workaround in this release.  |
| Arc VM management <!--26084213--> |In some instances, the status of the logical network shows as Failed in Azure portal. This occurs when you try to delete the logical network without first deleting any resources such as network interfaces associated with that logical network. <br>You should still be able to create resources on this logical network. The status is misleading in this instance.| If the status of this logical network was *Succeeded* at the time when this network was provisioned, then you can continue to create resources on this network.  |
| Arc VM management <!--26201356--> |In this release, when you update a VM with a data disk attached to it using the Azure CLI, the operation fails with the following error message: <br> *Couldn't find a virtual hard disk with the name*.| Use the Azure portal for all the VM update operations. For more information, see [Manage Arc VMs](./manage/manage-arc-virtual-machines.md) and [Manage Arc VM resources](./manage/manage-arc-virtual-machine-resources.md).  |
| Update <!----> |In rare instances, you may encounter this error while updating your Azure Stack HCI: Type 'UpdateArbAndExtensions' of Role 'MocArb' raised an exception: Exception Upgrading ARB and Extension in step [UpgradeArbAndExtensions :Get-ArcHciConfig] UpgradeArb: Invalid applianceyaml = [C:\AksHci\hci-appliance.yaml].  |If you see this issue, contact Microsoft Support to assist you with the next steps.   |
| Networking <!--24524483--> |There's an infrequent DNS client issue in this release that causes the deployment to fail on a two-node cluster with a DNS resolution error: *A WebException occurred while sending a RestRequest. WebException.Status: NameResolutionFailure.* As a result of the bug, the DNS record of the second node is deleted soon after it's created resulting in a DNS error. |Restart the server. This operation registers the DNS record, which prevents it from getting deleted. |
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Arc VM management |Deleting a network interface on an Arc VM from Azure portal doesn't work in this release.| Use the Azure CLI to first remove the network interface and then delete it. For more information, see [Remove the network interface](/cli/azure/stack-hci-vm/nic#az-stack-hci-vm-nic-remove) and see [Delete the network interface](/cli/azure/stack-hci-vm/network/nic#az-stack-hci-vm-network-nic-delete).|
| Deployment |Providing the OU name in an incorrect syntax isn't detected in the Azure portal. The incorrect syntax includes unsupported characters such as `&,",',<,>`. The incorrect syntax is detected at a later step during cluster validation.|Make sure that the OU path syntax is correct and does not include unsupported characters. |
| Deployment |Deployments via Azure Resource Manager time out after 2 hours. Deployments that exceed 2 hours show up as failed in the resource group though the cluster is successfully created.| To monitor the deployment in the Azure portal, go to the Azure Stack HCI cluster resource and then go to new **Deployments** entry. |
| Azure Site Recovery |Azure Site Recovery can't be installed on an Azure Stack HCI cluster in this release. |There's no known workaround in this release. |
| Update <!--X-->| When updating the Azure Stack HCI cluster via the Azure Update Manager, the update progress and results may not be visible in the Azure portal.| To work around this issue, on each cluster node, add the following registry key (no value needed):<br><br>`New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\HciCloudManagementSvc\Parameters" -force`</br><br> Then on one of the cluster nodes, restart the Cloud Management cluster group. </br><br>`Stop-ClusterGroup "Cloud Management"`</br><br>`Start-ClusterGroup "Cloud Management"`</br><br> This won't fully remediate the issue as the progress details may still not be displayed for a duration of the update process. To get the latest update details, you can [Retrieve the update progress with PowerShell](./update/update-via-powershell-23h2.md#step-4-download-check-readiness-and-install-updates). |
| Update <!--26659591--> |In rare instances, if a failed update is stuck in an *In progress* state in Azure Update Manager, the **Try again** button is disabled. | To resume the update, run the following PowerShell command:<br>`Get-SolutionUpdate`\|`Start-SolutionUpdate`.|
| Updates <!--26659432--> |In some cases, `SolutionUpdate` commands could fail if run after the `Send-DiagnosticData` command.  | Make sure to close the PowerShell session used for `Send-DiagnosticData`. Open a new PowerShell session and use it for `SolutionUpdate` commands.|
| Update <!--26417221--> |In rare instances, when applying an update from 2311.0.24 to 2311.2.4, cluster status reports *In Progress* instead of expected *Failed to update*.   | Retry the update. If the issue persists, contact Microsoft Support.|
| Update <!--26039754--> | Attempts to install solution updates can fail at the end of the CAU steps with:*<br>*`There was a failure in a Common Information Model (CIM) operation, that is, an operation performed by software that Cluster-Aware Updating depends on.` *<br>* This rare issue occurs if the `Cluster Name` or `Cluster IP Address` resources fail to start after a node reboot and is most typical in small clusters. |If you encounter this issue, contact Microsoft Support for next steps. They can work with you to manually restart the cluster resources and resume the update as needed. |
| Update <!--27625941--> | When applying a cluster update to 10.2402.3.11 the `Get-SolutionUpdate` cmdlet may not respond and eventually fails with a RequestTimeoutException after approximately 10 minutes. This is likely to occur following an add or repair server scenario. | Use the `Start-ClusterGroup` and `Stop-ClusterGroup` cmdlets to restart the update service. </br><br> `Get-ClusterGroup -Name "Azure Stack HCI Update Service Cluster Group"` \| `Stop-ClusterGroup` </br><br> `Get-ClusterGroup -Name "Azure Stack HCI Update Service Cluster Group"` \| `Start-ClusterGroup` </br><br> A successful run of these cmdlets should bring the update service online. |
| Cluster aware updating <!--26411980--> |Resume node operation failed to resume node. | This is a transient issue and could resolve on its own. Wait for a few minutes and retry the operation. If the issue persists, contact Microsoft Support.|
| Cluster aware updating <!--26346755--> |Suspend node operation was stuck for greater than 90 minutes. | This is a transient issue and could resolve on its own. Wait for a few minutes and retry the operation. If the issue persists, contact Microsoft Support.|


## Next steps

- Read the [Deployment overview](./deploy/deployment-introduction.md).
