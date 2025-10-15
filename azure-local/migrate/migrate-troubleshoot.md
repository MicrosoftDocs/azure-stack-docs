---
title: Troubleshoot issues when migrating VMs to Azure Local using Azure Migrate
description: Learn about how to troubleshoot issues when migrating Windows VMs to your Azure Local instance using Azure Migrate.
author: alkohli
ms.topic: how-to
ms.date: 10/15/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.custom:
  - linux-related-content
  - sfi-image-nochange
---

# Troubleshoot issues migrating VMs to Azure Local via Azure Migrate

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to troubleshoot any potential issues that you may experience when migrating Hyper-V (Preview) and VMware VMs to your Azure Local using Azure Migrate.


## Check if required services are running

Make sure that the source appliance VM and the target appliance VM have a healthy configuration by ensuring the following services are running.

Open PowerShell as an Administrator and run the following command for each of the services listed in parentheses for the source appliance and target appliance to verify they are running:

```powershell
Get-Service -Name <name_of_service>
``````

**On the source appliance VM**:
  
- Microsoft Azure Gateway Service (*asrgwy*)
- Microsoft Azure Hyper-V Discovery Service (*amhvdiscoverysvc*)
- Azure Site Recovery Management Service (*asrmgmtsvc*)

**On the target appliance VM**:
 
- Microsoft Azure Gateway Service (*asrgwy*)
- Azure Site Recovery Management Service (*asrmgmtsvc*)
    
Configuration data can be found at *C:\ProgramData\Microsoft Azure\Config*.

## Collect logs and information


If you experience any issues, before you open a Support ticket, collect the following information about your issues and share them with the Microsoft Support team for analysis.

- Logs from Azure Migrate appliance
- Description of the issue or feedback
- Subscription ID 
- Tenant ID 
- Azure Migrate project name
- Azure Migrate project region or geography
- VM name for issues in replication and migration 
- Correlation ID for deployment or job ID


The following sections describe how to gather this information based on the operation or the issue type.
 
### For user triggered operations from Azure portal

To troubleshoot user triggered operations, correlation ID or a job ID are needed.

#### Get correlation ID for a deployment

Failures in operations like creating or deleting a migrate project, creation of appliance artifacts, entities and storage accounts, errors are shown as failures in **Deployments** section of the migrate project resource group. Each deployment operation also has a **Correlation ID** that is useful for troubleshooting.

Additionally failed operations in the session are shown as notifications or in activity logs from older history.

Follow these steps to identify the correlation ID for your deployment in Azure portal:

1. Go to the resource group for your Azure Migrate project and then go to **Overview**. In the right-pane, select the hyperlink that shows failed and successful deployments.

    :::image type="content" source="./media/migrate-troubleshoot/get-correlation-id-1.png" alt-text="Screenshot Azure Migrate project resource group > Overview in Azure portal.":::
  
1. Identify the deployment that you want the correlation ID for and select the deployment name.

    :::image type="content" source="./media/migrate-troubleshoot/get-correlation-id-2.png" alt-text="Screenshot Azure Migrate project resource group > Deployments in Azure portal.":::
 
1. Find the correlation ID.

    :::image type="content" source="./media/migrate-troubleshoot/get-correlation-id-3.png" alt-text="Screenshot Azure Migrate project resource group > Deployments > Your deployment > Overview in Azure portal.":::
 

#### Get job ID for replication or migration

Operations such as creating and deleting a protected item (also known as creating and deleting a replication) and planned failover (also known as migration) are also listed as **Jobs** in the Azure Local migration section of the portal.

In these cases, the **Job ID** needs to be collected as well.

Follow these steps to get the job ID:

1. In your Azure Migrate project in the Azure portal, go to **Overview** under **Migration tools**.

    :::image type="content" source="./media/migrate-troubleshoot/get-job-id-1.png" alt-text="Screenshot Azure Migrate project > Migration tools > Overview in Azure portal.":::

1. In the left-pane, go to **Azure Local migration > Jobs**.

1. Identify the job that you want the job ID for and select the job name.

    :::image type="content" source="./media/migrate-troubleshoot/get-job-id-2.png" alt-text="Screenshot Azure Migrate project > Migration tools > Overview > Azure Local migration > Jobs > Your job in Azure portal.":::

1. Find the **Job Id**.

    :::image type="content" source="./media/migrate-troubleshoot/get-job-id-3.png" alt-text="Screenshot Azure Migrate project > Migration tools > Overview > Azure Local migration > Jobs >  Your job > Create or update protected item in Azure portal.":::

### For scheduled replication operations  

Failures in scheduled operations like hourly replication cycle failures are listed as **Events** under Azure Local migration section of the portal.

To troubleshoot replication issues, collect the following information:

- Error details shown in the events that include Time, Error ID, Error message, VM ID.
- Screenshots of Azure portal if possible.  
   
### For UX issues in portal  

To troubleshoot UX issues in portal, collect the following information:

- Screenshots from Azure portal.
- Record the operations in browser developer mode. Export the *HAR* file and share it.

### For appliance registration issues

To troubleshoot appliance registration issues, collect the following information:

- All the available logs on the appliance at *C:\ProgramData\MicrosoftAzure\Logs*.

### For discovery issues

To troubleshoot discovery issues, collect the following information:

- All available logs on the source appliance at *C:\ProgramData\MicrosoftAzure\Logs\HyperV\Discovery*.

For more information, see [Troubleshoot Discovery](/azure/migrate/troubleshoot-discovery).

### For special issues

If needed, Microsoft Support may also request component event viewer logs, or system event logs such as Hyper-V logs and SMB logs.


## Common issues and resolutions

### Azure Migrate project creation fails

**Root cause** 

The Azure Migrate project creation fails if the Azure subscription isn't registered for Azure Migrate or if the user doesn't have the required permissions to create a project.

**Recommended resolution** 

Verify the following:
- Make sure that you have **Application Administrator** role on the Azure AD tenant.
- Make sure that you have the **Contributor** and **User Access Administrator** roles on the Azure subscription.
- Make sure that you're selecting one of the supported regions for Azure Migrate project creation. For a list of supported regions, see [Supported geographies](migrate-hyperv-requirements.md).


### Target system validation fails on appliance

**Root cause**

The target system fails to validate because the FQDN is not DNS-resolvable by default from the appliance.

:::image type="content" source="./media/migrate-troubleshoot/cluster-fqdn.png" alt-text="Screenshot of Add Cluster Information page." lightbox="./media/migrate-troubleshoot/cluster-fqdn.png":::

**Recommended resolution**

If the target machine validation step fails during migration, follow these steps to resolve the issue:

1. Manually map the Azure Local IP to its corresponding FQDN:

    1. Edit the hosts file located at C:\Windows\System32\drivers\etc\hosts. 

    1. Add a new line using the format: 
        `<Cluster IP>    <Cluster FQDN>`

1. Verify the FQDN is reachable by ensuring that the system FQDN can be successfully pinged from the source appliance.

1. Enable WinRM on each target cluster node (if not already enabled). Run the following PowerShell command on each machine:
 
    ```PowerShell
        Enable-PSRemoting -Force
    ```

1. Test remote PowerShell connectivity. From the source appliance, ensure the following command completes successfully:

    ```PoweShell
        Enter-PSSession -ComputerName <Cluster FQDN> -Credential $Cred
    ```

1. Confirm required ports are open. See Prerequisites section to ensure all necessary ports are allowed between the source appliance and the Azure Local instance.

### Deleting or changing target system information from Source Appliance Configuration Manager doesn't work.

**Root cause** 
When providing information in the Source Appliance Configuration Manager, the target system name can't be changed once entered.


**Recommended resolution**
Follow these steps to delete or change the target system from the Source Appliance Configuration Manager:

1. On your source appliance, open Explorer. Go to *C:\ProgramData\Microsoft Azure\CredStore* and delete the  *TargetClusterCredentials.json*.

1. Reload Appliance Configuration Manager and you are able to enter new values for the target system.

> [!NOTE]
> This workaround is not recommended if you have started the replication. 
> 
> This workaround can be used only if the appliance is not registered. If the appliance is registered, you must [Remove the appliance from the project](#target-appliance-issues). You should then generate a new project key and reinstall the appliance.


### Target appliance registration fails

**Root cause** 

The target appliance registration fails. 

**Recommended resolution** 

Refresh the page and try registering again.

### Target appliance issues

**Root cause** 
 
In some instances, you may need to remove the target appliance from the project. For example, if you want to move the appliance to a different subscription or region. That would require you to remove the target appliance and create a new one in the new subscription or region.

**Recommended resolution** 

To remove the target appliance from the project, follow these steps:

1. Run PowerShell as an administrator.
1. Run the following command to remove the appliance:
    
    ```powershell
    .\AzureMigrateInstaller.ps1 -RemoveAzMigrate
    ```

### VM replication fails

**Root cause** 

Replication of VMs can fail because of one or more of the following reasons:
- The cluster shared volume or the storage container is full.
- The VMs aren't highly available. All VMs must be highly available to be discovered for replication and migration. If VMs aren't highly available, these don't show up in the list and are excluded for migration.

**Recommended resolution** 

To enable replication and migration, make sure that the cluster shared volume or the storage container has enough space. 

Also, to migrate a non-HA VM, follow these steps: 

1. You first need to make the VM highly available. For more information, see [Make Hyper-V VMs highly available](https://www.thomasmaurer.ch/2013/01/how-to-make-an-existing-hyper-v-virtual-machine-highly-available/). 
1. Wait for discovery agent to sync the data. 

Alternatively, go to Azure Migrate and select **Refresh** to manually refresh **Servers, databases, and web apps** to help expedite the discovery agent synchronization. 


### Replication or migration fails with error value can't be null

**Root cause** 

Replication or migration fails with the following error message:

Value can't be null. Parameter name: `FetchingHyperVDiskPropertiesFailed`.

The component fails to fetch the disk properties from the source Hyper-V host. This can happen if the underlying cluster virtual disk is offline or if the disk isn't in a healthy state.


**Recommended resolution** 

1.  Make sure the cluster disks are operational and verify that you can fetch disk properties.
2. On the source appliance, run PowerShell as an administrator. Run the following steps after replacing the content in {} with the actual values.

    ```powershell
    $ImageMgmtService = Get-WmiObject -Class "Msvm_ImageManagementService" -Namespace "root\virtualization\v2" -ComputerName "{HyperVHostOwningTheVM}" -Credential {$CredentialsToHyperVHost}
    
    $ImageMgmtService.GetVirtualHardDiskSettingData("{DiskPathShownInTheMessage}").
    ```
3. In the output that is returned, verify the properties `MaxInternalSize` and `ParentPath` in `SettingData` XML are appropriate.

### Disks on migrated VMs are offline

**Root cause**

The disks on the migrated Windows VMs and Linux VMs may not come online. 

Migration creates a new VHD/VHDX, which results in a new disk for the OS on the migrated VM.  

For Windows VMs, the OS sees this as a new drive and applies storage area network (SAN) policy. The OS will then not make the disk online as it is considered a shared disk. 

**Recommended resolution** 

**For Windows VMs**

To ensure that all migrated disks come online, set the SAN policy to **OnlineAll**. 

Configure this setting manually as follows: 

1. On the on-premises virtual machine (not the host server) prior to migration, open an elevated command prompt. 

1. Enter **diskpart**. 

1. Enter **SAN**. If the drive letter of the guest operating system isn't maintained,  **Offline All**  or  **Offline Shared**  is returned. 

1. At the **DISKPART** prompt, enter  **SAN Policy=OnlineAll**. This setting ensures that disks are brought online, and it ensures that you can read and write to both disks. 

1. During migration, you can verify that the disks are brought online. 

**For Linux VMs**

Update **fstab** entries to use persistent volume identifiers prior to migration.  

### Migration fails with unable to delete snapshot error

**Root cause**

Unable to migrate due to the following error:

Error: Failed to delete snapshot with Id(s)  

The Hyper-V VM manual operations on the system were failing with the same error and no manual operations on VM could be done on this server. 

**Recommended resolution** 

To mitigate this error, make sure that the VM is operational. 

Connect to your source appliance and try the following steps to ensure that your migration is smooth.

1. Get the VM ID in error info.

    ```powershell
    $VmId= '146a690f-2e88-4c54-a662-c4e7da70b5e9'
    ```
1. Make sure that get-VM is working fine and returning the information from the source appliance.

    ```powershell
    Get-VM -Id $VmId 
    ```
1. Make sure that get-VHD is working fine and returning the correct information.

    ```powershell
    Get-VHD -VMId $VmId
    ```

1. If snapshot creation operation is failing, make sure that manual snapshot creation is working fine on the VM.

    ```powershell
    Get-VM -Id $VmId | Checkpoint-VM 
    ```

1. If the snapshot deletion operation is failing, make sure snapshot deletion manually is working fine on the VM.

    ```powershell
    Get-VMCheckpoint -Id "TemporarilyCreatedCheckpointIdGuid" | Remove-VMSnapshot
    ```


### Turning off VM on Hyper-V host fails

**Root cause**

During the planned failover, the VM is turned off on the source Hyper-V host via a WMI call. You see error ID: 1000001 or an error message: An internal error has occurred.  

**Recommended resolution** 

You can turn off the VM manually on the source Hyper-V host via PowerShell.

```powershell
# Replace Guid '146..' In below command with actual VM ID.
$Vm = Get-WmiObject -Namespace root\virtualization\v2  -Query "Select * From Msvm_ComputerSystem Where Name ='146a690f-2e88-4c54-a662-c4e7da70b5ef'"

