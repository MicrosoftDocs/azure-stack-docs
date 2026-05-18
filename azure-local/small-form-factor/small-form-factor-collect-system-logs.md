---
title: Collect System Logs for Small Form Factor Deployments of Azure Local (preview)
description: Learn how to collect system logs for small form factor deployments of Azure Local (preview).
author: sipastak
ms.topic: how-to
ms.date: 05/04/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Collect system logs for small form factor deployments of Azure Local (preview)

This article describes how to create and download a support package from a small form factor Azure Local device.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure you have completed the following prerequisites:

- The [Configurator App](small-form-factor-configurator-app.md) is installed on your Windows PC.
- Your Windows PC is on the same network as the device.
- You can reach the device IP address from your PC.

To verify connectivity, open PowerShell and run:

```powershell
ping <ip-address>
```

## Connect to the device in the Configurator App

1. Open **Configurator App**.

1. Enter the device IP address in the **Machine name** prompt. Select **Next**.

1. Enter the username and select **Next**.

1. Enter the password or SSH key. Select **Sign in**.

1. After you sign in, select the help icon in the upper-right corner to open **Support & Troubleshooting**.

      :::image type="content" source="media/small-form-factor-support.png" alt-text="Screenshot showing the support and troubleshooting icon in the Configurator App." border="true" lightbox="media/small-form-factor-support.png":::

1. Select **Create** under **Create a support log package**.

1. After the support package is generated, select **Download** under **Download support log package**.

1. Choose a local folder, then select **Save**.

## Choose the correct credentials

The credentials you use depend on the current state of the **provisioned machine** resource in Azure.

### Credential mapping by device state

| Device state | Credential set |
| --- | --- |
| I haven't created a provisioned machine yet | Set A |
| Ready to connect | Set A |
| Provisioned | Set A |
| Clustering | Try Set A first, then Set B |
| Clustered | Set B |
| Unknown | Try Set A first, then Set B |

### Credential sets

| Credential set | Username | Authentication method | Secret |
|--| -- |--|--|
| Set A: Maintenance OS credentials | `edgeuser` | Password | `Password1` |
| Set B: Target OS credentials | The username entered during target OS setup, usually `clouduser` | SSH key | The SSH key downloaded by your browser during setup |