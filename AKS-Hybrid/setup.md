---
title: Quickstart to set up AKS hybrid using Windows Admin Center
description: Learn how to set up AKS hybrid using Windows Admin Center
author: sethmanheim
ms.topic: quickstart
ms.date: 04/21/2023
ms.author: sethm 
ms.lastreviewed: 03/16/2022
ms.reviewer: dawhite
ms.custom: mode-portal

# Intent: As an IT pro, I want to learn how to use Windows Admin Center in order to set up AKS hybrid.
# Keyword: Windows Admin Center Kubernetes
---

# Quickstart: Set up AKS hybrid using Windows Admin Center

In this quickstart, you set up AKS hybrid using Windows Admin Center. To use PowerShell instead, see [Set up with PowerShell](kubernetes-walkthrough-powershell.md).

Setup involves the following tasks:

* Setting up Windows Admin Center.
* Setting up an Azure Kubernetes Service host on the system to which you want to deploy the Kubernetes cluster.

Before getting started, make sure you've satisfied all the prerequisites on the [system requirements](.\system-requirements.md) page.

## Set up Windows Admin Center

The AKS hybrid extension for Windows Admin Center is natively available as part of the Windows Admin Center MSI. You can [install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) either on a Windows 10 machine or on a server. If you have already installed Windows Admin Center, make sure your version is `2103.2` or later. You can check your Windows Admin Center version by clicking on the question mark in the top right-hand corner.

:::image type="content" source="media/setup/check-wac-version.png" alt-text="Screenshot showing check for WAC version.":::

## Set up an Azure Kubernetes Service (AKS) host

You must set up an AKS host on your AKS hybrid cluster before deploying AKS workload clusters. Setting up an AKS host is also referred to as setting up the platform services or management cluster.  

:::image type="content" source="media/setup/aks-hci-architecture-focused.png" alt-text="Picture of an architecture diagram that highlights the platform services portion." lightbox="media/setup/aks-hci-architecture-focused.png":::

> [!NOTE]
> Setting up Azure Kubernetes Service hosts on two independent systems with the intention of merging them during Kubernetes cluster creation is not a supported scenario.

This setup can be done using the new Azure Kubernetes Service tool. This tool installs and downloads the necessary packages, as well as create an AKS host cluster that provides core Kubernetes services and orchestrates application workloads.

Now that you've verified the system settings, follow these steps:

1. Select **Set up** to launch the Setup wizard.

2. Review the prerequisites for the machine on which you're running Windows Admin Center, on the cluster to which you're connected, and the network. Additionally, make sure you're signed into an Azure account on Windows Admin Center and that the Azure subscription you're planning on using has not expired. You must have the **Owner** role on the subscription you are planning on using. When you're finished, select **Next**.

   > [!WARNING]
   > Make sure you have configured at least one external virtual switch before proceeding past this step, or you will not be able to successfully set up your Azure Kubernetes Service host.

3. On the **System checks** page of the wizard, take any required actions, such as [connecting your Windows Admin Center gateway to Azure](/windows-server/manage/windows-admin-center/azure/azure-integration). When connecting your Windows Admin Center gateway to Azure, be sure to create a new Microsoft Entra application. This step checks that Windows Admin Center and the system that hosts Azure Kubernetes Service have the proper configuration to continue. When you're finished taking action, select **Next**.

4. Ensure system connectivity through CredSSP in the **Connectivity** step. CredSSP lets Windows Admin Center delegate the user's credentials from the gateway to a target server for remote authentication. CredSSP needs to be enabled to set up Azure Kubernetes Service. After you've enabled CredSSP, select **Next**.  

