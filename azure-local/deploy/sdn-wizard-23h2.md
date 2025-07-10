---
title: Deploy SDN using Windows Admin Center for Azure Local
description: Learn how to deploy an SDN infrastructure using Windows Admin Center for Azure Local
author: alkohli
ms.topic: how-to
ms.date: 05/29/2025
ms.author: alkohli
ms.reviewer: anirbanpaul
---

# Deploy SDN using Windows Admin Center for Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to deploy Software Defined Networking (SDN) through Windows Admin Center after you deployed your Azure Local via the Azure portal.

Windows Admin Center enables you to deploy all the SDN infrastructure components on your existing Azure Local, in the following deployment order:

- Network Controller
- Software Load Balancer (SLB)
- Gateway

Alternatively, you can deploy the entire SDN infrastructure through the [SDN Express](./sdn-express-23h2.md) scripts.

You can also deploy an SDN infrastructure using System Center Virtual Machine Manager (VMM). For more information, see [Manage SDN resources in the VMM fabric](/system-center/vmm/network-sdn).

> [!IMPORTANT]
> If you are deploying SDN on an Azure Local, ensure that all the applicable SDN infrastructure VMs (Network Controller, Software Load Balancers, Gateways) are on the latest Windows Update patch. You can initiate the update from the SConfig UI on the machines. Without the latest patches, connectivity issues may arise. For more information about updating the SDN infrastructure, see [Update SDN infrastructure for Azure Local](../manage/update-sdn.md).

## Before you begin

Before you begin an SDN deployment, plan out and configure your physical and host network infrastructure. Reference the following articles:

