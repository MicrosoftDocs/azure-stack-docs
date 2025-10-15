---
title: Maintain static IP addresses during migration
description: Learn how to maintain static IP addresses for VMs during migration.
author: alkohli
ms.topic: how-to
ms.date: 10/15/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Maintain static IP addresses during migration

[!INCLUDE [hci-applies-to-2503](../includes/hci-applies-to-2503.md)]

This article explains how to preserve static IP addresses during virtual machine (VM) migration to Azure Local using Azure Migrate. It provides detailed instructions for running the static IP migration scripts on Windows and Linux VMs.

This article applies to migration of Hyper-V VMs (Preview) and VMware VMs.

## About the static IP migration package

For Windows VMs, this article supports guest operating systems from Windows Server 2012 R2 and later. For Linux VMs, it supports Ubuntu, Red Hat Enterprise Linux, CentOS, and Debian distributions.

Download the [static IP migration package](https://aka.ms/hci-migrate-static-ip-download) (.zip format). The .zip file includes different scripts for Windows and Linux VMs.

# [Windows](#tab/windows)

The following scripts are included for Windows:

- **Prepare-MigratedVM.ps1** – Prepares the VM for static IP migration using the `-StaticIPMigration` cmdlet, which runs the *Initialize-StaticIPMigration.ps1* script.

    Logs are automatically created in the script's directory.

- **Initialize-StaticIPMigration.ps1** - Collects the VM network interface information into a configuration file (*InterfaceConfigurations.json* in the local directory) and sets up a scheduled task to run the *Set-StaticIPConfiguration.ps1* script.

- **Set-StaticIPConfiguration.ps1** - Runs at VM startup to apply the network interface configuration file generated.

- **Utilities.psm1** - This script contains helper functions for the scripts.

# [Linux](#tab/linux)

The following scripts are included for Linux:

- **prepare_migrated_vm.sh** – Prepares the VM for static IP migration using the `-o StaticIPMigration` option. It executes the *initialize_static_ip_migration.sh* script.

- **initialize_static_ip_migration.sh** - Collects the VM's network interface information into a configuration file (*interface_configurations* in the local directory) and installs a cron job to execute the *set_static_ip_configuration.sh script*. 

- **set_static_ip_configuration.sh** - Runs at VM startup to apply the network interface configuration file generated.

- **utilities.sh** – This script contains helper functions for the scripts.

---

## Prerequisites

# [Windows](#tab/windows)

Before you begin, prepare the source and target environments for IP migration.

### Prepare source VMs for IP migration

To migrate Windows VMs with static IPs from the source system (Hyper-V or VMware), make sure the following requirements are met.

[!INCLUDE [static-ip-migration-prerequisites](../includes/static-ip-migration-prerequisites.md)]

- Ensure the preparation script is run on the source VM by an account with administrator privileges to create scheduled tasks.

[!INCLUDE [static-ip-migration-prepare-target](../includes/static-ip-migration-prepare-target.md)]

### (Optional) Prepare to deploy IP migration at scale using group policy

 To use this method, you need domain administrator privileges and access to the Group Policy Editor. Additionally, one of the following conditions must be met:

- The source VMs must have internet access to download the static IP migration package directly to their local file system.

- The source VMs must have read-only access to a remote file share hosting the static IP migration package, which must be prepared and downloaded to the remote share in advance.

# [Linux](#tab/linux)

Before you begin, prepare the source and target environments for IP migration.

### Prepare source VMs for IP migration

To migrate Linux VMs with static IPs from the source system (Hyper-V or VMware), make sure the following requirements are met.

[!INCLUDE [static-ip-migration-prerequisites](../includes/static-ip-migration-prerequisites.md)]

- For Linux VMs, ensure that **Linux Integration Services** are installed.

- Ensure the preparation script is run on the source VM by an account with administrator privileges to create scheduled tasks. For Linux VMs, the account should also have the appropriate privileges to run network administration commands (such as `ip`, `resolvectl`, and its variants).

[!INCLUDE [static-ip-migration-prepare-target](../includes/static-ip-migration-prepare-target.md)]

---

## Set up IP migration

Follow these steps to set up IP migration. The steps are different for Windows and Linux VMs.

# [Windows](#tab/windows)

For Windows VMs, you can set up IP migration manually or by using group policy.

### Set up IP migration manually

To set up IP migration manually for Windows VMs:

1. Download the .zip file and install the static IP migration package contents onto a local folder on the VM.

1. Open PowerShell as an administrator and run the *Prepare-MigratedVM.ps1* script with the following command:

    ```powershell
    .\Prepare-MigratedVM.ps1 -StaticIPMigration  
    ```

1. In the Azure portal, create a migration project, trigger discovery, and replicate the VM. For more information, see [Create an Azure Migrate project](migration-options-overview.md).

1. Before you select the VMs to migrate, use the Replication Wizard to assign and configure the correct logical networks for each network interface on the source VM.

1. In the **Replications > General > Compute and Network** section, select **VM**. On this tab, ensure that the network interfaces are assigned to the correct logical network. DHCP network interfaces are assigned to dynamic logical networks, and static network interfaces are assigned to static logical networks.

    :::image type="content" source="./media/migrate-maintain-ip-addresses/compute-network.png" alt-text="Screenshot of Compute and Network page." lightbox="./media/migrate-maintain-ip-addresses/compute-network.png":::

    Failure to correctly assign the network interfaces to their corresponding logical networks results in incorrect IP address information displayed in Azure Local and Azure portal.

1. On the **Migrate** view, under **Shut down virtual machines**, select **Yes, shut down virtual machines (ensures no data loss)**.

    :::image type="content" source="./media/migrate-maintain-ip-addresses/shut-down-vms.png" alt-text="Screenshot of Shut down VMs panel." lightbox="./media/migrate-maintain-ip-addresses/shut-down-vms.png":::

1. After the VM is migrated, check the migrated VM to verify that the static IP settings were migrated over.

### Set up IP migration using group policy

Follow these steps to set up static IP migration at scale on domain-joined VMs using group policy.

- Review the prerequisites listed for static IP migrations using group policy.

#### Create a group policy object

1. Open the Group Policy Management Console for your Active Directory (AD) environment.

1. In your AD forest, navigate to the location that contains the VMs you want to migrate with preserved static IPs.

1. Right-click and select **Create a GPO on this domain, and Link it here**.

1. When prompted, assign a descriptive name to this Group Policy Object (GPO):

    :::image type="content" source="./media/migrate-maintain-ip-addresses/group-policy-management.png" alt-text="Screenshot of the GPO menu item." lightbox="././media/migrate-maintain-ip-addresses/group-policy-management.png":::

1. Edit the GPO:

    1. Right-click the newly created GPO and select **Edit**.

    1. In the Group Policy Management Editor, go to **Computer Configuration > Preferences > Control Panel Settings > Scheduled Tasks**.

1. Right-click the blank area under **Scheduled Tasks** and select **New > Immediate Task (At least Windows 7)**.

#### Define the scheduled task

1. Select **New > Immediate Task**. When the Scheduled Task Wizard opens, configure each tab as follows:

1. On the **General** tab, under **Action**, select  **Create** and enter a descriptive name for the task.

1. Under **Security Options**, select the following settings:

    1. When running the task, use the following user account **NT AUTHORITY\SYSTEM**.

    1. Select **Run whether user is logged on or not**.

    1. Select **Run with highest privileges**.

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

#### Apply the group policy object

1. Link the GPO to the desired Organizational Unit (OU):

    1. If the GPO isn't already linked, right-click the desired OU in the Group Policy Management Console and select **Link an existing GPO**.

    1. Select the GPO you created.

1. Wait for replication to complete. After 10-20 minutes, the group policy object replicates to the respective domain controllers. You can also force the policy update by running the `gpupdate` cmdlet in PowerShell on a specific VM.

1. Verify the changes:

    1. Check the VM to confirm that an interface configuration file has been created under *C:\StaticIp\IpConfigurations.json*.

    1. Ensure that a scheduled task named `Set-StaticIpConfiguration` has been created to run on restart.

# [Linux](#tab/linux)

For Linux VMs, follow these steps to set up IP migration manually.

### Set up IP migration manually

To set up IP migration manually for Linux VMs:

1. Download the .zip file and install the static IP migration package contents onto a local folder on the VM.

1. Open a terminal session and run the *prepare_migrated_vm.sh* script with the following commands:

    ```Bash
    chmod u+x prepare_migrated_vm.sh 
    sudo ./prepare_migrated_vm.sh -o StaticIPMigration 
    ```

1. In the Azure portal, create a migration project, trigger discovery, and replicate the VM. For more information, see [Create an Azure Migrate project](migration-options-overview.md).

1. Before you select the VMs to migrate, use the Replication Wizard to assign and configure the correct logical networks for each network interface on the source VM.

1. In the **Replications > General > Compute and Network** section, select **VM**. On this tab, ensure that the network interfaces are assigned to the correct logical network. DHCP network interfaces are assigned to dynamic logical networks, and static network interfaces are assigned to static logical networks.

    :::image type="content" source="./media/migrate-maintain-ip-addresses/compute-network.png" alt-text="Screenshot of Compute and Network page." lightbox="./media/migrate-maintain-ip-addresses/compute-network.png":::

    Failure to correctly assign the network interfaces to their corresponding logical networks results in incorrect IP address information displayed in Azure Local and Azure portal.

1. On the **Migrate** view, under **Shut down virtual machines**, select **Yes, shut down virtual machines (ensures no data loss)**.

    :::image type="content" source="./media/migrate-maintain-ip-addresses/shut-down-vms.png" alt-text="Screenshot of Shut down VMs panel." lightbox="./media/migrate-maintain-ip-addresses/shut-down-vms.png":::

1. After the VM is migrated, check the migrated VM to verify that the static IP settings were migrated over.

---

## Known limitations

These are the known limitations and display issues when migrating static IP addresses:  

### Old network adapter information in Device Manager

After migration, Device Manager may still display the old network adapter information from pre-migration. While this doesn't affect the new network adapter created post-migration and won't cause IP conflicts, the script doesn't currently delete this old registration, so it remains visible.

### Multiple IP addresses on a single network adapter

When the source VM has multiple static IP addresses assigned to a single network adapter, those IP addresses are correctly assigned on the migrated VM. However, Azure Local VMs enabled by Azure Arc in Azure Local display only one IP address per network adapter in Azure portal. This is a known display issue in the Azure Local portal and does not affect the actual functionality of the IP addresses on the migrated VM.

### Multiple network adapters and types

If the source VM has multiple network adapters with a mix of DHCP and static configurations, the migrated VM will preserve the correct number of network adapter, network adapter types, and static IP addresses on the static network adapter. However, the Azure Local portal view of the migrated VM may incorrectly display duplicate or inaccurate IPs on the network adapters. This is a known display issue in the Azure Local portal and doesn't impact the functionality of the IP addresses on the migrated VM. See the example below of a migrated VM with a DHCP network adapter and a static network adapter.

:::image type="content" source="./media/migrate-maintain-ip-addresses/display-issue.png" alt-text="Screenshot of network adapters." lightbox="./media/migrate-maintain-ip-addresses/display-issue.png":::

### IPv6 static IP addresses not supported

Azure Local VMs currently only support IPv4 addresses. NICs configured with IPv6 addresses will not be migrated, as IPv6 is not supported.

## Logs

When configuring static IP migration for VMs using the *Prepare-MigratedVM.ps1* or *prepare_migrated_vm.sh* script, logs are automatically created in the script's directory.

## Next steps

- Read [Overview of Azure Migrate based migration for Azure Local](migration-azure-migrate-overview.md).
- Read [Overview of Azure Migrate based VMware migration for Azure Local](migration-azure-migrate-vmware-overview.md)
