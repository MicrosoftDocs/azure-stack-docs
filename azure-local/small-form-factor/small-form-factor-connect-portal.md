---
title: Connect a Provisioned Machine from the Azure portal for Small Form Factor Deployments of Azure Local (preview)
description: Learn how to connect a provisioned machine from the Azure portal for small form factor deployments of Azure Local (preview).
author: sipastak
ms.topic: how-to
ms.date: 05/04/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Connect a provisioned machine from the Azure portal (preview)

This article describes how to create an Azure Arc site, upload an ownership voucher, and connect a provisioned machine to Azure.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure you complete the following prerequisites:

- [Set up your subscription](small-form-factor-prepare-to-deploy.md#set-up-your-azure-subscription).
- [Install the maintenance environment on your machine for small form factor deployments](small-form-factor-installation.md).
- Optionally, have a Windows PC with the [Configurator App](small-form-factor-configurator-app.md) installed.
- Have an ownership voucher (`.pem`) file for provisioning your small form factor machines.

## Create and configure an Azure Arc site

### Create the site

1. In the Azure portal, search for and select **Azure Arc**.

1. Go to **Operations** > **Machine provisioning (preview)**.

1. On **Get started**, select **Provision**.

      :::image type="content" source="media/small-form-factor-arc-provision.png" alt-text="Screenshot of the Azure portal with the provision option selected." border="true" lightbox="media/small-form-factor-arc-provision.png":::

1. On the **Basics** tab, select **Create new** to create a new site, or choose an existing site.

1. Enter a site name, select your subscription, choose a resource group, and then select **Create**.

   > [!NOTE]
   > By default, Azure creates a new resource group with the same name as the site. You can select an existing resource group instead.

### Configure the site

1. On the **Basics** tab, select **Configure** under the selected site.

1. Configure the following settings on the **Site Configuration** pane.

   | Setting | Value |
   | --- | --- |
   | **Use Azure Arc Gateway** | `Yes` |
   | **Arc Gateway** | Select an existing gateway or create a new one |

1. Select **Save**.

## SSH key for accessing your small form factor machine

Use SSH keys for secure remote access to the machine over SSH. During provisioning, the process generates a new SSH key pair. Azure creates both the public and private keys. Azure installs the public key on the small form factor machine, and you download the private key (`.pem` file) to your local computer. Use the downloaded private key later to connect to the machine over SSH.

Store the private SSH key securely. If you lose the private key and don't configure another authentication method like JIT, you might lose SSH access to the provisioned machine.

For example:

```bash
ssh -i mykey.pem clouduser@<ip-address>
```

## Add the machine

To add your machine:

1. Under **Provisioned machines**, select **Add**.

1. In the **Add machines using ownership vouchers** pane, upload the ownership voucher that you created in [Install the maintenance environment on your machine](small-form-factor-installation.md). Select **Add**.

1. In the **Operating system** dropdown list, select **Azure Linux 2607**.

   > [!NOTE]
   > You must select **Azure Linux 2607** to deploy Azure Local small form factor. Selecting a different option results in deployment failures later on.

1. Enter a name for the SSH key that you use later.

1. Select **Review + create**.

## Wait for the machine to become ready

During provisioning, the machine moves through several lifecycle states. The following diagram shows the possible machine states and transitions during provisioning.

   :::image type="content" source="media/small-form-factor-connect-portal.png" alt-text="Screenshot of diagram showing machine provisioning." border="true" lightbox="media/small-form-factor-connect-portal.png":::

Provisioning can take 40-60 minutes to complete.

1. Open the **Provisioned machines** tab.
1. Wait until **Status** changes to **Provisioned**.

      :::image type="content" source="media/small-form-factor-provision-status.png" alt-text="Screenshot of the Azure portal with the machine state status showing provisioned." border="true" lightbox="media/small-form-factor-provision-status.png":::

## Optional: Configure devices with Configurator App

The Configurator App can help you configure static IP settings and advanced networking options and monitor installation progress.

To use the app:
1. Install the Configurator App. Follow this link to [download the Configurator App](small-form-factor-installation.md#download-the-maintenance-os-iso-and-configurator-app) 
1. Reopen the app and run it as an administrator.
1. Connect by using the device serial number or the IP address shown on the console.
1. If the device is still running the maintenance environment (ROE), sign in with:
   - Username: `edgeuser`
   - Password: `Password1`
1. After the target OS is installed, sign in by using your SSH key and configured username.

## Next steps

- [Configure JIT access on your small form factor machine](small-form-factor-configure-jit.md)
- [Access your small form factor machine using JIT access](small-form-factor-connect-jit.md)
