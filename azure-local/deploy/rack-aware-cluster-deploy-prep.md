---
title: Deploy Rack Aware Cluster via the Azure portal
description: Learn how to deploy Azure Local Rack Aware Clusters with high resiliency using ToR switches and VLAN isolation for optimal network configurations.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 10/07/2025
ms.topic: how-to
---


# Prepare for Rack Aware Cluster deployment

This document describes the preparation steps for deploying Azure Local
Rack Aware Clusters. It includes network design recommendations, machine
configuration guidelines, and best practices for deployment.

## Review supported network configurations

- Make sure to review the [Network design requirements for Azure Local Rack Aware Clusters](../index.yml) for detailed design and supported network configurations.

    - We strongly recommend that you deploy two Top of Rack (ToR) switches in each rack or room to ensure high resiliency.
    - For edge implementations where cost efficiency is a priority, a single ToR switch per room or rack may be sufficient, provided that adequate bandwidth is available.
    - Both storage networks reside on the same device and are isolated through distinct VLANs.

- Ensure that your network switches support Link Layer Discovery Protocol (LLDP) and that LLDP is enabled on all switch ports connected to the Azure Local machines. This is crucial for the LLDP Network Validator test, which verifies the network topology and connections for your Rack Aware Cluster deployment.

## Register cluster nodes

- Make sure to register the Azure Local machines that you intend to use in the Rack Aware Cluster. Follow the steps detailed in the [Register Azure Local machines with Azure Arc](./deployment-without-azure-arc-gateway.md).

    Verify that the Azure Local machines show in the resource group as registered.

## (Optional) Test rack-to-rack latency

Use the `psping` tool to validate rack-to-rack (room-to-room) network latency through a client-server testing model.

To ensure accurate and complete testing, we recommend that you run full mesh tests. This implies that every host tests connectivity with every other host in both directions.

- **Server**: This machine listens for the incoming test traffic.

- **Client**: This machine initiates the test to measure latency.

Each host takes turns acting as both **server** and **client** when testing against other hosts.

Follow these steps to test rack-to-rack latency:

1. **[Download psping](https://docs.microsoft.com/sysinternals/downloads/psping)**. Download and extract `psping` on each host that participates in testing.

1. **Allow TCP traffic through the firewall**. Since this test uses TCP, ensure the port is open on the **server**. Run this PowerShell command:

    ```powershell  
    New-NetFirewallRule -DisplayName "\<RULENAME\>" -Direction Inbound
    -Protocol TCP -LocalPort \<PORT\> -Action Allow -Enabled True
    -ErrorAction Stop
    ```

1. **Start the `psping` server on one host**. Run this PowerShell command:

    ```powershell
    .\psping.exe -s \<SERVER_IP\>:\<PORT\>
    ```

1. **Run the `psping` client on another host**. Run this PowerShell command:

    ```powershell
    .\psping.exe -l 1m -n 5000 -h 5 \<SERVER_IP\>:\<PORT\>
    ```

1. **Review output analysis**: After the test is complete, `psping` provides a summary and a histogram of latency values. This helps analyze performance more effectively.

    - **Average latency**: Use this key metric to understand the overall network delay.

    - **Histogram**: Use this metric to see a clear picture of how consistent the latency is across all the test packets.

### Sample example

In this sample example, the average latency is 0.51 ms which is less than 1ms.

:::image type="content" source="media/rack-aware-cluster-deploy-prep/image2.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::

To complete full mesh testing, **repeat steps 2 and 3** with **different server-client combinations until every host has tested with every other host.

> [!NOTE]
> Results can vary depending on when you run the test, as TCP latency is affected by your current network conditions. We strongly recommend that you run the test *multiple* times to get a reliable average.

## (Optional) Run the LLDP Network Validator test for Rack Aware Clusters

Use the LLDP Network Validator Test to validate the network topology and connections for your Rack Aware Cluster deployment. This test helps ensure that your network configuration meets the requirements for a successful Rack Aware Cluster deployment.

For more information, see [Run the LLDP Network Validator test for Rack Aware Clusters](../index.yml).

## Next steps

Proceed to deploy your Rack Aware Cluster by following the steps in:

- [Deploy a Rack Aware Cluster via the Azure portal](../index.yml).
- [Deploy a Rack Aware Cluster via Azure Resource Manager templates](../index.yml).