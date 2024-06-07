---
title: Collect data for common SDN troubleshooting scenarios
description: Learn how to collect network traces and logs to troubleshoot common Software Defined Networking (SDN) scenarios in Azure Stack HCI.
ms.topic: how-to
ms.author: arudell
author: arudell
ms.date: 06/07/2024
---

# Collect traces and logs for common SDN troubleshooting scenarios

> Applies to: Azure Stack HCI, versions 23H2 and 22H2; Windows Server 2022, Windows Server 2019

This article describes the data to collect to troubleshoot common scenarios in Software Defined Networking (SDN) on your Azure Stack HCI cluster. Use this information for initial troubleshooting before reaching out to Microsoft Support.

## Prerequisites

Before you begin, make sure that:

- The client computer that you use for log collection has access to the SDN environment. For example, a management computer running Windows Admin Center that can access SDN.

- You have installed the `SdnDiagnostics` module. For more information, see [Collect Software Defined Networking logs on Azure Stack HCI](/azure-stack/hci/manage/sdn-log-collection.md).

## Troubleshoot provisioning or configuration state failures

If the Network Controller reports a state other than **Success**, review the Network Controller logs to understand why it's not able to provision or achieve the desired configuration state.

- To return a list of all resources, such as virtual networks, run the following command:

    ```powershell
    Get-SdnResource -NcUri 'https://nc.contoso.com' -Resource VirtualNetwork
    ```

- To see more details regarding a specific resource, run the following command:

    ```powershell
    Get-SdnResource -NcUri 'https://nc.contoso.com' -Resource VirtualNetwork -ResourceId 'Contoso-VNET-01' | ConvertTo-Json -Depth 10
    ```

In scenarios where the `ProvisioningState` indicates a failure, you can collect just the Network Controller role.

- To collect logs for the last four hours, run the following command:

    ```powershell
    Start-SdnDataCollection -Role 'NetworkController' -IncludeLogs
    ```

- To collect logs for a specific time window when the resource was created, run the following command:

    ```powershell
    Start-SdnDataCollection -Role 'NetworkController' -IncludeLogs -FromDate "2024-05-24 09:00:00 AM" -ToDate "2024-05-24 11:00:00 AM"
    ```

In scenarios where the `ConfigurationState` indicates a failure, you might need to adjust the `-Role` with `Start-SdnDataCollection` to ensure that you capture the correct data points.

| Resource | Roles |
|--|--|
| AccessControlList | NetworkController,Server |
| Gateways | NetworkController,Gateway |
| GatewayPools | NetworkController,Gateway |
| LoadBalancerMuxes | NetworkController,LoadBalancerMux |
| LoadBalancers | NetworkController,LoadBalancerMux,Server |
| LogicalNetworks | NetworkController,Server |
| NetworkInterfaces | NetworkController,Server |
| PublicIPAddress | NetworkController,LoadBalancerMux,Server |
| SecurityTags | NetworkController,Server |
| Servers | NetworkController,Server |
| RouteTables | NetworkController,Server |
| VirtualGateways | NetworkController,Gateway |
| VirtualNetworks | NetworkController,Server |

## Troubleshoot network DataPath

When troubleshooting scenarios where traffic isn't working as expected, such as unable to reach a virtual IP or a virtual machine (VM) can't access an external resource, avoid relying on the ping protocol. Instead, use `Test-NetConnection` (Windows) or `telnet` (Linux) to test the specific endpoint you are attempting to reach. Ping can be unreliable due to factors, such as OS firewalls and network firewalls, leading to false troubleshooting results. Additionally, ping is typically blocked by default when attempting to ping a load-balanced endpoint.

Regardless of the method used for generating the traffic, ensure that numerous requests are performed, noting the protocol (ICMP, TCP, UDP) or port number being tested, and the timestamp of the results. Doing a single request isn't sufficient and carries a risk of not capturing the packet leading to false data analysis results. 

For ping, you can add `-t` to make the ping infinite. Otherwise, if using `Test-NetConnection` or `Telnet`, put them in a loop and capture 15-30 seconds of data.

For example:

```powershell
while ($true) {
    Test-NetConnection -ComputerName xx.xx.xx.xx -Port 3389
}
```

Here are the other datapoints recommended during reproduction of issue:

- Network traces taken from source and destination.
- IP address for source and destination.

## Troubleshoot virtual Gateway (L3/GRE/IPsec)

This section addresses scenarios where you encounter the following issues:

- Unable to access VMs via virtual Gateway from external location.
- Unable to access resources via virtual Gateway from virtual network associated with virtual Gateway.