5. Configure the machine that will host Azure Kubernetes Service in the **Host configuration** step. We recommend that you select **automatically download updates** in this section. This step of the wizard asks you to configure the following details:
   * **Host details**, such as a name for the AKS host cluster and an image directory where VM images will be stored. The image directory must point to a shared storage path or an SMB share that is accessible by the host machine.
   * **Kubernetes node networking**, which serves as the default for the AKS host and all Linux and Windows Kubernetes nodes VMs that are created to run containers and orchestrate container management.

       You can also specify separate network configurations for a workload cluster. These settings include the fields for the internet-connected virtual switch, virtual LAN identification enablement, IP address allocation method, and CloudAgent IP.
       You can use the CloudAgent IP to provide a static IP address to the CloudAgent service. This is applicable regardless of your IP address allocation selection. For more information, see [Kubernetes node networking](./concepts-node-networking.md). If you have selected the static IP address allocation method, there are a few extra fields that must be specified:
      * **Subnet prefix**, an IP address range that does not conflict with other addresses.
      * **Gateway**, the gateway through which packets will be routed outside the machine.
      * **DNS servers**, the comma-separated list of IP addresses for the DNS servers. Use a minimum of one and a maximum of three addresses.
      * **Kubernetes node IP pool start**, the pool start range for IP addresses used by Kubernetes clusters.
      * **Kubernetes node IP pool end**, the pool end range for IP addresses used by Kubernetes clusters.
   * **Load balancer settings**, which define the pool of addresses used for external services. If you have selected the static IP configuration in the VM networking section, the address pool start and end must be within the subnet range specified in that section.

   The following image represents an example of a DHCP host configuration:

   [![Screenshot that illustrates a DHCP configuration on the Host Configuration page.](.\media\setup\host-configuration-dhcp.png)](.\media\setup\host-configuration-dhcp.png#lightbox)

   The following image represents an example of a static IP host configuration:

   [![Screenshot that illustrates a static IP configuration on the Host Configuration page.](.\media\setup\host-configuration-static.png)](.\media\setup\host-configuration-static.png#lightbox)

   (Optional) Configure proxy settings as required for the Azure Kubernetes Service host. These settings are dependent on the proxy settings that are provisioned on the Azure Stack HCI host machine. Make sure you also provision the list of IP addresses that needs to bypass the proxy. When complete, select **Next: Review + Create**.

   [![Illustrates the optional proxy settings that you configure on the Host Configuration page.](.\media\setup\proxy-settings-host-configuration.png)](.\media\setup\proxy-settings-host-configuration.png#lightbox)

   Select **Next** after you're finished.

6. On the **Azure Registration** page of the wizard, provide details about the subscription, resource group, and region you want to use for this service. Your resource group must be in the Australia East, East US, Southeast Asia, or West Europe region.  

    Windows Admin Center requires permissions to access resources in your organization that only an admin can grant. Select **View in Azure**  to view your Windows Admin Center gateway in Azure and confirm you have been granted admin consent for the following:

   * Azure Service Management - user_impersonation
   * Microsoft Graph - Application.ReadWrite.All
   * Microsoft Graph - Directory.AccessAsUser.All

    If you've been granted permissions, you'll see the permissions in green under **Status** as shown below:

     :::image type="content" source="media/setup/access-granted.png" alt-text="Screenshot showing access granted." lightbox="media/setup/access-granted.png":::

   If you haven't been granted permissions, you may need the Azure subscription owner to manually grant admin consent.

   To add permissions:
   1. Select **Add a permission** in the top left corner.
   1. Select **Microsoft Graph**, and then select **Delegated permissions**.
   1. Search for **Application.ReadWrite.All**, and if necessary, expand the **Application** dropdown box.
   1. Search for **Directory.AccessAsUser.All**, and if necessary, expand the **Directory** dropdown box.
   1. Select the checkbox and then select **Add permissions**.

   You can also remove permissions that aren't required for AKS hybrid. To remove permissions before granting admin consent:
   1. Select the **...** to the right of the permission that shouldn't be granted.
   1. Select **Remove permission**.

   Once permissions are correct, select **Grant admin consent for \<user\>** and then select **Yes** to confirm them. You can revoke permissions at any time as needed.

   When you're done, your permissions may look something like this:  

   :::image type="content" source="media/setup/wac-api-permissions.png" alt-text="Screenshot showing permissions." lightbox="media/setup/wac-api-permissions.png":::

   When you're finished, select **Next**.

7. Review all of your selections in the **Review + create** step. If you're satisfied with your selections, select **Next: new cluster** to begin host setup.

8. On the **Setup progress** page, you can watch the progress of your host setup. At this point, you can open Windows Admin Center in a new tab and continue your management tasks.

   > [!WARNING]
   > During installation of your Azure Kuberenetes Service host, a **Kubernetes - Azure Arc** resource type is created in the resource group that's set during registration. Do not delete this resource; it represents your Azure Kuberenetes Service host. You can identify the resource by checking its distribution field for a value of `aks_management`. Deleting this resource results in an out-of-policy deployment.

9. If the deployment succeeds, select **Finish**, and you are presented with a management dashboard in which you can create and manage your Kubernetes clusters.

   :::image type="content" source="media/setup/dashboard.png" alt-text="Screenshot showing Kubernetes dashboard." lightbox="media/setup/dashboard.png":::

## Next steps

In this quickstart, you installed Windows Admin Center and configured an Azure Kubernetes Service host on the system you are going to deploy your Kubernetes clusters to. You are now ready to [create a Kubernetes cluster in Windows Admin Center](create-kubernetes-cluster.md).