$ShutdownIC = Get-WmiObject -Namespace root\virtualization\v2  -Query "Associators of {$Vm} Where AssocClass=Msvm_SystemDevice ResultClass=Msvm_ShutdownComponent"

$ShutdownIC.InitiateShutdown("TRUE", "Need to shutdown")
```

### Migration fails with address is already in use error

**Root cause**

This error typically occurs during migration of VMs configured to retain their static IP address. If the target logical network already has the same IP assigned to another network interface, migration fails with the following message:  

`The moc-operator network interface service returned an error while reconciling: rpc error: code = Unknown desc = The address is already in use: Already Set`.

**Recommended resolution**

Complete the following steps:

1. Navigate to the Azure Local logical network that the migrated VM is targeting. 
1. Verify that the intended IP address isn't currently assigned to another network interface.
1. Update the logical network configuration as needed to ensure no IP conflicts exist before retrying the migration.

### Clean up resources from failed migrations

**Root cause**

In some cases, migrations to Azure Local may fail during the migration phase, such as during planned failover, not during initial replication. When this occurs, manual cleanup of partially created resources may be required to ensure future migration attempts are successful.

**Recommended resolution**

To determine where the failure occurred, open the Planned failover job in the Azure Migrate portal. Use the job details to identify whether the failure occurred before or after VM creation on the Azure Local instance.

*If the failure occurred before VM creation*

Task failures listed above the red line (above the **Preparing protected entities** task) indicate that no target VM was created. No cleanup is required and you can retry migration directly.

:::image type="content" source="./media/migrate-troubleshoot/before-vm-creation.png" alt-text="Screenshot of Planned failover page before creation." lightbox="./media/migrate-troubleshoot/before-vm-creation.png":::

*If the failure occurred during or after VM creation*

Task failures listed below the red line (**Preparing protected entities** task and below) indicate that a target VM was partially or fully created. Manual cleanup is required before retrying migration.

:::image type="content" source="./media/migrate-troubleshoot/after-vm-creation.png" alt-text="Screenshot of Planned failover page after creation." lightbox="./media/migrate-troubleshoot/after-vm-creation.png":::

1. In Azure portal, navigate to the target Azure Local instance.

1. Locate and verify if a VM corresponding to the failed migration exists.

1. If found, delete the VM from the portal.

    :::image type="content" source="./media/migrate-troubleshoot/delete-vm.png" alt-text="Screenshot showing Delete button for selected virtual machine." lightbox="./media/migrate-troubleshoot/delete-vm.png":::

1. Connect to the Azure Local instance directly (via Hyper-V Manager) and confirm that the associated VM was also removed from the local Hyper-V host. If it wasn't removed, manually delete the VM resource.

1. Don't delete any of the following resources that may have been created:

    - Migrated (target) disk.

    - Seed disk.

    - Network interfaces.

    These resources will be reused automatically by Azure Migrate during subsequent migration attempts.

### Migrated VM data disks show as 1GB in Azure Portal

When you migrate a VM with one or more data disks attached, Azure Portal may incorrectly display the total data disk size as **1 GB**.

**Root cause**

This is a display issue only and doesn't affect the actual functionality or size of the VM's data disks.


**Recommended resolution**

To correct the display issue in Azure portal and reflect the true data disk size, follow the steps at [Expand a data disk](../manage/manage-arc-virtual-machine-resources.md?&tabs=azurecli#expand-a-data-disk) to reapply the same size as the current data disk (no actual size increase is required).

This triggers a portal refresh and updates the UX to reflect the correct data disk size.


## Next steps

Depending upon the phase of migration you are in, you may need to review one of the following articles to troubleshoot issues:

- [Troubleshoot discovery issues](/azure/migrate/troubleshoot-discovery).
- [Troubleshoot Azure Migrate projects](/azure/migrate/troubleshoot-general).
- [Troubleshoot with appliance diagnostics](/azure/migrate/troubleshoot-appliance-diagnostic).
