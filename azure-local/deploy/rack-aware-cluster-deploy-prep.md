---
title: Prepare to deploy rack aware cluster via the Azure portal (Preview)
description: Learn how to deploy Azure Local rack aware clusters with high resiliency using ToR switches and VLAN isolation for optimal network configurations. (Preview)
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 10/31/2025
ms.topic: how-to
---


# Prepare for rack aware cluster deployment (Preview)

> Applies to: Azure Local version 2510 and later

This article describes the preparation steps to deploy Azure Local rack aware clusters. It includes network design recommendations, machine configuration guidelines, and best practices for deployment.

[!INCLUDE [important](../includes/hci-preview.md)]

## Review supported network configurations

- Make sure to review the [Network design requirements for Azure Local rack aware clusters](../concepts/rack-aware-cluster-reference-architecture.md) for detailed design and supported network configurations.

    - We strongly recommend that you deploy two Top-of-Rack (ToR) switches in each rack or room to ensure high resiliency.
    - For edge implementations where cost efficiency is a priority, a single ToR switch per room or rack might be sufficient, provided that adequate bandwidth is available. Both storage networks reside on the same device and are isolated through distinct VLANs.

- Make sure your network switches support Link Layer Discovery Protocol (LLDP) and that LLDP is enabled on all switch ports connected to the Azure Local machines. This is crucial for the LLDP Network Validator test, which verifies the network topology and connections for your rack aware cluster deployment.

## Register cluster nodes

- Make sure you register the Azure Local machines that you intend to use in the rack aware cluster. Follow the steps detailed in the [Register Azure Local machines with Azure Arc](./deployment-without-azure-arc-gateway.md).

- Verify that the Azure Local machines show in the resource group as registered.

## Test rack-to-rack latency

To validate rack-to-rack (room-to-room) network latency through a client-server testing model, use the `psping` tool.

To ensure accurate and complete testing, we recommend that you run full mesh tests. This implies that every host tests connectivity with every other host in both directions.

- **Server**: This machine listens for the incoming test traffic.

- **Client**: This machine initiates the test to measure latency.

Each host takes turns acting as both **server** and **client** when testing against other hosts.

Follow these steps to test rack-to-rack latency:

1. **[Download `psping`](/sysinternals/downloads/psping)** and extract it on each host that participates in testing.

1. **Allow TCP traffic through the firewall**. Since this test uses TCP, ensure the port is open on the **server**. Run this command:

    ```powershell  
    New-NetFirewallRule -DisplayName "\<RULENAME\>" -Direction Inbound
    -Protocol TCP -LocalPort \<PORT\> -Action Allow -Enabled True
    -ErrorAction Stop
    ```

1. **Start the `psping` server on one host**. Run this command:

    ```powershell
    .\psping.exe -s \<SERVER_IP\>:\<PORT\>
    ```

1. **Run the `psping` client on another host**. Run this command:

    ```powershell
    .\psping.exe -l 1m -n 5000 -h 5 \<SERVER_IP\>:\<PORT\>
    ```

1. **Review output analysis**: After the test is complete, `psping` provides a summary and a histogram of latency values. This analysis helps evaluate performance more effectively.

    - **Average latency**: To understand the overall network delay, use this key metric.

    - **Histogram**: To see a clear picture of how consistent the latency is across all the test packets, use this metric.

### Latency example

In this example, the average latency is 0.51 ms which is less than 1 ms.

:::image type="content" source="media/rack-aware-cluster-deploy-prep/rack-aware-cluster-test-latency.png" alt-text="Screenshot of an example when using psping." lightbox="media/rack-aware-cluster-deploy-prep/rack-aware-cluster-test-latency.png":::

To complete the full mesh testing, repeat steps 3 and 4 with different server-client combinations until every host is tested with every other host.

> [!NOTE]
> Results can vary depending on when you run the test, as TCP latency is affected by your current network conditions. We strongly recommend that you run the test *multiple* times to get a reliable average.

## Run the LLDP Network Validator test for rack aware clusters

Use the LLDP Network Validator Test to validate the network topology and connections for your rack aware cluster deployment. This test helps ensure that your network configuration meets the requirements for a successful rack aware cluster deployment.

For more information, see [Run the LLDP Network Validator test for rack aware clusters](./rack-aware-cluster-readiness-check.md).

## Next steps

Proceed to deploy your rack aware cluster by following the steps in:

- [Deploy a rack aware cluster via the Azure portal](rack-aware-cluster-deploy-portal.md).
- [Deploy a rack aware cluster via Azure Resource Manager templates](rack-aware-cluster-deployment-via-template.md).