---

title: Troubleshoot network virtual appliance problems on Azure Stack Hub
description: Troubleshoot VM or VPN connectivity problems when using a network virtual appliance (NVA) in Microsoft Azure Stack Hub.
author: sethmanheim
ms.author: sethm
ms.date: 09/08/2020
ms.topic: article
ms.reviewer: sranthar
ms.lastreviewed: 05/12/2020

---

# Troubleshoot network virtual appliance problems

You might experience connectivity problems with virtual machines or VPNs that use a network virtual appliance (NVA) in Azure Stack Hub.

This article helps you validate basic platform requirements of Azure Stack Hub for NVA configurations.

An NVA's vendor provides technical support for the NVA and its integration with the Azure Stack Hub platform.

> [!NOTE]
> If you have a connectivity or routing problem that involves an NVA, you should [contact the NVA vendor](https://support.microsoft.com/help/2984655/support-for-azure-market-place-for-virtual-machines) directly.

If this article doesn't address your NVA problem with Azure Stack Hub, create an [Azure Stack Hub support ticket](../operator/azure-stack-manage-basics.md#where-to-get-support).

## Checklist for troubleshooting with an NVA vendor

- Updates for NVA VM software.
- Service account setup and functionality.
- User-defined routes (UDRs) on virtual network subnets that direct traffic to the NVA.
- UDRs on virtual network subnets that direct traffic from the NVA.
- Routing tables and rules within the NVA (for example, from NIC1 to NIC2).
- Tracing on NVA NICs to verify receiving and sending network traffic.

## Basic troubleshooting steps

1. Check the basic configuration.
2. Check NVA performance.
3. Do advanced network troubleshooting.

## Check the minimum configuration requirements for NVAs on Azure

Each NVA must meet basic configuration requirements to function correctly on Azure Stack Hub. This section shows the steps to verify these basic configurations. For more information, [contact the NVA vendor](https://support.microsoft.com/help/2984655/support-for-azure-market-place-for-virtual-machines).

> [!IMPORTANT]
> When packets use an S2S tunnel, they're further encapsulated with additional headers. This encapsulation increases the overall size of each packet.
>
> In this scenario, you must clamp TCP MSS at 1,350 bytes. If your VPN devices don't support MSS clamping, you can set the MTU on the tunnel interface to 1,400 bytes instead.
>
> For more information, see [Virtual network TCP/IP performance tuning](/azure/virtual-network/virtual-network-tcpip-performance-tuning).

### Check whether IP forwarding is enabled on the NVA

#### Use the Azure Stack Hub portal

1. Locate the NVA resource in the Azure Stack Hub portal, select **Networking**, and then select the network interface.
2. On the **Network interface** page, select **IP configuration**.
3. Make sure that IP forwarding is enabled.

#### Use PowerShell

1. Run the following command. Replace the values in angle brackets with your information.

   ```powershell
   Get-AzNetworkInterface -ResourceGroupName <ResourceGroupName> -Name <NIC name>
   ```

2. Check the **EnableIPForwarding** property.

3. If IP forwarding isn't enabled, run the following commands to enable it:

   ```powershell
   $nic2 = Get-AzNetworkInterface -ResourceGroupName <ResourceGroupName> -Name <NIC name>
   $nic2.EnableIPForwarding = 1
   Set-AzNetworkInterface -NetworkInterface $nic2
   Execute: $nic2 #and check for an expected output:
   EnableIPForwarding   : True
   NetworkSecurityGroup : null
   ```

### Check whether traffic can be routed to the NVA

1. Locate a VM that is configured to redirect traffic to the NVA.
1. To check that the NVA is the next hop, run `Tracert <Private IP of NVA>` for Windows or `Traceroute <Private IP of NVA>`.
1. If the NVA isn't listed as the next hop, check and update the Azure Stack Hub route tables.

Some guest-level operating systems might have firewall policies in place to block ICMP traffic. Update these firewall rules for the preceding commands to work.

### Check whether traffic can reach the NVA

1. Locate a VM that should have connectivity to the NVA.
1. Check whether any network security groups (NSGs) block traffic. For Windows, run `ping` (ICMP) or `Test-NetConnection <Private IP of NVA>` (TCP). For Linux, run `Tcpping <Private IP of NVA>`.
1. If your NSGs block traffic, modify them to allow traffic.

### Check whether the NVA and VMs are listening for expected traffic

1. Connect to the NVA by using RDP or SSH, and then run the following command:

   **Windows**

   ```shell
   netstat -an
   ```

   **Linux**

   ```shell
   netstat -an | grep -i listen
   ```

1. Look for the TCP ports used by the NVA software that is listed in the results. If you don't see them, configure the application on the NVA and VM to listen and respond to traffic that reaches those ports. [Contact the NVA vendor for assistance](https://support.microsoft.com/help/2984655/support-for-azure-market-place-for-virtual-machines).

## Check NVA performance

### Validate VM CPU usage

If CPU usage gets close to 100 percent, you might experience problems that affect network packet drops.

During a CPU spike, investigate which process on the guest VM is causing the high CPU usage. Then mitigate the usage if possible.

You might also need to resize the VM to a larger SKU size or, for a virtual machine scale set, increase the instance count.

If you need assistance, [contact the NVA vendor](https://support.microsoft.com/help/2984655/support-for-azure-market-place-for-virtual-machines).

### Validate VM network statistics

If the VM network use spikes or shows periods of high usage, consider increasing the VM's SKU size to get higher throughput.

## Advanced network administrator troubleshooting

### Capture a network trace

While you run [`PsPing`](/sysinternals/downloads/psping) or `Nmap`, capture a simultaneous network trace on the source and destination VMs and on the NVA. Then stop the trace.

1. To capture a simultaneous network trace, run the following command:

   **Windows**

   ```shell
   netsh trace start capture=yes tracefile=c:\server_IP.etl scenario=netconnection
   ```

   **Linux**

   ```shell
   sudo tcpdump -s0 -i eth0 -X -w vmtrace.cap
   ```

2. Use `PsPing` or `Nmap` from the source VM to the destination VM. Examples are `PsPing 10.0.0.4:80` or `Nmap -p 80 10.0.0.4`.

3. Open the network trace from the destination VM by using **tcpdump** or a packet analyzer of your choice. Apply a display filter for the IP of the source VM you ran `PsPing` or `Nmap` from. A Windows **netmon** example is `IPv4.address==10.0.0.4`. Linux examples are `tcpdump -nn -r vmtrace.cap src` and `dst host 10.0.0.4`.

### Analyze traces

If you don't see packets come into the backend VM trace, an NSG or UDR is likely interfering, or the NVA routing tables are incorrect.

If you see packets come in but with no response, you might need to address a problem with a VM application or firewall.

If you need assistance, [contact the NVA vendor](https://support.microsoft.com/help/2984655/support-for-azure-market-place-for-virtual-machines).

### Create a support ticket

If the preceding steps don't resolve your problem, create a [support ticket](../operator/azure-stack-manage-basics.md#where-to-get-support) and use the [on demand log collection tool](../operator/azure-stack-diagnostic-log-collection-overview.md) to provide logs.
