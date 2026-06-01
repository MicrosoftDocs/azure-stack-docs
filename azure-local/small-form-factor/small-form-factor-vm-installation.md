---
title: Test Small Form Factor Deployments of Azure Local in a Hyper-V Virtual Machine (preview)
description: Learn how to test small form factor deployments of Azure Local in a Hyper-V virtual machine (preview).
author: sipastak
ms.topic: how-to
ms.date: 05/04/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Test small form factor deployments of Azure Local in a Hyper-V virtual machine (preview)

> [!IMPORTANT]
>- Virtual machines (VMs) only support testing and evaluation scenarios. Running Azure Local small form factor deployments on VMs for production use isn't supported.
>- If you plan to run production workloads, deploy on a supported physical device. For a list of supported hardware, see [Supported devices for small form factor deployments](small-form-factor-overview.md#supported-devices).

This article describes how to test small form factor deployments of Azure Local in a Hyper-V virtual machine (VM).

If you don’t have access to physical hardware, you can use a Hyper-V VM to test these deployments. You can also follow this approach in an Azure Virtual Machine, though additional workaround steps are required as described later in this article.

While a VM is useful for testing, it doesn’t fully replicate bare-metal hardware behavior. For the most accurate representation of a customer deployment, use a supported physical device. For more information, see [Install small form factor deployments of Azure Local on a machine](small-form-factor-installation.md).

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Prerequisites

Before you start, make sure you have:

- Completed [Subscription setup](small-form-factor-subscription-setup.md).
- A Windows machine with Hyper-V support and administrator access.
- Internet access from the Windows host.
- Enough local storage for a 256 GB virtual hard disk.
- The ability to run PowerShell as an administrator.

> [!TIP]
> If you're running Hyper-V inside an Azure Virtual Machine, choose a VM size that supports nested virtualization.

## Install Hyper-V

1. Open **Turn Windows features on or off** from the Start menu.

    :::image type="content" source="media/small-form-factor-turn-windows-features-on-off.png" alt-text="Screenshot of the Turn Windows features on or off search option in the Start menu." border="true" lightbox="media/small-form-factor-turn-windows-features-on-off.png":::

1. Select **Hyper-V** and make sure the child features are selected too.

    :::image type="content" source="media/small-form-factor-hyper-v-selection.png" alt-text="Screenshot of the Windows Features Hyper-V selection." border="true" lightbox="media/small-form-factor-hyper-v-selection.png":::

1. Restart the device if Windows prompts you to do so.

## Download the ISO and Configurator App

Download these two artifacts from the Azure portal:

| Download | Description |
|--|--|
| Maintenance OS | Installs the maintenance environment used during testing. |
| Configurator App | Lets you connect to the VM, download the ownership voucher, and collect logs. |

To download them:

1. Go to the Azure portal.
1. Select **Azure Arc** > **Operations** > **Machine Provisioning (preview)** > **Get started** > **View downloads**.
1. Select **Download all**.

    :::image type="content" source="media/small-form-factor-download-install.png" alt-text="Screenshot of the Download and Install pane in the Azure portal showing the Download all option." border="true" lightbox="media/small-form-factor-download-install.png":::

> [!NOTE]
>
>- Leave the ISO in your **Downloads** folder. The ISO is needed for creating the VM.
>- Make sure your browser allows multiple downloads. Each file downloads separately.

## Create the virtual network

The VM needs a network that:

- Provides DHCP for the initial connection
- Supports assigning a static IP address later
- Has internet connectivity

To simplify setup, use the provided script to create the Hyper-V switch, configure NAT, and enable DHCP.

### Run the network configuration script

1. Download [`set-network.ps1`](https://github.com/Azure-Samples/AzureLocal/blob/main/small-form-factor/set-network.ps1).
1. Save the script locally.
1. Open PowerShell and allow the script to run for the current session:

   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
   ```

1. Run the script:

   ```powershell
   .\set-network.ps1
   ```

    > [!TIP]
    > The script is idempotent. You can rerun it if setup is interrupted or if you need to repair the Hyper-V switch, NAT, or DHCP configuration. Repeat runs converge on the same network configuration instead of creating duplicate resources.

## Apply the Azure Virtual Machine workaround if needed

If you're creating the Hyper-V environment inside an Azure Virtual Machine, block access to Azure Instance Metadata Service (IMDS) from the guest VM. That prevents the test VM from trying to use the host VM identity.

Run these commands after you create the VM, but before you start it for the first time:

```powershell
$adapter = (Get-VMNetworkAdapter -VMName "<your-vm-name>")[0]
Add-VMNetworkAdapterAcl -VMNetworkAdapter $adapter -Action Deny -Direction Inbound -RemoteIPAddress "169.254.169.254"
Add-VMNetworkAdapterAcl -VMNetworkAdapter $adapter -Action Deny -Direction Outbound -RemoteIPAddress "169.254.169.254"
```

## Create the Hyper-V virtual machine

1. Open **Hyper-V Manager**.

1. Select your local machine, then select **New** > **Virtual Machine**.

1. In the Virtual Machine Wizard, configure the following settings:

   - **Specify Name and Location:** Enter a name of your choice (for example, `linuxsff-vm`).

   - **Specify Generation:** Select **Generation 2**.

   - **Assign Memory:** Set the startup memory to **16000 MB**.

   - **Configure Networking:** Select the virtual network switch created earlier. By default, the provided script names this switch `HV-Internal-NAT`.

   - **Create a New Virtual Hard Disk:** Create a new virtual hard disk with **256 GB** of storage.

   - **Installation Options:** Select **Install an operating system from a bootable CD/DVD-ROM** and choose the ROE image file downloaded in **Prepare the ROE Image**.

1. After verifying your choices in the **Summary** page, select **Finish**.

## Update the VM settings

1. In Hyper-V Manager, right-click the VM, then select **Settings**.

1. Change these settings:
   - Under **Security**, clear **Enable Secure Boot** and select **Enable Trusted Platform Module**.
   - Under **Processor**, set the virtual processor count to at least `4`.

1. Select **Apply**, then **OK**.

## Download the ownership voucher

> [!NOTE]
> If you're running Hyper-V inside an Azure Virtual Machine, apply the [Azure Virtual Machine workaround](#apply-the-azure-virtual-machine-workaround-if-needed) before starting the VM.

1. Start the VM and wait about five minutes.

1. Select **Connect** in Hyper-V Manager to open the console.

1. Wait for the message **[Succeeded] ROE setup completed successfully**.

    :::image type="content" source="media/small-form-factor-console.png" alt-text="Screenshot of Azure ROE console." border="true" lightbox="media/small-form-factor-console.png":::

    > [!TIP]
    > If you see either success message, the maintenance environment is ready. You don't need to press Enter or sign in before downloading the ownership voucher.

1. Keep the console open so you can reference the VM IP address.

1. Open **Configurator App**.

1. Enter the VM IP address and select **Next**.

1. Enter the username **`edgeuser`** and select **Next**.

1. Select **Password** as the authentication method, enter **`Password1`**, and select **Sign in**.

1. Select **Download Ownership Voucher**.

    :::image type="content" source="media/small-form-factor-download-ownership-voucher.png" alt-text="Screenshot of the provisioned machine setup page in Configurator App." border="true" lightbox="media/small-form-factor-download-ownership-voucher.png":::

1. Save the `.pem` file to a local folder.

## Troubleshoot

To troubleshoot VM setup, see [Troubleshoot small form factor deployments of Azure Local](small-form-factor-troubleshoot.md#troubleshoot-vm-setup).

## Review your VM setup

Before you continue, confirm that:

- Hyper-V is installed.
- The VM is Generation 2, has TPM enabled, has Secure Boot disabled, and has at least 4 virtual processors.
- The VM booted the Maintenance OS successfully.
- You downloaded the ownership voucher and stored it securely.

## Next steps

- Continue to [Connect a provisioned machine from the Azure portal](small-form-factor-connect-portal.md).
