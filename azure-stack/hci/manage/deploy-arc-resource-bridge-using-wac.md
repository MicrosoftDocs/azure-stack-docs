---
title: Deploy Azure Arc Resource Bridge using Windows Admin Center
description: Learn how to Deploy Azure Arc Resource Bridge on Azure Stack HCI using Windows Admin Center
author: ManikaDhiman
ms.topic: how-to
ms.date: 03/24/2022
ms.author: v-mandhiman
ms.reviewer: JasonGerend
---

# Deploy Azure Arc Resource Bridge using Windows Admin Center

> Applies to: Azure Stack HCI, version 21H2

To enable virtual machine (VM) provisioning through Azure portal on Azure Stack HCI, you need to deploy [Azure Arc Resource Bridge](azure-arc-enabled-virtual-machines.mdazure-arc-enabled-virtual-machines.md#what-is-azure-arc-resource-bridge).

You can deploy Azure Arc Resource Bridge on the Azure Stack HCI cluster using Windows Admin Center or command line. This article describes how to deploy Azure Arc Resource Bridge for Arc VM
management on Azure Stack HCI using Windows Admin Center. It also describes how to create a custom location for the Azure Stack HCI cluster.

Azure Arc Resource Bridge deployment using Windows Admin Center involves completing the following steps:

- [Setting up Windows Admin Center](#set-up-windows-admin-center)

- [Setting up Arc Resource Bridge and creating custom location](#set-up-arc-resource-bridge-and-create-custom-location)

- [Projecting virtual network and images](#project-virtual-network-and-images)

If you want to deploy Azure Arc Resource Bridge using command line, see [Deploy Azure Arc Resource Bridge on Azure Stack HCI using command line][deploy-arc-resource-bridge-using-command-line.md].

For more information about VM provisioning through Azure portal, see [VM provisioning through Azure portal on Azure Stack HCI (preview)](azure-arc-enabled-virtual-machines.md).

## Before you begin

Before you begin the Azure Arc Resource Bridge deployment, plan out and configure your physical and host network infrastructure. Reference the following sections:

- [Prerequisites for deploying Azure Arc Resource Bridge](azure-arc-enabled-virtual-machines.md#prerequisites-for-deploying-azure-arc-resource-bridge).
- [Network port requirements](azure-arc-enabled-virtual-machines.md#network-port-requirements)
- [Firewall URL exceptions](azure-arc-enabled-virtual-machines.md#firewall-url-exceptions)

## Set up Windows Admin Center

The deployment for Arc Resource Bridge is natively available as part of the Windows Admin Center MSI. For Azure Arc Resource Bridge deployment, you must install Windows Admin Center 2110.2 or later on a Windows 10 machine or on a server. You can the version by clicking the question mark icon on the top right corner of the Windows Admin Center screen.

Also ensure that the latest version of the following extensions are installed:

- Azure Kubernetes Service

- Cluster Manager

These extensions come pre-installed with Windows Admin Center versions 2110.2 and later. To check the version of these extensions:

1. In Windows Admin Center, under **Tools** select **Settings**, then select **Extensions**.
2. On the **Installed Extensions** tab, find these extensions and verify their versions.

 :::image type="content" source="media/manage-azure-arc-vm/installed-extensions.png" alt-text="[Windows Admin Center Installed Extensions screenshot":::

## Set up Arc Resource Bridge and create custom location

To check all the prerequisites that should be met to deploy Arc Resource Bridge on an Azure Stack HCI Cluster, select **Settings** when connected to a cluster and navigate to **Azure Arc VM setup for Azure Stack HCI**. 

If an Resource Bridge deployment is detected, skip the steps in the following section and move to the [] section.

If an Arc Resource Bridge is not detected, a button is displayed to deploy Resource Bridge.

 :::image type="content" source="media/manage-azure-arc-vm/deploy-resource-bridge-button.png" alt-text="[Windows Admin Center Deploy Resource Bridge button screenshot":::

Perform the following steps to deploy Resource Bridge.

1. Select **Deploy Resource Bridge** to launch the setup wizard.

1. Review the prerequisites for the machine you're running Windows Admin Center on, the cluster you're connected to, and the network. Additionally, make sure you're signed into an Azure account on Windows Admin Center and that the Azure subscription you want to use is not expired. You must have the Owner role on your Azure subscription that you want to use. When finished reviewing the prerequisites, select **Next**.

>[!WARNING]
> Make sure you configured at least one external virtual switch before proceeding further. Otherwise, you won't be able to successfully set up your Azure Kubernetes Service host.

1. On the **System validation** page of the wizard, take required actions to connect Windows Admin Center gateway to the Azure Stack HCI cluster. As a result of validation, it will prompt you to install the required modules for deploying Arc Resource Bridge.

1. Ensure system connectivity through CredSSP in the Connectivity step. CredSSP lets Windows Admin Center delegate the user's credentials from the gateway to a target server for remote authentication. CredSSP needs to be enabled to set up Azure Kubernetes Service. After you enabled CredSSP, select **Next**.

1. Provide the configuration details for Arc Resource Bridge. This step of the wizard asks you to configure the following details:

    - **Host Details** such as name for the Resource Bridge and an image directory where VM images will be stored. The image directory must be on a Cluster Shared Volume available to all servers in the cluster.

    - **VM Networking** information for deploying Arc Resource Bridge appliance. These settings include the fields for the internet connected virtual switch, virtual LAN identification enablement, **Cloudagent IP** and **Control plane IP**. This section also provides an option to select the IP address allocation method for the Arc Resource Bridge VM.
    
        - The **Controlplane IP** address is used for the load balancer in the Arc Resource Bridge. This IP address needs to be in the same subnet as the DHCP scope for virtual machines and must be excluded from the DHCP scope to avoid IP address conflicts.
        
        - The **Cloudagent IP** address is required only for static IP configurations on the underlay network for the physical hosts.

        The following screenshot displays an example of a DHCP networking configuration:

        :::image type="content" source="media/manage-azure-arc-vm/networking-configuration.png" alt-text="[Screenshot that shows Networking configuration tab with DHCP option as selected":::

1. On the Azure Registration page of the wizard, provide the details about the subscription, resource group, and region you wish to use for this service. Your resource group will need to be in the East US or West Europe region.

    When finished, select **Review Settings**.

1. Review all of your selections in the **Review Settings** step. If you're satisfied with your selections, select, **Apply** to prepare the cluster hosts & after completion of that step, proceed to **Deployment**.

1. On the **Deployment** page, you can watch the progress of the Arc Resource Bridge. At this point, you are welcome to open Windows Admin Center in a new tab and continue your management tasks. The deployment takes about 15-30 minutes to complete.

If the deployment is successful, the wizard automatically navigates to the Arc Resource Bridge dashboard. On this dashboard, you can see the details of the custom location and Arc Resource Bridge.

> [!IMPORTANT]
> Even after successful deployment of the Azure Arc Resource Bridge, Windows Admin Center may not be able to detect the status of the Resource Bridge and may display an error instead of the dashboard. This error does not indicate any issues with your deployment and the operations conducted through the Azure portal should work normally.

## Project virtual network and images

Now that the custom location is available, you can create or add virtual networks and images for the custom location associated with the Azure Stack HCI cluster.

Access **Azure Arc VM setup for Azure Stack HCI** under cluster **Settings** again. On this page, project the vmswitch name that is used for network interfaces during VM provisioning. Also project the OS gallery images that are used for creating VMs through Azure Arc.

## Next steps

[Create virtual machines from Azure
portal](https://docs.microsoft.com/azure-stack/hci/manage/azure-arc-enabled-virtual-machines#view-your-cluster-in-azure-portal--manage-virtual-machines).
