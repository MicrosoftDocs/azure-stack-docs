---
title: Quickstart to set up Azure Kubernetes Service on Azure Stack HCI using Windows Admin Center
description: Learn how to set up Azure Kubernetes Service on Azure Stack HCI using Windows Admin Center
author: davannaw-msft
ms.topic: quickstart
ms.date: 01/22/2021
ms.author: dawhite
---
# Quickstart: Set up Azure Kubernetes Service on Azure Stack HCI using Windows Admin Center

> Applies to: Azure Stack HCI, Windows Server 2019 Datacenter

In this quickstart, you set up Azure Kubernetes Service on Azure Stack HCI using Windows Admin Center. To instead use PowerShell, see [Set up with PowerShell](setup-powershell.md).

Setting up involves the following tasks:

* Download Azure Kubernetes Service on Azure Stack HCI
* Set up Windows Admin Center, if you haven't done so already
* Install the Azure Kubernetes Service extension for Windows Admin Center
* Set up an Azure Kubernetes Service host on the system you want to deploy the Kubernetes cluster to

Before getting started, make sure you have satisfied all the prerequisites on the [system requirements](.\system-requirements.md) page.

## Download Azure Kubernetes Service on Azure Stack HCI

If you haven't already downloaded the preview software, see [evaluate AKS on Azure Stack HCI](https://aka.ms/AKS-HCI-Evaluate). You will be asked to download AKS on Azure Stack HCI. 

## Setting up Windows Admin Center

If you haven't already installed Windows Admin Center, see [install Windows Admin Center](https://aka.ms/aks-hci-wac-2009). You can run Windows Admin Center either on a Windows 10 machine or on a server. Make sure your Windows Admin Center version is build 2009 or later. 

## Installing the Azure Kubernetes Service extension

Once you have obtained the Azure Kubernetes Service on Azure Stack HCI public preview files, you must save the `.nupkg` file locally or to an SMB share and add the file path to the "Feeds" list in your Windows Admin Center extension manager. The `.nupkg` file is a NuGet package that contains the Windows Admin Center extension.

To access your existing extension feed, open Windows Admin Center and select on the gear in the top-right corner of the screen. This will take you to the settings menu. The extension feeds can be found under the **Gateway** section in the **Extensions** menu. Navigate to the **Feeds** tab and select **Add**. In this pane, paste the file path to your copy of the Azure Kubernetes Service extension and select **Add**. If your file path was added successfully, you'll receive a success notification. 

Now that we have added the feed, the Azure Kubernetes Service extension will be available in the list of available extensions. Once you have the extension selected, select **Install** at the top of the table to install this extension. Windows Admin Center will reload after installation is complete. 

