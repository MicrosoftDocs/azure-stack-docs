---
title: Reconnect Data Cluster After Azure Local Disconnected Operations Restore
description: Learn how to reconnect an Azure Local data cluster to a new restore machine after a disconnected operations restore by updating DNS, refreshing Arc agents, and restarting the control plane VM.
author: anupam8995
ms.author: kumaranupam
ms.date: 07/22/2026
ms.topic: how-to
ms.service: azure-local
ms.subservice: hyperconverged
ai-usage: ai-assisted
---

# Reconnect a data cluster after a disconnected operations restore

::: moniker range=">=azloc-2603"

This article describes how to reconnect an Azure Local data cluster to a new restore machine after you complete a [restore for disconnected operations](disconnected-operations-restore.md). After a restore, the IRVM and the control plane VM might run on a new IP address. Existing data clusters continue to point to the old IP and can't reach the restored environment until you update DNS, flush cached records, and restart the Azure Arc agents on the cluster hosts and DVM.

Use this procedure to redirect the cluster to the new IRVM and reestablish the connection so that you can manage virtual servers and other resources through the portal.

## Prerequisites

Before you start, complete these prerequisites:

- **Restore complete**: The [restore operation](disconnected-operations-restore.md) for your Azure Local disconnected environment finishes successfully.
- **New IRVM01 details**: You have the new IRVM01 ingress IP address that the restored environment uses.
- **DNS server access**: You have administrative access to the DNS server that hosts the disconnected operations DNS zone (for example, `autonomous.aldo.private`).
- **Cluster host access**: You have administrator credentials for each cluster host (for example, `v-Host1` and `v-Host2`) and the DVM.
- **Operator access**: Your identity has the required OperatorRP RBAC role in the Operator subscription. For more information, see [Operator subscription and RBAC permissions](disconnected-operations-identity.md).

## Overview of the reconnection workflow

To reconnect a data cluster to the new restore machine, complete these steps in order:

1. Update the DNS A record for the hostname on the DNS server, from DVM.
1. Flush the DNS client and server caches on the DVM and verify name resolution.
1. Restart the Azure Connected Machine agent services on each cluster host and on the DVM.
1. Restart the control plane VM that runs on one of the cluster hosts.

After you complete these steps, the cluster reconnects to the restored Azure Local disconnected operations environment, and you can create or modify resources, such as virtual servers, through the portal.

## Step 1: Update the DNS record on the DVM

Update the A record that maps the hostname (for example, `portal.autonomous.aldo.private`) to the new IP address. Run these commands from a cluster node by using the `-ComputerName` parameter to target the DNS server.

> [!NOTE]
> Replace the placeholders in the following commands with values from your environment:
>
> - `<IPa>`: IP address of the DNS server in the local network (lnet) that hosts the disconnected operations DNS zone.
> - `<IPb>`: IP address of the new IRVM01 in the restored environment.

1.  Find out the DNS forwarder by running `Get-DnsServerForwarder` on the DVM (`IPa`).

    :::image type="content" source="media/disconnected-operations/back-up-restore/dns-forwarder-entries-1.png" alt-text="First screenshot of DNS forwarder entries." lightbox=" ./media/disconnected-operations/back-up-restore/dns-forwarder-entries-1.png":::

    :::image type="content" source="media/disconnected-operations/back-up-restore/dns-forwarder-entries-2.png" alt-text="Second screenshot of DNS forwarder entries." lightbox=" ./media/disconnected-operations/back-up-restore/dns-forwarder-entries-2.png":::

1.  List the existing A records in the disconnected operations DNS zone:

    ```powershell
    Get-DnsServerResourceRecord -ComputerName <IPa> -ZoneName "autonomous.aldo.private" -RRType A
    ```

1.  Capture the current `portal` A record, clone it, and update the cloned record with the new DVM IP address:

    ```powershell
    $old = Get-DnsServerResourceRecord -ComputerName <IPa> -ZoneName "autonomous.aldo.private" -RRType A
    $new = $old.Clone()
    $new.RecordData.IPv4Address = [System.Net.IPAddress]::Parse("<IPb>")
    ```

1.  Apply the updated record to the DNS server:

    ```powershell
    Set-DnsServerResourceRecord -ComputerName <IPa> -ZoneName "autonomous.aldo.private" -OldInputObject $old -NewInputObject $new
    ```

## Step 2: Flush DNS caches and validate name resolution on the DVM

After you update the A record, clear cached DNS entries on the DVM and confirm that the hostname resolves to the new IP address.

On the DVM, run:

```powershell
Clear-DnsClientCache
Clear-DnsServerCache -Force
Resolve-DnsName portal.autonomous.aldo.private
```

Run the following command on each of the cluster nodes:

```powershell
Clear-DnsClientCache
```

Verify that `Resolve-DnsName` returns the new DVM IP address (`<IPb>`). If the output still shows the old IP address, recheck the DNS record update in step 1 and retry.

## Step 3: Restart Azure Arc agents on each host and the DVM

On each cluster host (for example, `v-Host1` and `v-Host2`) and on the DVM, restart the Azure Connected Machine agent services so that they pick up the updated DNS resolution and reestablish their connections.

1. Sign in to the host or DVM by using PowerShell.

1. Restart the Hybrid Instance Metadata Service:

    ```powershell
    Restart-Service himds
    ```

1. Restart the Guest Configuration Arc service:

    ```powershell
    Restart-Service GCArcService -ErrorAction SilentlyContinue
    ```

1. Restart the Extension service:

    ```powershell
    Restart-Service ExtensionService -ErrorAction SilentlyContinue
    ```

Repeat these steps on every cluster host and on the DVM.

## Step 4: Restart the control plane VM

Restart the control plane VM that runs on one of the cluster hosts (for example, `v-Host1` or `v-Host2`). The restart ensures that the control plane services bind to the updated DNS resolution and reconnect to the restored environment.

After the control plane VM restarts and the services come online, the connection to the restored Azure Local disconnected operations environment is reestablished. You can now create or modify resources, such as virtual servers, through the portal.

## Next step

If you need to reconnect Azure Arc on workload or management cluster machines to the restored environment, see:

> [!div class="nextstepaction"]
> [Reconnect Azure Arc on cluster machines after a disconnected operations restore](disconnected-operations-post-restore-reconnect-arc.md)

## Related content

- [Restore for disconnected operations for Azure Local](disconnected-operations-restore.md)
- [Back up disconnected operations](disconnected-operations-back-up-restore.md)
- [Disconnected operations for Azure Local](/azure/azure-local/manage/disconnected-operations-overview?view=azloc-2602&preserve-view=true)

::: moniker-end

::: moniker range="<=azloc-2602"

This feature is available only in Azure Local 2603 or later.

::: moniker-end
