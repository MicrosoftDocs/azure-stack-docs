---
title: Azure Local Release Notes | Fixed and Known Issues
description: Read about the known issues and fixed issues in Azure Local.
author: alkohli
ms.topic: conceptual
ms.date: 07/15/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Known issues in Azure Local

This article identifies critical known issues and their workarounds in Azure Local.

These release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Local instance, carefully review the information contained here.

> [!IMPORTANT]
> For information about supported update paths for this release, see [Release information](./release-information-23h2.md#about-azure-local-releases).

For more information about new features in this release, see [What's new for Azure Local](whats-new.md).

::: moniker range="=azloc-2507"

## Known issues for version 2507

For the 2506 release of Azure Local, Microsoft released two security updates, each aligned with a specific OS build. The following table provides the specific versions and their OS builds:

| Solution version  | OS build  |
|---------|---------|---------|
| 11.2507.1001.5          | 25398.1732        |
| 12.2507.1001.6         | 26100.4652       |

> [!IMPORTANT]
> The new deployments of this software use the **12.2507.1001.6** build. You can also update an existing deployment from 2505 by using **11.2507.1001.5**.

Release notes for this version include the issues fixed in this release, known issues in this release, and release note issues carried over from previous versions.

> [!NOTE]
> For detailed remediation for common known issues, see the [Azure Local Supportability](https://github.com/Azure/AzureStackHCI-Supportability) GitHub repository.

## Fixed issues

The following table lists the fixed issues in this release:

|Feature  |Issue  |Comments  |
|---------|---------|---------|
| Update <!--33470082--> |  Solution update fails with the error: `Unable to install solution update "11.2506.1001.24" - Type 'UpdateFOD' of Role 'ComposedImageUpdate' raised an exception.` |  |
| Deployment <!--33392176--> |  Deployment fails with PSTerminatingError. |  |
| Deployment <!--33390832--> | In rare instances, deployment fails with errors during validation that state that the mandatory Arc extensions are not yet installed. |  |


## Known issues

Microsoft isn't aware of any known issues in this release.

## Known issues from previous releases

The following table lists the known issues from previous releases:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Add server <br> Repair server <!--32447442--> | The `Add-server` and `Repair-server` cmdlets fail with the error: <br> `Cluster Build ID matches node to add's Build ID`. | Use the OS image of the same solution version as that running on the existing cluster. To get the OS image, identify and download the image version from this [Release table](https://github.com/Azure-Samples/AzureLocal/blob/main/os-image/os-image-tracking-table.md). |
| Deployment <!--33008717--> | In this release and previous releases, registration fails with the following error when you try to register Azure Local machines with Azure Arc: <br>`AZCMAgent command failed with error: >> exitcode: 42. Additional Info: See https://aka.ms/arc/azcmerror`. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/users/kagoyal/tsg-error42/TSG/ArcRegistration/TSG%20%7C%20Arc%20registration%20failing%20with%20error%2042.md). |
| Azure Local VM management | The Mochostagent service might appear to be running but can get stuck without updating logs for over a month. You can identify this issue by checking the service logs in `C:\programdata\mochostagent\logs` to see if logs are being updated. | Run the following command to restart the mochostagent service: `restart-service mochostagent`. |
| Update | When viewing the readiness check results for an Azure Local instance via the Azure Update Manager, there might be multiple readiness checks with the same name.  |There's no known workaround in this release. Select **View details** to view specific information about the readiness check. |
| Update | There's an intermittent issue in this release when the Azure portal incorrectly reports the update status as **Failed to update** or **In progress** though the update is complete.  |[Connect to your Azure Local instance](./update/update-via-powershell-23h2.md#connect-to-your-azure-local) via a remote PowerShell session. To confirm the update status, run the following PowerShell cmdlets: <br><br> `$Update = get-solutionupdate`\| `? version -eq "<version string>"`<br><br>Replace the version string with the version you're running. For example, "10.2405.0.23". <br><br>`$Update.state`<br><br>If the update status is **Installed**, no further action is required on your part. The Azure portal refreshes the status correctly within 24 hours. <br> To refresh the status sooner, follow these steps on one of the nodes. <br>Restart the Cloud Management cluster group.<br>`Stop-ClusterGroup "Cloud Management"`<br>`Start-ClusterGroup "Cloud Management"`|
| Add server <!--26852600--> |In this release and previous releases, when adding a machine to the system, isn't possible to update the proxy bypass list string to include the new machine. Updating environment variables proxy bypass list on the hosts won't update the proxy bypass list on Azure resource bridge or AKS. |There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps.|
| Azure Local VM management |Arc Extensions on Azure Local VMs stay in "Creating" state indefinitely. | Sign in to the VM, open a command prompt, and type the following: <br> **Windows**: <br> `notepad C:\ProgramData\AzureConnectedMachineAgent\Config\agentconfig.json` <br> **Linux**: <br> `sudo vi /var/opt/azcmagent/agentconfig.json` <br>  Next, find the `resourcename` property. Delete the GUID that is appended to the end of the resource name, so this property matches the name of the VM. Then restart the VM.|
| Azure Local VM management |Restart of Azure Local VM operation completes after approximately 20 minutes although the VM itself restarts in about a minute.| There's no known workaround in this release.  |
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Azure Local VM management |Deleting a network interface on an Azure Local VM from Azure portal doesn't work in this release.| Use the Azure CLI to first remove the network interface and then delete it. For more information, see [Remove the network interface](/cli/azure/stack-hci-vm/nic#az-stack-hci-vm-nic-remove) and see [Delete the network interface](/cli/azure/stack-hci-vm/network/nic#az-stack-hci-vm-network-nic-delete).|
| Update | When updating the Azure Local instance via the Azure Update Manager, the update progress and results may not be visible in the Azure portal.| To work around this issue, on each node, add the following registry key (no value needed):<br><br>`New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\HciCloudManagementSvc\Parameters" -force`</br><br> Then on one of the nodes, restart the Cloud Management cluster group. </br><br>`Stop-ClusterGroup "Cloud Management"`</br><br>`Start-ClusterGroup "Cloud Management"`</br><br> This won't fully remediate the issue as the progress details may still not be displayed for a duration of the update process. To get the latest update details, you can [Retrieve the update progress with PowerShell](./update/update-via-powershell-23h2.md#step-6-track-update-progress). |
| Security <!-- 56969147 --> | When fixing the compliance for the minimum password length rule, even after you've changed the minimum password length on the Azure Local host to 14, you continue to see it as non-compliant in Azure policy.  | You can verify the length of the password using the `net accounts` cmdlet. In the output, find **Minimum password length** to see the value. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |
| Security <!--30348397--> |  Azure Local might face an issue during normal operations (for example, Update, Repair) while using Defender for Endpoint and when the **Restrict App Execution** setting is enabled for one or more servers in the deployment.  | Disable the **Restrict App Execution** setting in the Defender portal and reboot. If the issue persists, [open a support case](/azure/azure-portal/supportability/how-to-create-azure-support-request). |
| Deployment <!--33471589--> |  After Azure portal deployment, SConfig network settings shows the error: `Set-SCfNetworksetting : Cannot bind argument to parameter 'Value' because it is null.` | There's no known workaround in this release. |
| Update <!--33448368--> |  Cluster-Aware Updating runs might fail with the error:<br>`Type 'SBEPartnerConfirmCauDone' of Role 'SBE' raised an exception:<br>SBE_MsftCIOnlyCommon_CommonForTesting_4.2.2504.16: ErrorID: SBE-CAU-RUNNING-AFTER-DONE -- CAU run is still in progress when it should be done. See https://aka.ms/AzureLocal/SBE/CauHelp for help. Review full Get-CauRun output it identify if it is progressing or stuck. Wait for it to complete if progressing.` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/SolutionExtension/SBE-CAU-RUNNING-AFTER-DONE-Single-node-fail-SBE-Update.md).|

::: moniker-end

::: moniker range="=azloc-2506"

## Known issues for version 2506

For the 2506 release of Azure Local, Microsoft released two security updates, each aligned with a specific OS build. The following table provides the specific versions and their OS builds:

| Solution version  | OS build  |
|---------|---------|---------|
| 11.2506.1001.28          | 25398.1665         |
| 12.2506.1001.29         | 26100.4349        |

> [!IMPORTANT]
> The new deployments of this software use the **12.2506.1001.29** build. You can also update an existing deployment from 2505 using **11.2506.1001.28**.

Release notes for this version include the issues fixed in this release, known issues in this release, and release note issues carried over from previous versions.

> [!NOTE]
> For detailed remediation for common known issues, see the [Azure Local Supportability](https://github.com/Azure/AzureStackHCI-Supportability) GitHub repository.

## Fixed issues

The following table lists the fixed issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Azure Local VMs <!--30035765-->| When creating a VM, there is no option to prompt for password. | Password is prompted when `--password` is not explicitly passed. This provides customers a more secure way to input password.  |
| Azure Local VMs <!--32130105--> | When creating a VM, `--admin-username` and `--password` are required for guest management enablement. | Unbound requirement for guest management enablement. Now, when creating a VM, `--admin-username` and `--password` are required unless the OS disk is provided or the `--authentication-type` is `ssh`. |
| Azure Local VMs <!--32417179--> | In some cases, VM update operations were incorrectly shown as successful on the Azure portal even though they had failed in the underlying infrastructure.  | Improved error reporting to ensure the Azure portal accurately reflects the true status of VM update operations. |
| Azure Local VMs <!--32503885--> | Deleting a logical network with an attached AKS cluster would leave behind orphaned on-premises resources.  | Properly detects and handles AKS cluster dependencies during logical network deletion to prevent resource leaks. |
| Azure Local VMs <!--32698064--> | Unable to create VHDs using  `--download-url` | Correctly initializes VHD property before assigning the download URL, ensuring successful disk creation. |
| Azure Local VMs <!--32195527--> | In some cases, deleting a VM from multiple platforms (Azure portal, Windows Admin Center, Failover Cluster Manager) could cause its high availability (HA) status to remain stuck in a pending state. | Correctly updates the HA status when the VM is removed from the cluster, preventing it from getting stuck. |
| Azure Local VMs <!--32255591--> | After creating a VM, a temporary ISO file used for guest agent setup was sometimes left attached. | ISO file is automatically removed after VM creation. |
| Azure Local VMs <!--30846971--> | In some cases, VM deletions did not properly clean up associated network interfaces or disks, leaving behind orphaned resources that blocked reuse of IP addresses and storage. | All dependent resources are correctly detached and deleted when a VM is deleted, preventing resource leaks. |
| Azure Local VMs <!--30651739--> | Improved validation for the IP address of the infrastructure range.  |  |
| Azure Local VMs <!--32078730--> | Improved behavior for loading PowerShell modules.  |  |
| Azure Local VMs <!--32311676--> | Added flag to enable decryption of volumes when re-attaching them.  |  |

## Known issues in this release

The following table lists the known issues in this release:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Security <!--30348397--> |  Azure Local might face an issue during normal operations (for example, Update, Repair) while using Defender for Endpoint and when the **Restrict App Execution** setting is enabled for one or more servers in the deployment.  | Disable the **Restrict App Execution** setting in the Defender portal and reboot. If the issue persists, [open a support case](/azure/azure-portal/supportability/how-to-create-azure-support-request). |
| Deployment <!--33390832--> | In rare instances, deployment fails with errors during validation that state that the mandatory Arc extensions are not yet installed. | If you face this issue, retry the deployment. |
| Deployment <!--33392176--> |  Deployment fails with PSTerminatingError. | If you face this issue, retry the deployment. |
| Update <!--33470082--> |  Solution update fails with the error: `Unable to install solution update "11.2506.1001.24" - Type 'UpdateFOD' of Role 'ComposedImageUpdate' raised an exception.` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Update/SolutionUpdate-UpdateFOD.md). |
| Deployment <!--33471589--> |  After Azure portal deployment, SConfig network settings shows the error: `Set-SCfNetworksetting : Cannot bind argument to parameter 'Value' because it is null.` | There's no known workaround in this release. |
| Update <!--33448368--> |  Cluster-Aware Updating runs might fail with the error:<br>`Type 'SBEPartnerConfirmCauDone' of Role 'SBE' raised an exception:<br>SBE_MsftCIOnlyCommon_CommonForTesting_4.2.2504.16: ErrorID: SBE-CAU-RUNNING-AFTER-DONE -- CAU run is still in progress when it should be done. See https://aka.ms/AzureLocal/SBE/CauHelp for help. Review full Get-CauRun output it identify if it is progressing or stuck. Wait for it to complete if progressing.` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/SolutionExtension/SBE-CAU-RUNNING-AFTER-DONE-Single-node-fail-SBE-Update.md).|

::: moniker-end

::: moniker range="=azloc-2505"

This article identifies critical known issues and their workarounds in Azure Local.

These release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Local instance, carefully review the information contained here.

> [!IMPORTANT]
> For information about supported update paths for this release, see [Release information](./release-information-23h2.md#about-azure-local-releases).

For more information about new features in this release, see [What's new for Azure Local](whats-new.md).

## Known issues for version 2505

For the 2505 release of Azure Local, Microsoft released two security updates: one for existing deployments and another for new deployments. The following table provides information about different deployment types, their corresponding security updates, and OS builds:

| Deployment type  | Solution version  | OS build  |
|---------|---------|---------|
| Existing deployments    | 11.2505.1001.22          | 25398.1611         |
| New deployments    | 12.2505.1001.23         | 26100.4061        |

> [!IMPORTANT]
> The new deployments of this software use the **12.2505.1001.23** build. You can also update an existing deployment from 2504 using **11.2505.1001.22**.

Release notes for this version include the issues fixed in this release, known issues in this release, and release note issues carried over from previous versions.

> [!NOTE]
> For detailed remediation for common known issues, see the [Azure Local Supportability](https://github.com/Azure/AzureStackHCI-Supportability) GitHub repository.

## Fixed issues

The following table lists the fixed issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Azure Local VMs <!--31710217-->| Timeout errors occur when creating a disk and gallery image. | Extended the timeout period to support larger disk and image size.  |
| Azure Local VMs <!--31388717--> | Mocguestagent gets stuck in a start/stop loop and can't connect to the host agent. | Improved Mocguestagent connectivity. |
| Azure Local VMs <!--31628331--> | Cannot delete a VM in the Azure portal or CLI after deleting it in Hyper-V. | If you delete the VM in Hyper-V instead of the Azure portal or CLI, delete the resource it in the Azure portal or CLI to clean it up. |
| Azure Local VMs <!--32258078--> | Unable to delete a data disk that failed to attach during VM creation.  | Fixed the attachment state of data disk to be accurate. You can now delete a data disk if it fails to attach during VM creation.  |
| Azure Local VMs <!--32475268--> | OS updates can automatically install on the third Tuesday of the month (for example, May 20, June 17, or July 15). This can cause unexpected outages or future issues because of mismatched OS versions for Azure Local.  | Removed logic that set up a scheduled CAU as part of some SBE updates.  |
| Deployment | Deployment via Azure Resource Manager (ARM) template fails with the following error during validation:<br> `Type 'DeployArb' of Role 'MocArb' raised an exception: [DeployArb:Fetching SP in CloudDeployment Scenario] Exception calling 'GetCredential' with '1' argument(s): 'Exception of type 'CloudEngine.Configurations.SecretNotFoundException' was thrown.' at at Get-CloudDeploymentServicePrincipal`. <br> The error is because of a missing SPN during deployment. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Deployment/TSG-Azure-LOCAL-HCI-missing-spn.md). |
| Solution extension <!--32616426--> | Changed the severity level for the health check that validates the plugin's presence. | |
| Azure portal <!--32131565--> | Added a fix to fetch Storage account properties during redeployment. | |
| Azure portal <!--32105125--> | Added an error message about subscription access rights during Azure Local download. | |
| Azure portal <!--32379635--> | Added a warning message if the subscription is not registered during the Azure Local download. | |
| Azure portal <!--32694573--> | Improved logic to show Azure Arc-enabled machines for selection during deployment. | |
| Azure portal <!--32756322--> | Enhanced the setting of machines' state during deployment. | |
| Azure portal <!--30482549--> | Improved error handling and data processing. | |
| Azure portal <!--31931881--> | Added a fix to disable the validation button until extension installations are complete during deployment. | |
| Deployment <!--31617326--> | Added validation to check for required permissions to change access control lists (ACL). | |
| Deployment <!--32199814--> | Added a server-side filter to the WMI call to improve performance and reduce call time. | |
| Deployment <!--31911046--> | Added fix to dispose of the PowerShell objects after use to improve performance when creating new PowerShell instances. | |
| Deployment <!--642400448--> | Fixed the time zone issue when running the **Install Azure Stack HCI** wizard and selecting a time zone. The **Install Azure Stack HCI** wizard now correctly applies the selected time zone during deployment. | |
| Security management <!--57340784--> | Fixed **Security defaults**, **Application control**, and **Data protections** pages showing as *Unknown* in the security compliance report. | |
| Add server <br> Repair server <!--32483959--> | Fixed running `Add-server` and `Repair-server` cmdlets with a customized storage adapter IP in Azure Local which resulted in the error: `Type 'ConfigureAzureStackHostStorageAdpaterIPAddressesInAddRepairNode' of Role 'HostNetwork' raised an exception: Connecting to remote server <MACHINE> failed with the following error message: Access is denied.`. | |

## Known issues in this release

The following table lists the known issues in this release:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Update <!--54889342--> |  A critical VM operational status not OK alert is shown in the Azure portal under **Update readiness** and in the **Alerts** pane after the update has completed successfully. Additionally, the alert appears when running the `Get-HealthFault` cmdlet. | No action is required on your part. This alert will resolve automatically in a few days. |
| Deployment <!--33153622-->| Updating Azure Arc extensions manually from the Azure Local Machine page via the Azure portal will result in issues during deployment. The extensions that shouldn't be updated manually are: `AzureEdgeDeviceManagement`, `AzureEdgeLifecycleManager`, and `AzureEdgeAKVBackupForWindows`. | Installing extensions manually from the Azure Local machine page is not supported. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |


## Known issues from previous releases

The following table lists the known issues from previous releases:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Add server <br> Repair server <!--32447442--> | The `Add-server` and `Repair-server` cmdlets fail with the error: <br> `Cluster Build ID matches node to add's Build ID`. | Use the OS image of the same solution version as that running on the existing cluster. To get the OS image, identify and download the image version from this [Release table](https://github.com/Azure-Samples/AzureLocal/blob/main/os-image/os-image-tracking-table.md). |
| Deployment <!--33008717--> | In this release and previous releases, registration fails with the following error when you try to register Azure Local machines with Azure Arc: <br>`AZCMAgent command failed with error: >> exitcode: 42. Additional Info: See https://aka.ms/arc/azcmerror`. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/users/kagoyal/tsg-error42/TSG/ArcRegistration/TSG%20%7C%20Arc%20registration%20failing%20with%20error%2042.md). |
| Azure Local VM management | The Mochostagent service might appear to be running but can get stuck without updating logs for over a month. You can identify this issue by checking the service logs in `C:\programdata\mochostagent\logs` to see if logs are being updated. | Run the following command to restart the mochostagent service: `restart-service mochostagent`. |
| Update | When viewing the readiness check results for an Azure Local instance via the Azure Update Manager, there might be multiple readiness checks with the same name.  |There's no known workaround in this release. Select **View details** to view specific information about the readiness check. |
| Update | There's an intermittent issue in this release when the Azure portal incorrectly reports the update status as **Failed to update** or **In progress** though the update is complete.  |[Connect to your Azure Local instance](./update/update-via-powershell-23h2.md#connect-to-your-azure-local) via a remote PowerShell session. To confirm the update status, run the following PowerShell cmdlets: <br><br> `$Update = get-solutionupdate`\| `? version -eq "<version string>"`<br><br>Replace the version string with the version you're running. For example, "10.2405.0.23". <br><br>`$Update.state`<br><br>If the update status is **Installed**, no further action is required on your part. The Azure portal refreshes the status correctly within 24 hours. <br> To refresh the status sooner, follow these steps on one of the nodes. <br>Restart the Cloud Management cluster group.<br>`Stop-ClusterGroup "Cloud Management"`<br>`Start-ClusterGroup "Cloud Management"`|
| Add server <!--26852600--> |In this release and previous releases, when adding a machine to the system, isn't possible to update the proxy bypass list string to include the new machine. Updating environment variables proxy bypass list on the hosts won't update the proxy bypass list on Azure resource bridge or AKS. |There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps.|
| Azure Local VM management |Arc Extensions on Azure Local VMs stay in "Creating" state indefinitely. | Sign in to the VM, open a command prompt, and type the following: <br> **Windows**: <br> `notepad C:\ProgramData\AzureConnectedMachineAgent\Config\agentconfig.json` <br> **Linux**: <br> `sudo vi /var/opt/azcmagent/agentconfig.json` <br>  Next, find the `resourcename` property. Delete the GUID that is appended to the end of the resource name, so this property matches the name of the VM. Then restart the VM.|
| Azure Local VM management |Restart of Azure Local VM operation completes after approximately 20 minutes although the VM itself restarts in about a minute.| There's no known workaround in this release.  |
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Azure Local VM management |Deleting a network interface on an Azure Local VM from Azure portal doesn't work in this release.| Use the Azure CLI to first remove the network interface and then delete it. For more information, see [Remove the network interface](/cli/azure/stack-hci-vm/nic#az-stack-hci-vm-nic-remove) and see [Delete the network interface](/cli/azure/stack-hci-vm/network/nic#az-stack-hci-vm-network-nic-delete).|
| Update | When updating the Azure Local instance via the Azure Update Manager, the update progress and results may not be visible in the Azure portal.| To work around this issue, on each node, add the following registry key (no value needed):<br><br>`New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\HciCloudManagementSvc\Parameters" -force`</br><br> Then on one of the nodes, restart the Cloud Management cluster group. </br><br>`Stop-ClusterGroup "Cloud Management"`</br><br>`Start-ClusterGroup "Cloud Management"`</br><br> This won't fully remediate the issue as the progress details may still not be displayed for a duration of the update process. To get the latest update details, you can [Retrieve the update progress with PowerShell](./update/update-via-powershell-23h2.md#step-6-track-update-progress). |
| Security <!-- 56969147 --> | When fixing the compliance for the minimum password length rule, even after you've changed the minimum password length on the Azure Local host to 14, you continue to see it as non-compliant in Azure policy.  | You can verify the length of the password using the `net accounts` cmdlet. In the output, find **Minimum password length** to see the value. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |
| Security <!--30348397--> |  Azure Local might face an issue during normal operations (for example, Update, Repair) while using Defender for Endpoint and when the **Restrict App Execution** setting is enabled for one or more servers in the deployment.  | Disable the **Restrict App Execution** setting in the Defender portal and reboot. If the issue persists, [open a support case](/azure/azure-portal/supportability/how-to-create-azure-support-request). |
| Deployment <!--33471589--> |  After Azure portal deployment, SConfig network settings shows the error: `Set-SCfNetworksetting : Cannot bind argument to parameter 'Value' because it is null.` | There's no known workaround in this release. |
| Update <!--33448368--> |  Cluster-Aware Updating runs might fail with the error:<br>`Type 'SBEPartnerConfirmCauDone' of Role 'SBE' raised an exception:<br>SBE_MsftCIOnlyCommon_CommonForTesting_4.2.2504.16: ErrorID: SBE-CAU-RUNNING-AFTER-DONE -- CAU run is still in progress when it should be done. See https://aka.ms/AzureLocal/SBE/CauHelp for help. Review full Get-CauRun output it identify if it is progressing or stuck. Wait for it to complete if progressing.` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/SolutionExtension/SBE-CAU-RUNNING-AFTER-DONE-Single-node-fail-SBE-Update.md).|

::: moniker-end

::: moniker range="=azloc-2506"

## Known issues for version 2506

For the 2506 release of Azure Local, Microsoft released two security updates, each aligned with a specific OS build. The following table provides the specific versions and their OS builds:

| Solution version  | OS build  |
|---------|---------|---------|
| 11.2506.1001.28          | 25398.1665         |
| 12.2506.1001.29         | 26100.4349        |

> [!IMPORTANT]
> The new deployments of this software use the **12.2506.1001.29** build. You can also update an existing deployment from 2505 using **11.2506.1001.28**.

Release notes for this version include the issues fixed in this release, known issues in this release, and release note issues carried over from previous versions.

> [!NOTE]
> For detailed remediation for common known issues, see the [Azure Local Supportability](https://github.com/Azure/AzureStackHCI-Supportability) GitHub repository.

## Fixed issues

The following table lists the fixed issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Azure Local VMs <!--30035765-->| When creating a VM, there is no option to prompt for password. | Password is prompted when `--password` is not explicitly passed. This provides customers a more secure way to input password.  |
| Azure Local VMs <!--32130105--> | When creating a VM, `--admin-username` and `--password` are required for guest management enablement. | Unbound requirement for guest management enablement. Now, when creating a VM, `--admin-username` and `--password` are required unless the OS disk is provided or the `--authentication-type` is `ssh`. |
| Azure Local VMs <!--32417179--> | In some cases, VM update operations were incorrectly shown as successful on the Azure portal even though they had failed in the underlying infrastructure.  | Improved error reporting to ensure the Azure portal accurately reflects the true status of VM update operations. |
| Azure Local VMs <!--32503885--> | Deleting a logical network with an attached AKS cluster would leave behind orphaned on-premises resources.  | Properly detects and handles AKS cluster dependencies during logical network deletion to prevent resource leaks. |
| Azure Local VMs <!--32698064--> | Unable to create VHDs using  `--download-url` | Correctly initializes VHD property before assigning the download URL, ensuring successful disk creation. |
| Azure Local VMs <!--32195527--> | In some cases, deleting a VM from multiple platforms (Azure portal, Windows Admin Center, Failover Cluster Manager) could cause its high availability (HA) status to remain stuck in a pending state. | Correctly updates the HA status when the VM is removed from the cluster, preventing it from getting stuck. |
| Azure Local VMs <!--32255591--> | After creating a VM, a temporary ISO file used for guest agent setup was sometimes left attached. | ISO file is automatically removed after VM creation. |
| Azure Local VMs <!--30846971--> | In some cases, VM deletions did not properly clean up associated network interfaces or disks, leaving behind orphaned resources that blocked reuse of IP addresses and storage. | All dependent resources are correctly detached and deleted when a VM is deleted, preventing resource leaks. |
| Azure Local VMs <!--30651739--> | Improved validation for the IP address of the infrastructure range.  |  |
| Azure Local VMs <!--32078730--> | Improved behavior for loading PowerShell modules.  |  |
| Azure Local VMs <!--32311676--> | Added flag to enable decryption of volumes when re-attaching them.  |  |

## Known issues in this release

The following table lists the known issues in this release:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Security <!--30348397--> |  Azure Local might face an issue during normal operations (for example, Update, Repair) while using Defender for Endpoint and when the **Restrict App Execution** setting is enabled for one or more servers in the deployment.  | Disable the **Restrict App Execution** setting in the Defender portal and reboot. If the issue persists, [open a support case](/azure/azure-portal/supportability/how-to-create-azure-support-request). |
| Deployment <!--33390832--> | In rare instances, deployment fails with errors during validation that state that the mandatory Arc extensions are not yet installed. | If you face this issue, retry the deployment. |
| Deployment <!--33392176--> |  Deployment fails with PSTerminatingError. | If you face this issue, retry the deployment. |
| Update <!--33470082--> |  Solution update fails with the error: `Unable to install solution update "11.2506.1001.24" - Type 'UpdateFOD' of Role 'ComposedImageUpdate' raised an exception.` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Update/SolutionUpdate-UpdateFOD.md). |
| Deployment <!--33471589--> |  After Azure portal deployment, SConfig network settings shows the error: `Set-SCfNetworksetting : Cannot bind argument to parameter 'Value' because it is null.` | There's no known workaround in this release. |
| Update <!--33448368--> |  Cluster-Aware Updating runs might fail with the error:<br>`Type 'SBEPartnerConfirmCauDone' of Role 'SBE' raised an exception:<br>SBE_MsftCIOnlyCommon_CommonForTesting_4.2.2504.16: ErrorID: SBE-CAU-RUNNING-AFTER-DONE -- CAU run is still in progress when it should be done. See https://aka.ms/AzureLocal/SBE/CauHelp for help. Review full Get-CauRun output it identify if it is progressing or stuck. Wait for it to complete if progressing.` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/SolutionExtension/SBE-CAU-RUNNING-AFTER-DONE-Single-node-fail-SBE-Update.md).|

::: moniker-end

::: moniker range="=azloc-2505"

This article identifies critical known issues and their workarounds in Azure Local.

These release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Local instance, carefully review the information contained here.

> [!IMPORTANT]
> For information about supported update paths for this release, see [Release information](./release-information-23h2.md#about-azure-local-releases).

For more information about new features in this release, see [What's new for Azure Local](whats-new.md).

## Known issues for version 2505

For the 2505 release of Azure Local, Microsoft released two security updates: one for existing deployments and another for new deployments. The following table provides information about different deployment types, their corresponding security updates, and OS builds:

| Deployment type  | Solution version  | OS build  |
|---------|---------|---------|
| Existing deployments    | 11.2505.1001.22          | 25398.1611         |
| New deployments    | 12.2505.1001.23         | 26100.4061        |

> [!IMPORTANT]
> The new deployments of this software use the **12.2505.1001.23** build. You can also update an existing deployment from 2504 using **11.2505.1001.22**.

Release notes for this version include the issues fixed in this release, known issues in this release, and release note issues carried over from previous versions.

> [!NOTE]
> For detailed remediation for common known issues, see the [Azure Local Supportability](https://github.com/Azure/AzureStackHCI-Supportability) GitHub repository.

## Fixed issues

The following table lists the fixed issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Azure Local VMs <!--31710217-->| Timeout errors occur when creating a disk and gallery image. | Extended the timeout period to support larger disk and image size.  |
| Azure Local VMs <!--31388717--> | Mocguestagent gets stuck in a start/stop loop and can't connect to the host agent. | Improved Mocguestagent connectivity. |
| Azure Local VMs <!--31628331--> | Cannot delete a VM in the Azure portal or CLI after deleting it in Hyper-V. | If you delete the VM in Hyper-V instead of the Azure portal or CLI, delete the resource it in the Azure portal or CLI to clean it up. |
| Azure Local VMs <!--32258078--> | Unable to delete a data disk that failed to attach during VM creation.  | Fixed the attachment state of data disk to be accurate. You can now delete a data disk if it fails to attach during VM creation.  |
| Azure Local VMs <!--32475268--> | OS updates can automatically install on the third Tuesday of the month (for example, May 20, June 17, or July 15). This can cause unexpected outages or future issues because of mismatched OS versions for Azure Local.  | Removed logic that set up a scheduled CAU as part of some SBE updates.  |
| Deployment | Deployment via Azure Resource Manager (ARM) template fails with the following error during validation:<br> `Type 'DeployArb' of Role 'MocArb' raised an exception: [DeployArb:Fetching SP in CloudDeployment Scenario] Exception calling 'GetCredential' with '1' argument(s): 'Exception of type 'CloudEngine.Configurations.SecretNotFoundException' was thrown.' at at Get-CloudDeploymentServicePrincipal`. <br> The error is because of a missing SPN during deployment. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Deployment/TSG-Azure-LOCAL-HCI-missing-spn.md). |
| Solution extension <!--32616426--> | Changed the severity level for the health check that validates the plugin's presence. | |
| Azure portal <!--32131565--> | Added a fix to fetch Storage account properties during redeployment. | |
| Azure portal <!--32105125--> | Added an error message about subscription access rights during Azure Local download. | |
| Azure portal <!--32379635--> | Added a warning message if the subscription is not registered during the Azure Local download. | |
| Azure portal <!--32694573--> | Improved logic to show Azure Arc-enabled machines for selection during deployment. | |
| Azure portal <!--32756322--> | Enhanced the setting of machines' state during deployment. | |
| Azure portal <!--30482549--> | Improved error handling and data processing. | |
| Azure portal <!--31931881--> | Added a fix to disable the validation button until extension installations are complete during deployment. | |
| Deployment <!--31617326--> | Added validation to check for required permissions to change access control lists (ACL). | |
| Deployment <!--32199814--> | Added a server-side filter to the WMI call to improve performance and reduce call time. | |
| Deployment <!--31911046--> | Added fix to dispose of the PowerShell objects after use to improve performance when creating new PowerShell instances. | |
| Deployment <!--642400448--> | Fixed the time zone issue when running the **Install Azure Stack HCI** wizard and selecting a time zone. The **Install Azure Stack HCI** wizard now correctly applies the selected time zone during deployment. | |
| Security management <!--57340784--> | Fixed **Security defaults**, **Application control**, and **Data protections** pages showing as *Unknown* in the security compliance report. | |
| Add server <br> Repair server <!--32483959--> | Fixed running `Add-server` and `Repair-server` cmdlets with a customized storage adapter IP in Azure Local which resulted in the error: `Type 'ConfigureAzureStackHostStorageAdpaterIPAddressesInAddRepairNode' of Role 'HostNetwork' raised an exception: Connecting to remote server <MACHINE> failed with the following error message: Access is denied.`. | |

## Known issues in this release

The following table lists the known issues in this release:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Update <!--54889342--> |  A critical VM operational status not OK alert is shown in the Azure portal under **Update readiness** and in the **Alerts** pane after the update has completed successfully. Additionally, the alert appears when running the `Get-HealthFault` cmdlet. | No action is required on your part. This alert will resolve automatically in a few days. |
| Deployment <!--33153622-->| Updating Azure Arc extensions manually from the Azure Local Machine page via the Azure portal will result in issues during deployment. The extensions that shouldn't be updated manually are: `AzureEdgeDeviceManagement`, `AzureEdgeLifecycleManager`, and `AzureEdgeAKVBackupForWindows`. | Installing extensions manually from the Azure Local machine page is not supported. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |


## Known issues from previous releases

The following table lists the known issues from previous releases:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Add server <br> Repair server <!--32447442--> | The `Add-server` and `Repair-server` cmdlets fail with the error: <br> `Cluster Build ID matches node to add's Build ID`. | Use the OS image of the same solution version as that running on the existing cluster. To get the OS image, identify and download the image version from this [Release table](https://github.com/Azure-Samples/AzureLocal/blob/main/os-image/os-image-tracking-table.md). |
| Deployment <!--33008717--> | In this release and previous releases, registration fails with the following error when you try to register Azure Local machines with Azure Arc: <br>`AZCMAgent command failed with error: >> exitcode: 42. Additional Info: See https://aka.ms/arc/azcmerror`. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/users/kagoyal/tsg-error42/TSG/ArcRegistration/TSG%20%7C%20Arc%20registration%20failing%20with%20error%2042.md). |
| Azure Local VM management | The Mochostagent service might appear to be running but can get stuck without updating logs for over a month. You can identify this issue by checking the service logs in `C:\programdata\mochostagent\logs` to see if logs are being updated. | Run the following command to restart the mochostagent service: `restart-service mochostagent`. |
| Update | When viewing the readiness check results for an Azure Local instance via the Azure Update Manager, there might be multiple readiness checks with the same name.  |There's no known workaround in this release. Select **View details** to view specific information about the readiness check. |
| Update | There's an intermittent issue in this release when the Azure portal incorrectly reports the update status as **Failed to update** or **In progress** though the update is complete.  |[Connect to your Azure Local instance](./update/update-via-powershell-23h2.md#connect-to-your-azure-local) via a remote PowerShell session. To confirm the update status, run the following PowerShell cmdlets: <br><br> `$Update = get-solutionupdate`\| `? version -eq "<version string>"`<br><br>Replace the version string with the version you're running. For example, "10.2405.0.23". <br><br>`$Update.state`<br><br>If the update status is **Installed**, no further action is required on your part. The Azure portal refreshes the status correctly within 24 hours. <br> To refresh the status sooner, follow these steps on one of the nodes. <br>Restart the Cloud Management cluster group.<br>`Stop-ClusterGroup "Cloud Management"`<br>`Start-ClusterGroup "Cloud Management"`|
| Add server <!--26852600--> |In this release and previous releases, when adding a machine to the system, isn't possible to update the proxy bypass list string to include the new machine. Updating environment variables proxy bypass list on the hosts won't update the proxy bypass list on Azure resource bridge or AKS. |There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps.|
| Azure Local VM management |Arc Extensions on Azure Local VMs stay in "Creating" state indefinitely. | Sign in to the VM, open a command prompt, and type the following: <br> **Windows**: <br> `notepad C:\ProgramData\AzureConnectedMachineAgent\Config\agentconfig.json` <br> **Linux**: <br> `sudo vi /var/opt/azcmagent/agentconfig.json` <br>  Next, find the `resourcename` property. Delete the GUID that is appended to the end of the resource name, so this property matches the name of the VM. Then restart the VM.|
| Azure Local VM management |Restart of Azure Local VM operation completes after approximately 20 minutes although the VM itself restarts in about a minute.| There's no known workaround in this release.  |
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Azure Local VM management |Deleting a network interface on an Azure Local VM from Azure portal doesn't work in this release.| Use the Azure CLI to first remove the network interface and then delete it. For more information, see [Remove the network interface](/cli/azure/stack-hci-vm/nic#az-stack-hci-vm-nic-remove) and see [Delete the network interface](/cli/azure/stack-hci-vm/network/nic#az-stack-hci-vm-network-nic-delete).|
| Update | When updating the Azure Local instance via the Azure Update Manager, the update progress and results may not be visible in the Azure portal.| To work around this issue, on each node, add the following registry key (no value needed):<br><br>`New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\HciCloudManagementSvc\Parameters" -force`</br><br> Then on one of the nodes, restart the Cloud Management cluster group. </br><br>`Stop-ClusterGroup "Cloud Management"`</br><br>`Start-ClusterGroup "Cloud Management"`</br><br> This won't fully remediate the issue as the progress details may still not be displayed for a duration of the update process. To get the latest update details, you can [Retrieve the update progress with PowerShell](./update/update-via-powershell-23h2.md#step-6-track-update-progress). |
| Security <!-- 56969147 --> | When fixing the compliance for the minimum password length rule, even after you've changed the minimum password length on the Azure Local host to 14, you continue to see it as non-compliant in Azure policy.  | You can verify the length of the password using the `net accounts` cmdlet. In the output, find **Minimum password length** to see the value. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |
| Security <!--30348397--> |  Azure Local might face an issue during normal operations (for example, Update, Repair) while using Defender for Endpoint and when the **Restrict App Execution** setting is enabled for one or more servers in the deployment.  | Disable the **Restrict App Execution** setting in the Defender portal and reboot. If the issue persists, [open a support case](/azure/azure-portal/supportability/how-to-create-azure-support-request). |
| Deployment <!--33471589--> |  After Azure portal deployment, SConfig network settings shows the error: `Set-SCfNetworksetting : Cannot bind argument to parameter 'Value' because it is null.` | There's no known workaround in this release. |
| Update <!--33448368--> |  Cluster-Aware Updating runs might fail with the error:<br>`Type 'SBEPartnerConfirmCauDone' of Role 'SBE' raised an exception:<br>SBE_MsftCIOnlyCommon_CommonForTesting_4.2.2504.16: ErrorID: SBE-CAU-RUNNING-AFTER-DONE -- CAU run is still in progress when it should be done. See https://aka.ms/AzureLocal/SBE/CauHelp for help. Review full Get-CauRun output it identify if it is progressing or stuck. Wait for it to complete if progressing.` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/SolutionExtension/SBE-CAU-RUNNING-AFTER-DONE-Single-node-fail-SBE-Update.md).|

::: moniker-end

::: moniker range="=azloc-2506"

## Known issues for version 2506

For the 2506 release of Azure Local, Microsoft released two security updates, each aligned with a specific OS build. The following table provides the specific versions and their OS builds:

| Solution version  | OS build  |
|---------|---------|---------|
| 11.2506.1001.28          | 25398.1665         |
| 12.2506.1001.29         | 26100.4349        |

> [!IMPORTANT]
> The new deployments of this software use the **12.2506.1001.29** build. You can also update an existing deployment from 2505 using **11.2506.1001.28**.

Release notes for this version include the issues fixed in this release, known issues in this release, and release note issues carried over from previous versions.

> [!NOTE]
> For detailed remediation for common known issues, see the [Azure Local Supportability](https://github.com/Azure/AzureStackHCI-Supportability) GitHub repository.

## Fixed issues

The following table lists the fixed issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Azure Local VMs <!--30035765-->| When creating a VM, there is no option to prompt for password. | Password is prompted when `--password` is not explicitly passed. This provides customers a more secure way to input password.  |
| Azure Local VMs <!--32130105--> | When creating a VM, `--admin-username` and `--password` are required for guest management enablement. | Unbound requirement for guest management enablement. Now, when creating a VM, `--admin-username` and `--password` are required unless the OS disk is provided or the `--authentication-type` is `ssh`. |
| Azure Local VMs <!--32417179--> | In some cases, VM update operations were incorrectly shown as successful on the Azure portal even though they had failed in the underlying infrastructure.  | Improved error reporting to ensure the Azure portal accurately reflects the true status of VM update operations. |
| Azure Local VMs <!--32503885--> | Deleting a logical network with an attached AKS cluster would leave behind orphaned on-premises resources.  | Properly detects and handles AKS cluster dependencies during logical network deletion to prevent resource leaks. |
| Azure Local VMs <!--32698064--> | Unable to create VHDs using  `--download-url` | Correctly initializes VHD property before assigning the download URL, ensuring successful disk creation. |
| Azure Local VMs <!--32195527--> | In some cases, deleting a VM from multiple platforms (Azure portal, Windows Admin Center, Failover Cluster Manager) could cause its high availability (HA) status to remain stuck in a pending state. | Correctly updates the HA status when the VM is removed from the cluster, preventing it from getting stuck. |
| Azure Local VMs <!--32255591--> | After creating a VM, a temporary ISO file used for guest agent setup was sometimes left attached. | ISO file is automatically removed after VM creation. |
| Azure Local VMs <!--30846971--> | In some cases, VM deletions did not properly clean up associated network interfaces or disks, leaving behind orphaned resources that blocked reuse of IP addresses and storage. | All dependent resources are correctly detached and deleted when a VM is deleted, preventing resource leaks. |
| Azure Local VMs <!--30651739--> | Improved validation for the IP address of the infrastructure range.  |  |
| Azure Local VMs <!--32078730--> | Improved behavior for loading PowerShell modules.  |  |
| Azure Local VMs <!--32311676--> | Added flag to enable decryption of volumes when re-attaching them.  |  |

## Known issues in this release

The following table lists the known issues in this release:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Security <!--30348397--> |  Azure Local might face an issue during normal operations (for example, Update, Repair) while using Defender for Endpoint and when the **Restrict App Execution** setting is enabled for one or more servers in the deployment.  | Disable the **Restrict App Execution** setting in the Defender portal and reboot. If the issue persists, [open a support case](/azure/azure-portal/supportability/how-to-create-azure-support-request). |
| Deployment <!--33390832--> | In rare instances, deployment fails with errors during validation that state that the mandatory Arc extensions are not yet installed. | If you face this issue, retry the deployment. |
| Deployment <!--33392176--> |  Deployment fails with PSTerminatingError. | If you face this issue, retry the deployment. |
| Update <!--33470082--> |  Solution update fails with the error: `Unable to install solution update "11.2506.1001.24" - Type 'UpdateFOD' of Role 'ComposedImageUpdate' raised an exception.` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Update/SolutionUpdate-UpdateFOD.md). |
| Deployment <!--33471589--> |  After Azure portal deployment, SConfig network settings shows the error: `Set-SCfNetworksetting : Cannot bind argument to parameter 'Value' because it is null.` | There's no known workaround in this release. |
| Update <!--33448368--> |  Cluster-Aware Updating runs might fail with the error:<br>`Type 'SBEPartnerConfirmCauDone' of Role 'SBE' raised an exception:<br>SBE_MsftCIOnlyCommon_CommonForTesting_4.2.2504.16: ErrorID: SBE-CAU-RUNNING-AFTER-DONE -- CAU run is still in progress when it should be done. See https://aka.ms/AzureLocal/SBE/CauHelp for help. Review full Get-CauRun output it identify if it is progressing or stuck. Wait for it to complete if progressing.` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/SolutionExtension/SBE-CAU-RUNNING-AFTER-DONE-Single-node-fail-SBE-Update.md).|

::: moniker-end

::: moniker range="=azloc-2505"

This article identifies critical known issues and their workarounds in Azure Local.

These release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Local instance, carefully review the information contained here.

> [!IMPORTANT]
> For information about supported update paths for this release, see [Release information](./release-information-23h2.md#about-azure-local-releases).

For more information about new features in this release, see [What's new for Azure Local](whats-new.md).

## Known issues for version 2505

For the 2505 release of Azure Local, Microsoft released two security updates: one for existing deployments and another for new deployments. The following table provides information about different deployment types, their corresponding security updates, and OS builds:

| Deployment type  | Solution version  | OS build  |
|---------|---------|---------|
| Existing deployments    | 11.2505.1001.22          | 25398.1611         |
| New deployments    | 12.2505.1001.23         | 26100.4061        |

> [!IMPORTANT]
> The new deployments of this software use the **12.2505.1001.23** build. You can also update an existing deployment from 2504 using **11.2505.1001.22**.

Release notes for this version include the issues fixed in this release, known issues in this release, and release note issues carried over from previous versions.

> [!NOTE]
> For detailed remediation for common known issues, see the [Azure Local Supportability](https://github.com/Azure/AzureStackHCI-Supportability) GitHub repository.

## Fixed issues

The following table lists the fixed issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Azure Local VMs <!--31710217-->| Timeout errors occur when creating a disk and gallery image. | Extended the timeout period to support larger disk and image size.  |
| Azure Local VMs <!--31388717--> | Mocguestagent gets stuck in a start/stop loop and can't connect to the host agent. | Improved Mocguestagent connectivity. |
| Azure Local VMs <!--31628331--> | Cannot delete a VM in the Azure portal or CLI after deleting it in Hyper-V. | If you delete the VM in Hyper-V instead of the Azure portal or CLI, delete the resource it in the Azure portal or CLI to clean it up. |
| Azure Local VMs <!--32258078--> | Unable to delete a data disk that failed to attach during VM creation.  | Fixed the attachment state of data disk to be accurate. You can now delete a data disk if it fails to attach during VM creation.  |
| Azure Local VMs <!--32475268--> | OS updates can automatically install on the third Tuesday of the month (for example, May 20, June 17, or July 15). This can cause unexpected outages or future issues because of mismatched OS versions for Azure Local.  | Removed logic that set up a scheduled CAU as part of some SBE updates.  |
| Deployment | Deployment via Azure Resource Manager (ARM) template fails with the following error during validation:<br> `Type 'DeployArb' of Role 'MocArb' raised an exception: [DeployArb:Fetching SP in CloudDeployment Scenario] Exception calling 'GetCredential' with '1' argument(s): 'Exception of type 'CloudEngine.Configurations.SecretNotFoundException' was thrown.' at at Get-CloudDeploymentServicePrincipal`. <br> The error is because of a missing SPN during deployment. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Deployment/TSG-Azure-LOCAL-HCI-missing-spn.md). |
| Solution extension <!--32616426--> | Changed the severity level for the health check that validates the plugin's presence. | |
| Azure portal <!--32131565--> | Added a fix to fetch Storage account properties during redeployment. | |
| Azure portal <!--32105125--> | Added an error message about subscription access rights during Azure Local download. | |
| Azure portal <!--32379635--> | Added a warning message if the subscription is not registered during the Azure Local download. | |
| Azure portal <!--32694573--> | Improved logic to show Azure Arc-enabled machines for selection during deployment. | |
| Azure portal <!--32756322--> | Enhanced the setting of machines' state during deployment. | |
| Azure portal <!--30482549--> | Improved error handling and data processing. | |
| Azure portal <!--31931881--> | Added a fix to disable the validation button until extension installations are complete during deployment. | |
| Deployment <!--31617326--> | Added validation to check for required permissions to change access control lists (ACL). | |
| Deployment <!--32199814--> | Added a server-side filter to the WMI call to improve performance and reduce call time. | |
| Deployment <!--31911046--> | Added fix to dispose of the PowerShell objects after use to improve performance when creating new PowerShell instances. | |
| Deployment <!--642400448--> | Fixed the time zone issue when running the **Install Azure Stack HCI** wizard and selecting a time zone. The **Install Azure Stack HCI** wizard now correctly applies the selected time zone during deployment. | |
| Security management <!--57340784--> | Fixed **Security defaults**, **Application control**, and **Data protections** pages showing as *Unknown* in the security compliance report. | |
| Add server <br> Repair server <!--32483959--> | Fixed running `Add-server` and `Repair-server` cmdlets with a customized storage adapter IP in Azure Local which resulted in the error: `Type 'ConfigureAzureStackHostStorageAdpaterIPAddressesInAddRepairNode' of Role 'HostNetwork' raised an exception: Connecting to remote server <MACHINE> failed with the following error message: Access is denied.`. | |

## Known issues in this release

The following table lists the known issues in this release:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Update <!--54889342--> |  A critical VM operational status not OK alert is shown in the Azure portal under **Update readiness** and in the **Alerts** pane after the update has completed successfully. Additionally, the alert appears when running the `Get-HealthFault` cmdlet. | No action is required on your part. This alert will resolve automatically in a few days. |
| Deployment <!--33153622-->| Updating Azure Arc extensions manually from the Azure Local Machine page via the Azure portal will result in issues during deployment. The extensions that shouldn't be updated manually are: `AzureEdgeDeviceManagement`, `AzureEdgeLifecycleManager`, and `AzureEdgeAKVBackupForWindows`. | Installing extensions manually from the Azure Local machine page is not supported. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |


## Known issues from previous releases

The following table lists the known issues from previous releases:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Add server <br> Repair server <!--32447442--> | The `Add-server` and `Repair-server` cmdlets fail with the error: <br> `Cluster Build ID matches node to add's Build ID`. | Use the OS image of the same solution version as that running on the existing cluster. To get the OS image, identify and download the image version from this [Release table](https://github.com/Azure-Samples/AzureLocal/blob/main/os-image/os-image-tracking-table.md). |
| Deployment <!--33008717--> | In this release and previous releases, registration fails with the following error when you try to register Azure Local machines with Azure Arc: <br>`AZCMAgent command failed with error: >> exitcode: 42. Additional Info: See https://aka.ms/arc/azcmerror`. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/users/kagoyal/tsg-error42/TSG/ArcRegistration/TSG%20%7C%20Arc%20registration%20failing%20with%20error%2042.md). |
| Azure Local VM management | The Mochostagent service might appear to be running but can get stuck without updating logs for over a month. You can identify this issue by checking the service logs in `C:\programdata\mochostagent\logs` to see if logs are being updated. | Run the following command to restart the mochostagent service: `restart-service mochostagent`. |
| Update | When viewing the readiness check results for an Azure Local instance via the Azure Update Manager, there might be multiple readiness checks with the same name.  |There's no known workaround in this release. Select **View details** to view specific information about the readiness check. |
| Update | There's an intermittent issue in this release when the Azure portal incorrectly reports the update status as **Failed to update** or **In progress** though the update is complete.  |[Connect to your Azure Local instance](./update/update-via-powershell-23h2.md#connect-to-your-azure-local) via a remote PowerShell session. To confirm the update status, run the following PowerShell cmdlets: <br><br> `$Update = get-solutionupdate`\| `? version -eq "<version string>"`<br><br>Replace the version string with the version you're running. For example, "10.2405.0.23". <br><br>`$Update.state`<br><br>If the update status is **Installed**, no further action is required on your part. The Azure portal refreshes the status correctly within 24 hours. <br> To refresh the status sooner, follow these steps on one of the nodes. <br>Restart the Cloud Management cluster group.<br>`Stop-ClusterGroup "Cloud Management"`<br>`Start-ClusterGroup "Cloud Management"`|
| Add server <!--26852600--> |In this release and previous releases, when adding a machine to the system, isn't possible to update the proxy bypass list string to include the new machine. Updating environment variables proxy bypass list on the hosts won't update the proxy bypass list on Azure resource bridge or AKS. |There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps.|
| Azure Local VM management |Arc Extensions on Azure Local VMs stay in "Creating" state indefinitely. | Sign in to the VM, open a command prompt, and type the following: <br> **Windows**: <br> `notepad C:\ProgramData\AzureConnectedMachineAgent\Config\agentconfig.json` <br> **Linux**: <br> `sudo vi /var/opt/azcmagent/agentconfig.json` <br>  Next, find the `resourcename` property. Delete the GUID that is appended to the end of the resource name, so this property matches the name of the VM. Then restart the VM.|
| Azure Local VM management |Restart of Azure Local VM operation completes after approximately 20 minutes though the VM itself restarts in about a minute.| There's no known workaround in this release.  |
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Azure Local VM management |Deleting a network interface on an Azure Local VM from Azure portal doesn't work in this release.| Use the Azure CLI to first remove the network interface and then delete it. For more information, see [Remove the network interface](/cli/azure/stack-hci-vm/nic#az-stack-hci-vm-nic-remove) and see [Delete the network interface](/cli/azure/stack-hci-vm/network/nic#az-stack-hci-vm-network-nic-delete).|
| Update | When updating the Azure Local instance via the Azure Update Manager, the update progress and results may not be visible in the Azure portal.| To work around this issue, on each node, add the following registry key (no value needed):<br><br>`New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\HciCloudManagementSvc\Parameters" -force`</br><br> Then on one of the nodes, restart the Cloud Management cluster group. </br><br>`Stop-ClusterGroup "Cloud Management"`</br><br>`Start-ClusterGroup "Cloud Management"`</br><br> This won't fully remediate the issue as the progress details may still not be displayed for a duration of the update process. To get the latest update details, you can [Retrieve the update progress with PowerShell](./update/update-via-powershell-23h2.md#step-6-track-update-progress). |
| Security <!-- 56969147 --> | When fixing the compliance for the minimum password length rule, even after you've changed the minimum password length on the Azure Local host to 14, you continue to see it as non-compliant in Azure policy.  | You can verify the length of the password using the `net accounts` cmdlet. In the output, find **Minimum password length** to see the value. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |
| Security <!--30348397--> |  Azure Local might face an issue during normal operations (for example, Update, Repair) while using Defender for Endpoint and when the **Restrict App Execution** setting is enabled for one or more servers in the deployment.  | Disable the **Restrict App Execution** setting in the Defender portal and reboot. If the issue persists, [open a support case](/azure/azure-portal/supportability/how-to-create-azure-support-request). |
| Deployment <!--33471589--> |  After Azure portal deployment, SConfig network settings shows the error: `Set-SCfNetworksetting : Cannot bind argument to parameter 'Value' because it is null.` | There's no known workaround in this release. |
| Update <!--33448368--> |  Cluster-Aware Updating runs might fail with the error:<br>`Type 'SBEPartnerConfirmCauDone' of Role 'SBE' raised an exception:<br>SBE_MsftCIOnlyCommon_CommonForTesting_4.2.2504.16: ErrorID: SBE-CAU-RUNNING-AFTER-DONE -- CAU run is still in progress when it should be done. See https://aka.ms/AzureLocal/SBE/CauHelp for help. Review full Get-CauRun output it identify if it is progressing or stuck. Wait for it to complete if progressing.` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/SolutionExtension/SBE-CAU-RUNNING-AFTER-DONE-Single-node-fail-SBE-Update.md).|

::: moniker-end

::: moniker range="=azloc-2506"

## Known issues for version 2506

For the 2506 release of Azure Local, Microsoft released two security updates, each aligned with a specific OS build. The following table provides the specific versions and their OS builds:

| Solution version  | OS build  |
|---------|---------|---------|
| 11.2506.1001.28          | 25398.1665         |
| 12.2506.1001.29         | 26100.4349        |

> [!IMPORTANT]
> The new deployments of this software use the **12.2506.1001.29** build. You can also update an existing deployment from 2505 using **11.2506.1001.28**.

Release notes for this version include the issues fixed in this release, known issues in this release, and release note issues carried over from previous versions.

> [!NOTE]
> For detailed remediation for common known issues, see the [Azure Local Supportability](https://github.com/Azure/AzureStackHCI-Supportability) GitHub repository.

## Fixed issues

The following table lists the fixed issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Azure Local VMs <!--30035765-->| When creating a VM, there is no option to prompt for password. | Password is prompted when `--password` is not explicitly passed. This provides customers a more secure way to input password.  |
| Azure Local VMs <!--32130105--> | When creating a VM, `--admin-username` and `--password` are required for guest management enablement. | Unbound requirement for guest management enablement. Now, when creating a VM, `--admin-username` and `--password` are required unless the OS disk is provided or the `--authentication-type` is `ssh`. |
| Azure Local VMs <!--32417179--> | In some cases, VM update operations were incorrectly shown as successful on the Azure portal even though they had failed in the underlying infrastructure.  | Improved error reporting to ensure the Azure portal accurately reflects the true status of VM update operations. |
| Azure Local VMs <!--32503885--> | Deleting a logical network with an attached AKS cluster would leave behind orphaned on-premises resources.  | Properly detects and handles AKS cluster dependencies during logical network deletion to prevent resource leaks. |
| Azure Local VMs <!--32698064--> | Unable to create VHDs using  `--download-url` | Correctly initializes VHD property before assigning the download URL, ensuring successful disk creation. |
| Azure Local VMs <!--32195527--> | In some cases, deleting a VM from multiple platforms (Azure portal, Windows Admin Center, Failover Cluster Manager) could cause its high availability (HA) status to remain stuck in a pending state. | Correctly updates the HA status when the VM is removed from the cluster, preventing it from getting stuck. |
| Azure Local VMs <!--32255591--> | After creating a VM, a temporary ISO file used for guest agent setup was sometimes left attached. | ISO file is automatically removed after VM creation. |
| Azure Local VMs <!--30846971--> | In some cases, VM deletions did not properly clean up associated network interfaces or disks, leaving behind orphaned resources that blocked reuse of IP addresses and storage. | All dependent resources are correctly detached and deleted when a VM is deleted, preventing resource leaks. |
| Azure Local VMs <!--30651739--> | Improved validation for the IP address of the infrastructure range.  |  |
| Azure Local VMs <!--32078730--> | Improved behavior for loading PowerShell modules.  |  |
| Azure Local VMs <!--32311676--> | Added flag to enable decryption of volumes when re-attaching them.  |  |

## Known issues in this release

The following table lists the known issues in this release:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Security <!--30348397--> |  Azure Local might face an issue during normal operations (for example, Update, Repair) while using Defender for Endpoint and when the **Restrict App Execution** setting is enabled for one or more servers in the deployment.  | Disable the **Restrict App Execution** setting in the Defender portal and reboot. If the issue persists, [open a support case](/azure/azure-portal/supportability/how-to-create-azure-support-request). |
| Deployment <!--33390832--> | In rare instances, deployment fails with errors during validation that state that the mandatory Arc extensions are not yet installed. | If you face this issue, retry the deployment. |
| Deployment <!--33392176--> |  Deployment fails with PSTerminatingError. | If you face this issue, retry the deployment. |
| Update <!--33470082--> |  Solution update fails with the error: `Unable to install solution update "11.2506.1001.24" - Type 'UpdateFOD' of Role 'ComposedImageUpdate' raised an exception.` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Update/SolutionUpdate-UpdateFOD.md). |
| Deployment <!--33471589--> |  After Azure portal deployment, SConfig network settings shows the error: `Set-SCfNetworksetting : Cannot bind argument to parameter 'Value' because it is null.` | There's no known workaround in this release. |
| Update <!--33448368--> |  Cluster-Aware Updating runs might fail with the error:<br>`Type 'SBEPartnerConfirmCauDone' of Role 'SBE' raised an exception:<br>SBE_MsftCIOnlyCommon_CommonForTesting_4.2.2504.16: ErrorID: SBE-CAU-RUNNING-AFTER-DONE -- CAU run is still in progress when it should be done. See https://aka.ms/AzureLocal/SBE/CauHelp for help. Review full Get-CauRun output it identify if it is progressing or stuck. Wait for it to complete if progressing.` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/SolutionExtension/SBE-CAU-RUNNING-AFTER-DONE-Single-node-fail-SBE-Update.md).|

::: moniker-end

::: moniker range="=azloc-2505"

This article identifies critical known issues and their workarounds in Azure Local.

These release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Local instance, carefully review the information contained here.

> [!IMPORTANT]
> For information about supported update paths for this release, see [Release information](./release-information-23h2.md#about-azure-local-releases).

For more information about new features in this release, see [What's new for Azure Local](whats-new.md).

## Known issues for version 2505

For the 2505 release of Azure Local, Microsoft released two security updates: one for existing deployments and another for new deployments. The following table provides information about different deployment types, their corresponding security updates, and OS builds:

| Deployment type  | Solution version  | OS build  |
|---------|---------|---------|
| Existing deployments    | 11.2505.1001.22          | 25398.1611         |
| New deployments    | 12.2505.1001.23         | 26100.4061        |

> [!IMPORTANT]
> The new deployments of this software use the **12.2505.1001.23** build. You can also update an existing deployment from 2504 using **11.2505.1001.22**.

Release notes for this version include the issues fixed in this release, known issues in this release, and release note issues carried over from previous versions.

> [!NOTE]
> For detailed remediation for common known issues, see the [Azure Local Supportability](https://github.com/Azure/AzureStackHCI-Supportability) GitHub repository.

## Fixed issues

The following table lists the fixed issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Azure Local VMs <!--31710217-->| Timeout errors occur when creating a disk and gallery image. | Extended the timeout period to support larger disk and image size.  |
| Azure Local VMs <!--31388717--> | Mocguestagent gets stuck in a start/stop loop and can't connect to the host agent. | Improved Mocguestagent connectivity. |
| Azure Local VMs <!--31628331--> | Cannot delete a VM in the Azure portal or CLI after deleting it in Hyper-V. | If you delete the VM in Hyper-V instead of the Azure portal or CLI, delete the resource it in the Azure portal or CLI to clean it up. |
| Azure Local VMs <!--32258078--> | Unable to delete a data disk that failed to attach during VM creation.  | Fixed the attachment state of data disk to be accurate. You can now delete a data disk if it fails to attach during VM creation.  |
| Azure Local VMs <!--32475268--> | OS updates can automatically install on the third Tuesday of the month (for example, May 20, June 17, or July 15). This can cause unexpected outages or future issues because of mismatched OS versions for Azure Local.  | Removed logic that set up a scheduled CAU as part of some SBE updates.  |
| Deployment | Deployment via Azure Resource Manager (ARM) template fails with the following error during validation:<br> `Type 'DeployArb' of Role 'MocArb' raised an exception: [DeployArb:Fetching SP in CloudDeployment Scenario] Exception calling 'GetCredential' with '1' argument(s): 'Exception of type 'CloudEngine.Configurations.SecretNotFoundException' was thrown.' at at Get-CloudDeploymentServicePrincipal`. <br> The error is because of a missing SPN during deployment. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Deployment/TSG-Azure-LOCAL-HCI-missing-spn.md). |
| Solution extension <!--32616426--> | Changed the severity level for the health check that validates the plugin's presence. | |
| Azure portal <!--32131565--> | Added a fix to fetch Storage account properties during redeployment. | |
| Azure portal <!--32105125--> | Added an error message about subscription access rights during Azure Local download. | |
| Azure portal <!--32379635--> | Added a warning message if the subscription is not registered during the Azure Local download. | |
| Azure portal <!--32694573--> | Improved logic to show Azure Arc-enabled machines for selection during deployment. | |
| Azure portal <!--32756322--> | Enhanced the setting of machines' state during deployment. | |
| Azure portal <!--30482549--> | Improved error handling and data processing. | |
| Azure portal <!--31931881--> | Added a fix to disable the validation button until extension installations are complete during deployment. | |
| Deployment <!--31617326--> | Added validation to check for required permissions to change access control lists (ACL). | |
| Deployment <!--32199814--> | Added a server-side filter to the WMI call to improve performance and reduce call time. | |
| Deployment <!--31911046--> | Added fix to dispose of the PowerShell objects after use to improve performance when creating new PowerShell instances. | |
| Deployment <!--642400448--> | Fixed the time zone issue when running the **Install Azure Stack HCI** wizard and selecting a time zone. The **Install Azure Stack HCI** wizard now correctly applies the selected time zone during deployment. | |
| Security management <!--57340784--> | Fixed **Security defaults**, **Application control**, and **Data protections** pages showing as *Unknown* in the security compliance report. | |
| Add server <br> Repair server <!--32483959--> | Fixed running `Add-server` and `Repair-server` cmdlets with a customized storage adapter IP in Azure Local which resulted in the error: `Type 'ConfigureAzureStackHostStorageAdpaterIPAddressesInAddRepairNode' of Role 'HostNetwork' raised an exception: Connecting to remote server <MACHINE> failed with the following error message: Access is denied.`. | |

## Known issues in this release

The following table lists the known issues in this release:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Update <!--54889342--> |  A critical VM operational status not OK alert is shown in the Azure portal under **Update readiness** and in the **Alerts** pane after the update has completed successfully. Additionally, the alert appears when running the `Get-HealthFault` cmdlet. | No action is required on your part. This alert will resolve automatically in a few days. |
| Deployment <!--33153622-->| Updating Azure Arc extensions manually from the Azure Local Machine page via the Azure portal will result in issues during deployment. The extensions that shouldn't be updated manually are: `AzureEdgeDeviceManagement`, `AzureEdgeLifecycleManager`, and `AzureEdgeAKVBackupForWindows`. | Installing extensions manually from the Azure Local machine page is not supported. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |


## Known issues from previous releases

The following table lists the known issues from previous releases:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Add server <br> Repair server <!--32447442--> | The `Add-server` and `Repair-server` cmdlets fail with the error: <br> `Cluster Build ID matches node to add's Build ID`. | Use the OS image of the same solution version as that running on the existing cluster. To get the OS image, identify and download the image version from this [Release table](https://github.com/Azure-Samples/AzureLocal/blob/main/os-image/os-image-tracking-table.md). |
| Deployment <!--33008717--> | In this release and previous releases, registration fails with the following error when you try to register Azure Local machines with Azure Arc: <br>`AZCMAgent command failed with error: >> exitcode: 42. Additional Info: See https://aka.ms/arc/azcmerror`. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/users/kagoyal/tsg-error42/TSG/ArcRegistration/TSG%20%7C%20Arc%20registration%20failing%20with%20error%2042.md). |
| Azure Local VM management | The Mochostagent service might appear to be running but can get stuck without updating logs for over a month. You can identify this issue by checking the service logs in `C:\programdata\mochostagent\logs` to see if logs are being updated. | Run the following command to restart the mochostagent service: `restart-service mochostagent`. |
| Update | When viewing the readiness check results for an Azure Local instance via the Azure Update Manager, there might be multiple readiness checks with the same name.  |There's no known workaround in this release. Select **View details** to view specific information about the readiness check. |
| Update | There's an intermittent issue in this release when the Azure portal incorrectly reports the update status as **Failed to update** or **In progress** though the update is complete.  |[Connect to your Azure Local instance](./update/update-via-powershell-23h2.md#connect-to-your-azure-local) via a remote PowerShell session. To confirm the update status, run the following PowerShell cmdlets: <br><br> `$Update = get-solutionupdate`\| `? version -eq "<version string>"`<br><br>Replace the version string with the version you're running. For example, "10.2405.0.23". <br><br>`$Update.state`<br><br>If the update status is **Installed**, no further action is required on your part. The Azure portal refreshes the status correctly within 24 hours. <br> To refresh the status sooner, follow these steps on one of the nodes. <br>Restart the Cloud Management cluster group.<br>`Stop-ClusterGroup "Cloud Management"`<br>`Start-ClusterGroup "Cloud Management"`|
| Add server <!--26852600--> |In this release and previous releases, when adding a machine to the system, isn't possible to update the proxy bypass list string to include the new machine. Updating environment variables proxy bypass list on the hosts won't update the proxy bypass list on Azure resource bridge or AKS. |There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps.|
| Azure Local VM management |Arc Extensions on Azure Local VMs stay in "Creating" state indefinitely. | Sign in to the VM, open a command prompt, and type the following: <br> **Windows**: <br> `notepad C:\ProgramData\AzureConnectedMachineAgent\Config\agentconfig.json` <br> **Linux**: <br> `sudo vi /var/opt/azcmagent/agentconfig.json` <br>  Next, find the `resourcename` property. Delete the GUID that is appended to the end of the resource name, so this property matches the name of the VM. Then restart the VM.|
| Azure Local VM management |Restart of Azure Local VM operation completes after approximately 20 minutes though the VM itself restarts in about a minute.| There's no known workaround in this release.  |
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Azure Local VM management |Deleting a network interface on an Azure Local VM from Azure portal doesn't work in this release.| Use the Azure CLI to first remove the network interface and then delete it. For more information, see [Remove the network interface](/cli/azure/stack-hci-vm/nic#az-stack-hci-vm-nic-remove) and see [Delete the network interface](/cli/azure/stack-hci-vm/network/nic#az-stack-hci-vm-network-nic-delete).|
| Update | When updating the Azure Local instance via the Azure Update Manager, the update progress and results may not be visible in the Azure portal.| To work around this issue, on each node, add the following registry key (no value needed):<br><br>`New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\HciCloudManagementSvc\Parameters" -force`</br><br> Then on one of the nodes, restart the Cloud Management cluster group. </br><br>`Stop-ClusterGroup "Cloud Management"`</br><br>`Start-ClusterGroup "Cloud Management"`</br><br> This won't fully remediate the issue as the progress details may still not be displayed for a duration of the update process. To get the latest update details, you can [Retrieve the update progress with PowerShell](./update/update-via-powershell-23h2.md#step-6-track-update-progress). |
| Security <!-- 56969147 --> | When fixing the compliance for the minimum password length rule, even after you've changed the minimum password length on the Azure Local host to 14, you continue to see it as non-compliant in Azure policy.  | You can verify the length of the password using the `net accounts` cmdlet. In the output, find **Minimum password length** to see the value. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |
| Security <!--30348397--> |  Azure Local might face an issue during normal operations (for example, Update, Repair) while using Defender for Endpoint and when the **Restrict App Execution** setting is enabled for one or more servers in the deployment.  | Disable the **Restrict App Execution** setting in the Defender portal and reboot. If the issue persists, [open a support case](/azure/azure-portal/supportability/how-to-create-azure-support-request). |
| Deployment <!--33471589--> |  After Azure portal deployment, SConfig network settings shows the error: `Set-SCfNetworksetting : Cannot bind argument to parameter 'Value' because it is null.` | There's no known workaround in this release. |
| Update <!--33448368--> |  Cluster-Aware Updating runs might fail with the error:<br>`Type 'SBEPartnerConfirmCauDone' of Role 'SBE' raised an exception:<br>SBE_MsftCIOnlyCommon_CommonForTesting_4.2.2504.16: ErrorID: SBE-CAU-RUNNING-AFTER-DONE -- CAU run is still in progress when it should be done. See https://aka.ms/AzureLocal/SBE/CauHelp for help. Review full Get-CauRun output it identify if it is progressing or stuck. Wait for it to complete if progressing.` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/SolutionExtension/SBE-CAU-RUNNING-AFTER-DONE-Single-node-fail-SBE-Update.md).|

::: moniker-end

::: moniker range="=azloc-2505"

This article identifies critical known issues and their workarounds in Azure Local.

These release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Local instance, carefully review the information contained here.

> [!IMPORTANT]
> For information about supported update paths for this release, see [Release information](./release-information-23h2.md#about-azure-local-releases).

For more information about new features in this release, see [What's new for Azure Local](whats-new.md).

## Known issues for version 2505

For the 2505 release of Azure Local, Microsoft released two security updates: one for existing deployments and another for new deployments. The following table provides information about different deployment types, their corresponding security updates, and OS builds:

| Deployment type  | Solution version  | OS build  |
|---------|---------|---------|
| Existing deployments    | 11.2505.1001.22          | 25398.1611         |
| New deployments    | 12.2505.1001.23         | 26100.4061        |

> [!IMPORTANT]
> The new deployments of this software use the **12.2505.1001.23** build. You can also update an existing deployment from 2504 using **11.2505.1001.22**.

Release notes for this version include the issues fixed in this release, known issues in this release, and release note issues carried over from previous versions.

> [!NOTE]
> For detailed remediation for common known issues, see the [Azure Local Supportability](https://github.com/Azure/AzureStackHCI-Supportability) GitHub repository.

## Fixed issues

The following table lists the fixed issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Azure Local VMs <!--31710217-->| Timeout errors occur when creating a disk and gallery image. | Extended the timeout period to support larger disk and image size.  |
| Azure Local VMs <!--31388717--> | Mocguestagent gets stuck in a start/stop loop and can't connect to the host agent. | Improved Mocguestagent connectivity. |
| Azure Local VMs <!--31628331--> | Cannot delete a VM in the Azure portal or CLI after deleting it in Hyper-V. | If you delete the VM in Hyper-V instead of the Azure portal or CLI, delete the resource it in the Azure portal or CLI to clean it up. |
| Azure Local VMs <!--32258078--> | Unable to delete a data disk that failed to attach during VM creation.  | Fixed the attachment state of data disk to be accurate. You can now delete a data disk if it fails to attach during VM creation.  |
| Azure Local VMs <!--32475268--> | OS updates can automatically install on the third Tuesday of the month (for example, May 20, June 17, or July 15). This can cause unexpected outages or future issues because of mismatched OS versions for Azure Local.  | Removed logic that set up a scheduled CAU as part of some SBE updates.  |
| Deployment | Deployment via Azure Resource Manager (ARM) template fails with the following error during validation:<br> `Type 'DeployArb' of Role 'MocArb' raised an exception: [DeployArb:Fetching SP in CloudDeployment Scenario] Exception calling 'GetCredential' with '1' argument(s): 'Exception of type 'CloudEngine.Configurations.SecretNotFoundException' was thrown.' at at Get-CloudDeploymentServicePrincipal`. <br> The error is because of a missing SPN during deployment. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Deployment/TSG-Azure-LOCAL-HCI-missing-spn.md). |
| Solution extension <!--32616426--> | Changed the severity level for the health check that validates the plugin's presence. | |
| Azure portal <!--32131565--> | Added a fix to fetch Storage account properties during redeployment. | |
| Azure portal <!--32105125--> | Added an error message about subscription access rights during Azure Local download. | |
| Azure portal <!--32379635--> | Added a warning message if the subscription is not registered during the Azure Local download. | |
| Azure portal <!--32694573--> | Improved logic to show Azure Arc-enabled machines for selection during deployment. | |
| Azure portal <!--32756322--> | Enhanced the setting of machines' state during deployment. | |
| Azure portal <!--30482549--> | Improved error handling and data processing. | |
| Azure portal <!--31931881--> | Added a fix to disable the validation button until extension installations are complete during deployment. | |
| Deployment <!--31617326--> | Added validation to check for required permissions to change access control lists (ACL). | |
| Deployment <!--32199814--> | Added a server-side filter to the WMI call to improve performance and reduce call time. | |
| Deployment <!--31911046--> | Added fix to dispose of the PowerShell objects after use to improve performance when creating new PowerShell instances. | |
| Deployment <!--642400448--> | Fixed the time zone issue when running the **Install Azure Stack HCI** wizard and selecting a time zone. The **Install Azure Stack HCI** wizard now correctly applies the selected time zone during deployment. | |
| Security management <!--57340784--> | Fixed **Security defaults**, **Application control**, and **Data protections** pages showing as *Unknown* in the security compliance report. | |
| Add server <br> Repair server <!--32483959--> | Fixed running `Add-server` and `Repair-server` cmdlets with a customized storage adapter IP in Azure Local which resulted in the error: `Type 'ConfigureAzureStackHostStorageAdpaterIPAddressesInAddRepairNode' of Role 'HostNetwork' raised an exception: Connecting to remote server <MACHINE> failed with the following error message: Access is denied.`. | |

## Known issues in this release

The following table lists the known issues in this release:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Update <!--54889342--> |  A critical VM operational status not OK alert is shown in the Azure portal under **Update readiness** and in the **Alerts** pane after the update has completed successfully. Additionally, the alert appears when running the `Get-HealthFault` cmdlet. | No action is required on your part. This alert will resolve automatically in a few days. |
| Deployment <!--33153622-->| Updating Azure Arc extensions manually from the Azure Local Machine page via the Azure portal will result in issues during deployment. The extensions that shouldn't be updated manually are: `AzureEdgeDeviceManagement`, `AzureEdgeLifecycleManager`, and `AzureEdgeAKVBackupForWindows`. | Installing extensions manually from the Azure Local machine page is not supported. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |


## Known issues from previous releases

The following table lists the known issues from previous releases:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Add server <br> Repair server <!--32447442--> | The `Add-server` and `Repair-server` cmdlets fail with the error: <br> `Cluster Build ID matches node to add's Build ID`. | Use the OS image of the same solution version as that running on the existing cluster. To get the OS image, identify and download the image version from this [Release table](https://github.com/Azure-Samples/AzureLocal/blob/main/os-image/os-image-tracking-table.md). |
| Deployment <!--33008717--> | In this release and previous releases, registration fails with the following error when you try to register Azure Local machines with Azure Arc: <br>`AZCMAgent command failed with error: >> exitcode: 42. Additional Info: See https://aka.ms/arc/azcmerror`. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/users/kagoyal/tsg-error42/TSG/ArcRegistration/TSG%20%7C%20Arc%20registration%20failing%20with%20error%2042.md). |
| Azure Local VM management | The Mochostagent service might appear to be running but can get stuck without updating logs for over a month. You can identify this issue by checking the service logs in `C:\programdata\mochostagent\logs` to see if logs are being updated. | Run the following command to restart the mochostagent service: `restart-service mochostagent`. |
| Update | When viewing the readiness check results for an Azure Local instance via the Azure Update Manager, there might be multiple readiness checks with the same name.  |There's no known workaround in this release. Select **View details** to view specific information about the readiness check. |
| Update | There's an intermittent issue in this release when the Azure portal incorrectly reports the update status as **Failed to update** or **In progress** though the update is complete.  |[Connect to your Azure Local instance](./update/update-via-powershell-23h2.md#connect-to-your-azure-local) via a remote PowerShell session. To confirm the update status, run the following PowerShell cmdlets: <br><br> `$Update = get-solutionupdate`\| `? version -eq "<version string>"`<br><br>Replace the version string with the version you're running. For example, "10.2405.0.23". <br><br>`$Update.state`<br><br>If the update status is **Installed**, no further action is required on your part. The Azure portal refreshes the status correctly within 24 hours. <br> To refresh the status sooner, follow these steps on one of the nodes. <br>Restart the Cloud Management cluster group.<br>`Stop-ClusterGroup "Cloud Management"`<br>`Start-ClusterGroup "Cloud Management"`|
| Add server <!--26852600--> |In this release and previous releases, when adding a machine to the system, isn't possible to update the proxy bypass list string to include the new machine. Updating environment variables proxy bypass list on the hosts won't update the proxy bypass list on Azure resource bridge or AKS. |There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps.|
| Azure Local VM management |Arc Extensions on Azure Local VMs stay in "Creating" state indefinitely. | Sign in to the VM, open a command prompt, and type the following: <br> **Windows**: <br> `notepad C:\ProgramData\AzureConnectedMachineAgent\Config\agentconfig.json` <br> **Linux**: <br> `sudo vi /var/opt/azcmagent/agentconfig.json` <br>  Next, find the `resourcename` property. Delete the GUID that is appended to the end of the resource name, so this property matches the name of the VM. Then restart the VM.|
| Azure Local VM management |Restart of Azure Local VM operation completes after approximately 20 minutes though the VM itself restarts in about a minute.| There's no known workaround in this release.  |
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Azure Local VM management |Deleting a network interface on an Azure Local VM from Azure portal doesn't work in this release.| Use the Azure CLI to first remove the network interface and then delete it. For more information, see [Remove the network interface](/cli/azure/stack-hci-vm/nic#az-stack-hci-vm-nic-remove) and see [Delete the network interface](/cli/azure/stack-hci-vm/network/nic#az-stack-hci-vm-network-nic-delete).|
| Update | When updating the Azure Local instance via the Azure Update Manager, the update progress and results may not be visible in the Azure portal.| To work around this issue, on each node, add the following registry key (no value needed):<br><br>`New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\HciCloudManagementSvc\Parameters" -force`</br><br> Then on one of the nodes, restart the Cloud Management cluster group. </br><br>`Stop-ClusterGroup "Cloud Management"`</br><br>`Start-ClusterGroup "Cloud Management"`</br><br> This won't fully remediate the issue as the progress details may still not be displayed for a duration of the update process. To get the latest update details, you can [Retrieve the update progress with PowerShell](./update/update-via-powershell-23h2.md#step-6-track-update-progress). |
| Security <!-- 56969147 --> | When fixing the compliance for the minimum password length rule, even after you've changed the minimum password length on the Azure Local host to 14, you continue to see it as non-compliant in Azure policy.  | You can verify the length of the password using the `net accounts` cmdlet. In the output, find **Minimum password length** to see the value. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |
| Security <!--30348397--> |  Azure Local might face an issue during normal operations (for example, Update, Repair) while using Defender for Endpoint and when the **Restrict App Execution** setting is enabled for one or more servers in the deployment.  | Disable the **Restrict App Execution** setting in the Defender portal and reboot. If the issue persists, [open a support case](/azure/azure-portal/supportability/how-to-create-azure-support-request). |
| Deployment <!--33471589--> |  After Azure portal deployment, SConfig network settings shows the error: `Set-SCfNetworksetting : Cannot bind argument to parameter 'Value' because it is null.` | There's no known workaround in this release. |
| Update <!--33448368--> |  Cluster-Aware Updating runs might fail with the error:<br>`Type 'SBEPartnerConfirmCauDone' of Role 'SBE' raised an exception:<br>SBE_MsftCIOnlyCommon_CommonForTesting_4.2.2504.16: ErrorID: SBE-CAU-RUNNING-AFTER-DONE -- CAU run is still in progress when it should be done. See https://aka.ms/AzureLocal/SBE/CauHelp for help. Review full Get-CauRun output it identify if it is progressing or stuck. Wait for it to complete if progressing.` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/SolutionExtension/SBE-CAU-RUNNING-AFTER-DONE-Single-node-fail-SBE-Update.md).|

::: moniker-end

::: moniker range="=azloc-2505"

This article identifies critical known issues and their workarounds in Azure Local.

These release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Local instance, carefully review the information contained here.

> [!IMPORTANT]
> For information about supported update paths for this release, see [Release information](./release-information-23h2.md#about-azure-local-releases).

For more information about new features in this release, see [What's new for Azure Local](whats-new.md).

## Known issues for version 2505

For the 2505 release of Azure Local, Microsoft released two security updates: one for existing deployments and another for new deployments. The following table provides information about different deployment types, their corresponding security updates, and OS builds:

| Deployment type  | Solution version  | OS build  |
|---------|---------|---------|
| Existing deployments    | 11.2505.1001.22          | 25398.1611         |
| New deployments    | 12.2505.1001.23         | 26100.4061        |

> [!IMPORTANT]
> The new deployments of this software use the **12.2505.1001.23** build. You can also update an existing deployment from 2504 using **11.2505.1001.22**.

Release notes for this version include the issues fixed in this release, known issues in this release, and release note issues carried over from previous versions.

> [!NOTE]
> For detailed remediation for common known issues, see the [Azure Local Supportability](https://github.com/Azure/AzureStackHCI-Supportability) GitHub repository.

## Fixed issues

The following table lists the fixed issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Azure Local VMs <!--31710217-->| Timeout errors occur when creating a disk and gallery image. | Extended the timeout period to support larger disk and image size.  |
| Azure Local VMs <!--31388717--> | Mocguestagent gets stuck in a start/stop loop and can't connect to the host agent. | Improved Mocguestagent connectivity. |
| Azure Local VMs <!--31628331--> | Cannot delete a VM in the Azure portal or CLI after deleting it in Hyper-V. | If you delete the VM in Hyper-V instead of the Azure portal or CLI, delete the resource it in the Azure portal or CLI to clean it up. |
| Azure Local VMs <!--32258078--> | Unable to delete a data disk that failed to attach during VM creation.  | Fixed the attachment state of data disk to be accurate. You can now delete a data disk if it fails to attach during VM creation.  |
| Azure Local VMs <!--32475268--> | OS updates can automatically install on the third Tuesday of the month (for example, May 20, June 17, or July 15). This can cause unexpected outages or future issues because of mismatched OS versions for Azure Local.  | Removed logic that set up a scheduled CAU as part of some SBE updates.  |
| Deployment | Deployment via Azure Resource Manager (ARM) template fails with the following error during validation:<br> `Type 'DeployArb' of Role 'MocArb' raised an exception: [DeployArb:Fetching SP in CloudDeployment Scenario] Exception calling 'GetCredential' with '1' argument(s): 'Exception of type 'CloudEngine.Configurations.SecretNotFoundException' was thrown.' at at Get-CloudDeploymentServicePrincipal`. <br> The error is because of a missing SPN during deployment. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Deployment/TSG-Azure-LOCAL-HCI-missing-spn.md). |
| Solution extension <!--32616426--> | Changed the severity level for the health check that validates the plugin's presence. | |
| Azure portal <!--32131565--> | Added a fix to fetch Storage account properties during redeployment. | |
| Azure portal <!--32105125--> | Added an error message about subscription access rights during Azure Local download. | |
| Azure portal <!--32379635--> | Added a warning message if the subscription is not registered during the Azure Local download. | |
| Azure portal <!--32694573--> | Improved logic to show Azure Arc-enabled machines for selection during deployment. | |
| Azure portal <!--32756322--> | Enhanced the setting of machines' state during deployment. | |
| Azure portal <!--30482549--> | Improved error handling and data processing. | |
| Azure portal <!--31931881--> | Added a fix to disable the validation button until extension installations are complete during deployment. | |
| Deployment <!--31617326--> | Added validation to check for required permissions to change access control lists (ACL). | |
| Deployment <!--32199814--> | Added a server-side filter to the WMI call to improve performance and reduce call time. | |
| Deployment <!--31911046--> | Added fix to dispose of the PowerShell objects after use to improve performance when creating new PowerShell instances. | |
| Deployment <!--642400448--> | Fixed the time zone issue when running the **Install Azure Stack HCI** wizard and selecting a time zone. The **Install Azure Stack HCI** wizard now correctly applies the selected time zone during deployment. | |
| Security management <!--57340784--> | Fixed **Security defaults**, **Application control**, and **Data protections** pages showing as *Unknown* in the security compliance report. | |
| Add server <br> Repair server <!--32483959--> | Fixed running `Add-server` and `Repair-server` cmdlets with a customized storage adapter IP in Azure Local which resulted in the error: `Type 'ConfigureAzureStackHostStorageAdpaterIPAddressesInAddRepairNode' of Role 'HostNetwork' raised an exception: Connecting to remote server <MACHINE> failed with the following error message: Access is denied.`. | |

## Known issues in this release

The following table lists the known issues in this release:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Update <!--54889342--> |  A critical VM operational status not OK alert is shown in the Azure portal under **Update readiness** and in the **Alerts** pane after the update has completed successfully. Additionally, the alert appears when running the `Get-HealthFault` cmdlet. | No action is required on your part. This alert will resolve automatically in a few days. |
| Deployment <!--33153622-->| Updating Azure Arc extensions manually from the Azure Local Machine page via the Azure portal will result in issues during deployment. The extensions that shouldn't be updated manually are: `AzureEdgeDeviceManagement`, `AzureEdgeLifecycleManager`, and `AzureEdgeAKVBackupForWindows`. | Installing extensions manually from the Azure Local machine page is not supported. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |


## Known issues from previous releases

The following table lists the known issues from previous releases:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Add server <br> Repair server <!--32447442--> | The `Add-server` and `Repair-server` cmdlets fail with the error: <br> `Cluster Build ID matches node to add's Build ID`. | Use the OS image of the same solution version as that running on the existing cluster. To get the OS image, identify and download the image version from this [Release table](https://github.com/Azure-Samples/AzureLocal/blob/main/os-image/os-image-tracking-table.md). |
| Deployment <!--33008717--> | In this release and previous releases, registration fails with the following error when you try to register Azure Local machines with Azure Arc: <br>`AZCMAgent command failed with error: >> exitcode: 42. Additional Info: See https://aka.ms/arc/azcmerror`. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/users/kagoyal/tsg-error42/TSG/ArcRegistration/TSG%20%7C%20Arc%20registration%20failing%20with%20error%2042.md). |
| Azure Local VM management | The Mochostagent service might appear to be running but can get stuck without updating logs for over a month. You can identify this issue by checking the service logs in `C:\programdata\mochostagent\logs` to see if logs are being updated. | Run the following command to restart the mochostagent service: `restart-service mochostagent`. |
| Update | When viewing the readiness check results for an Azure Local instance via the Azure Update Manager, there might be multiple readiness checks with the same name.  |There's no known workaround in this release. Select **View details** to view specific information about the readiness check. |
| Update | There's an intermittent issue in this release when the Azure portal incorrectly reports the update status as **Failed to update** or **In progress** though the update is complete.  |[Connect to your Azure Local instance](./update/update-via-powershell-23h2.md#connect-to-your-azure-local) via a remote PowerShell session. To confirm the update status, run the following PowerShell cmdlets: <br><br> `$Update = get-solutionupdate`\| `? version -eq "<version string>"`<br><br>Replace the version string with the version you're running. For example, "10.2405.0.23". <br><br>`$Update.state`<br><br>If the update status is **Installed**, no further action is required on your part. The Azure portal refreshes the status correctly within 24 hours. <br> To refresh the status sooner, follow these steps on one of the nodes. <br>Restart the Cloud Management cluster group.<br>`Stop-ClusterGroup "Cloud Management"`<br>`Start-ClusterGroup "Cloud Management"`|
| Add server <!--26852600--> |In this release and previous releases, when adding a machine to the system, isn't possible to update the proxy bypass list string to include the new machine. Updating environment variables proxy bypass list on the hosts won't update the proxy bypass list on Azure resource bridge or AKS. |There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps.|
| Azure Local VM management |Arc Extensions on Azure Local VMs stay in "Creating" state indefinitely. | Sign in to the VM, open a command prompt, and type the following: <br> **Windows**: <br> `notepad C:\ProgramData\AzureConnectedMachineAgent\Config\agentconfig.json` <br> **Linux**: <br> `sudo vi /var/opt/azcmagent/agentconfig.json` <br>  Next, find the `resourcename` property. Delete the GUID that is appended to the end of the resource name, so this property matches the name of the VM. Then restart the VM.|
| Azure Local VM management |Restart of Azure Local VM operation completes after approximately 20 minutes though the VM itself restarts in about a minute.| There's no known workaround in this release.  |
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Azure Local VM management |Deleting a network interface on an Azure Local VM from Azure portal doesn't work in this release.| Use the Azure CLI to first remove the network interface and then delete it. For more information, see [Remove the network interface](/cli/azure/stack-hci-vm/nic#az-stack-hci-vm-nic-remove) and see [Delete the network interface](/cli/azure/stack-hci-vm/network/nic#az-stack-hci-vm-network-nic-delete).|
| Update | When updating the Azure Local instance via the Azure Update Manager, the update progress and results may not be visible in the Azure portal.| To work around this issue, on each node, add the following registry key (no value needed):<br><br>`New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\HciCloudManagementSvc\Parameters" -force`</br><br> Then on one of the nodes, restart the Cloud Management cluster group. </br><br>`Stop-ClusterGroup "Cloud Management"`</br><br>`Start-ClusterGroup "Cloud Management"`</br><br> This won't fully remediate the issue as the progress details may still not be displayed for a duration of the update process. To get the latest update details, you can [Retrieve the update progress with PowerShell](./update/update-via-powershell-23h2.md#step-6-track-update-progress). |
| Security <!-- 56969147 --> | When fixing the compliance for the minimum password length rule, even after you've changed the minimum password length on the Azure Local host to 14, you continue to see it as non-compliant in Azure policy.  | You can verify the length of the password using the `net accounts` cmdlet. In the output, find **Minimum password length** to see the value. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |
| Security <!--30348397--> |  Azure Local might face an issue during normal operations (for example, Update, Repair) while using Defender for Endpoint and when the **Restrict App Execution** setting is enabled for one or more servers in the deployment.  | Disable the **Restrict App Execution** setting in the Defender portal and reboot. If the issue persists, [open a support case](/azure/azure-portal/supportability/how-to-create-azure-support-request). |
| Deployment <!--33471589--> |  After Azure portal deployment, SConfig network settings shows the error: `Set-SCfNetworksetting : Cannot bind argument to parameter 'Value' because it is null.` | There's no known workaround in this release. |
| Update <!--33448368--> |  Cluster-Aware Updating runs might fail with the error:<br>`Type 'SBEPartnerConfirmCauDone' of Role 'SBE' raised an exception:<br>SBE_MsftCIOnlyCommon_CommonForTesting_4.2.2504.16: ErrorID: SBE-CAU-RUNNING-AFTER-DONE -- CAU run is still in progress when it should be done. See https://aka.ms/AzureLocal/SBE/CauHelp for help. Review full Get-CauRun output it identify if it is progressing or stuck. Wait for it to complete if progressing.` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/SolutionExtension/SBE-CAU-RUNNING-AFTER-DONE-Single-node-fail-SBE-Update.md).|

::: moniker-end

::: moniker range="=azloc-2505"

This article identifies critical known issues and their workarounds in Azure Local.

These release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Local instance, carefully review the information contained here.

> [!IMPORTANT]
> For information about supported update paths for this release, see [Release information](./release-information-23h2.md#about-azure-local-releases).

For more information about new features in this release, see [What's new for Azure Local](whats-new.md).

## Known issues for version 2505

For the 2505 release of Azure Local, Microsoft released two security updates: one for existing deployments and another for new deployments. The following table provides information about different deployment types, their corresponding security updates, and OS builds:

| Deployment type  | Solution version  | OS build  |
|---------|---------|---------|
| Existing deployments    | 11.2505.1001.22          | 25398.1611         |
| New deployments    | 12.2505.1001.23         | 26100.4061        |

> [!IMPORTANT]
> The new deployments of this software use the **12.2505.1001.23** build. You can also update an existing deployment from 2504 using **11.2505.1001.22**.

Release notes for this version include the issues fixed in this release, known issues in this release, and release note issues carried over from previous versions.

> [!NOTE]
> For detailed remediation for common known issues, see the [Azure Local Supportability](https://github.com/Azure/AzureStackHCI-Supportability) GitHub repository.

## Fixed issues

The following table lists the fixed issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Azure Local VMs <!--31710217-->| Timeout errors occur when creating a disk and gallery image. | Extended the timeout period to support larger disk and image size.  |
| Azure Local VMs <!--31388717--> | Mocguestagent gets stuck in a start/stop loop and can't connect to the host agent. | Improved Mocguestagent connectivity. |
| Azure Local VMs <!--31628331--> | Cannot delete a VM in the Azure portal or CLI after deleting it in Hyper-V. | If you delete the VM in Hyper-V instead of the Azure portal or CLI, delete the resource it in the Azure portal or CLI to clean it up. |
| Azure Local VMs <!--32258078--> | Unable to delete a data disk that failed to attach during VM creation.  | Fixed the attachment state of data disk to be accurate. You can now delete a data disk if it fails to attach during VM creation.  |
| Azure Local VMs <!--32475268--> | OS updates can automatically install on the third Tuesday of the month (for example, May 20, June 17, or July 15). This can cause unexpected outages or future issues because of mismatched OS versions for Azure Local.  | Removed logic that set up a scheduled CAU as part of some SBE updates.  |
| Deployment | Deployment via Azure Resource Manager (ARM) template fails with the following error during validation:<br> `Type 'DeployArb' of Role 'MocArb' raised an exception: [DeployArb:Fetching SP in CloudDeployment Scenario] Exception calling 'GetCredential' with '1' argument(s): 'Exception of type 'CloudEngine.Configurations.SecretNotFoundException' was thrown.' at at Get-CloudDeploymentServicePrincipal`. <br> The error is because of a missing SPN during deployment. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Deployment/TSG-Azure-LOCAL-HCI-missing-spn.md). |
| Solution extension <!--32616426--> | Changed the severity level for the health check that validates the plugin's presence. | |
| Azure portal <!--32131565--> | Added a fix to fetch Storage account properties during redeployment. | |
| Azure portal <!--32105125--> | Added an error message about subscription access rights during Azure Local download. | |
| Azure portal <!--32379635--> | Added a warning message if the subscription is not registered during the Azure Local download. | |
| Azure portal <!--32694573--> | Improved logic to show Azure Arc-enabled machines for selection during deployment. | |
| Azure portal <!--32756322--> | Enhanced the setting of machines' state during deployment. | |
| Azure portal <!--30482549--> | Improved error handling and data processing. | |
| Azure portal <!--31931881--> | Added a fix to disable the validation button until extension installations are complete during deployment. | |
| Deployment <!--31617326--> | Added validation to check for required permissions to change access control lists (ACL). | |
| Deployment <!--32199814--> | Added a server-side filter to the WMI call to improve performance and reduce call time. | |
| Deployment <!--31911046--> | Added fix to dispose of the PowerShell objects after use to improve performance when creating new PowerShell instances. | |
| Deployment <!--642400448--> | Fixed the time zone issue when running the **Install Azure Stack HCI** wizard and selecting a time zone. The **Install Azure Stack HCI** wizard now correctly applies the selected time zone during deployment. | |
| Security management <!--57340784--> | Fixed **Security defaults**, **Application control**, and **Data protections** pages showing as *Unknown* in the security compliance report. | |
| Add server <br> Repair server <!--32483959--> | Fixed running `Add-server` and `Repair-server` cmdlets with a customized storage adapter IP in Azure Local which resulted in the error: `Type 'ConfigureAzureStackHostStorageAdpaterIPAddressesInAddRepairNode' of Role 'HostNetwork' raised an exception: Connecting to remote server <MACHINE> failed with the following error message: Access is denied.`. | |

## Known issues in this release

The following table lists the known issues in this release:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Update <!--54889342--> |  A critical VM operational status not OK alert is shown in the Azure portal under **Update readiness** and in the **Alerts** pane after the update has completed successfully. Additionally, the alert appears when running the `Get-HealthFault` cmdlet. | No action is required on your part. This alert will resolve automatically in a few days. |
| Deployment <!--33153622-->| Updating Azure Arc extensions manually from the Azure Local Machine page via the Azure portal will result in issues during deployment. The extensions that shouldn't be updated manually are: `AzureEdgeDeviceManagement`, `AzureEdgeLifecycleManager`, and `AzureEdgeAKVBackupForWindows`. | Installing extensions manually from the Azure Local machine page is not supported. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |


## Known issues from previous releases

The following table lists the known issues from previous releases:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Add server <br> Repair server <!--32447442--> | The `Add-server` and `Repair-server` cmdlets fail with the error: <br> `Cluster Build ID matches node to add's Build ID`. | Use the OS image of the same solution version as that running on the existing cluster. To get the OS image, identify and download the image version from this [Release table](https://github.com/Azure-Samples/AzureLocal/blob/main/os-image/os-image-tracking-table.md). |
| Deployment <!--33008717--> | In this release and previous releases, registration fails with the following error when you try to register Azure Local machines with Azure Arc: <br>`AZCMAgent command failed with error: >> exitcode: 42. Additional Info: See https://aka.ms/arc/azcmerror`. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/users/kagoyal/tsg-error42/TSG/ArcRegistration/TSG%20%7C%20Arc%20registration%20failing%20with%20error%2042.md). |
| Azure Local VM management | The Mochostagent service might appear to be running but can get stuck without updating logs for over a month. You can identify this issue by checking the service logs in `C:\programdata\mochostagent\logs` to see if logs are being updated. | Run the following command to restart the mochostagent service: `restart-service mochostagent`. |
| Update | When viewing the readiness check results for an Azure Local instance via the Azure Update Manager, there might be multiple readiness checks with the same name.  |There's no known workaround in this release. Select **View details** to view specific information about the readiness check. |
| Update | There's an intermittent issue in this release when the Azure portal incorrectly reports the update status as **Failed to update** or **In progress** though the update is complete.  |[Connect to your Azure Local instance](./update/update-via-powershell-23h2.md#connect-to-your-azure-local) via a remote PowerShell session. To confirm the update status, run the following PowerShell cmdlets: <br><br> `$Update = get-solutionupdate`\| `? version -eq "<version string>"`<br><br>Replace the version string with the version you're running. For example, "10.2405.0.23". <br><br>`$Update.state`<br><br>If the update status is **Installed**, no further action is required on your part. The Azure portal refreshes the status correctly within 24 hours. <br> To refresh the status sooner, follow these steps on one of the nodes. <br>Restart the Cloud Management cluster group.<br>`Stop-ClusterGroup "Cloud Management"`<br>`Start-ClusterGroup "Cloud Management"`|
| Add server <!--26852600--> |In this release and previous releases, when adding a machine to the system, isn't possible to update the proxy bypass list string to include the new machine. Updating environment variables proxy bypass list on the hosts won't update the proxy bypass list on Azure resource bridge or AKS. |There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps.|
| Azure Local VM management |Arc Extensions on Azure Local VMs stay in "Creating" state indefinitely. | Sign in to the VM, open a command prompt, and type the following: <br> **Windows**: <br> `notepad C:\ProgramData\AzureConnectedMachineAgent\Config\agentconfig.json` <br> **Linux**: <br> `sudo vi /var/opt/azcmagent/agentconfig.json` <br>  Next, find the `resourcename` property. Delete the GUID that is appended to the end of the resource name, so this property matches the name of the VM. Then restart the VM.|
| Azure Local VM management |Restart of Azure Local VM operation completes after approximately 20 minutes though the VM itself restarts in about a minute.| There's no known workaround in this release.  |
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Azure Local VM management |Deleting a network interface on an Azure Local VM from Azure portal doesn't work in this release.| Use the Azure CLI to first remove the network interface and then delete it. For more information, see [Remove the network interface](/cli/azure/stack-hci-vm/nic#az-stack-hci-vm-nic-remove) and see [Delete the network interface](/cli/azure/stack-hci-vm/network/nic#az-stack-hci-vm-network-nic-delete).|
| Update | When updating the Azure Local instance via the Azure Update Manager, the update progress and results may not be visible in the Azure portal.| To work around this issue, on each node, add the following registry key (no value needed):<br><br>`New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\HciCloudManagementSvc\Parameters" -force`</br><br> Then on one of the nodes, restart the Cloud Management cluster group. </br><br>`Stop-ClusterGroup "Cloud Management"`</br><br>`Start-ClusterGroup "Cloud Management"`</br><br> This won't fully remediate the issue as the progress details may still not be displayed for a duration of the update process. To get the latest update details, you can [Retrieve the update progress with PowerShell](./update/update-via-powershell-23h2.md#step-6-track-update-progress). |
| Security <!-- 56969147 --> | When fixing the compliance for the minimum password length rule, even after you've changed the minimum password length on the Azure Local host to 14, you continue to see it as non-compliant in Azure policy.  | You can verify the length of the password using the `net accounts` cmdlet. In the output, find **Minimum password length** to see the value. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |
| Security <!--30348397--> |  Azure Local might face an issue during normal operations (for example, Update, Repair) while using Defender for Endpoint and when the **Restrict App Execution** setting is enabled for one or more servers in the deployment.  | Disable the **Restrict App Execution** setting in the Defender portal and reboot. If the issue persists, [open a support case](/azure/azure-portal/supportability/how-to-create-azure-support-request). |
| Deployment <!--33471589--> |  After Azure portal deployment, SConfig network settings shows the error: `Set-SCfNetworksetting : Cannot bind argument to parameter 'Value' because it is null.` | There's no known workaround in this release. |
| Update <!--33448368--> |  Cluster-Aware Updating runs might fail with the error:<br>`Type 'SBEPartnerConfirmCauDone' of Role 'SBE' raised an exception:<br>SBE_MsftCIOnlyCommon_CommonForTesting_4.2.2504.16: ErrorID: SBE-CAU-RUNNING-AFTER-DONE -- CAU run is still in progress when it should be done. See https://aka.ms/AzureLocal/SBE/CauHelp for help. Review full Get-CauRun output it identify if it is progressing or stuck. Wait for it to complete if progressing.` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/SolutionExtension/SBE-CAU-RUNNING-AFTER-DONE-Single-node-fail-SBE-Update.md).|

::: moniker-end

::: moniker range="=azloc-2505"

This article identifies critical known issues and their workarounds in Azure Local.

These release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Local instance, carefully review the information contained here.

> [!IMPORTANT]
> For information about supported update paths for this release, see [Release information](./release-information-23h2.md#about-azure-local-releases).

For more information about new features in this release, see [What's new for Azure Local](whats-new.md).

## Known issues for version 2505

For the 2505 release of Azure Local, Microsoft released two security updates: one for existing deployments and another for new deployments. The following table provides information about different deployment types, their corresponding security updates, and OS builds:

| Deployment type  | Solution version  | OS build  |
|---------|---------|---------|
| Existing deployments    | 11.2505.1001.22          | 25398.1611         |
| New deployments    | 12.2505.1001.23         | 26100.4061        |

> [!IMPORTANT]
> The new deployments of this software use the **12.2505.1001.23** build. You can also update an existing deployment from 2504 using **11.2505.1001.22**.

Release notes for this version include the issues fixed in this release, known issues in this release, and release note issues carried over from previous versions.

> [!NOTE]
> For detailed remediation for common known issues, see the [Azure Local Supportability](https://github.com/Azure/AzureStackHCI-Supportability) GitHub repository.

## Fixed issues

The following table lists the fixed issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Azure Local VMs <!--31710217-->| Timeout errors occur when creating a disk and gallery image. | Extended the timeout period to support larger disk and image size.  |
| Azure Local VMs <!--31388717--> | Mocguestagent gets stuck in a start/stop loop and can't connect to the host agent. | Improved Mocguestagent connectivity. |
| Azure Local VMs <!--31628331--> | Cannot delete a VM in the Azure portal or CLI after deleting it in Hyper-V. | If you delete the VM in Hyper-V instead of the Azure portal or CLI, delete the resource it in the Azure portal or CLI to clean it up. |
| Azure Local VMs <!--32258078--> | Unable to delete a data disk that failed to attach during VM creation.  | Fixed the attachment state of data disk to be accurate. You can now delete a data disk if it fails to attach during VM creation.  |
| Azure Local VMs <!--32475268--> | OS updates can automatically install on the third Tuesday of the month (for example, May 20, June 17, or July 15). This can cause unexpected outages or future issues because of mismatched OS versions for Azure Local.  | Removed logic that set up a scheduled CAU as part of some SBE updates.  |
| Deployment | Deployment via Azure Resource Manager (ARM) template fails with the following error during validation:<br> `Type 'DeployArb' of Role 'MocArb' raised an exception: [DeployArb:Fetching SP in CloudDeployment Scenario] Exception calling 'GetCredential' with '1' argument(s): 'Exception of type 'CloudEngine.Configurations.SecretNotFoundException' was thrown.' at at Get-CloudDeploymentServicePrincipal`. <br> The error is because of a missing SPN during deployment. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Deployment/TSG-Azure-LOCAL-HCI-missing-spn.md). |
| Solution extension <!--32616426--> | Changed the severity level for the health check that validates the plugin's presence. | |
| Azure portal <!--32131565--> | Added a fix to fetch Storage account properties during redeployment. | |
| Azure portal <!--32105125--> | Added an error message about subscription access rights during Azure Local download. | |
| Azure portal <!--32379635--> | Added a warning message if the subscription is not registered during the Azure Local download. | |
| Azure portal <!--32694573--> | Improved logic to show Azure Arc-enabled machines for selection during deployment. | |
| Azure portal <!--32756322--> | Enhanced the setting of machines' state during deployment. | |
| Azure portal <!--30482549--> | Improved error handling and data processing. | |
| Azure portal <!--31931881--> | Added a fix to disable the validation button until extension installations are complete during deployment. | |
| Deployment <!--31617326--> | Added validation to check for required permissions to change access control lists (ACL). | |
| Deployment <!--32199814--> | Added a server-side filter to the WMI call to improve performance and reduce call time. | |
| Deployment <!--31911046--> | Added fix to dispose of the PowerShell objects after use to improve performance when creating new PowerShell instances. | |
| Deployment <!--642400448--> | Fixed the time zone issue when running the **Install Azure Stack HCI** wizard and selecting a time zone. The **Install Azure Stack HCI** wizard now correctly applies the selected time zone during deployment. | |
| Security management <!--57340784--> | Fixed **Security defaults**, **Application control**, and **Data protections** pages showing as *Unknown* in the security compliance report. | |
| Add server <br> Repair server <!--32483959--> | Fixed running `Add-server` and `Repair-server` cmdlets with a customized storage adapter IP in Azure Local which resulted in the error: `Type 'ConfigureAzureStackHostStorageAdpaterIPAddressesInAddRepairNode' of Role 'HostNetwork' raised an exception: Connecting to remote server <MACHINE> failed with the following error message: Access is denied.`. | |

## Known issues in this release

The following table lists the known issues in this release:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Update <!--54889342--> |  A critical VM operational status not OK alert is shown in the Azure portal under **Update readiness** and in the **Alerts** pane after the update has completed successfully. Additionally, the alert appears when running the `Get-HealthFault` cmdlet. | No action is required on your part. This alert will resolve automatically in a few days. |
| Deployment <!--33153622-->| Updating Azure Arc extensions manually from the Azure Local Machine page via the Azure portal will result in issues during deployment. The extensions that shouldn't be updated manually are: `AzureEdgeDeviceManagement`, `AzureEdgeLifecycleManager`, and `AzureEdgeAKVBackupForWindows`. | Installing extensions manually from the Azure Local machine page is not supported. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |


## Known issues from previous releases

The following table lists the known issues from previous releases:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Add server <br> Repair server <!--32447442--> | The `Add-server` and `Repair-server` cmdlets fail with the error: <br> `Cluster Build ID matches node to add's Build ID`. | Use the OS image of the same solution version as that running on the existing cluster. To get the OS image, identify and download the image version from this [Release table](https://github.com/Azure-Samples/AzureLocal/blob/main/os-image/os-image-tracking-table.md). |
| Deployment <!--33008717--> | In this release and previous releases, registration fails with the following error when you try to register Azure Local machines with Azure Arc: <br>`AZCMAgent command failed with error: >> exitcode: 42. Additional Info: See https://aka.ms/arc/azcmerror`. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/users/kagoyal/tsg-error42/TSG/ArcRegistration/TSG%20%7C%20Arc%20registration%20failing%20with%20error%2042.md). |
| Azure Local VM management | The Mochostagent service might appear to be running but can get stuck without updating logs for over a month. You can identify this issue by checking the service logs in `C:\programdata\mochostagent\logs` to see if logs are being updated. | Run the following command to restart the mochostagent service: `restart-service mochostagent`. |
| Update | When viewing the readiness check results for an Azure Local instance via the Azure Update Manager, there might be multiple readiness checks with the same name.  |There's no known workaround in this release. Select **View details** to view specific information about the readiness check. |
| Update | There's an intermittent issue in this release when the Azure portal incorrectly reports the update status as **Failed to update** or **In progress** though the update is complete.  |[Connect to your Azure Local instance](./update/update-via-powershell-23h2.md#connect-to-your-azure-local) via a remote PowerShell session. To confirm the update status, run the following PowerShell cmdlets: <br><br> `$Update = get-solutionupdate`\| `? version -eq "<version string>"`<br><br>Replace the version string with the version you're running. For example, "10.2405.0.23". <br><br>`$Update.state`<br><br>If the update status is **Installed**, no further action is required on your part. The Azure portal refreshes the status correctly within 24 hours. <br> To refresh the status sooner, follow these steps on one of the nodes. <br>Restart the Cloud Management cluster group.<br>`Stop-ClusterGroup "Cloud Management"`<br>`Start-ClusterGroup "Cloud Management"`|
| Add server <!--26852600--> |In this release and previous releases, when adding a machine to the system, isn't possible to update the proxy bypass list string to include the new machine. Updating environment variables proxy bypass list on the hosts won't update the proxy bypass list on Azure resource bridge or AKS. |There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps.|
| Azure Local VM management |Arc Extensions on Azure Local VMs stay in "Creating" state indefinitely. | Sign in to the VM, open a command prompt, and type the following: <br> **Windows**: <br> `notepad C:\ProgramData\AzureConnectedMachineAgent\Config\agentconfig.json` <br> **Linux**: <br> `sudo vi /var/opt/azcmagent/agentconfig.json` <br>  Next, find the `resourcename` property. Delete the GUID that is appended to the end of the resource name, so this property matches the name of the VM. Then restart the VM.|
| Azure Local VM management |Restart of Azure Local VM operation completes after approximately 20 minutes though the VM itself restarts in about a minute.| There's no known workaround in this release.  |
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Azure Local VM management |Deleting a network interface on an Azure Local VM from Azure portal doesn't work in this release.| Use the Azure CLI to first remove the network interface and then delete it. For more information, see [Remove the network interface](/cli/azure/stack-hci-vm/nic#az-stack-hci-vm-nic-remove) and see [Delete the network interface](/cli/azure/stack-hci-vm/network/nic#az-stack-hci-vm-network-nic-delete).|
| Update | When updating the Azure Local instance via the Azure Update Manager, the update progress and results may not be visible in the Azure portal.| To work around this issue, on each node, add the following registry key (no value needed):<br><br>`New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\HciCloudManagementSvc\Parameters" -force`</br><br> Then on one of the nodes, restart the Cloud Management cluster group. </br><br>`Stop-ClusterGroup "Cloud Management"`</br><br>`Start-ClusterGroup "Cloud Management"`</br><br> This won't fully remediate the issue as the progress details may still not be displayed for a duration of the update process. To get the latest update details, you can [Retrieve the update progress with PowerShell](./update/update-via-powershell-23h2.md#step-6-track-update-progress). |
| Security <!-- 56969147 --> | When fixing the compliance for the minimum password length rule, even after you've changed the minimum password length on the Azure Local host to 14, you continue to see it as non-compliant in Azure policy.  | You can verify the length of the password using the `net accounts` cmdlet. In the output, find **Minimum password length** to see the value. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |
| Security <!--30348397--> |  Azure Local might face an issue during normal operations (for example, Update, Repair) while using Defender for Endpoint and when the **Restrict App Execution** setting is enabled for one or more servers in the deployment.  | Disable the **Restrict App Execution** setting in the Defender portal and reboot. If the issue persists, [open a support case](/azure/azure-portal/supportability/how-to-create-azure-support-request). |
| Deployment <!--33471589--> |  After Azure portal deployment, SConfig network settings shows the error: `Set-SCfNetworksetting : Cannot bind argument to parameter 'Value' because it is null.` | There's no known workaround in this release. |
| Update <!--33448368--> |  Cluster-Aware Updating runs might fail with the error:<br>`Type 'SBEPartnerConfirmCauDone' of Role 'SBE' raised an exception:<br>SBE_MsftCIOnlyCommon_CommonForTesting_4.2.2504.16: ErrorID: SBE-CAU-RUNNING-AFTER-DONE -- CAU run is still in progress when it should be done. See https://aka.ms/AzureLocal/SBE/CauHelp for help. Review full Get-CauRun output it identify if it is progressing or stuck. Wait for it to complete if progressing.` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/SolutionExtension/SBE-CAU-RUNNING-AFTER-DONE-Single-node-fail-SBE-Update.md).|

::: moniker-end

::: moniker range="=azloc-2505"

This article identifies critical known issues and their workarounds in Azure Local.

These release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Local instance, carefully review the information contained here.

> [!IMPORTANT]
> For information about supported update paths for this release, see [Release information](./release-information-23h2.md#about-azure-local-releases).

For more information about new features in this release, see [What's new for Azure Local](whats-new.md).

## Known issues for version 2505

For the 2505 release of Azure Local, Microsoft released two security updates: one for existing deployments and another for new deployments. The following table provides information about different deployment types, their corresponding security updates, and OS builds:

| Deployment type  | Solution version  | OS build  |
|---------|---------|---------|
| Existing deployments    | 11.2505.1001.22          | 25398.1611         |
| New deployments    | 12.2505.1001.23         | 26100.4061        |

> [!IMPORTANT]
> The new deployments of this software use the **12.2505.1001.23** build. You can also update an existing deployment from 2504 using **11.2505.1001.22**.

Release notes for this version include the issues fixed in this release, known issues in this release, and release note issues carried over from previous versions.

> [!NOTE]
> For detailed remediation for common known issues, see the [Azure Local Supportability](https://github.com/Azure/AzureStackHCI-Supportability) GitHub repository.

## Fixed issues

The following table lists the fixed issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Azure Local VMs <!--31710217-->| Timeout errors occur when creating a disk and gallery image. | Extended the timeout period to support larger disk and image size.  |
| Azure Local VMs <!--31388717--> | Mocguestagent gets stuck in a start/stop loop and can't connect to the host agent. | Improved Mocguestagent connectivity. |
| Azure Local VMs <!--31628331--> | Cannot delete a VM in the Azure portal or CLI after deleting it in Hyper-V. | If you delete the VM in Hyper-V instead of the Azure portal or CLI, delete the resource it in the Azure portal or CLI to clean it up. |
| Azure Local VMs <!--32258078--> | Unable to delete a data disk that failed to attach during VM creation.  | Fixed the attachment state of data disk to be accurate. You can now delete a data disk if it fails to attach during VM creation.  |
| Azure Local VMs <!--32475268--> | OS updates can automatically install on the third Tuesday of the month (for example, May 20, June 17, or July 15). This can cause unexpected outages or future issues because of mismatched OS versions for Azure Local.  | Removed logic that set up a scheduled CAU as part of some SBE updates.  |
| Deployment | Deployment via Azure Resource Manager (ARM) template fails with the following error during validation:<br> `Type 'DeployArb' of Role 'MocArb' raised an exception: [DeployArb:Fetching SP in CloudDeployment Scenario] Exception calling 'GetCredential' with '1' argument(s): 'Exception of type 'CloudEngine.Configurations.SecretNotFoundException' was thrown.' at at Get-CloudDeploymentServicePrincipal`. <br> The error is because of a missing SPN during deployment. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Deployment/TSG-Azure-LOCAL-HCI-missing-spn.md). |
| Solution extension <!--32616426--> | Changed the severity level for the health check that validates the plugin's presence. | |
| Azure portal <!--32131565--> | Added a fix to fetch Storage account properties during redeployment. | |
| Azure portal <!--32105125--> | Added an error message about subscription access rights during Azure Local download. | |
| Azure portal <!--32379635--> | Added a warning message if the subscription is not registered during the Azure Local download. | |
| Azure portal <!--32694573--> | Improved logic to show Azure Arc-enabled machines for selection during deployment. | |
| Azure portal <!--32756322--> | Enhanced the setting of machines' state during deployment. | |
| Azure portal <!--30482549--> | Improved error handling and data processing. | |
| Azure portal <!--31931881--> | Added a fix to disable the validation button until extension installations are complete during deployment. | |
| Deployment <!--31617326--> | Added validation to check for required permissions to change access control lists (ACL). | |
| Deployment <!--32199814--> | Added a server-side filter to the WMI call to improve performance and reduce call time. | |
| Deployment <!--31911046--> | Added fix to dispose of the PowerShell objects after use to improve performance when creating new PowerShell instances. | |
| Deployment <!--642400448--> | Fixed the time zone issue when running the **Install Azure Stack HCI** wizard and selecting a time zone. The **Install Azure Stack HCI** wizard now correctly applies the selected time zone during deployment. | |
| Security management <!--57340784--> | Fixed **Security defaults**, **Application control**, and **Data protections** pages showing as *Unknown* in the security compliance report. | |
| Add server <br> Repair server <!--32483959--> | Fixed running `Add-server` and `Repair-server` cmdlets with a customized storage adapter IP in Azure Local which resulted in the error: `Type 'ConfigureAzureStackHostStorageAdpaterIPAddressesInAddRepairNode' of Role 'HostNetwork' raised an exception: Connecting to remote server <MACHINE> failed with the following error message: Access is denied.`. | |

## Known issues in this release

The following table lists the known issues in this release:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Update <!--54889342--> |  A critical VM operational status not OK alert is shown in the Azure portal under **Update readiness** and in the **Alerts** pane after the update has completed successfully. Additionally, the alert appears when running the `Get-HealthFault` cmdlet. | No action is required on your part. This alert will resolve automatically in a few days. |
| Deployment <!--33153622-->| Updating Azure Arc extensions manually from the Azure Local Machine page via the Azure portal will result in issues during deployment. The extensions that shouldn't be updated manually are: `AzureEdgeDeviceManagement`, `AzureEdgeLifecycleManager`, and `AzureEdgeAKVBackupForWindows`. | Installing extensions manually from the Azure Local machine page is not supported. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |


## Known issues from previous releases

The following table lists the known issues from previous releases:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Add server <br> Repair server <!--32447442--> | The `Add-server` and `Repair-server` cmdlets fail with the error: <br> `Cluster Build ID matches node to add's Build ID`. | Use the OS image of the same solution version as that running on the existing cluster. To get the OS image, identify and download the image version from this [Release table](https://github.com/Azure-Samples/AzureLocal/blob/main/os-image/os-image-tracking-table.md). |
| Deployment <!--33008717--> | In this release and previous releases, registration fails with the following error when you try to register Azure Local machines with Azure Arc: <br>`AZCMAgent command failed with error: >> exitcode: 42. Additional Info: See https://aka.ms/arc/azcmerror`. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/users/kagoyal/tsg-error42/TSG/ArcRegistration/TSG%20%7C%20Arc%20registration%20failing%20with%20error%2042.md). |
| Azure Local VM management | The Mochostagent service might appear to be running but can get stuck without updating logs for over a month. You can identify this issue by checking the service logs in `C:\programdata\mochostagent\logs` to see if logs are being updated. | Run the following command to restart the mochostagent service: `restart-service mochostagent`. |
| Update | When viewing the readiness check results for an Azure Local instance via the Azure Update Manager, there might be multiple readiness checks with the same name.  |There's no known workaround in this release. Select **View details** to view specific information about the readiness check. |
| Update | There's an intermittent issue in this release when the Azure portal incorrectly reports the update status as **Failed to update** or **In progress** though the update is complete.  |[Connect to your Azure Local instance](./update/update-via-powershell-23h2.md#connect-to-your-azure-local) via a remote PowerShell session. To confirm the update status, run the following PowerShell cmdlets: <br><br> `$Update = get-solutionupdate`\| `? version -eq "<version string>"`<br><br>Replace the version string with the version you're running. For example, "10.2405.0.23". <br><br>`$Update.state`<br><br>If the update status is **Installed**, no further action is required on your part. The Azure portal refreshes the status correctly within 24 hours. <br> To refresh the status sooner, follow these steps on one of the nodes. <br>Restart the Cloud Management cluster group.<br>`Stop-ClusterGroup "Cloud Management"`<br>`Start-ClusterGroup "Cloud Management"`|
| Add server <!--26852600--> |In this release and previous releases, when adding a machine to the system, isn't possible to update the proxy bypass list string to include the new machine. Updating environment variables proxy bypass list on the hosts won't update the proxy bypass list on Azure resource bridge or AKS. |There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps.|
| Azure Local VM management |Arc Extensions on Azure Local VMs stay in "Creating" state indefinitely. | Sign in to the VM, open a command prompt, and type the following: <br> **Windows**: <br> `notepad C:\ProgramData\AzureConnectedMachineAgent\Config\agentconfig.json` <br> **Linux**: <br> `sudo vi /var/opt/azcmagent/agentconfig.json` <br>  Next, find the `resourcename` property. Delete the GUID that is appended to the end of the resource name, so this property matches the name of the VM. Then restart the VM.|
| Azure Local VM management |Restart of Azure Local VM operation completes after approximately 20 minutes though the VM itself restarts in about a minute.| There's no known workaround in this release.  |
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Azure Local VM management |Deleting a network interface on an Azure Local VM from Azure portal doesn't work in this release.| Use the Azure CLI to first remove the network interface and then delete it. For more information, see [Remove the network interface](/cli/azure/stack-hci-vm/nic#az-stack-hci-vm-nic-remove) and see [Delete the network interface](/cli/azure/stack-hci-vm/network/nic#az-stack-hci-vm-network-nic-delete).|
| Update | When updating the Azure Local instance via the Azure Update Manager, the update progress and results may not be visible in the Azure portal.| To work around this issue, on each node, add the following registry key (no value needed):<br><br>`New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\HciCloudManagementSvc\Parameters" -force`</br><br> Then on one of the nodes, restart the Cloud Management cluster group. </br><br>`Stop-ClusterGroup "Cloud Management"`</br><br>`Start-ClusterGroup "Cloud Management"`</br><br> This won't fully remediate the issue as the progress details may still not be displayed for a duration of the update process. To get the latest update details, you can [Retrieve the update progress with PowerShell](./update/update-via-powershell-23h2.md#step-6-track-update-progress). |
| Security <!-- 56969147 --> | When fixing the compliance for the minimum password length rule, even after you've changed the minimum password length on the Azure Local host to 14, you continue to see it as non-compliant in Azure policy.  | You can verify the length of the password using the `net accounts` cmdlet. In the output, find **Minimum password length** to see the value. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |
| Security <!--30348397--> |  Azure Local might face an issue during normal operations (for example, Update, Repair) while using Defender for Endpoint and when the **Restrict App Execution** setting is enabled for one or more servers in the deployment.  | Disable the **Restrict App Execution** setting in the Defender portal and reboot. If the issue persists, [open a support case](/azure/azure-portal/supportability/how-to-create-azure-support-request). |
| Deployment <!--33471589--> |  After Azure portal deployment, SConfig network settings shows the error: `Set-SCfNetworksetting : Cannot bind argument to parameter 'Value' because it is null.` | There's no known workaround in this release. |
| Update <!--33448368--> |  Cluster-Aware Updating runs might fail with the error:<br>`Type 'SBEPartnerConfirmCauDone' of Role 'SBE' raised an exception:<br>SBE_MsftCIOnlyCommon_CommonForTesting_4.2.2504.16: ErrorID: SBE-CAU-RUNNING-AFTER-DONE -- CAU run is still in progress when it should be done. See https://aka.ms/AzureLocal/SBE/CauHelp for help. Review full Get-CauRun output it identify if it is progressing or stuck. Wait for it to complete if progressing.` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/SolutionExtension/SBE-CAU-RUNNING-AFTER-DONE-Single-node-fail-SBE-Update.md).|

::: moniker-end

::: moniker range="=azloc-2505"

This article identifies critical known issues and their workarounds in Azure Local.

These release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Local instance, carefully review the information contained here.

> [!IMPORTANT]
> For information about supported update paths for this release, see [Release information](./release-information-23h2.md#about-azure-local-releases).

For more information about new features in this release, see [What's new for Azure Local](whats-new.md).

## Known issues for version 2505

For the 2505 release of Azure Local, Microsoft released two security updates: one for existing deployments and another for new deployments. The following table provides information about different deployment types, their corresponding security updates, and OS builds:

| Deployment type  | Solution version  | OS build  |
|---------|---------|---------|
| Existing deployments    | 11.2505.1001.22          | 25398.1611         |
| New deployments    | 12.2505.1001.23         | 26100.4061        |

> [!IMPORTANT]
> The new deployments of this software use the **12.2505.1001.23** build. You can also update an existing deployment from 2504 using **11.2505.1001.22**.

Release notes for this version include the issues fixed in this release, known issues in this release, and release note issues carried over from previous versions.

> [!NOTE]
> For detailed remediation for common known issues, see the [Azure Local Supportability](https://github.com/Azure/AzureStackHCI-Supportability) GitHub repository.

## Fixed issues

The following table lists the fixed issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Azure Local VMs <!--31710217-->| Timeout errors occur when creating a disk and gallery image. | Extended the timeout period to support larger disk and image size.  |
| Azure Local VMs <!--31388717--> | Mocguestagent gets stuck in a start/stop loop and can't connect to the host agent. | Improved Mocguestagent connectivity. |
| Azure Local VMs <!--31628331--> | Cannot delete a VM in the Azure portal or CLI after deleting it in Hyper-V. | If you delete the VM in Hyper-V instead of the Azure portal or CLI, delete the resource it in the Azure portal or CLI to clean it up. |
| Azure Local VMs <!--32258078--> | Unable to delete a data disk that failed to attach during VM creation.  | Fixed the attachment state of data disk to be accurate. You can now delete a data disk if it fails to attach during VM creation.  |
| Azure Local VMs <!--32475268--> | OS updates can automatically install on the third Tuesday of the month (for example, May 20, June 17, or July 15). This can cause unexpected outages or future issues because of mismatched OS versions for Azure Local.  | Removed logic that set up a scheduled CAU as part of some SBE updates.  |
| Deployment | Deployment via Azure Resource Manager (ARM) template fails with the following error during validation:<br> `Type 'DeployArb' of Role 'MocArb' raised an exception: [DeployArb:Fetching SP in CloudDeployment Scenario] Exception calling 'GetCredential' with '1' argument(s): 'Exception of type 'CloudEngine.Configurations.SecretNotFoundException' was thrown.' at at Get-CloudDeploymentServicePrincipal`. <br> The error is because of a missing SPN during deployment. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Deployment/TSG-Azure-LOCAL-HCI-missing-spn.md). |
| Solution extension <!--32616426--> | Changed the severity level for the health check that validates the plugin's presence. | |
| Azure portal <!--32131565--> | Added a fix to fetch Storage account properties during redeployment. | |
| Azure portal <!--32105125--> | Added an error message about subscription access rights during Azure Local download. | |
| Azure portal <!--32379635--> | Added a warning message if the subscription is not registered during the Azure Local download. | |
| Azure portal <!--32694573--> | Improved logic to show Azure Arc-enabled machines for selection during deployment. | |
| Azure portal <!--32756322--> | Enhanced the setting of machines' state during deployment. | |
| Azure portal <!--30482549--> | Improved error handling and data processing. | |
| Azure portal <!--31931881--> | Added a fix to disable the validation button until extension installations are complete during deployment. | |
| Deployment <!--31617326--> | Added validation to check for required permissions to change access control lists (ACL). | |
| Deployment <!--32199814--> | Added a server-side filter to the WMI call to improve performance and reduce call time. | |
| Deployment <!--31911046--> | Added fix to dispose of the PowerShell objects after use to improve performance when creating new PowerShell instances. | |
| Deployment <!--642400448--> | Fixed the time zone issue when running the **Install Azure Stack HCI** wizard and selecting a time zone. The **Install Azure Stack HCI** wizard now correctly applies the selected time zone during deployment. | |
| Security management <!--57340784--> | Fixed **Security defaults**, **Application control**, and **Data protections** pages showing as *Unknown* in the security compliance report. | |
| Add server <br> Repair server <!--32483959--> | Fixed running `Add-server` and `Repair-server` cmdlets with a customized storage adapter IP in Azure Local which resulted in the error: `Type 'ConfigureAzureStackHostStorageAdpaterIPAddressesInAddRepairNode' of Role 'HostNetwork' raised an exception: Connecting to remote server <MACHINE> failed with the following error message: Access is denied.`. | |

## Known issues in this release

The following table lists the known issues in this release:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Update <!--54889342--> |  A critical VM operational status not OK alert is shown in the Azure portal under **Update readiness** and in the **Alerts** pane after the update has completed successfully. Additionally, the alert appears when running the `Get-HealthFault` cmdlet. | No action is required on your part. This alert will resolve automatically in a few days. |
| Deployment <!--33153622-->| Updating Azure Arc extensions manually from the Azure Local Machine page via the Azure portal will result in issues during deployment. The extensions that shouldn't be updated manually are: `AzureEdgeDeviceManagement`, `AzureEdgeLifecycleManager`, and `AzureEdgeAKVBackupForWindows`. | Installing extensions manually from the Azure Local machine page is not supported. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |


## Known issues from previous releases

The following table lists the known issues from previous releases:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Add server <br> Repair server <!--32447442--> | The `Add-server` and `Repair-server` cmdlets fail with the error: <br> `Cluster Build ID matches node to add's Build ID`. | Use the OS image of the same solution version as that running on the existing cluster. To get the OS image, identify and download the image version from this [Release table](https://github.com/Azure-Samples/AzureLocal/blob/main/os-image/os-image-tracking-table.md). |
| Deployment <!--33008717--> | In this release and previous releases, registration fails with the following error when you try to register Azure Local machines with Azure Arc: <br>`AZCMAgent command failed with error: >> exitcode: 42. Additional Info: See https://aka.ms/arc/azcmerror`. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/users/kagoyal/tsg-error42/TSG/ArcRegistration/TSG%20%7C%20Arc%20registration%20failing%20with%20error%2042.md). |
| Azure Local VM management | The Mochostagent service might appear to be running but can get stuck without updating logs for over a month. You can identify this issue by checking the service logs in `C:\programdata\mochostagent\logs` to see if logs are being updated. | Run the following command to restart the mochostagent service: `restart-service mochostagent`. |
| Update | When viewing the readiness check results for an Azure Local instance via the Azure Update Manager, there might be multiple readiness checks with the same name.  |There's no known workaround in this release. Select **View details** to view specific information about the readiness check. |
| Update | There's an intermittent issue in this release when the Azure portal incorrectly reports the update status as **Failed to update** or **In progress** though the update is complete.  |[Connect to your Azure Local instance](./update/update-via-powershell-23h2.md#connect-to-your-azure-local) via a remote PowerShell session. To confirm the update status, run the following PowerShell cmdlets: <br><br> `$Update = get-solutionupdate`\| `? version -eq "<version string>"`<br><br>Replace the version string with the version you're running. For example, "10.2405.0.23". <br><br>`$Update.state`<br><br>If the update status is **Installed**, no further action is required on your part. The Azure portal refreshes the status correctly within 24 hours. <br> To refresh the status sooner, follow these steps on one of the nodes. <br>Restart the Cloud Management cluster group.<br>`Stop-ClusterGroup "Cloud Management"`<br>`Start-ClusterGroup "Cloud Management"`|
| Add server <!--26852600--> |In this release and previous releases, when adding a machine to the system, isn't possible to update the proxy bypass list string to include the new machine. Updating environment variables proxy bypass list on the hosts won't update the proxy bypass list on Azure resource bridge or AKS. |There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps.|
| Azure Local VM management |Arc Extensions on Azure Local VMs stay in "Creating" state indefinitely. | Sign in to the VM, open a command prompt, and type the following: <br> **Windows**: <br> `notepad C:\ProgramData\AzureConnectedMachineAgent\Config\agentconfig.json` <br> **Linux**: <br> `sudo vi /var/opt/azcmagent/agentconfig.json` <br>  Next, find the `resourcename` property. Delete the GUID that is appended to the end of the resource name, so this property matches the name of the VM. Then restart the VM.|
| Azure Local VM management |Restart of Azure Local VM operation completes after approximately 20 minutes though the VM itself restarts in about a minute.| There's no known workaround in this release.  |
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Azure Local VM management |Deleting a network interface on an Azure Local VM from Azure portal doesn't work in this release.| Use the Azure CLI to first remove the network interface and then delete it. For more information, see [Remove the network interface](/cli/azure/stack-hci-vm/nic#az-stack-hci-vm-nic-remove) and see [Delete the network interface](/cli/azure/stack-hci-vm/network/nic#az-stack-hci-vm-network-nic-delete).|
| Update | When updating the Azure Local instance via the Azure Update Manager, the update progress and results may not be visible in the Azure portal.| To work around this issue, on each node, add the following registry key (no value needed):<br><br>`New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\HciCloudManagementSvc\Parameters" -force`</br><br> Then on one of the nodes, restart the Cloud Management cluster group. </br><br>`Stop-ClusterGroup "Cloud Management"`</br><br>`Start-ClusterGroup "Cloud Management"`</br><br> This won't fully remediate the issue as the progress details may still not be displayed for a duration of the update process. To get the latest update details, you can [Retrieve the update progress with PowerShell](./update/update-via-powershell-23h2.md#step-6-track-update-progress). |
| Security <!-- 56969147 --> | When fixing the compliance for the minimum password length rule, even after you've changed the minimum password length on the Azure Local host to 14, you continue to see it as non-compliant in Azure policy.  | You can verify the length of the password using the `net accounts` cmdlet. In the output, find **Minimum password length** to see the value. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |
| Security <!--30348397--> |  Azure Local might face an issue during normal operations (for example, Update, Repair) while using Defender for Endpoint and when the **Restrict App Execution** setting is enabled for one or more servers in the deployment.  | Disable the **Restrict App Execution** setting in the Defender portal and reboot. If the issue persists, [open a support case](/azure/azure-portal/supportability/how-to-create-azure-support-request). |
| Deployment <!--33471589--> |  After Azure portal deployment, SConfig network settings shows the error: `Set-SCfNetworksetting : Cannot bind argument to parameter 'Value' because it is null.` | There's no known workaround in this release. |
| Update <!--33448368--> |  Cluster-Aware Updating runs might fail with the error:<br>`Type 'SBEPartnerConfirmCauDone' of Role 'SBE' raised an exception:<br>SBE_MsftCIOnlyCommon_CommonForTesting_4.2.2504.16: ErrorID: SBE-CAU-RUNNING-AFTER-DONE -- CAU run is still in progress when it should be done. See https://aka.ms/AzureLocal/SBE/CauHelp for help. Review full Get-CauRun output it identify if it is progressing or stuck. Wait for it to complete if progressing.` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/SolutionExtension/SBE-CAU-RUNNING-AFTER-DONE-Single-node-fail-SBE-Update.md).|

::: moniker-end

::: moniker range="=azloc-2505"

This article identifies critical known issues and their workarounds in Azure Local.

These release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Local instance, carefully review the information contained here.

> [!IMPORTANT]
> For information about supported update paths for this release, see [Release information](./release-information-23h2.md#about-azure-local-releases).

For more information about new features in this release, see [What's new for Azure Local](whats-new.md).

## Known issues for version 2505

For the 2505 release of Azure Local, Microsoft released two security updates: one for existing deployments and another for new deployments. The following table provides information about different deployment types, their corresponding security updates, and OS builds:

| Deployment type  | Solution version  | OS build  |
|---------|---------|---------|
| Existing deployments    | 11.2505.1001.22          | 25398.1611         |
| New deployments    | 12.2505.1001.23         | 26100.4061        |

> [!IMPORTANT]
> The new deployments of this software use the **12.2505.1001.23** build. You can also update an existing deployment from 2504 using **11.2505.1001.22**.

Release notes for this version include the issues fixed in this release, known issues in this release, and release note issues carried over from previous versions.

> [!NOTE]
> For detailed remediation for common known issues, see the [Azure Local Supportability](https://github.com/Azure/AzureStackHCI-Supportability) GitHub repository.

## Fixed issues

The following table lists the fixed issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Azure Local VMs <!--31710217-->| Timeout errors occur when creating a disk and gallery image. | Extended the timeout period to support larger disk and image size.  |
| Azure Local VMs <!--31388717--> | Mocguestagent gets stuck in a start/stop loop and can't connect to the host agent. | Improved Mocguestagent connectivity. |
| Azure Local VMs <!--31628331--> | Cannot delete a VM in the Azure portal or CLI after deleting it in Hyper-V. | If you delete the VM in Hyper-V instead of the Azure portal or CLI, delete the resource it in the Azure portal or CLI to clean it up. |
| Azure Local VMs <!--32258078--> | Unable to delete a data disk that failed to attach during VM creation.  | Fixed the attachment state of data disk to be accurate. You can now delete a data disk if it fails to attach during VM creation.  |
| Azure Local VMs <!--32475268--> | OS updates can automatically install on the third Tuesday of the month (for example, May 20, June 17, or July 15). This can cause unexpected outages or future issues because of mismatched OS versions for Azure Local.  | Removed logic that set up a scheduled CAU as part of some SBE updates.  |
| Deployment | Deployment via Azure Resource Manager (ARM) template fails with the following error during validation:<br> `Type 'DeployArb' of Role 'MocArb' raised an exception: [DeployArb:Fetching SP in CloudDeployment Scenario] Exception calling 'GetCredential' with '1' argument(s): 'Exception of type 'CloudEngine.Configurations.SecretNotFoundException' was thrown.' at at Get-CloudDeploymentServicePrincipal`. <br> The error is because of a missing SPN during deployment. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Deployment/TSG-Azure-LOCAL-HCI-missing-spn.md). |
| Solution extension <!--32616426--> | Changed the severity level for the health check that validates the plugin's presence. | |
| Azure portal <!--32131565--> | Added a fix to fetch Storage account properties during redeployment. | |
| Azure portal <!--32105125--> | Added an error message about subscription access rights during Azure Local download. | |
| Azure portal <!--32379635--> | Added a warning message if the subscription is not registered during the Azure Local download. | |
| Azure portal <!--32694573--> | Improved logic to show Azure Arc-enabled machines for selection during deployment. | |
| Azure portal <!--32756322--> | Enhanced the setting of machines' state during deployment. | |
| Azure portal <!--30482549--> | Improved error handling and data processing. | |
| Azure portal <!--31931881--> | Added a fix to disable the validation button until extension installations are complete during deployment. | |
| Deployment <!--31617326--> | Added validation to check for required permissions to change access control lists (ACL). | |
| Deployment <!--32199814--> | Added a server-side filter to the WMI call to improve performance and reduce call time. | |
| Deployment <!--31911046--> | Added fix to dispose of the PowerShell objects after use to improve performance when creating new PowerShell instances. | |
| Deployment <!--642400448--> | Fixed the time zone issue when running the **Install Azure Stack HCI** wizard and selecting a time zone. The **Install Azure Stack HCI** wizard now correctly applies the selected time zone during deployment. | |
| Security management <!--57340784--> | Fixed **Security defaults**, **Application control**, and **Data protections** pages showing as *Unknown* in the security compliance report. | |
| Add server <br> Repair server <!--32483959--> | Fixed running `Add-server` and `Repair-server` cmdlets with a customized storage adapter IP in Azure Local which resulted in the error: `Type 'ConfigureAzureStackHostStorageAdpaterIPAddressesInAddRepairNode' of Role 'HostNetwork' raised an exception: Connecting to remote server <MACHINE> failed with the following error message: Access is denied.`. | |

## Known issues in this release

The following table lists the known issues in this release:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Update <!--54889342--> |  A critical VM operational status not OK alert is shown in the Azure portal under **Update readiness** and in the **Alerts** pane after the update has completed successfully. Additionally, the alert appears when running the `Get-HealthFault` cmdlet. | No action is required on your part. This alert will resolve automatically in a few days. |
| Deployment <!--33153622-->| Updating Azure Arc extensions manually from the Azure Local Machine page via the Azure portal will result in issues during deployment. The extensions that shouldn't be updated manually are: `AzureEdgeDeviceManagement`, `AzureEdgeLifecycleManager`, and `AzureEdgeAKVBackupForWindows`. | Installing extensions manually from the Azure Local machine page is not supported. |
| Upgrade <!--33417006-->| The upgrade banner is currently available for users using the Azure Government cloud. However, the environment checker fails, suggesting that Azure Government clouds are not supported. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |


## Known issues from previous releases

The following table lists the known issues from previous releases:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Add server <br> Repair server <!--32447442--> | The `Add-server` and `Repair-server` cmdlets fail with the error: <br> `Cluster Build ID matches node to add's Build ID`. | Use the OS image of the same solution version as that running on the existing cluster. To get the OS image, identify and download the image version from this [Release table](https://github.com/Azure-Samples/AzureLocal/blob/main/os-image/os-image-tracking-table.md). |
| Deployment <!--33008717--> | In this release and previous releases, registration fails with the following error when you try to register Azure Local machines with Azure Arc: <br>`AZCMAgent command failed with error: >> exitcode: 42. Additional Info: See https://aka.ms/arc/azcmerror`. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/users/kagoyal/tsg-error42/TSG/ArcRegistration/TSG%20%7C%20Arc%20registration%20failing%20with%20error%2042.md). |
| Azure Local VM management | The Mochostagent service might appear to be running but can get stuck without updating logs for over a month. You can identify this issue by checking the service logs in `C:\programdata\mochostagent\logs` to see if logs are being updated. | Run the following command to restart the mochostagent service: `restart-service mochostagent`. |
| Update | When viewing the readiness check results for an Azure Local instance via the Azure Update Manager, there might be multiple readiness checks with the same name.  |There's no known workaround in this release. Select **View details** to view specific information about the readiness check. |
| Update | There's an intermittent issue in this release when the Azure portal incorrectly reports the update status as **Failed to update** or **In progress** though the update is complete.  |[Connect to your Azure Local instance](./update/update-via-powershell-23h2.md#connect-to-your-azure-local) via a remote PowerShell session. To confirm the update status, run the following PowerShell cmdlets: <br><br> `$Update = get-solutionupdate`\| `? version -eq "<version string>"`<br><br>Replace the version string with the version you're running. For example, "10.2405.0.23". <br><br>`$Update.state`<br><br>If the update status is **Installed**, no further action is required on your part. The Azure portal refreshes the status correctly within 24 hours. <br> To refresh the status sooner, follow these steps on one of the nodes. <br>Restart the Cloud Management cluster group.<br>`Stop-ClusterGroup "Cloud Management"`<br>`Start-ClusterGroup "Cloud Management"`|
| Add server <!--26852600--> |In this release and previous releases, when adding a machine to the system, isn't possible to update the proxy bypass list string to include the new machine. Updating environment variables proxy bypass list on the hosts won't update the proxy bypass list on Azure resource bridge or AKS. |There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps.|
| Azure Local VM management |Arc Extensions on Azure Local VMs stay in "Creating" state indefinitely. | Sign in to the VM, open a command prompt, and type the following: <br> **Windows**: <br> `notepad C:\ProgramData\AzureConnectedMachineAgent\Config\agentconfig.json` <br> **Linux**: <br> `sudo vi /var/opt/azcmagent/agentconfig.json` <br>  Next, find the `resourcename` property. Delete the GUID that is appended to the end of the resource name, so this property matches the name of the VM. Then restart the VM.|
| Azure Local VM management |Restart of Azure Local VM operation completes after approximately 20 minutes though the VM itself restarts in about a minute.| There's no known workaround in this release.  |
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Azure Local VM management |Deleting a network interface on an Azure Local VM from Azure portal doesn't work in this release.| Use the Azure CLI to first remove the network interface and then delete it. For more information, see [Remove the network interface](/cli/azure/stack-hci-vm/nic#az-stack-hci-vm-nic-remove) and see [Delete the network interface](/cli/azure/stack-hci-vm/network/nic#az-stack-hci-vm-network-nic-delete).|
| Update | When updating the Azure Local instance via the Azure Update Manager, the update progress and results may not be visible in the Azure portal.| To work around this issue, on each node, add the following registry key (no value needed):<br><br>`New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\HciCloudManagementSvc\Parameters" -force`</br><br> Then on one of the nodes, restart the Cloud Management cluster group. </br><br>`Stop-ClusterGroup "Cloud Management"`</br><br>`Start-ClusterGroup "Cloud Management"`</br><br> This won't fully remediate the issue as the progress details may still not be displayed for a duration of the update process. To get the latest update details, you can [Retrieve the update progress with PowerShell](./update/update-via-powershell-23h2.md#step-6-track-update-progress). |
| Security <!-- 56969147 --> | When fixing the compliance for the minimum password length rule, even after you've changed the minimum password length on the Azure Local host to 14, you continue to see it as non-compliant in Azure policy.  | You can verify the length of the password using the `net accounts` cmdlet. In the output, find **Minimum password length** to see the value. |


## Known issues for version 2408.2

This software release maps to software version number **2408.2.7**.

Release notes for this version include the issues fixed in this release, known issues in this release, and release note issues carried over from previous versions.

> [!NOTE]
> For detailed remediation for common known issues, see the [Azure Local Supportability](https://github.com/Azure/AzureStackHCI-Supportability) GitHub repository.

### Fixed issues

The following issues are fixed in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Security | SideChannelMitigation is reporting properly in both local cmdlets and Windows Admin Center. ||
| Update <!--29100330--> | An update would unnecessarily download Solution Builder Extension content that was already added. ||
| Upgrade <!--29426262--> | Cluster resources weren't in the same group. ||
| Upgrade <!--29444056--> | Fixed IP pool validation in the Azure portal. ||
| Upgrade <!--29498611--> | Added validation to ensure the package is the latest version ||
| Upgrade <!--29546100--> | Validation would fail due to group policies. ||

### Known issues in this release

The following table lists the known issues in this release:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Security <!-- 56969147 -->| When fixing the compliance for the minimum password length rule, even after you've changed the minimum password length on the Azure Local host to 14, you continue to see it as non-compliant in Azure policy.  | You can verify the length of the password using the `net accounts` cmdlet. In the output, find **Minimum password length** to see the value. |

### Known issues from previous releases

The following table lists the known issues from previous releases:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Azure Local VM management <!--ADO--> | If you try to enable guest management on a migrated VM, the operation fails with the following error: *(InternalError) admission webhook "createupdatevalidationwebhook.infrastructure.azstackhci.microsoft.com" denied the request: OsProfile cannot be changed after resource creation*||
| Security <!--29333930--> | The SideChannelMitigation security feature may not show an enabled state even if it's enabled. | There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps. |
| Update | When viewing the readiness check results for an Azure Local instance via the Azure Update Manager, there might be multiple readiness checks with the same name.  |There's no known workaround in this release. Select **View details** to view specific information about the readiness check. |
| Update | There is an intermittent issue in this release where the Azure portal may incorrectly display the update status as **Failed to update** or **In progress**, even though the update has actually completed successfully. This behavior is particularly observed when updating Azure Local instances via Azure Update Manager, where the update progress and results may not be visible in the portal.  | You might need to wait up to 30 minutes or more to see the updated status. If the status still isn't refreshed after that time, follow these steps: [Connect to your Azure Local instance](./update/update-via-powershell-23h2.md#connect-to-your-azure-local) via a remote PowerShell session. To confirm the update status, run the following PowerShell cmdlets: <br><br> `$Update = get-solutionupdate`\| `? version -eq "<version string>"`<br><br>Replace the version string with the version you're running. For example, "10.2405.0.23". <br><br>`$Update.state`<br><br>If the update status is **Installed**, no further action is required on your part. Azure portal refreshes the status correctly within 24 hours. <br> To refresh the status sooner, follow these steps on one of the nodes. <br>Restart the Cloud Management cluster group.<br>`Stop-ClusterGroup "Cloud Management"`<br>`Start-ClusterGroup "Cloud Management"`|
| Add server <!--26852600--> |In this release and previous releases, when adding a machine to the system, isn't possible to update the proxy bypass list string to include the new machine. Updating environment variables proxy bypass list on the hosts won't update the proxy bypass list on Azure Update Manager or AKS. |There's no workaround in this release. If you encounter this issue, contact Microsoft Support to determine next steps.|
| Azure portal <!--25741164--> |In some instances, the Azure portal might take a while to update and the view might not be current.| You might need to wait for 30 minutes or more to see the updated view. |
| Azure Local VM management |In rare instances, deleting a network interface on an Azure Local VM from Azure portal doesn't work in this release.| Use the Azure CLI to first remove the network interface and then delete it. For more information, see [Remove the network interface](/cli/azure/stack-hci-vm/nic#az-stack-hci-vm-nic-remove) and see [Delete the network interface](/cli/azure/stack-hci-vm/network/nic#az-stack-hci-vm-network-nic-delete).|
| Security <!-- 56969147 --> | When fixing the compliance for the minimum password length rule, even after you've changed the minimum password length on the Azure Local host to 14, you continue to see it as non-compliant in Azure policy.  | You can verify the length of the password using the `net accounts` cmdlet. In the output, find **Minimum password length** to see the value. |
| Azure Arc registration <!-- 32995193 --> | When registering a new machine with Azure Arc, registration fails during `ImageRecipeValidationTests` with the following error:<br>` "Responses": [ { "Name": "ImageRecipeValidation", "Status": "Failed", "Errors": [ { "ErrorMessage": "Diagnostics failed for the test category: ImageRecipeValidation.", "StackTrace": null, "ExceptionType": "DiagnosticsTestFailedException", "RecommendedActions": [ "Please contact Microsoft support." ] } ] } ` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/users/kagoyal/tsg-error42/TSG/ArcRegistration/TSG%20%7c%20Arc%20registration%20failing%20with%20error%2042.md). |
| Upgrade <!--32812323--> | Failed to upgrade cluster with `Get-AzureStackHCI ConnectionStatus` in `RepairRegistration` due to the Virtualization-Based Security (VBS) master key lost during Secure Boot certificate installation. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Update/BreakFix-Update-Resolve-subscription-status-precheck-failure.md). |
| Registration <!--32812323-->  | After installing certain updates (including BIOS), clusters may report `RepairRegistrationRequired` and show a stale connection state.  | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/ClusterRegistration/BreakFix-Registration-How-to-resolve-a-repairregistrationrequired-connection-status-after-service-or-bios-updates.md).  |

## Known and expected behaviors

The following table lists the known and expected system behaviors that shouldn't be considered as bugs or limitations.

| Feature  | Behavior  |  Workaround |
|---------|---------|---------|
| Operating system  | Restoring the registry using *RegBack* isn't supported on Azure Local. This operation can remove the Lifecycle Manager (LCM) and Microsoft On-premises Cloud (MOC) settings on your Azure Local instance, which can corrupt the solution.  | |
| Azure Local VM management| Using an exported Azure VM OS disk as a VHD to create a gallery image for provisioning an Azure Local VM is unsupported. | Run the command `restart-service mochostagent` to restart the mochostagent service. |

::: moniker-end

::: moniker range="=azloc-2504"

## Known issues for version 2504

For the 2504 release of Azure Local, Microsoft released two security updates: one for existing deployments and another for new deployments. The following table provides information about different deployment types, their corresponding security updates, and OS builds:


| Deployment type  | Solution version  | OS build  |
|---------|---------|---------|
| Existing deployments    | 11.2504.1001.19          | 25398.1551         |
| New deployments    | 12.2504.1001.20         | 26100.3775         |

> [!IMPORTANT]
> The new deployments of this software use the **12.2504.1001.20** build. You can also update an existing deployment from 2503 using **11.2504.1001.19**.

Release notes for this version include the issues fixed in this release, known issues in this release, and release note issues carried over from previous versions.

> [!NOTE]
> For detailed remediation for common known issues, see the [Azure Local Supportability](https://github.com/Azure/AzureStackHCI-Supportability) GitHub repository.

## Fixed issues

The following table lists the fixed issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Azure Local VMs <!--31912537-->| Subsequent deployments or operations on source image fail if a VM is created with OS disk and source image located on the same CSV and an error occurred during a previous copy of the source image. |  |
| Azure Local VMs <!--31925164--> | Multiple Hyper-V VMs for a single Azure Local VM that failed to be created are left running on Azure Local. | |
| Azure Local VMs <!--30299461--> | Storage path deletion times out if AKS node disks are present. | No timeout and will error out with proper error message listing the resources on the storage path. |
| Azure Local VMs <!--31569686--> | Issues with deleting resources that are in use by other resources that no longer exist on the cluster.  | Enhanced validation to check if resources are present on the cluster before attempting to delete.  |
| Azure Local VMs <!--30353875--> | Issues with deleting and resizing an Azure Local VM that has checkpoint(s).  | You can checkpoint an Azure Local VM with on-premises tools. The VM will remain manageable from the Azure portal.  |
| Solution extension <!--31050791--> | Improved error message to fix firewall blocking access to solution extension manifest endpoints. | |
| Solution extension <!--31630939--> | Improved reliability of copying solution extension content locally to each machine. | |
| Solution extension <!--31632765--> | Added specification of plug-in name in the solution extension. | |
| Solution extension <!--32105125--> | Fixed issue where system was unable to get available solution extension updates. | |
| Update <!--26952715--> | Simplified the Azure portal experience for viewing the progress and history of update runs. | |
| Update  | When monitoring update progress in the Azure Update Management portal, the progress might appear to not have updated for several hours. | Run `Get-SolutionUpdate` on one of the cluster nodes. If an update object is returned, the update might be taking longer than expected but it is progressing. If an update object is not returned, the update may be stalled. For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Update/Get-SolutionUpdate-GatewayTimeout.md).|

## Known issues in this release

The following table lists the known issues in this release:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Add server <br> Repair server <!--32447442--> | The `Add-server` and `Repair-server` cmdlets fail with the error: <br> `Cluster Build ID matches node to add's Build ID`. | Use the OS image of the same solution version as that running on the existing cluster. To get the OS image, identify and download the image version from this [Release table](https://github.com/Azure-Samples/AzureLocal/blob/main/os-image/os-image-tracking-table.md). |
| Add server <br> Repair server <!--32483959--> | If running `Add-server` and `Repair-server` cmdlets with customized storage adapter IP configured in your Azure Local instance, the operation might fail with the error: <br> `Type 'ConfigureAzureStackHostStorageAdpaterIPAddressesInAddRepairNode' of Role 'HostNetwork' raised an exception: Connecting to remote server <MACHINE> failed with the following error message : Access is denied.`. | Contact Microsoft Support if you experience this issue. |
| Security management <!--57340784--> | The **Security defaults**, **Application control**, and **Data protections** pages show *Unknown* for all security settings. | This issue is only in the security compliance report. The states of the security settings are unaffected. Use PowerShell to verify the compliance status of the security settings. <br><br>For more information, see [Manage secure baseline via PowerShell cmdlets](./manage/manage-secure-baseline.md#powershell-cmdlet-properties) |
| Deployment <!--33008717--> | In this release and previous releases, registration fails with the following error when you try to register Azure Local machines with Azure Arc: <br>`AZCMAgent command failed with error: >> exitcode: 42. Additional Info: See https://aka.ms/arc/azcmerror`. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/users/kagoyal/tsg-error42/TSG/ArcRegistration/TSG%20%7C%20Arc%20registration%20failing%20with%20error%2042.md). |
| Azure Arc registration <!-- 32995193 --> | When registering a new machine with Azure Arc, registration fails during `ImageRecipeValidationTests` with the following error:<br>` "Responses": [ { "Name": "ImageRecipeValidation", "Status": "Failed", "Errors": [ { "ErrorMessage": "Diagnostics failed for the test category: ImageRecipeValidation.", "StackTrace": null, "ExceptionType": "DiagnosticsTestFailedException", "RecommendedActions": [ "Please contact Microsoft support." ] } ] } ` | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/users/kagoyal/tsg-error42/TSG/ArcRegistration/TSG%20%7c%20Arc%20registration%20failing%20with%20error%2042.md). |
| Upgrade <!--32812323--> | Failed to upgrade cluster with `Get-AzureStackHCI ConnectionStatus` in `RepairRegistration` due to the Virtualization-Based Security (VBS) master key lost during Secure Boot certificate installation. | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Update/BreakFix-Update-Resolve-subscription-status-precheck-failure.md). |
| Registration <!--32812323-->  | After installing certain updates (including BIOS), clusters may report `RepairRegistrationRequired` and show a stale connection state.  | For detailed steps on how to resolve this issue, see the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/ClusterRegistration/BreakFix-Registration-How-to-resolve-a-repairregistrationrequired-connection-status-after-service-or-bios-updates.md).  |

## Known and expected behaviors

The following table lists the known and expected system behaviors that shouldn't be considered as bugs or limitations.

| Feature  | Behavior  |  Workaround |
|---------|---------|---------|
| Operating system  | Restoring the registry using *RegBack* isn't supported on Azure Local. This operation can remove the Lifecycle Manager (LCM) and Microsoft On-premises Cloud (MOC) settings on your Azure Local instance, which can corrupt the solution.  | |
| Azure Local VM management| Using an exported Azure VM OS disk as a VHD to create a gallery image for provisioning an Azure Local VM is unsupported. | Run the command `restart-service mochostagent` to restart the mochostagent service. |

::: moniker-end

::: moniker range="=azloc-2503"

## Known issues for version 2503

This software release maps to software version number **2503.0.13**.

> [!IMPORTANT]
> The new deployments of this software use the **2503.0.13** build. You can also update from 2411.3.

Release notes for this version include the issues fixed in this release, known issues in this release, and release note issues carried over from previous versions.

> [!NOTE]
> For detailed remediation for common known issues, see the [Azure Local Supportability](https://github.com/Azure/AzureStackHCI-Supportability) GitHub repository.

## Fixed issues

The following table lists the fixed issues in this release:

|Feature|Issue|Workaround/Comments|
|------|------|----------|
| Azure Local VMs | Intermittent failures or timeouts when creating or deleting Azure Local VMs due to internal service entering a deadlocked state. | You can now deploy Azure Local VMs without facing timeout issues. |
| Azure Local VMs <!--ADO--> | Unable to delete a gallery image if the source Azure Local VM gallery image was created from, was deleted.| You can now delete a gallery image even if the source Azure Local VM the gallery image was created from, was deleted.|
| Azure Local VMs <!--ADO--> | After Azure Arc resource bridge disaster recovery, some Azure Local VMs may lose network connectivity. | Updated Azure Arc resource bridge disaster recovery logic to ensure network configurations of Azure Local VMs persists. |
| Azure Local VMs <!--ADO--> | Inaccurate power state reporting on Azure for Azure Local VMs when the source image for the VM is deleted from the cluster.  | Power operations shows consistent and accurate power state representation on Azure for Azure Local VMs with deleted source images.  |
| Azure Local VMs <!--ADO--> | Inaccurate power state reporting on Azure for Azure Local VMs when attempting power operations.  | Improved the accuracy of power state reconciliation by reducing latency and fixing a bug that impacted power operations visibility to Azure.  |
| Azure Local VMs <!--ADO--> | Unable to create a gallery image with specified storage path.  | You can now create a gallery image with specified storage path.  |
| Azure Local VMs <!--ADO--> | Running `azcmagent disconnect` deletes the Azure Local VM.  | Don't use `azcmagent disconnect` on Azure Local VMs. Use only `azcmagent disconnect -f` or `azcmagent disconnect --force-local-only`. This command disconnects the connected machine agent and keeps the VM running (no longer deletes). |
| Azure Local VM management | The Mochostagent service might appear to be running but can get stuck without updating logs for over a month. You can identify this issue by checking the service logs in `C:\programdata\mochostagent\logs` to see if logs are being updated. | Run the following command to restart the mochostagent service: `restart-service mochostagent`. |
| Azure Local VMs/Azure Migrate | Migration of Gen 1 (non-sysprep) VMs using Azure Migrate fails with the error: *Failed to clean up seed ISO disk from the file system for VM*. | Migration of Gen 1 (non-sysprep) VMs using Azure Migrate will no longer fail with this error.  |
| Azure Local VMs/Azure Migrate | VM creation from OS disk fails due to incorrect storage precheck. | VM creation succeeds regardless if the source is gallery image or OS disk.  |
| Deployment | When trying to deploy via the Azure portal, Azure Local machine nodes aren't visible in the Azure portal. | Azure Local deployments via the Azure portal are only supported for 2503 and later. For previous versions, [deploy via Azure Resource Manager (ARM) template](./deploy/deployment-azure-resource-manager-template.md). |
| Deployment | During the Azure Local deployment, `DeviceManagementExtension` fails to install when a proxy is configured. | Install previous `DeviceManangementExtension` version 1.2502.0.3012 when using a proxy. |
| Update <!--30345067--> | When updating from version 2408.2.7 to 2411.0.24, the update process could fail with the following error message: `Type 'CauPreRequisites' of Role 'CAU' raised an exception: Could not finish cau prerequisites due to error 'Cannot remove item C:\UpdateDistribution\<any_file_name>: Access to the path is denied.'` | This issue is now fixed. |
| Update <!--30232441--> | Ensure that Solution Builder Extension updates of type *Notify* that have been imported get copied correctly before validation.  |   |
| Update <!--30324217--> | Improved the Solution Extension Secret Location cmdlet help to provide better examples.  |   |
| Update <!--29409214--> | Added retry logic to Cluster-Aware Updating runs and health checks for cluster nodes.   |   |
| Update <!--31104115--> | Increased system stability during the .NET 8 updates.   |   |
| Update <!--ADO--> | With the 2411 release, solution and Solution Builder Extension update aren't combined in a single update run.  |To apply a Solution Builder Extension package, you need a separate update run.|
| Upgrade <!--29558170--> | Disable the Carbon PowerShell module if detected and load the known modules.   | |
| Upgrade <!--30353283--> | Optimized the current Carbon PowerShell module solution.   |  |
| Upgrade <!--30251075--> | Added a check to validate enough free memory to start an Azure Arc resource bridge VM.    |   |
| Security <!--XXXX--> | Mitigation for security vulnerability CVE-2024-21302 was implemented. See the [Guidance for blocking rollback of Virtualization-based Security (VBS) related security updates](https://support.microsoft.com/topic/guidance-for-blocking-rollback-of-virtualization-based-security-vbs-related-security-updates-b2e7ebf4-f64d-4884-a390-38d63171b8d3)   |   |
| Deployment  | During Azure Local deployment via portal, **Validate selected machines** fails with this error message: `Mandatory extension [Lcm controller] installed version [30.2503.0.907] is not equal to the required version [30.2411.2.789] for Arc machine [Name of the machine]. Please create EdgeDevice resource again for this machine to fix the issue.`   | Reinstall the correct version of `AzureEdgeLifecycleManager` extension. Follow these steps: <br> 1. Select the machine and then select **Install extensions**. <br> <br>![Screenshot of extension installation on Azure Local machines.](media/known-issues/select-machine-2.png)<br> <br> 2. Repeat this step for each machine you intend to cluster. It takes roughly 15 minutes for the installation to complete. <br> 3. Verify that the `AzureEdgeLifecycleManager` extension version is 30.2411.2.789. <br><br> ![Screenshot of extension version installed on Azure Local machines that can be validated.](media/known-issues/select-machine-1.png) <br><br> 4. After the extensions are installed on all the machines in the list, select **Add machines** to refresh the list. <br> 5. Select **Validate selected machines**. The validation should succeed. |

## Known issues in this release

The following table lists the known issues in this release:

|Feature  |Issue  |Workaround  |
|---------|---------|---------|
| Azure Migrate | Migration of Gen 1 (non-sysprep) VMs using Azure Migrate fails with the error: *Failed to clean