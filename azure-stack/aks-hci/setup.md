---
title: Set up Azure Kubernetes Service on Azure Stack HCI using Windows Admin Center
description: Learn how to set up Azure Kubernetes Service on Azure Stack HCI using Windows Admin Center
author: davannaw-msft
ms.topic: quickstart
ms.date: 09/21/2020
ms.author: dawhite
---
# Set up Azure Kubernetes Service on Azure Stack HCI using Windows Admin Center

> Applies to: Azure Stack HCI

In this quickstart, you'll: 
* Set up Windows Admin Center, if you haven't done so already
* Install the Azure Kubernetes Service for Azure Stack HCI extension for Windows Admin Center
* Set up an Azure Kubernetes Service host on the system you want to deploy the Kubernetes cluster to

Before getting started, make sure you have satisfied all the prerequisites on the [Before You Begin](.\before-you-begin.md) page.

## Setting up Windows Admin Center
If you haven't already installed Windows Admin Center, see [install Windows Admin Center](https://docs.microsoft.com/windows-server/manage/windows-admin-center/deploy/install).

## Installing the Azure Kubernetes Service extension
Once you have obtained the Azure Kubernetes Service on Azure Stack HCI extension for Windows Admin Center, you must save the file locally or to an SMB share and add the file path to the "Feeds" list in your Windows Admin Center extension manager. 

To access your existing extension feed, open Windows Admin Center and select on the gear in the top right corner of the screen. This will take you to the settings menu. The extension feeds can be found under the **Gateway** section in the **Extensions** menu. Navigate to the **Feeds** tab and select **Add**. In this pane, paste the file path to your copy of the Azure Kubernetes Service on Azure Stack HCI extension and select **Add**. If your file path was added successfully, you will receive a success notification. 

Now that we have added the feed, the Azure Kubernetes Service on Azure Stack HCI extension will be available in the list of available extensions. Once you have the extension selected, select **Install** at the top of the table to install this extension. Windows Admin Center will reload after installation is complete. 

[ ![View of the available extension list in Windows Admin Center extension manager.](.\media\extension-manager.png) ](.\media\extension-manager.png#lightbox)

## Setting up an Azure Kubernetes Service host
There is one final step that should be completed before you create a Kubernetes cluster. You need to set up an Azure Kubernetes Service host on the system you want to deploy the Kubernetes cluster to. This system must be an Azure Stack HCI cluster. 

> [!NOTE] 
> Setting up Azure Kubernetes Service hosts on two independent systems with the intention of merging them during Kubernetes cluster creation is not a supported scenario. 

This set up can be done using the new Azure Kubernetes Service tool. 

This tool will install and download the necessary packages, as well as create a management cluster that provides core Kubernetes services and orchestrates application workloads. 

Let's get started: 
1. Select **Set up** to launch the set up wizard.
2. Review the prerequisites for the machine you are running Windows Admin Center on, the Azure Stack HCI cluster you're connected to, as well as the network. Additionally, make sure you're signed into an Azure account on Windows Admin Center. When finished, select **Next**.
3. On the **System checks** page of the wizard, take any required actions, such as connecting your Windows Admin Center gateway to Azure. This step check that Windows Admin Center and the system that will host Azure Kubernetes Service have the proper configurations to continue. When you're finished taking action, select **Next**.
4. Configure the machine that will host Azure Kubernetes Service in the **Host configuration** step. We recommend you select **automatically download updates** in this section. Select **Next** after you're finished. This step of the wizard asks you to configure the following details:
    * host details, such as a name for the management cluster and a folder to store VM images
    * VM networking, which will apply to all Linux and Windows VMs (nodes) that are created to run containers and orchestrate container management. 
    * load balancer settings, which define the pool of addresses used for external services

    ![Illustrates the Host configuration step of the Azure Kubernetes Service host wizard.](.\media\host-configuration.png)

5. Register with Azure and choose to send diagnostic data to Microsoft in the **Azure registration** step. While this page asks for an Azure subscription and resource group, there is no cost for setting up and using Azure Kubernetes Service in public preview. The diagnostic data you send to Microsoft will be used to help keep the service secure and up to date, troubleshoot problems, and make product improvements. After you've made your selections, select **Next**.
6. Review all of your selections so far in the **Review + create** step. If you're satisfied with your selections, select **Set up** to begin host setup. 
7. On the **Setup progress** page, you can watch the progress of your host setup. At this point, you are welcome to open Windows Admin Center in a new tab and continue your management tasks. 
8. If the deployment succeeds, you will be presented with next steps and the **Finish** button will be enabled. Selecting **Download management cluster kubeconfig** under **Next Steps** will begin a download and will not direct you away from the wizard. 

## Next steps

In this quickstart, you installed Windows Admin Center and the Azure Kubernetes Service for Azure Stack HCI extension. You also configured an Azure Kubernetes Service host on the system you are going to deploy a Kubernetes cluster to.

You are now ready to go ahead with [creating a Kubernetes cluster in Windows Admin Center](.\create-kubernetes-cluster.md).
