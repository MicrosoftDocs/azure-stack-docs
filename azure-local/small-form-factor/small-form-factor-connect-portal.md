---
title: Connect a Provisioned Machine from the Azure Portal for Small Form Factor Deployments of Azure Local (preview)
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

> [!NOTE]
> Use [this Azure portal preview link](https://aka.ms/sfflinux/tryit) for testing.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure you complete the following prerequisites:

- [Set up your subscription](small-form-factor-subscription-setup.md)
- [Install small form factor](small-form-factor-installation.md) on your machines or virtual machines (VMs).
- Have a Windows PC with the [Configurator App](small-form-factor-configurator-app.md) installed.
- Have the ownership voucher (`.pem`) files for your machines.

## Create and configure an Azure Arc site

### Create the site

1. In the [Azure portal](https://aka.ms/sfflinux/tryit), search for and select **Azure Arc**.

1. Go to **Operations** > **Provisioning (preview)**.

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
   | **Region** | `East US` |
   | **Use Azure Arc Gateway** | `Yes` |
   | **Arc Gateway** | Select an existing gateway or create a new one |

1. Select **Save**.

## Add the machine

SSH keys are used for secure remote access to the machine over SSH. During provisioning, the public key is installed on the machine, and the corresponding private key is later used to authenticate SSH connections.

You can either generate a new SSH key pair in Azure or upload an existing SSH public key that you already use.

If you generate a new key pair in Azure, Azure creates both the public and private keys. The public key is installed on the machine, and the private key (`.pem` file) is downloaded to your local computer. You use the downloaded private key later to connect to the machine over SSH.

For example:

```bash
ssh -i mykey.pem clouduser@<ip-address>
```

Store the private SSH key securely. If the private key is lost and no other authentication method or authorized key exists on the machine, you might lose SSH access to the machine.

If you upload your own SSH public key, make sure that you securely store and manage the corresponding private key.

Multiple users can access the same machine either by securely sharing the same private key between authorized users or by adding additional SSH public keys to the machine for separate user access.

To add your machine:

1. Under **Provisioned machines**, select **Add**.

1. In the **Add machines using ownership vouchers** pane, upload the ownership voucher that you created in [Install small form factor deployments of Azure Local on a machine](small-form-factor-installation.md). Select **Add**.

1. In the **Operating system** dropdown list, select **Azure Linux 2604**.

1. Enter a name for the SSH key that you use later.

1. Select **Review + create**.

## Wait for the machine to become ready

   :::image type="content" source="media/small-form-factor-connect-portal.png" alt-text="Screenshot of diagram showing machine provisioning." border="true" lightbox="media/small-form-factor-connect-portal.png":::

During provisioning, the machine moves through several lifecycle states. The diagram above shows the possible machine states and transitions during provisioning.

Provisioning can take up to 25 minutes to complete.

1. Open the **Provisioned machines** tab.
1. Wait until **Machine State** changes to **Provisioned**.

      :::image type="content" source="media/small-form-factor-provision-status.png" alt-text="Screenshot of the Azure portal with the machine state status showing provisioned." border="true" lightbox="media/small-form-factor-provision-status.png":::

## Connect to the machine over SSH

When the machine state is **Provisioned**, you can connect to it over SSH.

To connect over SSH, you must have one of the following role assignments at the subscription level. Pick the role assignment based on the level of access needed:

- [Virtual Machine Administrator Login](/azure/role-based-access-control/built-in-roles/compute#virtual-machine-administrator-login): Users with this role can sign in with administrator privileges. This role provides sudo level access on the provisioned machine.

- [Virtual Machine User Login](/azure/role-based-access-control/built-in-roles/compute#virtual-machine-user-login): Users with this role can sign in with regular user privileges. This role provides non-sudo level access on the provisioned machine.

### Connect by using Azure Cloud Shell

1. Open the **Provisioned Machine** resource in the Azure portal.
1. Select **Settings** > **Connect**.
1. Open **Azure Cloud Shell**.
1. Upload your private key file to Cloud Shell.

      :::image type="content" source="media/small-form-factor-connect-ssh.png" alt-text="Screenshot of the Azure portal showing how to connect with SSH." border="true" lightbox="media/small-form-factor-connect-ssh.png":::

1. Restrict permissions on the uploaded key file.

   ```azurecli
   chmod 600 /path/to/uploaded-key-file
   ```

1. Copy the SSH command shown in the portal and paste it into CloudShell.

1. Update the command to reference the uploaded `.pem` file path in `--private-key-file`.

1. Run the command to establish the SSH connection.

> [!NOTE]
> The Azure portal automatically generates the SSH command under **Connect** for your provisioned machine.

### Connect over the local network (optional)

For local access and file transfers, you can configure SSH on your local machine.

1. Create an SSH config file:

   ```azurecli
   az ssh config -g <MANAGED_RESOURCE_GROUP_NAME> -n <ARC_FOR_SERVERS_NAME> --file ./sshconfig -i </path/to/private-key>
   ```

1. Use the config file to copy files:

   ```bash
   scp -F ~/sshconfig ~/setup-k3s-arc.sh <MANAGED_RESOURCE_GROUP_NAME>-<ARC_FOR_SERVERS_NAME>-clouduser:~
   ```

1. Use the config file to connect:

   ```bash
   ssh -F ~/sshconfig <MANAGED_RESOURCE_GROUP_NAME>-<ARC_FOR_SERVERS_NAME>-clouduser
   ```

> [!TIP]
> Using an SSH config file simplifies repeat connections and file transfers.

## Configure devices with Configurator App (optional)

The Configurator App can help you:

- Configure static IP settings and advanced networking options
- Monitor installation progress
- Troubleshoot local issues

To use the app:

1. Install the Configurator App from the [Configurator App download link](https://aka.ms/ztp/configuratorapp).
1. Reopen the app and run it as an administrator.
1. Connect by using the device serial number or the IP address shown on the console.
1. If the device is still running the maintenance environment (ROE), sign in with:
   - Username: `edgeuser`
   - Password: `Password1`
1. After the target OS is installed, sign in using your SSH key and configured username.

## Next steps

- [Run containerized workloads](small-form-factor-containerized-workloads.md)