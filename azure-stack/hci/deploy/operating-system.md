---
title: Deploy the Azure Stack HCI operating system
description: This article discusses different ways to deploy the Azure Stack HCI operating system, and then use Windows Admin Center to connect to your servers. Reference to related guidance on creating a server cluster is included, as well as optional steps to get the latest Windows updates and firmware for your servers.
author: JohnCobb1
ms.author: v-johcob 
ms.topic: article
ms.date: 06/04/2020
---

# Deploy the Azure Stack HCI operating system
After completing the steps in [Before you deploy Azure Stack HCI](before-you-start.md#install-windows-admin-center), the first step in deploying Azure Stack HCI is to install the Azure Stack HCI operating system on each server that you want to cluster. This article discusses different ways to deploy the operating system, and using Windows Admin Center to connect to the servers.

After deploying the operating system, you're ready to use related guidance on creating a server cluster, and getting the latest Windows updates and firmware updates for your servers. Optional steps to get these updates are included in this article. However, we recommend using the Cluster Creation wizard to streamline getting updates. To learn more, see [Create an Azure Stack HCI cluster using Windows Admin Center](https://docs.microsoft.com/azure-stack/hci/deploy/operating-system?branch=pr-en-us-2779).

## Prerequisites
- Windows Admin Center set up on a system that can access the servers you want to cluster, as described in [Before you deploy Azure Stack HCI](before-you-start.md#install-windows-admin-center).

## Deployment preparation
After you've acquired the server hardware for your Azure Stack HCI solution, it's time to rack and cable it. Use the following steps to prepare the server hardware for deployment of the operating system.

1. Rack all server nodes that you want to use in your server cluster.
1. Connect the server nodes to your network switches.
1. Configure the BIOS or the Unified Extensible Firmware Interface (UEFI) of your servers as recommended by your Azure Stack HCI hardware vendor to maximize performance and reliability.

## Operating system deployment options
Deployment options include:
- Server manufacturer preinstallation.
- Headless deployment using an answer file.
- System Center Virtual Machine Manager (VMM).
- Network deployment.
- Manual deployment by connecting either a keyboard and monitor directly to the server hardware in your datacenter, or by connecting a KVM hardware device to the server hardware.

### Server manufacturer preinstallation
For enterprise deployment of the Azure Stack HCI operating system, we recommend Azure Stack HCI Integrated System solution hardware from your preferred hardware partner. The solution hardware arrives with the operating system preinstalled, and supports using Windows Admin Center to deploy and update drivers and firmware from the hardware manufacturer.

Solution hardware ranges from 2 to 16 nodes and is tested and validated by Microsoft and partner vendors. ​To find Azure Stack HCI solution hardware from your preferred hardware partner, see the [Azure Stack HCI Catalog](https://www.microsoft.com/cloud-platform/azure-stack-hci-catalog).

### Headless deployment
You can use an answer file to do a headless deployment of the operating system. The answer file uses an XML format to define configuration settings and values during an unattended installation of Windows Server.

For this deployment option, you can use Windows System Image Manager to create an unattend.xml answer file to deploy the operating system on your servers. Windows System Image Manager creates your unattend answer file through a graphical tool with component sections to define the "answers" to the configuration questions, and then ensure the correct format and syntax in the file.
The Windows System Image Manager tool is available in the Windows Assessment and Deployment Kit (Windows ADK). To get started: [Download and install the Windows ADK](/windows-hardware/get-started/adk-install).

### System Center Virtual Machine Manager (VMM) deployment
System Center Virtual Machine Manager (VMM) is part of the System Center suite. You can use VMM to deploy the Azure Stack HCI operating system on bare-metal hardware, as well as to cluster the servers. To learn about VMM, see [System requirements for System Center Virtual Machine Manager](/system-center/vmm/system-requirements?view=sc-vmm-2019).

For more information about using VMM to do a bare-metal deployment of the operating system, see [Provision a Hyper-V host or cluster from bare metal computers](/system-center/vmm/hyper-v-bare-metal?view=sc-vmm-2019).

### Network deployment
Another option is to install the Azure Stack HCI operating system over the network using [Windows Deployment Services](https://docs.microsoft.com/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/hh831764(v=ws.11)).

### Manual deployment
To manually deploy the Azure Stack HCI operating system on the system drive of each server to be clustered, install the operating system via your preferred method, such as booting from a DVD or USB drive. Then start each server and use the Server Configuration tool (Sconfig.cmd) to prepare the servers for clustering. To learn more about the tool, see [Configure a Server Core installation with Sconfig.cmd](/windows-server/get-started/sconfig-on-ws2016).

To manually install the Azure Stack HCI operating system:
1. Start the Install Azure Stack HCI wizard on the system drive of the server where you want to install the operating system.
1. Choose the language to install or accept the default language settings, select **Next**, and then on next page of the wizard, select **Install now**.

    :::image type="content" source="../media/operating-system/azure-stack-hci-install-language.png" alt-text="The language page of the Install Azure Stack HCI wizard.":::

1. On the Applicable notices and license terms page, review the license terms, select the **I accept the license terms** checkbox, and then select **Next**.
1. On the Which type of installation do you want? page, select **Custom: Install the newer version of Azure Stack HCI only (advanced)**.

    :::image type="content" source="../media/operating-system/azure-stack-hci-install-which-type.png" alt-text="The installation type option page of the Install Azure Stack HCI wizard.":::

1. On the Where do you want to install Azure Stack HCI? page, either confirm the drive location where you want to install the operating system or update it, and then select **Next**.

    :::image type="content" source="../media/operating-system/azure-stack-hci-install-where.png" alt-text="The drive location page of the Install Azure Stack HCI wizard.":::

1. The Installing Azure Stack HCI page displays to show status on the process.

    :::image type="content" source="../media/operating-system/azure-stack-hci-installing.png" alt-text="The status page of the Install Azure Stack HCI wizard.":::

    > [!NOTE]
    > The installation process restarts the operating system twice to complete the process, and displays notices on starting services before opening an Administrator command prompt.

1. At the Administrator command prompt, select **Ok** to change the user’s password before signing in to the operating system, and press Enter.

    :::image type="content" source="../media/operating-system/azure-stack-hci-change-admin-password.png" alt-text="The change password prompt.":::

1. At the Enter new credential for Administrator prompt, enter a new password, enter it again to confirm it, and then press Enter.

1. At the Your password has been changed confirmation prompt, press Enter.

    :::image type="content" source="../media/operating-system/azure-stack-hci-admin-password-changed.png" alt-text="The changed password confirmation prompt":::

To use Sconfig.cmd:
1. Connect to the server running the Azure Stack HCI operating system that you want to deploy. This could be locally via a keyboard and monitor or using a remote management (headless or BMC) controller.
1. Open a command prompt as an administrator, and then change to the system drive.
1. At the command prompt, type `Sconfig.cmd` and press Enter to open the Server Configuration tool interface.

    :::image type="content" source="../media/operating-system/azure-stack-hci-sconfig-screen.png" alt-text="The Server Configuration tool interface." lightbox="../media/operating-system/azure-stack-hci-sconfig-screen.png":::

1. Take note of the computer's **Domain/Workgroup** and its **Computer Name** for reference.

From the Server Configuration tool interface, you can perform important tasks, such as adding additional users to the local administrators group and changing network settings.

After configuring the operating system as needed with Sconfig.cmd on each server, you're ready to use the Cluster Creation wizard in Windows Admin Center to cluster the servers. To learn more, see [Create an Azure Stack HCI cluster using Windows Admin Center](https://docs.microsoft.com/azure-stack/hci/deploy/operating-system?branch=pr-en-us-2779).

## Connect Windows Admin Center to your cluster servers
After installing the operating system on each server in the cluster, you can connect the servers to Windows Admin Center and use this browser-based tool for the rest of the cluster configuration. There are three ways to connect your servers to Windows Admin Center:
- Add a single server or a cluster as a managed node
- Bulk import multiple servers
- Search Active Directory to add servers (if the servers are already domain-joined)

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

## Getting the latest Windows updates and firmware updates
This section includes optional steps you can use to get the latest Windows updates and firmware updates for your servers. However, we recommending using the Cluster Creation wizard to streamline getting updates. To learn more, see [Create an Azure Stack HCI cluster using Windows Admin Center](https://docs.microsoft.com/azure-stack/hci/deploy/operating-system?branch=pr-en-us-2779).

### Get the latest Windows updates
To use Windows Admin Center to get the latest Windows updates:
1. In **Windows Admin Center**, under **All connections** in the **Name** column, select the checkbox next to the first server, and then select **Connect** to display the server's **Overview** page.
1. On the server's **Overview** page, under **Tools**, select **Updates**.
1. On the **Windows Update** page, review any available updates.
1. Under **Update title**, select the updates that you want to apply to the server.
1. Leave the update restart option set to either **Restart immediately**, or select **Schedule restart**, set the date and time, and then select **Install updates**.
1. Repeat the previous steps to apply Windows updates to each server.

### Get the latest firmware updates from your hardware provider
To get your hardware provider's latest firmware updates:
1. Visit the [Azure Stack HCI solutions](https://azure.microsoft.com/products/azure-stack/hci/) website.
1. On the website, select [Azure Stack HCI Catalog](https://www.microsoft.com/cloud-platform/azure-stack-hci-catalog).
1. On the Preferred hardware vendor page of the catalog, under **Hardware partners**, reference your Azure Stack HCI hardware provider.
1. Select the hardware provider's product name to go to the company's Azure Stack HCI solutions website to get the product's latest firmware updates.

## Next steps
To perform the next management task related to this article, see:
> [!div class="nextstepaction"]
> [Creating volumes in Azure Stack HCI](../manage/create-volumes.md)
