---
title: Migrate VMs to Azure Local in Azure Government using Azure Catalyst (preview)
description: Learn how to migrate VMware and Hyper-V VMs to Azure Local in Azure Government using Azure Catalyst (preview), including the steps that differ from the Azure public cloud.
author: trumanbrown
ms.author: trumanbrown
ms.topic: how-to
ms.date: 11/13/2026
ms.service: azure-local
ms.subservice: hyperconverged
ai-usage: ai-assisted
---

# Migrate VMs to Azure Local in Azure Government using Azure Catalyst (preview)

[!INCLUDE [hci-applies-to-2503](../includes/hci-applies-to-2503.md)]

This article describes how to migrate VMware and Hyper-V virtual machines (VMs) to Azure Local in Azure Government using Azure Catalyst (formerly Azure Migrate). Most of the migration process is the same as in the Azure public cloud. This article covers the steps that differ and links to the existing articles for the rest.

[!INCLUDE [important](../includes/hci-preview.md)]

## What's different in Azure Government

| Area | Azure public cloud | Azure Government |
|---|---|---|
| Azure portal | `portal.azure.com` | `portal.azure.us` |
| Portal experience | New Azure Migrate experience | Classic Azure Migrate experience |
| Create project | **Get started** > **Start migration journey** | **Get started** > **Discover, assess and migrate** > **Create project** |
| Project geography | Asia-Pacific, Europe, or United States | Azure Government, with metadata stored in US Gov Virginia or US Gov Arizona |
| Start discovery | Project **Overview** > **Start discovery** | **Migration and modernization** > **Discover** |
| Appliance download | .ova file (VMware), .vhd file (Hyper-V), or .zip file | .zip file only |
| Appliance installer parameter | `-Cloud Public` | `-Cloud USGov` |
| Appliance URLs | [Public cloud URLs](/azure/migrate/migrate-appliance#public-cloud-urls) | [Government cloud URLs](/azure/migrate/migrate-appliance#government-cloud-urls) |
| Generate target appliance key | **Appliances** tab of the **Replicate** wizard | **Specify intent** > **Download and configure** |
| Replicate and migrate VMs | Project > **Server replication** | **Migration tools** > **Overview** > **Azure Local migration** > **Replications** |

The **Replicate** wizard, the **Migrate** page, Azure Arc resource reuse, Trusted Launch VM migration, and the PowerShell, Azure CLI, and Terraform workflows work the same way as in the Azure public cloud.

## Prerequisites

- You have an Azure Government subscription.
- Your Azure Local instance is deployed and registered in US Gov Virginia or US Gov Arizona. For the URLs that Azure Local needs, see [Required firewall URLs for Azure Local in Azure Government regions](../concepts/firewall-requirements.md#required-firewall-urls-for-azure-local-in-azure-government-regions).
- You completed the requirements and prerequisites for your source environment. Skip the step to create a project, and use the steps in this article instead.
    - For VMware, see [Review requirements](migrate-vmware-requirements.md) and [Complete prerequisites](migrate-vmware-prerequisites.md).
    - For Hyper-V, see [Review requirements](migrate-hyperv-requirements.md) and [Complete prerequisites](migrate-hyperv-prerequisites.md).
- The source and target appliances can reach the [Azure Government URLs for the Azure Migrate appliance](/azure/migrate/migrate-appliance#government-cloud-urls) and `*.siterecovery.azure.us`.

## Create an Azure Catalyst project

> [!IMPORTANT]
> To migrate to Azure Local, you must create the Azure Catalyst project in the Azure portal. Azure Local migrations don't support projects that you create by using other methods, such as an Azure Resource Manager (ARM) template, the REST API, Azure CLI, or Azure PowerShell.

1. Sign in to the [Azure portal for Azure Government](https://portal.azure.us).

1. Search for and select **Azure Migrate**.

1. On **Get started**, under **Windows, Linux and SQL Server**, select **Discover, assess and migrate**.

    :::image type="content" source="media/migrate-azure-government/get-started.png" alt-text="Screenshot of the Get started page for Azure Migrate in the Azure Government portal." lightbox="media/migrate-azure-government/get-started.png":::

1. Select **Create project**.

1. On **Create project**:

    1. Select your subscription. Ensure that the subscription is associated with the same Azure tenant as your Azure Local instance.
    1. Select an existing resource group, or create a new one.
    1. Enter a name for the project.
    1. For **Geography**, select **Azure Government**.
    1. Under **Advanced**, keep **Connectivity method** set to **Public endpoint**.

    :::image type="content" source="media/migrate-azure-government/create-project.png" alt-text="Screenshot of the Create project page with Azure Government selected for Geography." lightbox="media/migrate-azure-government/create-project.png":::

1. Select **Create**.

## Set up the source appliance

1. In your project, under **Migration tools** > **Migration and modernization**, select **Discover**.

    :::image type="content" source="media/migrate-azure-government/project-discover.png" alt-text="Screenshot of the Discover option under Migration and modernization in the Azure Government portal." lightbox="media/migrate-azure-government/project-discover.png":::

1. On **Discover**, under **Where do you want to migrate to**, select **Azure Local**.

1. Under **Are your machines virtualized**, select **Yes, with VMware vSphere Hypervisor** or **Yes, with Hyper-V**.

1. Enter a name for your source appliance, and then select **Generate key**. Copy the project key to a text editor such as Notepad and save it for later use.

1. Under **Download Azure Migrate appliance**, select **Download**. In Azure Government, the appliance is available only as a .zip file.

    :::image type="content" source="media/migrate-azure-government/discover-download-zip.png" alt-text="Screenshot of the Discover page in the Azure Government portal, where the appliance is available only as a .zip file." lightbox="media/migrate-azure-government/discover-download-zip.png":::

1. Create a VM for the source appliance with the following configuration. For VMware, create the VM in vCenter. For Hyper-V, create the VM on a Hyper-V host.

    - Operating system: Windows Server 2022 or Windows Server 2025
    - vCPU: 8
    - Disk: >80 GB
    - Memory: 16 GB

1. Sign in to the VM as an administrator. Copy the .zip file to the VM, extract it to a folder, and go to the folder that contains the `AzureMigrateInstaller.ps1` PowerShell script.

1. Open PowerShell as an administrator and run the command for your source environment.

    - For VMware:

        ```powershell
        Set-ExecutionPolicy -ExecutionPolicy Unrestricted
        .\AzureMigrateInstaller.ps1 -Scenario VMware -Cloud USGov -PrivateEndpoint:$false -EnableAzureStackHCITarget
        ```

    - For Hyper-V:

        ```powershell
        Set-ExecutionPolicy -ExecutionPolicy Unrestricted
        .\AzureMigrateInstaller.ps1 -Scenario HyperV -Cloud USGov -PrivateEndpoint:$false -EnableAzureStackHCITarget
        ```

1. Follow the onscreen instructions to install the source appliance. For VMware, select option 1: **Primary appliance to discover, assess and migrate servers**.

1. Restart the VM after the installation is complete. Sign in to the VM.

1. Configure the source appliance and start discovery the same way as in the Azure public cloud:

    - For VMware, follow the steps from [Configure the source appliance and discover VMs](migrate-vmware-replicate.md#configure-the-source-appliance-and-discover-vms) through [Start discovery](migrate-vmware-replicate.md#start-discovery). These steps include installing the VMware Virtual Disk Development Kit (VDDK).
    - For Hyper-V, follow the steps from [Configure the appliance and discover VMs](migrate-hyperv-replicate.md#configure-the-appliance-and-discover-vms) through [Start discovery](migrate-hyperv-replicate.md#start-discovery).

## Set up the target appliance

1. In your project, under **Migration tools** > **Migration and modernization**, select **Replicate**.

1. On **Specify intent**, provide the following inputs:

    - For **What do you want to migrate?**, select **Servers or virtual machines (VM)**.
    - For **Where do you want to migrate to?**, select **Azure Local**.
    - For **Virtualization type**, select **VMware vSphere** or **Hyper-V**.
    - For **On-premises appliance**, select your source appliance.

1. In **Before you start replication to Azure Local**, select **Download and configure**.

1. On the **Deploy and configure the target appliance** pane, enter a name for the target appliance, and then select **Generate key**. Copy the project key to a text editor such as Notepad and save it for later use.

1. Under **Step 2: Download and install the target appliance**, select **Download**. In Azure Government, the appliance is available only as a .zip file.

1. Create a VM on your Azure Local instance with the following configuration:

    - Operating system: Windows Server 2022 or Windows Server 2025
    - vCPU: 8
    - Disk: >80 GB
    - Memory: 16 GB

1. Sign in to the VM as an administrator. Copy the .zip file to the VM, extract it to a folder, and go to the folder that contains the `AzureMigrateInstaller.ps1` PowerShell script.

1. Open PowerShell as an administrator and run the following command:

    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted
    .\AzureMigrateInstaller.ps1 -Scenario AzureLocalTarget -Cloud USGov -PrivateEndpoint:$false
    ```

1. Restart the VM after the installation is complete. Sign in to the VM.

1. Register the target appliance the same way as in the Azure public cloud:

    - For VMware, see [Register the target appliance](migrate-vmware-replicate.md#register-the-target-appliance).
    - For Hyper-V, see [Register the target appliance](migrate-hyperv-replicate.md#register-the-target-appliance).

## Replicate and migrate VMs

After you register both appliances, replicate and migrate VMs from the classic experience. The **Replicate** wizard and the **Migrate** page work the same way as in the Azure public cloud.

1. In your project, under **Migration tools** > **Migration and modernization**, select **Replicate**.

1. On **Specify intent**, select the same values that you used to generate the target appliance key, and then select **Continue**.

1. Complete the **Replicate** wizard, starting with the **Basics** tab:

    - For VMware, see [Start replication](migrate-vmware-replicate.md#step-3-start-replication).
    - For Hyper-V, see [Start replication](migrate-hyperv-replicate.md#step-3-start-replication).

1. To monitor replication, under **Migration tools**, select **Overview**, and then select **Azure Local migration** > **Replications**. Replication and migration operations are listed under **Azure Local migration** > **Jobs**, and replication cycle failures are listed under **Azure Local migration** > **Events**.

1. When the **Migration status** of a VM shows **Ready to migrate**, select **Migrate** on the **Replications** page, or select **Migrate** from the context menu for the VM. The **Migrate** page and the steps to verify the migrated VM are the same as in the Azure public cloud:

    - For VMware, see [Migrate VMware VMs](migrate-vmware-migrate.md).
    - For Hyper-V, see [Migrate Hyper-V VMs](migrate-azure-migrate.md).

1. After you verify the migrated VM, go to **Azure Local migration** > **Replications**, select **...** next to the VM, and then select **Complete migration**.

If your source VMs are Azure Arc-enabled servers, you can keep their existing Azure Arc resources during migration. For more information, see [Reuse Azure Arc-enabled server resources when you migrate VMs to Azure Local](migrate-arc-reuse.md).

### Use PowerShell, Azure CLI, or Terraform

To [migrate VMs by using PowerShell, Azure CLI, or Terraform](migrate-via-powershell.md), connect to Azure Government before you run the commands:

- PowerShell: Run `Connect-AzAccount -Environment AzureUSGovernment`.
- Azure CLI: Run `az cloud set --name AzureUSGovernment`, and then run `az login`.
- Terraform: Set the Azure CLI to Azure Government as shown for Azure CLI, and set `environment = "usgovernment"` in the `azapi` provider block.

## Related content

- [What's new in Azure Catalyst for Azure Local](migrate-whats-new.md)
- [Set up an appliance for Azure Government cloud](/azure/migrate/deploy-appliance-script-government)
- [Azure Government documentation](/azure/azure-government/)
