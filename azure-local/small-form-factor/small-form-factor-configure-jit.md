---
title: Configure JIT Access for Small Form Factor Deployments of Azure Local (preview)
description: Learn how to configure JIT access for small form factor deployments of Azure Local (preview).
author: sipastak
ms.topic: how-to
ms.date: 08/17/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Configure JIT access 

Just-in-time (JIT) access gives users temporary SSH access to a small form factor device through Microsoft Entra Privileged Identity Management (PIM), using a short-lived certificate.

This article covers the **one-time setup**. After that, users connect by following [Connect using JIT access](small-form-factor-connect-jit.md).

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

> [!NOTE]
> The `provisionedmachine` Azure CLI extension is in preview. Preview features are provided without a service-level agreement and aren't recommended for production workloads.

## Roles

| Role | Description |
|---|---|
| **Azure administrator** | The person doing the setup.|
| **Provisioned Machine Admin** | A PIM role on the resource. Gives a user SSH access **with `sudo`**. |
| **Provisioned Machine Contributor** | A PIM role on the resource. Gives a user SSH access **without `sudo`**. |

## Prerequisites

**Azure administrator:**

- A small form factor resource in your subscription.
- Permission to manage PIM role assignments on that resource.
- Verify that you have **Key Vault Crypto Officer** on the key vault created during the provisioning flow.
- [Azure CLI](/cli/azure/install-azure-cli) installed.

## Step 1: Admin creates the Key Vault CA key

A **Key Vault CA key** is a signing key in Azure Key Vault that acts as the certificate authority for the device. The device trusts SSH certificates signed by this key, and the CLI calls the Key Vault Sign API to issue each user a short-lived certificate. The private key is non-exportable and never leaves Key Vault.

The key vault is created automatically during the provisioning flow, so it already exists. 

1. Navigate to the key vault created for your device, select **Objects** > **Keys**, and select **New**. 
1. Import the key that was created during the provisioning flow by uploading that file. 
1. Name this new key `<provisioned-machine-name>-ssh-ca` &mdash; for example, `machine1-ssh-ca`.
1. The key vault should now have the original key pair that was there by default and the new ssh-ca key you imported.

## Step 2: Admin grants eligible PIM assignments

An admin needs to set up PIM for their organization. For more information about PIM, see [Privileged Identity Management documentation](/entra/id-governance/privileged-identity-management/).

1. In [Azure portal](https://portal.azure.com/), open **Microsoft Entra Privileged Identity Management** > **Azure resources**.
1. Select the small form factor resource, and then select **Assignments** > **Add assignments**.
1. Users can be assigned to two eligible roles. Assign a provisioned machine role to the user:

    - **Provisioned Machine Admin** if they need `sudo`.
    - **Provisioned Machine Contributor** if they don't.

1. On the **Settings** tab, set the assignment type to **Eligible**, not Active.
1. Add an approver to approve the request.
1. Repeat on the resource's key vault, assigning **Key Vault Crypto User** as **Eligible**.

## Step 3: Users install the CLI extension

The `provisionedmachine` Azure CLI extension provides the provisioned machine SSH command. Install it from the `.whl` package.

1. Download the [provisionedmachine extension .whl file](https://github.com/Azure-Samples/AzureLocal/blob/main/small-form-factor/provisionedmachine-1.0.0b5-py3-none-any.whl).

1. Install the extension.

    ```azurecli
    az extension add --source <path-to-provisionedmachine.whl>
    ```

1. If the extension is already installed, remove it and reinstall it to ensure you have the correct version:

    ```azurecli
    az extension remove --name provisionedmachine
    az extension add --source <path-to-provisionedmachine.whl>
    ```

1. Confirm the extension is installed:

    ```azurecli
    az extension list --output table
    ```

## Next step

- [Connect to small form factor deployments of Azure Local using JIT access](small-form-factor-connect-jit.md)
