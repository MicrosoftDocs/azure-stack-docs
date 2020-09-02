---
title: Set up Azure Kubernetes Service on Azure Stack HCI using Windows Admin Center
description: Learn how to set up Azure Kubernetes Service on Azure Stack HCI using Windows Admin Center
author: davannaw-msft
ms.topic: quickstart
ms.date: 09/01/2020
ms.author: dawhite
---

# Setting up Azure Kubernetes Service on Azure Stack HCI using Windows Admin Center
Before creating a Kubernetes cluster using Windows Admin Center, you first have to install Windows Admin Center and the Azure Kubernetes Service on Azure Stack HCI extension. After you've followed these steps, you also need to set up an Azure Kubernetes Service host on the system you want to deploy the Kubernetes cluster to.

## Setting up Windows Admin Center
The first step in setting up Azure Kubernetes Service on Azure Stack HCI is to install Windows Admin Center. Installations of Windows Admin Center on client (a Windows 10 machine) or server may be used to utilize Azure Kubernetes Service on Azure Stack HCI functionality. 

Windows Admin Center can be installed in server configurations for Azure Kubernetes Service on Azure Stack HCI. The most common configurations are: 
1. On a Windows 10 local client in desktop mode. Users on the client will be able to access the locally running WAC instance to remotely manage target servers. 
2. On a gateway server in service mode. Users will be able to connect to the WAC instance on the gateway server to remotely manage target servers.
3. On a managed target server as a side-by-side workload. Users will be able to connect to the WAC instance running as a workload on the target server and manage the target server. WAC does not support self-management (performing management actions on the same system it is installed on). Doing so will cause unpredictable behavior and results.

The target servers can be either workgroup or domain joined. 

For more information about installation, see the [Windows Admin Center installation documentation](https://docs.microsoft.com/windows-server/manage/windows-admin-center/plan/installation-options).

## Installing the Azure Kubernetes Service for Azure Stack HCI extension
Once you have obtained the Azure Kubernetes Service for Azure Stack HCI extension for Windows Admin Center, you must save the file locally or to an SMB share and add the file path to the "Feeds" list in your Windows Admin Center extension manager. 

To access your existing extension feed, open Windows Admin Center and click on the gear in the top right corner of the screen. This will take you to the settings menu. The extension feeds can be found under the “Gateway” section in the “Extensions” menu. Navigate to the tab labeled “Feeds” and click “Add.” In this pane, paste the file path to your copy of the ECP extension and click “Add.” If your file path was added successfully, you will receive a success notification. 

(picture)

Now that we have added the feed, the Azure Kubernetes Service for Azure Stack HCI extension will be available in the list of available extensions. Once you have the extension selected, click “Install” at the top of the table to install this extension. Windows Admin Center will reload after installation is complete. 

## Setting up an Azure Kubernetes Service host
There is one final step that should be completed before you create a Kubernetes cluster. You need to set up an Azure Kubernetes Service host on the system you want to deploy the Kubernetes cluster to. This system can be a single server, a failover cluster, or an Azure Stack HCI cluster. 

> [!NOTE] 
> Setting up Azure Kubernetes Service hosts on two independent systems with the intention of merging them during Kubernetes cluster creation is not a supported scenario. 

This set up can be done using the new Azure Kubernetes Service tool. 

(picture)

This tool will install and download the necessary packages, as well as create a management cluster that provides core Kubernetes services and orchestrates application workloads. 

Let's get started: 
1. Click **Set up** to launch the set up wizard.
2. Review the prerequisites for the machine you are running Windows Admin Center on, the server or cluster you're connected to, as well as the network. Additionally, make sure you're signed into an Azure account on Windows Admin Center. When finished, click **Next**.
3. On the **System checks** page of the wizard, take any required actions, such as connecting your Windows Admin Center gateway to Azure. This step check that Windows Admin Center and the system that will host Azure Kubernetes Service have the proper configurations to continue. When you're finished taking action, click **Next**.

(picture)

4. Configure the machine that will host Azure Kubernetes Service in the **Host configuration** step. Click **Next** after you're finished. This step of the wizard asks you to configure the following details:
    * host details, such as a name for the management cluster and a folder to store VM images 
    * VM networking, which will apply to all Linux and Windows VMs (nodes) that are created to run containers and orchestrate container management
    * load balancer settings, which define the pool of addresses used for external services

> [!IMPORTANT] 
> Static IP address allocation is not available for public preview. 

> [!NOTE] 
> It is recommended you select "automatically download updates" in the "Host details" section of this page

(picture)

5. Register with Azure and choose to send diagnostic data to Microsoft in the **Azure registration** step. While this page asks for an Azure subscription and resource group, there is no cost for setting up and using Azure Kubernetes Service in public preview. The diagnostic data you send to Microsoft will be used to keep the service secure and up to date, troubleshoot problems, and make product improvements. After you've made your selections, click **Next**.

(picture)

6. Review all of your selections so far in the **Review + create** step. If you're satisfied with your selections, click **Set up** to begin host setup. 
7. On the **Setup progress** page, you can watch the progress of your host setup. At this point, you are welcome to open Windows Admin Center in a new tab and continue your management tasks. 
8. If the deployment succeeds, you will be presented with next steps and the **Finish** button will be enabled. Clicking on **Download management cluster kubeconfig** under **Next Steps** will begin a download and will not direct you away from the wizard. 

(picture)

## Next steps

In this quickstart, you installed Windows Admin Center and the Azure Kubernetes Service for Azure Stack HCI extension. You also configured an Azure Kubernetes Service host on the system you are going to deploy a Kubernetes cluster to.

You are now ready to go ahead with [creating a Kubernetes cluster in Windows Admin Center](/quickstart-create-wac).
