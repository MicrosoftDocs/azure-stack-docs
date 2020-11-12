---
title: Deploy the Azure Stack HCI operating system
description: Learn to deploy the Azure Stack HCI OS, and then use Windows Admin Center to connect to your servers. Learn to create a server cluster, and understand how to get the latest Windows updates and firmware for your servers.
author: JohnCobb1
ms.author: v-johcob 
ms.topic: tutorial
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/28/2020
---

# Deploy the Azure Stack HCI operating system

> Applies to: Azure Stack HCI, version 20H2

The first step in deploying Azure Stack HCI is to [download Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) and install the operating system on each server that you want to cluster. This article discusses different ways to deploy the operating system, and using Windows Admin Center to connect to the servers.

> [!NOTE]
> If you've purchased Azure Stack HCI Integrated System solution hardware from the [Azure Stack HCI Catalog](https://azure.microsoft.com/en-us/products/azure-stack/hci/catalog/) through your preferred Microsoft hardware partner, the Azure Stack HCI operating system should be pre-installed. In that case, you can skip this step and move on to [Create an Azure Stack HCI cluster](create-cluster.md).

## Prerequisites

Before you deploy the Azure Stack HCI operating system, you'll need to:

- Determine whether your hardware meets the requirements for Azure Stack HCI clusters
- Gather the required information for a successful deployment
- Install Windows Admin Center on a management PC or server

