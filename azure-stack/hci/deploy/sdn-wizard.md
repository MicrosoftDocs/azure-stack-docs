---
title: Deploy SDN using Windows Admin Center
description: Learn how to deploy an SDN infrastructure using Windows Admin Center
author: v-dasis
ms.topic: how-to
ms.date: 10/29/2021
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Deploy SDN using Windows Admin Center

> Applies to: Azure Stack HCI, versions 21H2 and 20H2

You can deploy SDN Network Controller using Windows Admin Center either during or after cluster creation. This article discusses how to deploy SDN Network Controller after cluster deployment.

To deploy SDN Network Controller during cluster creation, see [Step 5: SDN (optional)](create-cluster.md#step-5-sdn-optional) of the Create cluster wizard.

For a full SDN deployment including Software Load Balancers and Gateways, use the [SDN Express](../manage/sdn-express.md) script. You can also use SDN Express to deploy Software Load Balancers or Gateways after deploying the Network Controller through WAC.

You can also deploy an SDN infrastructure using System Center Virtual Machine Manager (VMM). For more information, see [Manage SDN resources in the VMM fabric](/system-center/vmm/network-sdn).

## Before you begin

Before you begin an SDN deployment, plan out and configure your physical and host network infrastructure. Reference the following articles:

- See [Physical network requirements](../concepts/physical-network-requirements.md)
- See [Host network requirements](../concepts/host-network-requirements.md)
- See [Create a cluster using Windows Admin Center](create-cluster.md)
- See [Create a cluster using Windows PowerShell](create-cluster-powershell.md)
- See [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure.md)
- See the **Phased deployment** section of [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure.md#phased-deployment) to determine the capabilities enabled by deploying Network Controller

## Requirements

The following requirements must be met for a successful SDN deployment:

- All server nodes must have Hyper-V enabled
- All server nodes must be joined to Active Directory
- A virtual switch must be created
- The physical network must be configured

## Create the VHDX file

SDN uses a VHDX file containing the Azure Stack HCI operating system (OS) as a source for creating the SDN virtual machines (VMs). The version of the OS in your VHDX must match the version used by the Azure Stack HCI Hyper-V hosts. This VHDX file is used by all SDN infrastructure components.

If you've downloaded and installed the Azure Stack HCI OS from an ISO, you can create the VHDX file using the `Convert-WindowsImage` utility. The following shows an example using `Convert-WindowsImage`:

~~~powershell
Install-Module -Name Convert-WindowsImage
Import-Module Convert-WindowsImage

$wimpath = "E:\sources\install.wim"
$vhdpath = "D:\temp\AzureStackHCI.vhdx"
$edition=1
Convert-WindowsImage -SourcePath $wimpath -Edition $edition -VHDPath $vhdpath -SizeBytes 500GB -DiskLayout UEFI
~~~

> [!NOTE]
> This script should be run from a Windows client computer. You will probably need to run this as Administrator and to modify the execution policy for scripts using the Set-ExecutionPolicy command.

## Configure SDN deployment

SDN Network Controller deployment functionality is an extension in Windows Admin Center. Complete the following steps to deploy Network Controller on your existing Azure Stack HCI cluster.

1. In Windows Admin Center, under **Tools** select **Settings**, then select **Extensions**.
1. On the **Installed Exensions** tab, verify that the **SDN Infrastructure** extension is installed. If not, install it.
1. In Windows Admin Center, under **Tools**, select **SDN Infrastructure**.

    :::image type="content" source="media/sdn/sdn-wizard.png" alt-text="SDN deployment wizard in Windows Admin Center" lightbox="media/sdn/sdn-wizard.png":::

1. Under **Cluster settings**, under **Host**, enter a name for the Network Controller. This is the DNS name used by management clients (such as Windows Admin Center) to communicate with Network Controller. You can also use the default populated name.
1. Specify a path to the Azure Stack HCI VHD file. Use **Browse** to find it quicker.
1. Specify the number of VMs to be dedicated for Network Controller. Three VMs are strongly recommended for production deployments.
1. Under **Network**, enter the VLAN ID of the management network. Network Controller needs connectivity to same management network as the Hyper-V hosts so that it can communicate and configure the hosts.
1. For **VM network addressing**, select either **DHCP** or **Static**.
1. If you selected **DHCP**, enter the name for the Network Controller VMs. You can also use the default populated names.
1. If you selected **Static**, do the following:
     - Specify an IP address.
     - Specify a subnet prefix.
     - Specify the default gateway.
     - Specify one or more DNS servers. Click **Add** to add additional DNS servers.
1. Under **Credentials**, enter the username and password used to join the Network Controller VMs to the cluster domain.
1. Enter the local administrative password for these VMs.
1. Under **Advanced**, enter the path to the VMs. You can also use the default populated path.
1. Enter values for **MAC address pool start** and **MAC address pool end**. You can also use the default populated values. This is the MAC pool used to assign MAC addresses to VMs attached to SDN networks.
1. When finished, click **Next: Deploy**.
1. Wait until the wizard completes its job. Stay on this page until all progress tasks are complete. Then click **Finish**.

> [!NOTE]
> If deployment fails, delete all Network Controller VMs and their VHDs from all server nodes, then run the deployment wizard again.

## Next steps

- Manage SDN logical networks. See [Manage tenant logical networks](../manage/tenant-logical-networks.md).
- Manage SDN virtual networks. See [Manage tenant virtual networks](../manage/tenant-virtual-networks.md).
- Manage microsegmentation with datacenter firewall. See [Use Datacenter Firewall to configure ACLs](../manage/use-datacenter-firewall-windows-admin-center.md).
- Manage your VMs. See [Manage VMs](../manage/vm.md).