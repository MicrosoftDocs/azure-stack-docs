---
title: Maintain static IP addresses during migration (preview)
description: Learn how to maintain static IP addresses for VMs during migration.
author: alkohli
ms.topic: how-to
ms.date: 12/16/2024
ms.author: alkohli
ms.reviewer: alkohli
---

# Maintain static IP addresses during migration (preview)

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article explains how to preserve static IP addresses during virtual machine (VM) migration to Azure Local using Azure Migrate. It provides detailed instructions for running the static IP migration scripts on Windows VMs, and supporting guest operating systems from Windows Server 2012 R2 and later.

The static IP migration package is available for download at [Windows Static IP Migration Package](https://aka.ms/hci-migrate-static-ip-download) (.zip format).

The .zip file includes the following scripts:

- **Prepare-MigratedVM.ps1** – Prepares the VM for static IP migration using the `-StaticIPMigration` cmdlet, which runs the *Initialize-StaticIPMigration.ps1* script.

- **Initialize-StaticIPMigration.ps1** - Collects the VM network interface information into a configuration file (*InterfaceConfigurations.json* in the local directory) and sets up a scheduled task to run the *Set-StaticIPConfiguration.ps1* script.

- **Set-StaticIPConfiguration.ps1** - This script runs at VM startup to apply the network interface configuration file generated.

- **Utilities.psm1** - Contains helper functions for the scripts.

> [!NOTE]
> Static IP address migration is currently available only for Windows VMs, and is not supported for Linux VMs.

## Prerequisites

Prepare the source and target environments for IP migration:

### Prepare source environment for IP migration

To migrate VMs with static IPs from Hyper-V or VMware, ensure the following are completed:

- The VMs are powered on throughout the replication process and up to planned failover (migration).

- For VMware VMs, **VMware Tools** are installed.  

- For Hyper-V VMs, that **Hyper-V Integration Services** are installed. For non-Windows VMs, that **Linux Integration Services** are installed. For more information, see [Manage Hyper-V Integration Services](/windows-server/virtualization/hyper-v/manage/manage-hyper-v-integration-services).

- The preparation script is run on the source VM by an account with administrator privileges to create scheduled tasks.

### Prepare target Azure Local instance for IP migration

On the target system, provision a static Azure Arc logical network to support the migration. This setup requires defining the IP address space, gateway address, DNS servers, and optionally an IP pool range.

For detailed guidance on creating and configuring static or dynamic Azure Arc logical networks, see [Create logical networks for Azure Local](../manage/create-logical-networks.md?tabs=azurecli).

### (Optional) Prepare to deploy IP migration at scale using Group Policy

To use this method, you need domain administrator privileges and access to the Group Policy Editor. Additionally, one of the following conditions must be met:

- The source VMs must have internet access to download the static IP migration package directly to their local file system.

- The source VMs must have read-only access to a remote file share hosting the static IP migration package, which must be prepared and downloaded to the remote share in advance.

## Setup IP migration manually

1. Download the .zip file and install the static IP migration package contents onto a local folder on the VM.

1. Open a PowerShell console and run the *Prepare-MigratedVM.ps1* script with the following command:

```powershell
.\Prepare-MigratedVM.ps1 -StaticIPMigration  
```

1. In Azure portal, follow the standard process to create a migration project, trigger discovery, and replicate the VM. For more information, see [Create an Azure Migrate project](migration-options-overview.md).

1. Before you select the VMs to migrate, use the Replication Wizard to assign and configure the correct logical networks for each NIC on the source VM.

1. In the **Replications > General > Compute and Network** section, select **VM**. On this tab, ensure that the NICs are assigned to the correct logical network. DHCP NICs are assigned to dynamic logical networks, and static NICs are assigned to static logical networks. See the following:

    :::image type="content" source="./media/migrate-maintain-ip-addresses/compute-network.png" alt-text="Screenshot of Compute and Network page ." lightbox="./media/migrate-maintain-ip-addresses/compute-network.png":::

    Failure to correctly assign the NICs to their corresponding logical networks results in incorrect IP address information displayed in Azure Arc and Azure portal.

1. On the **Migrate** view, under **Shut down virtual machines**, select **Yes, shut down virtual machines (ensures no data loss)**:

    :::image type="content" source="./media/migrate-maintain-ip-addresses/shutdown-vms.png" alt-text="Screenshot of Shut down VMs panel." lightbox="./media/migrate-maintain-ip-addresses/shutdown-vms.png":::

1. After the VM is migrated, check the migrated VM to verify that the static IP settings were migrated over.

## Setup IP migration using Group Policy

To setup static IP migration at scale on domain-joined VMs using Group Policy, follow these steps:

1. Review the prerequisites listed for static IP migrations using Group Policy.

### Create a Group Policy Object

1. Open the Group Policy Management Console for your Active Directory (AD)environment.

1. In your AD forest, navigate to the location that contains the VMs you want to migrate with preserved static IPs.

1. Right-click and select **Create a GPO on this domain, and Link it here**.

1. When prompted, assign a descriptive name to this GPO:

    :::image type="content" source="./media/migrate-maintain-ip-addresses/group-policy-management.png" alt-text="Screenshot of ." lightbox="././media/migrate-maintain-ip-addresses/group-policy-management.png":::

1. Edit the GPO:

    1. Right-click the newly created GPO and select **Edit**.

    1. In the Group Policy Management Editor, go to **Computer Configuration > Preferences > Control Panel Settings > Scheduled Tasks**.

1. Right-click the blank area under **Scheduled Tasks** and select **New > Immediate Task (At least Windows 7)**.

### Define the scheduled task

1. Select **New > Immediate Task**. When the Scheduled Task Wizard opens, configure each tab as follows:

1. On the **General** tab, under **Action**, select  **Create** and enter a descriptive name for the task.

1. Under **Security Options**, select the following settings:

    1. When running the task, use the following user account **NT AUTHORITY\SYSTEM**.

    1. Select **Run whether user is logged on or not**.

    1. Select**Run with highest privileges**.

1. Under **Configure for**, select **Windows Vista or Windows Server 2008** for configuration:

    :::image type="content" source="./media/migrate-maintain-ip-addresses/ip-migration-properties.png" alt-text="Screenshot of IP migration properties dialog box." lightbox="././media/migrate-maintain-ip-addresses/ip-migration-properties.png":::

1. On the **Actions** tab, select  **New** under the **Actions** tab.

1. Under **Action**,  select **Start a program**.

1. Under **Settings**:

    1. Run *Program/script: Type powershell.exe*.

    1. If your VMs can access the download link for the .zip file, add the following arguments, replacing the parameters in brackets:

        ```azurepowershell
        -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri [download link] -OutFile [path to static IP migration package] ; Expand-Archive Path [path to static IP migration package] -DestinationPath C:\StaticIp ; & C:\StaticIp\Prepare-MigratedVM.ps1 -StaticIPMigration
        ```   
    1. (Alternate) If you have a remote share hosting the .zip file, add the following arguments, replacing the parameters in brackets:

    ```azurepowershell
    -ExecutionPolicy Bypass -Command "Copy-Item -Path [ZIP file path in remote share] -Destination [path to static IP migration package] -Force ; Expand-Archive -Path [path to static IP migration package] DestinationPath C:\StaticIp ; & C:\StaticIp\Prepare-MigratedVM.ps1 -StaticIPMigration
    ``` 

1. Select an **Action**, **Program/script**, add optional **arguments**, and optional **Start in** information as shown:  

    :::image type="content" source="./media/migrate-maintain-ip-addresses/start-program.png" alt-text="Screenshot of Action page." lightbox="./media/migrate-maintain-ip-addresses/start-program.png":::

1. Select **OK** to finalize the scheduled task configuration.

### Apply the Group Policy Object

1. Link the GPO to the desired Organizational Unit (OU):

    1. If the GPO is not already linked, right-click the desired OU in the Group Policy Management Console and select **Link an existing GPO**.

    1. Select the GPO you created.

1. Wait for replication to complete. After 10-20 minutes, the Group Policy Object replicates to the respective domain controllers. You can also force the policy update by running the `gpupdate` cmdlet in PowerShell on a specific VM.

1. Verify the changes:

    1. Check the VM to confirm that an interface configuration file has been created under *C:\StaticIp\IpConfigurations.json*.

    1. Ensure that a scheduled task named `Set-StaticIpConfiguration` has been created to run on restart.

## Known limitations

There are a couple of limitations regarding the network interface information displayed in Azure portal.

**Static network interfaces with static logical networks**

For static network interfaces created using a static logical network, Azure portal may not display the correct IP address, even if the static IP migration scripts were run and the correct IP addresses were transferred to the migrated VM.

The Arc Resource Bridge defaults to selecting the first IP address marked as available on the underlying logical network subnet and displays that in Azure portal. On-demand modification of this IP address is not supported at this time. This limitation does not apply to dynamic network interfaces created using a dynamic logical network. 

Azure portal should display the correct IP address that were assigned to the DHCP-enabled NIC on the migrated VM, provided that the prerequisites are met and Hyper-V Manager is able to view the IP address of the network interface on the VM.

**Old network adapter information in Device Manager**

Device Manager may still show the old network adapter information pre-migration. While this does not affect the new network adapter created post-migration and will not cause IP conflicts, the script doesn't currently delete this old registration, so it remains visible.

## Next steps

- Read [Overview of Azure Migrate based migration for Azure Local](migration-azure-migrate-overview.md).
- Read [Overview of Azure Migrate based VMware migration for Azure Local](migration-azure-migrate-vmware-overview.md)