Run the following command to <!--Adam: what are we capturing here?-->
```powershell
Get-SdnEnvironmentInfo -NetworkController 'nc01.contoso.com'
Start-SdnNetshTrace -ComputerName $Global:SdnDiagnostics.EnvironmentInfo.Gateway -Role Gateway

# if using IPsec, also need to capture traffic on the MUXes
# Start-SdnNetshTrace -ComputerName $Global:SdnDiagnostics.EnvironmentInfo.LoadBalancerMux -Role 'LoadBalancerMux'

# perform a repro of the issue

Stop-SdnNetshTrace -ComputerName $Global:SdnDiagnostics.EnvironmentInfo.Gateway
# Stop-SdnNetshTrace -ComputerName $Global:SdnDiagnostics.EnvironmentInfo.LoadBalancerMux
```

After you generate the network traces, you can then pick them up automatically by running [Start-SdnDataCollection](https://github.com/microsoft/SdnDiagnostics/wiki/Start-SdnDataCollection).

```powershell
# add LoadBalancerMux to -Role if using IPsec in previous step
Start-SdnDataCollection -Role NetworkController,Gateway -IncludeLogs -FromDate (Get-Date).AddHours(-1)
```

> [!NOTE]
> If you switched to a non-default directory for saving trace files, keep in mind that the traces files won’t be automatically picked up. You’ll need to manually collect them.

### Troubleshoot Load Balancer VIP or Inbound/Outbound NAT

This section addresses scenarios where you encounter the following issues:

- Unable to access a Load Balancer VIP from external location.
- Unable to access a Load Balancer VIP from a VM deployed in seperate virtual network or logical network.
- Unable to access external (on-premises or Internet) location from VM deployed on virtual network or logical network.

In these scenarios, traffic flow isn't expected to route through a Virtual Gateway or Network Virtual Appliance (NVA) and is handled directly by the Load Balancer Muxes.

The [Enable-SdnVipTrace](/functions/Enable-SdnVipTrace.md) automates enabling tracing on the datapath nodes that the traffic will traverse. Once tracing is enabled, the cmdlet will pause to allow you to reproduce the issue. Once you have reproduced the problem, press any key to continue to disable the traces.

1. To automate enabling tracing on the datapath nodes, run the following command:

    ```powershell
    Enable-SdnVipTrace -VirtualIP xx.xx.xx.xx -NcUri 'https://nc.contoso.com'
    ```

1. Once the tracing has completed, to manually retrieve trace files, use [Copy-SdnFileFromComputer](/functions/Copy-SdnFileFromComputer.md). It'll copy the .etl files over to your workstation.

    Alternatively, to automatically retrieve network traces, use [Start-SdnDataCollection](/functions/Start-SdnDataCollection.md), by running the following command:

    ```powershell
    Start-SdnDataCollection -Role NetworkController,LoadBalancerMux -IncludeLogs -FromDate (Get-Date).AddHours(-1)
    ```

Additionally, a `{VIP}_TraceMapping.json` file is generated under the working directory on your workstation. This file includes valuable information for analyzing the network traces.

### Troubleshoot East/West Traffic Flow

This section addresses scenarios where you are encounter the following issues:

- Unable to access private IP address of VM deployed on the same Virtual Network or Logical Network.
- Unable to access private IP address of VM deployed on seperate Virtual Network or Logical Network.

1. Identify the Hyper-V host that the VMs you are troubleshooting are hosted on. Once you have the Hyper-V hosts identified, perform network tracing using [Start-SdnNetshTrace](/functions/Start-SdnNetshTrace.md) and [Stop-SdnNetshTrace](/functions/Stop-SdnNetshTrace.md)

    ```powershell
    Start-SdnNetshTrace -ComputerName 'server01.contoso.com','server02.contoso.com' -Role:Server

    # repro your scenario
    Stop-SdnNetshTrace -ComputerName 'server01.contoso.com','server02.contoso.com'
    ```

1. Once the tracing is complete, to manually retrieve trace files, use [Copy-SdnFileFromComputer](/functions/Copy-SdnFileFromComputer.md) to copy the .etl files over to your workstation

    Alternatively, to automatically retrieve network traces, use [Start-SdnDataCollection](/functions/Start-SdnDataCollection.md), by running the following command:

    ```powershell
    Start-SdnDataCollection -ComputerName 'server01.contoso.com','server02.contoso.com' -IncludeLogs -FromDate (Get-Date).AddHours(-1)
    ```

## Next steps

- [Contact Microsoft Support](get-support.md)
- [Collect Software Defined Networking logs on Azure Stack HCI](./sdn-log-collection.md)