For Azure Kubernetes Service on Azure Stack HCI requirements, see [AKS requirements on Azure Stack HCI](../../aks-hci/overview.md#what-you-need-to-get-started).

### Determine hardware requirements

Microsoft recommends purchasing a validated Azure Stack HCI hardware/software solution from our partners. These solutions are designed, assembled, and validated against our reference architecture to ensure compatibility and reliability, so you get up and running quickly. Check that the systems, components, devices, and drivers you are using are Windows Server 2019 Certified per the Windows Server Catalog. Visit the [Azure Stack HCI solutions](https://azure.microsoft.com/overview/azure-stack/hci) website for validated solutions.

At minimum, you will need two servers, a reliable high-bandwidth, low-latency network connection between servers, and SATA, SAS, NVMe, or persistent memory drives that are physically attached to just one server each.

However, your hardware requirements may vary depending on the size and configuration of the cluster(s) you wish to deploy. To make sure your deployment is successful, review the Azure Stack HCI [system requirements](../concepts/system-requirements.md).

### Gather information

To prepare for deployment, gather the following details about your environment:

- **Server names:** Get familiar with your organization's naming policies for computers, files, paths, and other resources. You'll need to provision several servers, each with unique names.
- **Domain name:** Get familiar with your organization's policies for domain naming and domain joining. You'll be joining the servers to your domain, and you'll need to specify the domain name.
- **Static IP addresses:** Azure Stack HCI requires static IP addresses for storage and workload (VM) traffic and doesn't support dynamic IP address assignment through DHCP for this high-speed network. You can use DHCP for the management network adapter unless you're using two in a team, in which case again you need to use static IPs. Consult your network administrator about the IP address you should use for each server in the cluster.
- **RDMA networking:** There are two types of RDMA protocols: iWarp and RoCE. Note which one your network adapters use, and if RoCE, also note the version (v1 or v2). For RoCE, also note the model of your top-of-rack switch.
- **VLAN ID:** Note the VLAN ID to be used for the network adapters on the servers, if any. You should be able to obtain this from your network administrator.
- **Site names:** For stretched clusters, two sites are used for disaster recovery. You can set up sites using [Active Directory Domain Services](/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview), or the Create cluster wizard can automatically set them up for you. Consult your domain administrator about setting up sites.

### Install Windows Admin Center

Windows Admin Center is a locally deployed, browser-based app for managing Azure Stack HCI. The simplest way to [install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) is on a local management PC (desktop mode), although you can also install it on a server (service mode).

If you install Windows Admin Center on a server, tasks that require CredSSP, such as cluster creation and installing updates and extensions, require using an account that's a member of the Gateway Administrators group on the Windows Admin Center server. For more information, see the first two sections of [Configure User Access Control and Permissions](/windows-server/manage/windows-admin-center/configure/user-access-control#gateway-access-role-definitions).

## Prepare hardware for deployment

After you've acquired the server hardware for your Azure Stack HCI solution, it's time to rack and cable it. Use the following steps to prepare the server hardware for deployment of the operating system.

1. Rack all server nodes that you want to use in your server cluster.
1. Connect the server nodes to your network switches.
1. Configure the BIOS or the Unified Extensible Firmware Interface (UEFI) of your servers as recommended by your Azure Stack HCI hardware vendor to maximize performance and reliability.

## Operating system deployment options

You can deploy the Azure Stack HCI operating system in the same ways that you're used to deploying other Microsoft operating systems:

- Server manufacturer pre-installation.
- Headless deployment using an answer file.
- System Center Virtual Machine Manager (VMM).
- Network deployment.
- Manual deployment by connecting either a keyboard and monitor directly to the server hardware in your datacenter, or by connecting a KVM hardware device to the server hardware.

### Server manufacturer pre-installation

For enterprise deployment of the Azure Stack HCI operating system, we recommend Azure Stack HCI Integrated System solution hardware from your preferred hardware partner. The solution hardware arrives with the operating system preinstalled, and supports using Windows Admin Center to deploy and update drivers and firmware from the hardware manufacturer.

Solution hardware ranges from 2 to 16 nodes and is tested and validated by Microsoft and partner vendors. ​To find Azure Stack HCI solution hardware from your preferred hardware partner, see the [Azure Stack HCI Catalog](https://www.microsoft.com/cloud-platform/azure-stack-hci-catalog).

### Headless deployment

You can use an answer file to do a headless deployment of the operating system. The answer file uses an XML format to define configuration settings and values during an unattended installation of the operating system.

For this deployment option, you can use Windows System Image Manager to create an unattend.xml answer file to deploy the operating system on your servers. Windows System Image Manager creates your unattend answer file through a graphical tool with component sections to define the "answers" to the configuration questions, and then ensure the correct format and syntax in the file.
The Windows System Image Manager tool is available in the Windows Assessment and Deployment Kit (Windows ADK). To get started: [Download and install the Windows ADK](/windows-hardware/get-started/adk-install).

### System Center Virtual Machine Manager (VMM) deployment

You can use System Center Virtual Machine Manager to deploy the Azure Stack HCI operating system on bare-metal hardware, as well as to cluster the servers. To learn about VMM, see [System requirements for System Center Virtual Machine Manager](/system-center/vmm/system-requirements).

For more information about using VMM to do a bare-metal deployment of the operating system, see [Provision a Hyper-V host or cluster from bare metal computers](/system-center/vmm/hyper-v-bare-metal).

### Network deployment

Another option is to install the Azure Stack HCI operating system over the network using [Windows Deployment Services](/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/hh831764(v=ws.11)).

### Manual deployment

To manually deploy the Azure Stack HCI operating system on the system drive of each server to be clustered, install the operating system via your preferred method, such as booting from a DVD or USB drive. Complete the installation process using the Server Configuration tool (Sconfig) to prepare the servers for clustering. To learn more about the tool, see [Configure a Server Core installation with Sconfig](/windows-server/get-started/sconfig-on-ws2016).

To manually install the Azure Stack HCI operating system:
1. Start the Install Azure Stack HCI wizard on the system drive of the server where you want to install the operating system.
1. Choose the language to install or accept the default language settings, select **Next**, and then on next page of the wizard, select **Install now**.

    :::image type="content" source="../media/operating-system/azure-stack-hci-install-language.png" alt-text="The language page of the Install Azure Stack HCI wizard.":::

1. On the Applicable notices and license terms page, review the license terms, select the **I accept the license terms** checkbox, and then select **Next**.
1. On the Which type of installation do you want? page, select **Custom: Install the newer version of Azure Stack HCI only (advanced)**.

    > [!NOTE]
    > Upgrade installations are not supported in this release of the operating system.

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

Now you're ready to use the Server Configuration tool (Sconfig) to perform important tasks. To use Sconfig, log on to the server running the Azure Stack HCI operating system. This could be locally via a keyboard and monitor, or using a remote management (headless or BMC) controller, or Remote Desktop. The Sconfig tool opens automatically when you log on to the server.

:::image type="content" source="../media/operating-system/azure-stack-hci-sconfig-screen.png" alt-text="The Server Configuration tool interface." lightbox="../media/operating-system/azure-stack-hci-sconfig-screen.png":::

From the main page of the Sconfig tool, you can perform the following initial configuration tasks:
- Configure networking or confirm that the network was configured automatically using Dynamic Host Configuration Protocol (DHCP).
- Rename the server if the default automatically generated server name does not suit you.
- Join the server to an Active Directory domain.
- Add your domain user account or designated domain group to local administrators.
- Enable access to Windows Remote Management (WinRM) if you plan to manage the server from outside the local subnet and decided not to join domain yet. (The default Firewall rules allow management both from local subnet and from any subnet within your Active Directory domain services.)

After configuring the operating system as needed with Sconfig on each server, you're ready to use the Cluster Creation wizard in Windows Admin Center to cluster the servers.

## Next steps

To perform the next management task related to this article, see:
> [!div class="nextstepaction"]
> [Create an Azure Stack HCI cluster](../deploy/create-cluster.md)
