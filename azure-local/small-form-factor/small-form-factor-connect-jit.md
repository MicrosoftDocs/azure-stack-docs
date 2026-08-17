---
title: Connect to Small Form Factor Deployments of Azure Local using JIT Access (preview)
description: Learn how to connect to small form factor deployments of Azure Local using JIT access (preview).
author: sipastak
ms.topic: how-to
ms.date: 08/17/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Connect to small form factor deployments of Azure Local using JIT access (preview)

This article explains how to use just-in-time (JIT) access to connect to a small form factor resource over SSH. You do everything from the **Connect** page of the resource in the Azure portal:

1. **Get role**: Request access in PIM.
1. **Check your role**: The page updates itself and loads your commands.
1. **Generate certificate**: Run the first command.
1. **SSH**: Run the second command.

Access is temporary. When it expires, you start again at step 1.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

To start, open the [Azure portal](https://portal.azure.com/), go to your provisioned machine resource page, and select **Connect**. Keep this page open. Your commands appear here later.

## Step 1: Get role

1. In the [Azure portal](https://portal.azure.com/), open **Microsoft Entra Privileged Identity Management** > **My roles** > **Azure resources**.
2. Find your eligible **Provisioned Machine** role.
3. Under **Action**, select **Activate**.
4. Set the **duration** you need access for, up to a maximum of **8 hours**.
5. Enter a justification for the request, and then submit it.
6. **Repeat** for the **Key Vault Crypto User** role on the device's key vault.

## Step 2: Wait for the role to refresh

Return to the **Connect** page. There's nothing to do here.

- The page refreshes your role status automatically. 
- When your role is active, **the page loads your commands**: the certificate command and the SSH command, prefilled with your vault name, resource ID, and device host name.

## Step 3: Generate the certificate

1. In a terminal, sign in with the right tenant and subscription:

    ```azurecli
    az login --tenant <tenant-id>
    az account set --subscription <subscription-id>
    ```

1. Copy the certificate command from the **Connect** page and run it:

    ```azurecli
    az provisionedmachine ssh-cert-create \
        --vault-name <vault-name> \
        --resource-id <resource-id>
    ```

The output gives you the private key path, the certificate path, and a ready-to-use SSH command:

```output
SSH certificate created successfully.
  Private key : C:\Users\username\AppData\Local\Temp\azssh_pm_abc123\id_rsa.pem
  Certificate : C:\Users\username\AppData\Local\Temp\azssh_pm_abc123\id_rsa.pem-cert.pub
  Usage: ssh -i C:\Users\...\id_rsa.pem -o CertificateFile=C:\Users\...\id_rsa.pem-cert.pub username_jit@<device-hostname>
```

## Step 4: SSH to the device

There are two ways to connect. Use whichever suits your setup - both use the certificate you just generated.

### Option 1: Azure CLI with Azure Arc - from anywhere using the Arc connection.

If the device is Azure Arc-enabled and you don't have direct network access to it, connect through Azure Arc. This method tunnels the session through Azure, so you don't need the device's IP address:

```azurecli
az ssh arc \
    --resource-group <resource-group> \
    --name <machine-name> \
    --local-user <username>_jit \
    --private-key-file <privateKeyPath> \
    --certificate-file <certificatePath>
```

Copy the exact command from the **Connect** page when it's available there.

When you connect, you see `Welcome to Microsoft Azure Linux` and a `<username>_jit` account created for this session. That account has `sudo` only if you activate the Provisioned Machine Administrator role.

If the first attempt fails with `404 Endpoint does not exist` or `websocket: bad handshake`, the SSH service is still initializing. Wait a few seconds and retry.

### Option 2: Native SSH - from the device's local network, using a direct connection. 

Run the SSH command from the **Connect** page or from the `Usage:` line above, replacing `<device-hostname>` with the device's IP address or host name. Ensure you have access to the device IP address. 

```bash
ssh -i <privateKeyPath> -o CertificateFile=<certificatePath> <username>_jit@<device-hostname>
```

When you connect successfully, you see a welcome message:

```output
Welcome to Microsoft Azure Linux
```

The message includes the `<username>_jit` account created for this JIT session.

You're now connected to the Azure Local small form factor device over a temporary, just-in-time session. When the activated role expires, access ends automatically.

## Troubleshooting

| Error | Fix |
|---|---|
| `No Provisioned Machine Contributor or Admin role assignment found` | Activate your provisioned machine role in PIM, wait 60 seconds, and retry. |
| `Your PIM activation has expired or been deactivated` | Activate the role again. |
| `Access denied to Key Vault` | Activate **Key Vault Crypto User**. Activating your provisioned machine role doesn't activate it. |
| `permission denied` or `user is not in the sudoers file` | You activated Contributor, which has no `sudo`. Ask your administrator for Provisioned Machine Admin. |
| `Key '{name}' not found in vault` | The CA key is missing. Contact your administrator. |
| `InvalidAuthenticationTokenTenant` | Run `az login --tenant <correct-tenant-id>`. |
| `ssh-keygen not found` | Install OpenSSH on your workstation. |
| `az provisionedmachine` not recognized | [Install the CLI extension](small-form-factor-configure-jit.md#step-3-users-install-the-cli-extension). |
| `PermissionError: [WinError 5] Access is denied` | Run your terminal as a local Windows administrator. |