[ ![View of the available extension list in Windows Admin Center extension manager.](.\media\setup\extension-manager.png) ](.\media\setup\extension-manager.png#lightbox)

## Setting up an Azure Kubernetes Service host

There is one final step that should be completed before you create a Kubernetes cluster. You need to set up an Azure Kubernetes Service host on the system you want to deploy the Kubernetes cluster to. This is also referred to as setting up the platform services or management cluster.  

[![Picture of an architecture diagram that highlights the platform services portion.](.\media\setup\aks-hci-architecture-focused.png)](.\media\setup\aks-hci-architecture-focused.png) 

This system can be a Windows Server 2019 Datacenter cluster, a single node Windows Server 2019 Datacenter, or a 2-4 node Azure Stack HCI cluster. 

> [!NOTE] 
> Setting up Azure Kubernetes Service hosts on two independent systems with the intention of merging them during Kubernetes cluster creation is not a supported scenario. 

This set up can be done using the new Azure Kubernetes Service tool. 

This tool will install and download the necessary packages, as well as create an AKS host cluster that provides core Kubernetes services and orchestrates application workloads. 

Now that we've verified our system settings, let's get started: 
1. Select **Set up** to launch the Setup wizard.
2. Review the prerequisites for the machine you are running Windows Admin Center on, the cluster you're connected to, as well as the network. Additionally, make sure you're signed into an Azure account on Windows Admin Center and that the Azure subscription you're planning on using is not expired. When you're finished, select **Next**.

   > [!WARNING]
   > If you're using a 2-4 node Azure Stack HCI cluster, make sure you have configured at least one external virtual switch before proceeding past this step, or you will not be able to successfully set up your Azure Kubernetes Service host.

3. On the **System checks** page of the wizard, take any required actions, such as [connecting your Windows Admin Center gateway to Azure](/windows-server/manage/windows-admin-center/azure/azure-integration). When connecting your Windows Admin Center gateway to Azure, be sure to create a **new** Azure Active Directory application. This step checks that Windows Admin Center and the system that will host Azure Kubernetes Service have the proper configurations to continue. When you're finished taking action, select **Next**.
4. Ensure system connectivity through CredSSP in the **Connectivity** step. CredSSP lets Windows Admin Center delegate the user's credentials from the gateway to a target server for remote authentication. CredSSP needs to be enabled to set up Azure Kubernetes Service. After you've enabled CredSSP, select **Next**.  
5. Configure the machine that will host Azure Kubernetes Service in the **Host configuration** step. We recommend you select **automatically download updates** in this section. This step of the wizard asks you to configure the following details:
    * **Host details**, such as a name for the AKS host cluster and an image directory where VM images will be stored. The image directory must point to a shared storage path or an SMB share that is accessible by the host machine.
    * **VM networking**, which will apply to all Linux and Windows VMs (nodes) that are created to run containers and orchestrate container management. This includes the fields for the internet connected virtual switch, virtual LAN identification enablement, IP address allocation method, and Cloudagent IP. Cloudagent IP can be used to provide a static IP address to the CloudAgent service. This is applicable regardless of your IP address allocation selection. For additional details, see [Kubernetes node networking](./concepts-node-networking.md). If you have selected the static IP address allocation method, there are a few additional fields that must be specified:
      - **Subnet prefix**, an IP address range that does not conflict with other addresses
      - **Gateway**, the gateway through which packets will be routed outside the machine
      - **DNS servers**, the comma-separated list of IP addresses for the DNS servers. Use a minimum of one and a maximum of three addresses. 
      - **Kubernetes node IP pool start**, the pool start range for IP addresses used by Kubernetes clusters
      - **Kubernetes node IP pool end**, the pool end range for IP addresses used by Kubernetes clusters
    * **Load balancer settings**, which define the pool of addresses used for external services. If you have selected the static IP configuration in the VM Networking section, the address pool start and end must be within the subnet range specified in that section. 

    ![Illustrates the Host configuration step of the Azure Kubernetes Service host wizard.](.\media\setup\host-configuration.png)
    
    Select **Next** after you're finished.

6. On the **Azure Registration** page of the wizard, provide details about the subscription and resource group you wish to use for this service. While Azure Kubernetes Service is in preview, you will not be charged. Windows Admin Center also requires permissions to access resources in your organization that only an admin can grant. Click **View in Azure**  to view your Windows Admin Center gateway in Azure and confirm you have been granted admin consent. If you've been granted permissions, you'll see the permissions in _green_ under **Status** as shown below:

     ![Illustrates that status is granted for the Windows Admin Center gateway.](.\media\setup\access-granted.png)

   If you haven't been been granted permissions, use the following steps to manually add the permission.
   1. Click **Add a permission** in the top left corner.
   2. Select **Microsoft Graph**, and then select **Delegated permissions**.
   3. Search for **Application.ReadWrite.All**, and if necessary, expand the **Application** dropdown box.
   4. Select the checkbox and then click **Add permissions**.
   5. Click **Grant admin consent for <_user_>**, and to confirm the permissions, click **Yes**.
   
   When you're finished, select **Next**.

7. Review all of your selections in the **Review + create** step. If you're satisfied with your selections, select **Next** to begin host setup. 
8. On the **Setup progress** page, you can watch the progress of your host setup. At this point, you are welcome to open Windows Admin Center in a new tab and continue your management tasks. 
9. If the deployment succeeds, select *Finish*, and you will be presented with a management dashboard where you can create and manage your Kubernetes clusters. This dashboard, like the rest of Azure Kubernetes Services on Azure Stack HCI, is in a preview release and will be updated with additional functionality in future releases.
 
   ![Illustrates the Azure Kubernetes Services on Azure Stack HCI management dashboard.](.\media\setup\dashboard.png)
 
## Next steps

In this quickstart, you installed Windows Admin Center and the Azure Kubernetes Service extension. You also configured an Azure Kubernetes Service host on the system you are going to deploy a Kubernetes cluster to.

You are now ready to go ahead with [creating a Kubernetes cluster in Windows Admin Center](create-kubernetes-cluster.md).
