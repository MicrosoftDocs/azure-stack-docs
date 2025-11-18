---
title: Review prerequisites for Azure Local VMs for multi-rack deployments (preview)
description: Learn about the prerequisites for deploying Azure Local VMs for multi-rack deployments (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 11/17/2025
---

# Review prerequisites for Azure Local VMs for multi-rack deployments (preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article lists the requirements and prerequisites for Azure Local virtual machines (VMs) for multi-rack deployments. Review the requirements and complete the prerequisites before you manage your Azure Local VMs.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Azure requirements

Azure requirements include:

- To provision Azure Local VMs and VM resources such as network interfaces, VM images, and data disks, you must have access to an Azure subscription with the appropriate Role-based access control (RBAC) role and permissions assigned. For more information, see [RBAC roles for Azure Local VMs](./multi-rack-assign-vm-rbac-roles.md#custom-roles).

- Azure Local VM infrastructure is supported in the regions documented in the [What is Azure Local for multi-rack deployments?](multi-rack-overview.md) For Azure Local VMs, all entities must be registered, enabled, or created in the same region.

  The entities included with your Azure Local for multi-rack deployments include Network Fabric Controller, Cluster Manager, Custom Location, VM resources (disks, NICs, images), and VMs created from Azure Arc. These entities can be in different or same resource groups as long as all resource groups are in the same region.

## Azure Local requirements

Ensure you have:

- Access to an Azure Local instance with the following configuration:

  - Deployed with the network fabric.
  - At least one Layer 3 isolation domain is configured.
  - At least one Layer 3 external network and one Layer 3 internal network with sufficiently large IP CIDR.
  - Custom location is configured.

    > [!NOTE]
    > The first eight IPs of the address prefix associated with a Layer 3 internal network are reserved for internal use. Plan the size of the IP CIDR based on how many IPs your workloads require.

  - Go to the **Overview** page in the Azure Local resource. Verify that **Detailed Status** shows as **Running**. You should also see a custom/extended location in the cluster overview page.

    <!--:::image type="content" source="./media/multi-rack-vm-management-prerequisites/azure-arc-connected.png" alt-text="Screenshot of the Overview page in the Azure Local resource showing Azure Arc as connected." lightbox="./media/multi-rack-vm-management-prerequisites/azure-arc-connected.png":::-->

- Details of your proxy server to provide during VM creation. Azure Local VMs don't have external connectivity to enable guest management without proxy details configured at the time of creation.

## Azure Local VM image requirements

For Azure Local VM images to be used on Azure Local, make sure to satisfy the following requirements:

- Use only English (en-us) language VHDs to create VM images.

- For Linux VM images:  

  - To allow for initial configuration and customization during VM provisioning, you need to ensure that the image contains cloud init with nocloud datasource.

  - You need to configure the bootloader, kernel, and init system in your image to enable both serial connectivity and text-based console. Use both `GRUB_TERMINAL="console serial"` and kernel cmdline settings. This configuration is required to enable serial access for troubleshooting deployment issues and console support for your VM after deployment. Make sure the serial port settings on your system and terminal match to establish proper communication.

- For Windows VM images, install VirtIO drivers in the image to ensure proper detection of virtual storage and network devices during VM deployment.

## Azure Command-Line Interface (CLI) requirements

Skip this section if you aren't using Azure CLI to provision and manage Azure Local VMs and VM resources.

For information on Azure CLI commands for Azure Local VMs, see [az stack-hci-vm](/cli/azure/stack-hci-vm).

### Connect to the system remotely

If you're accessing your Azure Local remotely, the following requirements must be met:

- The latest version of Azure CLI. Install this version on the client that you're using to connect to your Azure Local.

- For installation instructions, see [Install Azure CLI](/cli/azure/install-azure-cli-windows). After you install Azure CLI, restart the terminal to ensure the `PATH` variable is set properly.
  
  - If you're using a local installation, sign in to Azure CLI by using the [az login](/cli/azure/reference-index#az-login) command. To finish the authentication process, follow the steps displayed in your terminal. For other sign-in options, see [Sign in with the Azure CLI](/cli/azure/authenticate-azure-cli).

  - Run [az version](/cli/azure/reference-index#az-version) to find the version and dependent libraries that are installed. To upgrade to the latest version, run [az upgrade](/cli/azure/reference-index#az-upgrade).

  - Install the latest version of Azure Local extension using `stack-hci-vm`.

    1. Check if there's a version of the extension installed on the client. Run the following command:
  
        ```azurecli
        az extension list --output table
        ```

    1. If there's an older version installed, remove it and install the new version. Run the following command:
  
        ```azurecli
        az extension remove --name "stack-hci-vm"
        ```

    1. To install the extension, run the following command:

        ```azurecli
        az extension add --name "stack-hci-vm" --version "<version>"
        ```

    1. To verify that the extension is installed, use the `list` command again.

## Next steps

- [Assign RBAC role for Azure Local VMs](./multi-rack-assign-vm-rbac-roles.md).
