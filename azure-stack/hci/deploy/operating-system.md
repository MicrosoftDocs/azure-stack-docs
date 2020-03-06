---
title: Deploy Azure Stack HCI
description: This article details how to deploy the operating system for Azure Stack HCI, connect cluster servers to Windows Admin Center to get Windows updates, and how to get firmware updates from hardware providers.
author: JohnCobb1
ms.author: v-johcob 
ms.topic: article
ms.date: 02/28/2020
---

# Deploy Azure Stack HCI

You can deploy Azure Stack HCI to run on the cluster servers in your organization after first installing the Server Core option of Windows Server 2019 Datacenter. Server Core is a minimal installation of the operating system. It includes most server roles, but uses less disk space to provide a smaller attack surface because of its smaller code base.

This article details Windows Server 2019 deployment options for Azure Stack HCI. It then details how to connect the servers in your cluster to Windows Admin Center to get the latest Windows updates, and update the firmware on the servers of your hardware provider.

## Prerequisites

- Server Core of Windows Server 2019 Datacenter installed on the primary management computer.

## Deployment options

Windows Server 2019 deployment options include:
- Manual deployment by connecting either a keyboard and monitor directly to the server hardware in your datacenter, or by connecting a KVM hardware device to the server hardware.
- Headless deployment using an answer file.
- System Center Virtual Machine Manager (VMM).

### Manual deployment
After you've acquired the server hardware for your Azure Stack HCI solution, it's time to rack and cable it to deploy Windows Server 2019 Datacenter.

1. Rack all server nodes that you want to use in your server cluster.
1. Connect the server nodes to your primary management computer running Windows Server 2019 Datacenter, according to instructions from your Azure Stack HCI hardware vendor.
1. Connect the server nodes to your network switches.
1. Configure the BIOS or the Unified Extensible Firmware Interface (UEFI) of your servers as recommended by your Azure Stack HCI hardware vendor to maximize performance and reliability.
1. Install Windows Server 2019 Datacenter on a local disk of each server node.

### Headless deployment
You can use an answer file to do a headless deployment of Windows Server 2019 Datacenter. The answer file uses an XML format to define configuration settings and values during an unattended installation of Windows Server.

For this deployment option, you can use Windows System Image Manager (Windows SIM) to create an unattend.xml answer file to deploy Windows Server on your server nodes. Windows SIM creates your unattend answer file through a GUI tool with component sections to define the “answers” to the configuration questions, and then ensure correct format and syntax in the file.

The Windows SIM tool is available in the Windows Assessment and Deployment Kit (Windows ADK). To get started: [Download and install the Windows ADK](/windows-hardware/get-started/adk-install).

### System Center Virtual Machine Manager (VMM) deployment
System Center Virtual Machine Manager (VMM) is part of the System Center suite. You can use VMM to configure and deploy Windows Server 2019 Datacenter to the server nodes in your datacenter.

If you're using VMM to set up and deploy Windows Server on your server nodes, you can do most initial configuration automatically on all nodes at once. To get started, see [Plan VMM installation](/system-center/vmm/plan-install?view=sc-vmm-2019).

## Connect Windows Admin Center to your cluster servers
Now you're ready to connect the servers in your cluster to Windows Admin Center.

1. Open **Windows Admin Center**, and then under **All connections**, click **+ Add**. 
1. On the **Add resources** menu, under **Windows Server**, **Connect to servers**, click **Add**.
1. In the **Server name** box, type the name of the server, and then click **Add**.

    **Note:** Repeat this step to add all of the servers to Windows Admin Center for your Azure Stack HCI solution.
1. Under **All connections**, in the **Name** column, select the checkbox next to the first server, and then click **Connect** to display the server's **Overview** page in Windows Admin Center from **Server Manger**.

    **Note:** Repeat this step to start each server.

## Get the latest Windows updates

After connecting your servers, use Windows Admin Center to get the latest Windows updates.

1. In **Windows Admin Center**, under **All connections** in the **Name** column, select the checkbox next to the first server, and then click **Connect** to display the server's **Overview** page.
1. On the server's **Overview** page, under **Tools**, click **Updates**.
1. On the **Windows Update** page, review any available updates.
1. Under **Update title**, select the updates that you want to apply to the server.
1. Leave the update restart option set to either **Restart immediately**, or click **Schedule restart**, set the date and time, and then click **Install updates**.

    **Note:** Repeat these steps to apply Windows updates to each server.

## Get the latest firmware updates from your hardware provider

Now you're ready to get your hardware provider's latest firmware updates.

1. Visit the [Azure Stack HCI solutions](https://azure.microsoft.com/products/azure-stack/hci/) website.
1. On the website, click [Azure Stack HCI Catalog](https://www.microsoft.com/cloud-platform/azure-stack-hci-catalog).
1. On the Preferred hardware vendor page of the catalog, under **Hardware partners**, reference your Azure Stack HCI hardware provider.
1. Click the hardware provider's product name to go to the company's Azure Stack HCI solutions website to get the product's latest firmware updates.

## Next steps

Advance to the next article to learn how to create...
> [!div class="nextstepaction"]
> [Next steps button]()