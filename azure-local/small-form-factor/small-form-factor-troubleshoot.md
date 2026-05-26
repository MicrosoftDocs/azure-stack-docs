---
title: Troubleshoot Small Form Factor Deployments of Azure Local (preview)
description: Learn how to troubleshoot small form factor deployments of Azure Local (preview).
author: sipastak
ms.topic: concept-article
ms.date: 05/04/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Troubleshoot small form factor deployments of Azure Local (preview)

This article describes how to troubleshoot small form factor deployments of Azure Local.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Collect a support package from the app

A log package is composed of all the relevant logs that can help Microsoft Support troubleshoot any device issues. You can generate a log package via the local web UI. Follow these steps to collect a support package from the app:

1. Select the help icon in the top-right corner of the app to open **Support + troubleshooting**.

1. Select **Create** to begin support package collection. The package collection could take several minutes.

1. After the support package is created, select **Download**. A zipped package is downloaded on your local system. You can unzip the package and view the system log files.

## USB boot infinite loop when "Boot USB Devices First" is enabled

**Problem**:

If the BIOS option **Boot USB Devices First** is enabled on an Intel NUC device, the system can enter a continuous USB boot cycle.

This setting overrides the configured boot order and keeps prioritizing connected USB media. As a result, even after ROE is installed successfully, the device keeps booting from the USB drive instead of the internal disk.

The device can appear stuck in a cycle where it:

1. Boots from the USB device
1. Reinstalls Azure Linux
1. Reboots

This cycle usually repeats about every 10 minutes.

**Cause**:

The BIOS option forces the system to prioritize USB boot media over the internal disk.

Because the installation media stays connected:

- The system keeps detecting the USB drive as the highest-priority boot device.
- The configured internal boot order is ignored.
- The installation flow restarts after every reboot.

**Recommendation**:

Disable **Boot USB Devices First**, or the equivalent BIOS setting for your hardware model.

After you disable the setting:

- The system boots from the internal disk after installation finishes.
- The boot loop stops.
- Normal startup behavior returns.

## TPM isn't writable during provisioning

**Problem**:

Provisioning can fail if the device TPM isn't writable. Some OEM systems ship with TPM settings that block write operations until you clear the TPM in BIOS.

If TPM write access isn't enabled:

1. Provisioning won't complete successfully.
1. The device can't continue through the expected setup flow.

**Cause**:

The TPM is in a non-writable state because of the platform BIOS configuration. This isn't an installer issue.

**Recommendation**:

Perform a one-time TPM clear in the system BIOS for each device. You only need to do this once per device, not once per installation.

> [!NOTE]
> Remove all USB storage devices before you clear the TPM. On some systems, including ASUS NUC devices, leaving USB storage connected can make the USB device unusable.

TPM clear options vary by hardware vendor and BIOS version. Look under **Advanced** or **Security** for settings such as:

- **Pending Operation**
- **Local Platform Erase Configuration**

### Example: ASUS NUC

1. Remove all USB storage devices.
1. Boot the device and repeatedly press `F12` to enter BIOS.
1. Go to **Advanced** > **Local Platform Erase Configuration**, then apply the TPM clear option.

      :::image type="content" source="media/small-form-factor-tpm-clear.png" alt-text="Screenshot ASUS NUC TPM clear options." border="true" lightbox="media/small-form-factor-tpm-clear.png":::

## SSH login prompts for a password when using a `.pem` file

**Problem**:

When connecting to a provisioned machine over SSH using a `.pem` file, the connection prompts for a password instead of signing in automatically.

For example:

```bash
ssh -i mykey.pem clouduser@<ip-address>
```

Instead of connecting successfully, SSH prompts:

```text
clouduser@<ip-address>'s password:
```

**Cause**:

The `clouduser` account doesn't have a password configured.

If SSH prompts for a password, it means the `.pem` key authentication failed and SSH is falling back to password authentication.

The most common causes are:

- The wrong `.pem` file is being used. For example, using:
  - A `.pem` file downloaded for a different device.
  - The wrong .pem file is being used for the target device.
- The `.pem` file permissions weren't restricted with `chmod 600`.

If the file permissions are too open, SSH rejects the key for security reasons.

**Recommendation**:

1. Verify that you're using the correct `.pem` file downloaded from the Azure portal for the specific device you're connecting to.

1. Confirm that the key file permissions are configured correctly.
    1. On Linux, restrict the key permissions with:

    ```bash
    chmod 600 <your-key>.pem
    ```

    1. On Windows, you can restrict the key permissions using:

    ```powershell
    icacls <your-key>.pem /inheritance:r
    icacls <your-key>.pem /grant:r "%username%":R
    ```

1. Then retry the SSH connection.

1. If the issue persists, run the Azure Arc SSH command with verbose logging enabled to view detailed authentication errors:

    ```bash
    az ssh arc --verbose
    ```

1. Review the verbose output for key authentication failures, permission issues, or mismatched key errors.

## Troubleshoot VM setup

### The VM doesn't get an IP address

- Confirm the virtual machine (VM) uses the `HV-Internal-NAT` switch created by [`set-network.ps1`](https://github.com/Azure-Samples/AzureLocal/blob/main/small-form-factor/set-network.ps1).
- Confirm the host has internet connectivity.
- Rerun `set-network.ps1` from an elevated PowerShell session.

### The Configurator App can't connect

- Confirm the VM reached one of the success messages in the Hyper-V console.
- Use the IP address shown in the VM console.
- Confirm Windows Firewall or VPN settings aren't blocking local host-to-VM traffic.

### You need to debug from the VM console

For the normal flow, don't sign in to the VM console. If the setup fails or you need diagnostics, sign in with the maintenance environment credentials:

- Username: `edgeuser`
- Password: `Password1`

Use local console access only for troubleshooting. After the VM is successfully provisioned and the target OS is installed, use the SSH connection flow in [Connect a provisioned machine from the Azure portal](small-form-factor-connect-portal.md).