- [Physical network requirements](../concepts/physical-network-requirements.md).
- [Host network requirements](../concepts/host-network-requirements.md).
- [Deploy a cluster using Azure portal](deploy-via-portal.md).
- [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure.md).
- The **Phased deployment** section of [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure.md#phased-deployment) to determine the capabilities enabled by deploying Network Controller.

## Requirements

The following requirements must be met for a successful SDN deployment:

- All machines must have Hyper-V enabled.
- Active Directory must be prepared. For more information, see [Prepare Active Directory](deployment-prep-active-directory.md).
- All machines must be joined to Active Directory.
- A [virtual switch](../manage/create-logical-networks.md) must be created. You can use the default switch created for Azure Local. You may need to create separate switches for compute traffic and management traffic, for example.
- The physical network must be configured.

## Download the VHDX file

[!INCLUDE [download-vhdx](../includes/hci-download-vhdx-2.md)]

## Deploy SDN Network Controller

SDN Network Controller deployment is a functionality of the SDN Infrastructure extension in Windows Admin Center. Complete the following steps to deploy Network Controller on your existing Azure Local.

1. In Windows Admin Center, under **Tools**, select **Settings**, and then select **Extensions**.
1. On the **Installed Extensions** tab, verify that the **SDN Infrastructure** extension is installed. If not, install it.
1. In Windows Admin Center, under **Tools**, select **SDN Infrastructure**, then select **Get Started**.
1. Under **Cluster settings**, under **Host**, enter a name for the Network Controller. This is the DNS name used by management clients (such as Windows Admin Center) to communicate with Network Controller. You can also use the default populated name.

    :::image type="content" source="media/sdn/sdn-wizard.png" alt-text="SDN deployment wizard in Windows Admin Center" lightbox="media/sdn/sdn-wizard.png":::

1. Specify a path to the Azure Local VHD file. Use **Browse** to find it quicker.
1. Specify the number of VMs to be dedicated for Network Controller. We strongly recommend three VMs for production deployments.
1. Under **Network**, enter the VLAN ID of the management network. Network Controller needs connectivity to same management network as the Hyper-V hosts so that it can communicate and configure the hosts.
1. For **VM network addressing**, select either **DHCP** or **Static**.

    - For **DHCP**, enter the name for the Network Controller VMs. You can also use the default populated names.
    - For **Static**, do the following:
    
        1. Specify an IP address.
        1. Specify a subnet prefix.
        1. Specify the default gateway.
        1. Specify one or more DNS servers. Select **Add** to add additional DNS servers.
1. Under **Credentials**, enter the username and password used to join the Network Controller VMs to the cluster domain.
    > [!NOTE]
    > You must enter the username in the following format: `domainname\username`. For example, if the domain is `contoso.com`, enter the username as `contoso\<username>`. Don't use formats like `contoso.com\<username>` or `username@contoso.com`.
1. Enter the local administrator password for these VMs.
1. Under **Advanced**, enter the path to the VMs. You can also use the default populated path.
    > [!NOTE]
    > Universal Naming Convention (UNC) paths aren't supported. For cluster storage-based paths, use a format like `C:\ClusterStorage\...`.
1. Enter values for **MAC address pool start** and **MAC address pool end**. You can also use the default populated values. This is the MAC pool used to assign MAC addresses to VMs attached to SDN networks.
1. When finished, select **Next: Deploy**.
1. Wait until the wizard completes its job. Stay on this page until all progress tasks are complete, and then select **Finish**.
1. After the Network Controller VMs are created, configure dynamic DNS updates for the Network Controller cluster name on the DNS server. For more information, see [Dynamic DNS updates](../concepts/network-controller.md#dynamic-dns-updates).

### Redeploy SDN Network Controller

If the Network Controller deployment fails or you want to deploy it again, do the following:

1. Delete all Network Controller VMs and their VHDs from all the Azure Local machines.
1. Remove the following registry key from all hosts by running this command:

   ```powershell
    Remove-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Services\NcHostAgent\Parameters\' -Name Connections
   ```

1. After removing the registry key, remove Azure Local from the Windows Admin Center management, and then add it back.

   > [!NOTE]
   > If you don't do this step, you may not see the SDN deployment wizard in Windows Admin Center.

1. (Additional step only if you plan to uninstall Network Controller and not deploy it again) Run the following cmdlet on all the machines in your Azure Local, and then skip the last step.
    
    ```powershell
    Disable-VMSwitchExtension -VMSwitchName "<Compute vmswitch name>" -Name "Microsoft Azure VFP Switch Extension"
    ```

1. Run the deployment wizard again.

## Deploy SDN Software Load Balancer

SDN SLB deployment is a functionality of the SDN Infrastructure extension in Windows Admin Center. Complete the following steps to deploy SLB on your existing Azure Local.

> [!NOTE]
> Network Controller must be set up before you configure SLB.

1. In Windows Admin Center, under **Tools**, select **Settings**, and then select **Extensions**.

1. On the **Installed Extensions** tab, verify that the **SDN Infrastructure** extension is installed. If not, install it.
1. In Windows Admin Center, under **Tools**, select **SDN Infrastructure**, then select **Get Started** on the **Load Balancer** tab.
1. Under **Load Balancer Settings**, under **Front-End subnets**, provide the following:

    - **Public VIP subnet prefix**. This could be public Internet subnets. They serve as the front end IP addresses for accessing workloads behind the load balancer, which use IP addresses from a private backend network.
    
    - **Private VIP subnet prefix**. These don’t need to be routable on the public Internet because they are used for internal load balancing.
1. Under **BGP Router Settings**, enter the **SDN ASN** for the SLB. This ASN is used to peer the SLB infrastructure with the Top of the Rack switches to advertise the Public VIP and Private VIP IP addresses.
1. Under **BGP Router Settings**, enter the **IP Address** and **ASN** of the Top of Rack switch. SLB infrastructure needs these settings to create a BGP peer with the switch. If you have an additional Top of Rack switch that you want to peer the SLB infrastructure with, add **IP Address** and **ASN** for that switch as well.
1. Under **VM Settings**, specify a path to the Azure Local VHDX file. Use **Browse** to find it quicker.
1. Specify the number of VMs to be dedicated for software load balancing. We strongly recommend at least two VMs for production deployments.
1. Under **Network**, enter the VLAN ID of the management network. SLB needs connectivity to same management network as the Hyper-V hosts so that it can communicate and configure the hosts.
1. For **VM network addressing**, select either **DHCP** or **Static**.
    - For **DHCP**, enter the name for the Network Controller VMs. You can also use the default populated names.
    
    - For **Static**, do the following:
        1. Specify an IP address.
        1. Specify a subnet prefix.
        1. Specify the default gateway.
        1. Specify one or more DNS servers. Select **Add** to add additional DNS servers.
    
1. Under **Credentials**, enter the username and password that you used to join the Software Load Balancer VMs to the cluster domain.
    > [!NOTE]
    > You must enter the username in the following format: `domainname\username`. For example, if the domain is `contoso.com`, enter the username as `contoso\<username>`. Don't use formats like `contoso.com\<username>` or `username@contoso.com`.
1. Enter the local administrative password for these VMs.
1. Under **Advanced**, enter the path to the VMs. You can also use the default populated path.
    > [!NOTE]
    > Universal Naming Convention (UNC) paths aren't supported. For cluster storage-based paths, use a format like `C:\ClusterStorage\...`.
1. When finished, select **Next: Deploy**.
1. Wait until the wizard completes its job. Stay on this page until all progress tasks are complete, and then select **Finish**.

## Deploy SDN Gateway

SDN Gateway deployment is a functionality of the SDN Infrastructure extension in Windows Admin Center. Complete the following steps to deploy SDN Gateways on your existing Azure Local.

> [!NOTE]
> Network Controller and SLB must be set up before you configure Gateways.

1. In Windows Admin Center, under **Tools**, select **Settings**, then select **Extensions**.

1. On the **Installed Extensions** tab, verify that the **SDN Infrastructure** extension is installed. If not, install it.
1. In Windows Admin Center, under **Tools**, select **SDN Infrastructure**, then select **Get Started** on the **Gateway** tab.
1. Under **Define the Gateway Settings**, under **Tunnel subnets**, provide the **GRE Tunnel Subnets**. IP addresses from this subnet are used for provisioning on the SDN gateway VMs for GRE tunnels. If you don't plan to use GRE tunnels, put any placeholder subnets in this field.
1. Under **BGP Router Settings**, enter the **SDN ASN** for the Gateway. This ASN is used to peer the gateway VMs with the Top of the Rack switches to advertise the GRE IP addresses. This field is auto populated to the SDN ASN used by SLB.
1. Under **BGP Router Settings**, enter the **IP Address** and **ASN** of the Top of Rack switch. Gateway VMs need these settings to create a BGP peer with the switch. These fields are auto populated from the SLB deployment wizard. If you have an additional Top of Rack switch that you want to peer the gateway VMs with, add **IP Address** and **ASN** for that switch as well.
1. Under **Define the Gateway VM Settings**, specify a path to the Azure Local VHDX file. Use **Browse** to find it quicker.
1. Specify the number of VMs to be dedicated for gateways. We strongly recommend at least two VMs for production deployments.
1. Enter the value for **Redundant Gateways**. Redundant gateways don't host any gateway connections. In event of failure or restart of an active gateway VM, gateway connections from the active VM are moved to the redundant gateway and the redundant gateway is then marked as active. In a production deployment, we strongly recommend that you have at least one redundant gateway.

    > [!NOTE]
    > Ensure that the total number of gateway VMs is at least one more than the number of redundant gateways. Otherwise, you won't have any active gateways to host gateway connections.
1. Under **Network**, enter the VLAN ID of the management network. Gateways needs connectivity to same management network as the Hyper-V hosts and Network Controller VMs.
1. For VM network addressing, select either **DHCP** or **Static**.

    - For **DHCP**, enter the name for the Gateway VMs. You can also use the default populated names.
    
    - For **Static**, do the following:
        1. Specify an IP address.
        1. Specify a subnet prefix.
        1. Specify the default gateway.
        1. Specify one or more DNS servers. Select **Add** to add additional DNS servers.
        
1. Under **Credentials**, enter the username and password used to join the Gateway VMs to the cluster domain.
    > [!NOTE]
    > You must enter the username in the following format: `domainname\username`. For example, if the domain is `contoso.com`, enter the username as `contoso\<username>`. Don't use formats like `contoso.com\<username>` or `username@contoso.com`.
1. Enter the local administrative password for these VMs.
1. Under **Advanced**, provide the **Gateway Capacity**. It is auto populated to 10 Gbps. Ideally, you should set this value to approximate throughput available to the gateway VM. This value may depend on various factors, such as physical NIC speed on the host machine, other VMs on the host machine and their throughput requirements.
    > [!NOTE]
    > Universal Naming Convention (UNC) paths aren't supported. For cluster storage-based paths, use a format like `C:\ClusterStorage\...`.
1. Enter the path to the VMs. You can also use the default populated path.
1. When finished, select **Next: Deploy the Gateway**.
1. Wait until the wizard completes its job. Stay on this page until all progress tasks are complete, and then select **Finish**.

## Next steps

- Manage your VMs. See [Manage VMs](../manage/vm.md).
- Manage Software Load Balancers. See [Manage Software Load Balancers](../manage/load-balancers.md).
- Manage Gateway connections. See [Manage Gateway Connections](../manage/gateway-connections.md).
- Troubleshoot SDN deployment. See [Troubleshoot Software Defined Networking deployment via Windows Admin Center](../manage/troubleshoot-sdn-deployment.md).
