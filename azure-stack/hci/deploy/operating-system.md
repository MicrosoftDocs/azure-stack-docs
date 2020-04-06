---
title: Deploy the Azure Stack HCI operating system
description: This article details how to deploy the operating system for Azure Stack HCI, connect cluster servers to Windows Admin Center to get Windows updates, and how to get firmware updates from hardware providers.
author: JohnCobb1
ms.author: v-johcob 
ms.topic: article
ms.date: 04/06/2020
---

# Deploy the Azure Stack HCI operating system
The first step in deploying an Azure Stack HCI cluster is deploying the operating system on each of the servers to be clustered. This topic details the deployment options for the Azure Stack HCI operating system, as well as how to connect the servers in your cluster to Windows Admin Center to get the latest Windows updates, and update the firmware on the servers of your hardware provider.

## Prerequisites
- Windows Admin Center set up on a system that can access the cluster.

## Deployment preparation
After you've acquired the server hardware for your Azure Stack HCI solution, it's time to rack and cable it. Use the following steps to prepare the server hardware for deployment of the operating system, and then getting Windows updates and the latest firmware settings.

1. Rack all server nodes that you want to use in your server cluster.
1. Connect the server nodes to your network switches.
1. Configure the BIOS or the Unified Extensible Firmware Interface (UEFI) of your servers as recommended by your Azure Stack HCI hardware vendor to maximize performance and reliability.

## Deployment options
Windows Server 2019 deployment options include:
- Preinstallation by the server manufacturer.
- Manual deployment by connecting either a keyboard and monitor directly to the server hardware in your datacenter, or by connecting a KVM hardware device to the server hardware.
- Headless deployment using an answer file.
- System Center Virtual Machine Manager (VMM).

### Manual deployment
Install Azure Stack HCI on the system drive of each server to be clustered.

### Headless deployment
You can use an answer file to do a headless deployment of the operating system. The answer file uses an XML format to define configuration settings and values during an unattended installation of Windows Server.

For this deployment option, you can use Windows System Image Manager to create an unattend.xml answer file to deploy the operating system on your servers. Windows System Image Manager creates your unattend answer file through a graphical tool with component sections to define the "answers" to the configuration questions, and then ensure the correct format and syntax in the file.
The Windows System Image Manager tool is available in the Windows Assessment and Deployment Kit (Windows ADK). To get started: [Download and install the Windows ADK](/windows-hardware/get-started/adk-install).

### System Center Virtual Machine Manager (VMM) deployment
System Center Virtual Machine Manager (VMM) is part of the System Center suite. You can use VMM to deploy the Azure Stack HCI operating system on bare-metal hardware, as well as to cluster the servers. To learn about VMM, see [System requirements for System Center Virtual Machine Manager](/system-center/vmm/system-requirements?view=sc-vmm-2019).

For more information about using VMM to do a bare-metal deployment of the operating system, see [Provision a Hyper-V host or cluster from bare metal computers](/system-center/vmm/hyper-v-bare-metal?view=sc-vmm-2019).

## Connect Windows Admin Center to your cluster servers
After installing the operating system on each server in the cluster, you can connect the servers to Windows Admin Center and use this browser-based tool for the rest of the cluster configuration. There are three ways to connect your servers to Windows Admin Center:
- Add a single server or a cluster as a managed node
- Bulk import multiple servers
- Search Active Directory to add servers

The following sections describe each approach.
### Add a single server or a cluster as a managed node
1. Open **Windows Admin Center**, and then under **All connections**, select **+ Add**.

    :::image type="content" source="../media/operating-system/add-server.png" alt-text="The Add button on the All connections page in Windows Admin Center.":::

1. On the **Add resources** page, you can choose to add a server, a cluster, a Windows PC, or an Azure VM. On the **Windows Server** tile, select **Add**.

    :::image type="content" source="../media/operating-system/choose-connection-type.png" alt-text="The Add resources menu showing the Add Windows Server tile in Windows Admin Center.":::
  
1. On the **Add one** tab, in the **Server name** box, type the name of the server, and then select **Add** to add it to your connection list on the overview page.

    :::image type="content" source="../media/operating-system/add-single-server.png" alt-text="The Server name box to add a single server in Windows Admin Center.":::

1. Under **All connections**, in the **Name** column, select the checkbox next to the server, and then select **Connect** to display the server's **Overview** page in Windows Admin Center from **Server Manger**.
1. Repeat the previous step to start each server that you add to Windows Admin Center.

### Bulk import multiple servers
1. On the **Windows Server** tile, select **Add**, and then select the **Import a file** tab.

    :::image type="content" source="../media/operating-system/bulk-import-a-list.png" alt-text="The Bulk import box to add multiple servers in Windows Admin Center.":::

1. Click **Select a file** to select a text file that contains a comma, or new line separated, list of FQDNs for the servers you want to add Windows Admin Center.

### Search Active Directory to add servers
1. On the **Windows Server** tile, select **Add**, and then select the **Search Active Directory** tab.

    :::image type="content" source="../media/operating-system/search-ad.png" alt-text="The Search Active Directory box to add multiple servers in Windows Admin Center.":::
 
1. Enter your search criteria and click **Search**. Wildcards (*) are supported.
1. After the search completes, select one or more of the results, optionally add tags, and then click **Add**.

## Get the latest Windows updates
After connecting your servers, use Windows Admin Center to get the latest Windows updates.
1. In **Windows Admin Center**, under **All connections** in the **Name** column, select the checkbox next to the first server, and then select **Connect** to display the server's **Overview** page.
1. On the server's **Overview** page, under **Tools**, select **Updates**.
1. On the **Windows Update** page, review any available updates.
1. Under **Update title**, select the updates that you want to apply to the server.
1. Leave the update restart option set to either **Restart immediately**, or select **Schedule restart**, set the date and time, and then select **Install updates**.
1. Repeat the previous steps to apply Windows updates to each server.

## Get the latest firmware updates from your hardware provider
Now you're ready to get your hardware provider's latest firmware updates.
1. Visit the [Azure Stack HCI solutions](https://azure.microsoft.com/products/azure-stack/hci/) website.
1. On the website, select [Azure Stack HCI Catalog](https://www.microsoft.com/cloud-platform/azure-stack-hci-catalog).
1. On the Preferred hardware vendor page of the catalog, under **Hardware partners**, reference your Azure Stack HCI hardware provider.
1. Select the hardware provider's product name to go to the company's Azure Stack HCI solutions website to get the product's latest firmware updates.

## Next steps
To perform the next management task related to this article, see:
> [!div class="nextstepaction"]
> [Creating volumes in Azure Stack HCI](../manage/create-volumes.md)