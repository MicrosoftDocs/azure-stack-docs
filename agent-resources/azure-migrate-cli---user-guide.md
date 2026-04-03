---
title: Migrate VMs to Azure Local with Azure Migrate using Azure CLI
description: This article describes how to migrate virtual machines (VMs) to Azure Local with Azure Migrate using Azure CLI. This article applies to migration of Hyper-V VMs (Preview) and VMware VMs.
author: trumanbrown_microsoft
ms.author: trumanbrown
ms.reviewer: trumanbrown
ms.date: 04/02/2026
ms.topic: tutorial
---

# Overview

The Azure CLI Migrate Extension provides a unified command-line interface for managing server migrations in Azure Local (Azure Stack HCI) environments. It supports discovery, replication, migration, and monitoring of servers from VMware and Hyper-V sources, streamlining migration workflows for cloud and edge scenarios.

# Prerequisites

• Azure CLI version 2.75.0 or later  
• Azure subscription with Contributor, Storage Contributor, and User Access Administrator roles  
• Configured Azure Migrate project  
• Source appliance (VMware or Hyper-V)  
• Target Azure Local appliance  
• Arc Resource Bridge running  
• Network connectivity between source and target

# Installation

To install the Azure CLI, migrate extension, run:  
  
az extension add --name migrate --allow-preview true

# Supported Scenarios

• Migrate servers from VMware or Hyper-V to Azure Local (Azure Stack HCI)  
• Manage replication lifecycle (initiate, monitor, remove)  
• Execute planned failover (migration)  
• Monitor migration jobs

# Step-by-Step Migration Workflow

1.  **Login to Azure:**

Authenticate with your Azure account and follow the steps to select your subscription ID.

> az login

1.  **Discover servers:**

Identify servers available for migration in your Azure Migrate project.

> az migrate get-discovered-server \\
>
> --project-name \<projectName\> \\
>
> --resource-group \<resourceGroup\>

1.  **Initialize replication infrastructure:**

You can initialize the replication infrastructure for your Azure Migrate project using the \` az migrate local replication init\` command. This command sets up the necessary infrastructure and metadata storage account needed to eventually replicate VMs from the source appliance to the target appliance. Running this command, multiple times will not cause any issues, as it checks if the replication infrastructure is already initialized.

> az migrate local replication init \\
>
> --resource-group \<resourceGroup\> \az
>
> --project-name \<projectName\> \\
>
> --source-appliance-name \<sourceAppliance\> \\
>
> --target-appliance-name \<targetAppliance\>

1.  **Create new replication:**

> Set up a new replication for a selected machine by specifying the machine ID, storage path, resource group, VM name, source and target appliances, OS disk, and target virtual switch. You can use the output of az migrate get-discovered-server to paste the machine ID and OS Disk ID that correspond to the same server you wish to replicate.
>
> az migrate local replication new \\
>
> --machine-id "\<machineARMID\>" \\
>
> --target-storage-path-id "\<storagePathARMID\>" \\
>
> --target-resource-group-id "\<resourceGroupARMID\>" \\
>
> --target-vm-name "\<targetVMName\>" \\
>
> --source-appliance-name \<sourceAppliance\> \\
>
> --target-appliance-name \<targetAppliance\> \\
>
> --os-disk-id "\<osDiskID\>" \\
>
> --target-virtual-switch-id "\<logicalNetworkARMID\>"

1.  **List and monitor replications:**

To view all active replications associated with your Azure Migrate project and resource group to monitor their status, you can run the az migrate local replication list or az migrate local replication get commands. List all ongoing replications:

> az migrate local replication list \\
>
> --resource-group \<resourceGroup\> \\
>
> --project-name \<projectName\>
>
> To get details for a specific replication run:
>
> az migrate local replication get \\
>
> --id "\<protectedItemARMID\>"

1.  **Start migration (planned failover):**

> To initiate the migration (planned failover) action for a protected item you can use the az migrate local start-migration command:
>
> az migrate local start-migration \\
>
> --protected-item-id "\<protectedItemARMID\>"

1.  **Monitor migration jobs:**

To track the progress and status of migration jobs for your project and resource group. This command will fetch a list of all jobs that occurred on a specific project or display details associate with a specific project:

> az migrate local replication get-job \\
>
> --resource-group \<resourceGroup\> \\
>
> --project-name \<projectName\>

1.  **Clean up after migration:**

To remove completed replications by specifying the protected item ID to clean up resources after migration you can run the az migrate local replication remove command.

> az migrate local replication remove \\
>
> --target-object-id "\<protectedItemARMID\>"

# Troubleshooting

| Issue                               | Resolution                            |
|-------------------------------------|---------------------------------------|
| No Data Replication Service         | Run replication init command          |
| Arc Resource Bridge not running     | Verify status in Azure portal         |
| Protected item cannot be migrated   | Check replication health and state    |
| Failed to grant storage permissions | Verify User Access Administrator role |
