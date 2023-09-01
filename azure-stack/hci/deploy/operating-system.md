---
title: Deploy the Azure Stack HCI operating system
description: Learn to deploy the Azure Stack HCI OS, and then use Windows Admin Center to connect to your servers. Learn to create a server cluster, and understand how to get the latest Windows updates and firmware for your servers.
author: pronichkin
ms.author: artemp
ms.topic: reference
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/29/2022
---

# Deploy the Azure Stack HCI operating system

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

The first step in deploying Azure Stack HCI is to [download Azure Stack HCI](./download-azure-stack-hci-software.md) and install the operating system on each server that you want to cluster. This article discusses different ways to deploy the operating system, and using Windows Admin Center to connect to the servers.

> [!NOTE]
> If you've purchased Azure Stack HCI Integrated System solution hardware from the [Azure Stack HCI Catalog](https://aka.ms/AzureStackHCICatalog) through your preferred Microsoft hardware partner, the Azure Stack HCI operating system should be pre-installed. In that case, you can skip this step and move on to [Create an Azure Stack HCI cluster](create-cluster.md).

## Determine hardware and network requirements

Microsoft recommends purchasing a validated Azure Stack HCI hardware/software solution from our partners. These solutions are designed, assembled, and validated against our reference architecture to ensure compatibility and reliability, so you get up and running quickly. Check that the systems, components, devices, and drivers you are using are certified for use with Azure Stack HCI. Visit the [Azure Stack HCI solutions](https://azure.microsoft.com/overview/azure-stack/hci) website for validated solutions.

At minimum, you need one server, a reliable high-bandwidth, low-latency network connection between servers, and SATA, SAS, NVMe, or persistent memory drives that are physically attached to just one server each. However, your hardware requirements may vary depending on the size and configuration of the cluster(s) you wish to deploy. To make sure your deployment is successful, review the Azure Stack HCI [system requirements](../concepts/system-requirements.md).

Before you deploy the Azure Stack HCI operating system:

- Plan your [physical network requirements](../concepts/physical-network-requirements.md) and [host network requirements](../concepts/host-network-requirements.md).
- If your deployment will stretch across multiple sites, determine how many servers you will need at each site, and whether the cluster configuration will be active/passive or active/active. For more information, see [Stretched clusters overview](../concepts/stretched-clusters.md).
- Carefully [choose drives](../concepts/choose-drives.md) and [plan volumes](../concepts/plan-volumes.md) to meet your storage performance and capacity requirements.

For Azure Kubernetes Service on Azure Stack HCI and Windows Server requirements, see [AKS requirements on Azure Stack HCI](/azure/aks/hybrid/overview#what-you-need-to-get-started).

## Gather information

To prepare for deployment, you'll need to take note of the server names, domain names, computer account names, RDMA protocols and versions, and VLAN ID for your deployment. Gather the following details about your environment:

- **Server name:** Get familiar with your organization's naming policies for computers, files, paths, and other resources. If you need to provision several servers, each should have a unique name.
- **Domain name:** Get familiar with your organization's policies for domain naming and domain joining. You'll be joining the servers to your domain, and you'll need to specify the domain name.
- **Computer account names:** Servers that you want to add as cluster nodes have computer accounts. These computer accounts need to be moved into their own dedicated organizational unit (OU).
- **Organizational unit (OU):** If not already done so, create a dedicated OU for your computer accounts. Consult your domain administrator about creating an OU. For detailed information, see [Create a failover cluster](/windows-server/failover-clustering/create-failover-cluster#verify-the-prerequisites).

- **Static IP addresses:** Azure Stack HCI requires static IP addresses for storage and workload (VM) traffic and doesn't support dynamic IP address assignment through DHCP for this high-speed network. You can use DHCP for the management network adapter unless you're using two in a team, in which case again you need to use static IPs. Consult your network administrator about the IP address you should use for each server in the cluster.
- **RDMA networking:** There are two types of RDMA protocols: iWarp and RoCE. Note which one your network adapters use, and if RoCE, also note the version (v1 or v2). For RoCE, also note the model of your top-of-rack switch.
- **VLAN ID:** Note the VLAN ID to be used for the network adapters on the servers, if any. You should be able to obtain this from your network administrator.
- **Site names:** For stretched clusters, two sites are used for disaster recovery. You can set up sites using [Active Directory Domain Services](/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview), or the Create cluster wizard can automatically set them up for you. Consult your domain administrator about setting up sites.

## Install Windows Admin Center

Windows Admin Center is a locally deployed, browser-based app for managing Azure Stack HCI. The simplest way to [install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) is on a local management PC (desktop mode), although you can also install it on a server (service mode).

If you install Windows Admin Center on a server, tasks that require CredSSP, such as cluster creation and installing updates and extensions, require using an account that's a member of the Gateway Administrators group on the Windows Admin Center server. For more information, see the first two sections of [Configure User Access Control and Permissions](/windows-server/manage/windows-admin-center/configure/user-access-control#gateway-access-role-definitions).

## Prepare hardware for deployment

After you've acquired the server hardware for your Azure Stack HCI solution, it's time to rack and cable it. Use the following steps to prepare the server hardware for deployment of the operating system.

1. Rack all server nodes that you want to use in your server cluster.
1. Connect the server nodes to your network switches.
1. Configure the BIOS or the Unified Extensible Firmware Interface (UEFI) of your servers as recommended by your Azure Stack HCI hardware vendor to maximize performance and reliability.

> [!NOTE]
> If you are preparing a single server deployment, see the [Azure Stack HCI OS single server overview](../concepts/single-server-clusters.md)

## Operating system deployment options

You can deploy the Azure Stack HCI operating system in the same ways that you're used to deploying other Microsoft operating systems:

- Server manufacturer pre-installation.
- Headless deployment using an answer file.
- System Center Virtual Machine Manager (VMM).
- Network deployment.
- Manual deployment by connecting either a keyboard and monitor directly to the server hardware in your datacenter, or by connecting a KVM hardware device to the server hardware.

### Server manufacturer pre-installation

For enterprise deployment of the Azure Stack HCI operating system, we recommend Azure Stack HCI Integrated System solution hardware from your preferred hardware partner. The solution hardware arrives with the operating system preinstalled, and supports using Windows Admin Center to deploy and update drivers and firmware from the hardware manufacturer.

Solution hardware ranges from 1 to 16 nodes and is tested and validated by Microsoft and partner vendors. ​To find Azure Stack HCI solution hardware from your preferred hardware partner, see the [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net).

### Headless deployment

You can use an answer file to do a headless deployment of the operating system. The answer file uses an XML format to define configuration settings and values during an unattended installation of the operating system.

For this deployment option, you can use Windows System Image Manager to create an unattend.xml answer file to deploy the operating system on your servers. Windows System Image Manager creates your unattend answer file through a graphical tool with component sections to define the "answers" to the configuration questions, and then ensure the correct format and syntax in the file.
The Windows System Image Manager tool is available in the Windows Assessment and Deployment Kit (Windows ADK). To get started: [Download and install the Windows ADK](/windows-hardware/get-started/adk-install).

### System Center Virtual Machine Manager (VMM) deployment

You can use [System Center 2022](/system-center/) to deploy the Azure Stack HCI, version 21H2 operating system on bare-metal hardware, as well as to cluster and manage the servers. For more information about using VMM to do a bare-metal deployment of the operating system, see [Provision a Hyper-V host or cluster from bare metal computers](/system-center/vmm/hyper-v-bare-metal).

> [!IMPORTANT]
> You can't use Microsoft System Center Virtual Machine Manager 2019 to deploy or manage clusters running Azure Stack HCI, version 21H2. If you're using VMM 2019 to manage your Azure Stack HCI, version 20H2 cluster, don't attempt to upgrade the cluster to version 21H2 without first installing [System Center 2022](/system-center/).

### Network deployment

Another option is to install the Azure Stack HCI operating system over the network using [Windows Deployment Services](/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/hh831764(v=ws.11)).

### Manual deployment

To manually deploy the Azure Stack HCI operating system on the system drive of each server to be clustered, install the operating system via your preferred method, such as booting from a DVD or USB drive. Complete the installation process using the Server Configuration tool (SConfig) to prepare the server or servers for clustering. To learn more about the tool, see [Configure a Server Core installation with SConfig](/windows-server/windows-server-2022/get-started/sconfig-on-ws2022).

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

1. At the Administrator command prompt, select **Ok** to change the user's password before signing in to the operating system, and press Enter.

    :::image type="content" source="../media/operating-system/azure-stack-hci-change-admin-password.png" alt-text="The change password prompt.":::

1. At the Enter new credential for Administrator prompt, enter a new password, enter it again to confirm it, and then press Enter.
1. At the Your password has been changed confirmation prompt, press Enter.

    :::image type="content" source="../media/operating-system/azure-stack-hci-admin-password-changed.png" alt-text="The changed password confirmation prompt":::

## Configure the server using SConfig

Now you're ready to use the Server Configuration tool (SConfig) to perform important tasks. To use SConfig, log on to the server running the Azure Stack HCI operating system. This could be locally via a keyboard and monitor, or using a remote management (headless or BMC) controller, or Remote Desktop. The SConfig tool opens automatically when you log on to the server.

:::image type="content" source="../media/operating-system/azure-stack-hci-sconfig-screen.png" alt-text="The Server Configuration tool interface." lightbox="../media/operating-system/azure-stack-hci-sconfig-screen.png":::

From the Welcome to Azure Stack HCI window (SConfig tool), you can perform these initial configuration tasks on each server:

- Configure networking or confirm that the network was configured automatically using Dynamic Host Configuration Protocol (DHCP).
- Rename the server if the default automatically generated server name does not suit you.
- Join the server to an Active Directory domain.
- Add your domain user account or designated domain group to local administrators.
- Enable access to Windows Remote Management (WinRM) if you plan to manage the server from outside the local subnet and decided not to join domain yet. (The default Firewall rules allow management both from local subnet and from any subnet within your Active Directory domain services.)

For more detail, see [Server Configuration Tool (SConfig)](/windows-server/administration/server-core/server-core-sconfig).

After configuring the operating system as needed with SConfig on each server, you're ready to use the Cluster Creation wizard in Windows Admin Center to cluster the servers.

> [!NOTE]
> If you're installing Azure Stack HCI on a single server, you must use PowerShell to create the cluster.

## Next steps

To perform the next management task related to this article, see:
> [!div class="nextstepaction"]
> [Create an Azure Stack HCI cluster](create-cluster.md)
