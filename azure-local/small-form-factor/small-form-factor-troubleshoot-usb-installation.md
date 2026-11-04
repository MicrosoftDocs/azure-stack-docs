---
title: Troubleshoot USB Installation for Small Form Factor Deployments of Azure Local (preview)
description: Learn how to troubleshoot USB installation issues for small form factor deployments of Azure Local (preview).
author: sipastak
ms.topic: troubleshooting
ms.date: 10/28/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Troubleshoot USB installation

This article describes how to troubleshoot USB installation issues for small form factor deployments of Azure Local.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Infinite USB boot loop with “Boot USB Devices First” enabled

**Problem**:

If you enable the BIOS option **Boot USB Devices First** on a device, the system can enter a continuous USB boot cycle.

This setting overrides the configured boot order and keeps prioritizing connected USB media. As a result, even after you install ROE successfully, the device keeps booting from the USB drive instead of the internal disk.

The device can appear stuck in a cycle where it:

1. Boots from the USB device
1. Reinstalls Azure Linux
1. Reboots

This cycle usually repeats about every 10 minutes.

**Cause**:

The BIOS option forces the system to prioritize USB boot media over the internal disk.

Because the installation media stays connected:

- The system keeps detecting the USB drive as the highest-priority boot device.
- The system ignores the configured internal boot order.
- The installation flow restarts after every reboot.

**Recommendation**:

Disable **Boot USB Devices First**, or the equivalent BIOS setting for your hardware model.

After you disable the setting:

- The system boots from the internal disk after installation finishes.
- The boot loop stops.
- Normal startup behavior returns.

## TPM isn't writable during installation

**Problem**:

Provisioning can fail if the device Trusted Platform Module (TPM) isn't writable. Some OEM systems ship with TPM settings that block write operations until you clear the TPM in BIOS.

If TPM write access isn't enabled:

1. Provisioning won't complete successfully.
1. The device can't continue through the expected setup flow.

**Cause**:

The TPM is in a non-writable state because of the platform BIOS configuration. This condition isn't an installer issue.

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
1. Go to **Advanced** > **Local Platform Erase Configuration**, and then select the TPM clear option.

      :::image type="content" source="media/small-form-factor-tpm-clear.png" alt-text="Screenshot showing ASUS NUC TPM clear options." border="true" lightbox="media/small-form-factor-tpm-clear.png":::

## Related content

- [Install the maintenance environment on your machine](small-form-factor-installation.md)
- [Troubleshoot management and connectivity](small-form-factor-troubleshoot.md)
