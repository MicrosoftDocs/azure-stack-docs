---

title: Troubleshoot Network Virtual Appliance issues on Azure Stack Hub
description: 115-145 characters including spaces. This abstract displays in the search result.
author: sethmanheim
ms.author: sethm
ms.date: 4/14/2020
ms.topic: article
ms.reviewer: sranthar
ms.lastreviewed: 04/14/2020

---

# Troubleshoot Network Virtual Appliance issues

You might experience VM or VPN connectivity issues and errors when using a third party Network Virtual Appliance (NVA) in Microsoft Azure Stack Hub. This article provides basic steps to help you validate basic Azure Stack Hub platform requirements for NVA configurations.

Technical support for third-party NVAs and their integration with the Azure Stack Hub platform is provided by the NVA vendor.

> [!NOTE]
> If you have a connectivity or routing problem that involves an NVA, you should [contact the vendor of the NVA](https://support.microsoft.com/help/2984655/support-for-azure-market-place-for-virtual-machines) directly.

If your Azure Stack Hub issue is not addressed in this article, please visit the [Azure Stack Hub MSDN forum](https://social.msdn.microsoft.com/Forums/azure/home?forum=azurestack). You also can submit an Azure support request. To submit a support request, see [Azure Stack Hub support](../operator/azure-stack-manage-basics.md#where-to-get-support).

## Checklist for troubleshooting with NVA vendor

- Software updates for NVA VM software.
- Service account setup and functionality.
- User-defined routes (UDRs) on virtual network subnets that direct traffic to NVA.
- UDRs on virtual network subnets that direct traffic from NVA.
- Routing tables and rules within the NVA (for example, from NIC1 to NIC2).
- Tracing on NVA NICs to verify receiving and sending network traffic.

## Basic troubleshooting steps

- Check the basic configuration.
- Check NVA performance.
- Advanced network troubleshooting.

## Check the minimum configuration requirements for NVAs on Azure

Each NVA has basic configuration requirements to function correctly on Azure Stack Hub. The following section provides the steps to verify these basic configurations. For more information, [contact the vendor of the NVA](https://support.microsoft.com/help/2984655/support-for-azure-market-place-for-virtual-machines).

> [!IMPORTANT]
> When using an S2S tunnel, packets are further encapsulated with additional headers. This encapsulation increases the overall size of the packet. In these scenarios, you must clamp TCP **MSS** at **1350**. If your VPN devices do not support MSS clamping, you can set the MTU on the tunnel interface to **1400** bytes instead. For more information, see [Virutal Network TCPIP performance tuning](/azure/virtual-network/virtual-network-tcpip-performance-tuning).

### Check whether IP forwarding is enabled on NVA

#### Use the Azure Stack Hub portal

- Locate the NVA resource in the Azure Stack Hub portal, select **Networking**, and then select the network interface.
- On the **Network interface** page, select **IP configuration**.
- Make sure that IP forwarding is enabled.

#### Use PowerShell

- Run the following command (replace the bracketed values with your information):

   ```powershell
   Get-AzureRMNetworkInterface -ResourceGroupName <ResourceGroupName> -Name <NIC name>
   ```

- Check the **EnableIPForwarding** property.
- If IP forwarding is not enabled, run the following commands to enable it:

   ```powershell
   $nic2 = Get-AzureRMNetworkInterface -ResourceGroupName <ResourceGroupName> -Name <NIC name>
   $nic2.EnableIPForwarding = 1
   Set-AzureRMNetworkInterface -NetworkInterface $nic2
   Execute: $nic2 #and check for an expected output:
   EnableIPForwarding   : True
   NetworkSecurityGroup : null
   ```

### Check whether the traffic can be routed to the NVA.

- Locate a VM that is configured to redirect traffic to the NVA
- Run `Tracert <Private IP of NVA>` for Windows, or `Traceroute <Private IP of NVA>` to check for NVA as the next hop.
- If the NVA is not listed as the next hop, check and update the Azure Stack Hub route tables.

Some guest-level operating systems may have firewall policies in place to block ICMP traffic. These firewall rules must be updated for the preceding commands to work.

### Check whether the traffic can reach the NVA

- Locate a VM that should have connectivity to the NVA.
- Run `ping (ICMP)` or `Test-NetConnection (TCP) <Private IP of NVA>` for Windows, and `Tcpping <Private IP of NVA>` for Linux, to check whether the traffic is blocked by any Network Security Groups.
- If traffic is blocked, modify your NSGs to allow traffic.

### Check whether NVA and VMs are listening for expected traffic

- Connect to the NVA by using RDP or SSH, and then run following command:

   **Windows**:
   ```shell
   netstat -an
   ```

   **Linux**:
   ```shell
   netstat -an | grep -i listen
   ```

- If you don't see the TCP port that's used by the NVA software that is listed in the results, you must configure the application on the NVA and VM to listen and respond to traffic that reaches those ports. [Contact the NVA vendor for assistance as needed](https://support.microsoft.com/help/2984655/support-for-azure-market-place-for-virtual-machines).

## Check NVA performance

### Validate VM CPU

If CPU usage gets close to 100 percent, you may experience issues that affect network packet drops. During a CPU spike, investigate which process on the guest VM is causing the high CPU, and mitigate it if possible. You might also have to resize the VM to a larger SKU size or, for a virtual machine scale set, increase the instance count. For either of these issues, [contact the NVA vendor for assistance as needed](https://support.microsoft.com/help/2984655/support-for-azure-market-place-for-virtual-machines).

### Validate VM network statistics

If the VM network use spikes or shows periods of high usage, you might also have to increase the SKU size of the VM to obtain higher throughput capabilities.

## Advanced network administrator troubleshooting

### Capture network trace

Capture a simultaneous network trace on the source VM, the NVA, and the destination VM while you run [**PsPing**](/sysinternals/downloads/psping) or **Nmap**, and then stop the trace.

- To capture a simultaneous network trace, run the following command:

   **Windows**

   ```shell
   netsh trace start capture=yes tracefile=c:\server_IP.etl scenario=netconnection
   ```

   **Linux**

   ```shell
   sudo tcpdump -s0 -i eth0 -X -w vmtrace.cap
   ```

- Use **PsPing** or **Nmap** from the source VM to the destination VM (for example: `PsPing 10.0.0.4:80` or `Nmap -p 80 10.0.0.4`).

- Open the network trace from the destination VM by using **tcpdump** or a packet analyzer of your choice. Apply a display filter for the IP of the source VM you ran **PsPing** or **Nmap** from, such as `IPv4.address==10.0.0.4` (Windows netmon) or `tcpdump -nn -r vmtrace.cap src` or `dst host 10.0.0.4` (Linux).

### Analyze traces

If you do not see the packets coming in to the backend VM trace, there is likely an NSG or UDR interfering, or the NVA routing tables are incorrect.

If you do see the packets coming in but with no response, then you may need to address a VM application or a firewall issue. For either of these issues, [contact the NVA vendor for assistance as needed](https://support.microsoft.com/help/2984655/support-for-azure-market-place-for-virtual-machines).

### Create a support ticket

If none of the preceding steps resolve your issue, please create a [support ticket](../operator/azure-stack-manage-basics.md#where-to-get-support) and use the [on demand log collection tool](../operator/azure-stack-configure-on-demand-diagnostic-log-collection.md) to provide logs.
