---
title: Install Azure Local Small Form Factor On Your Machines (preview)
description: Learn how to install Azure Local small form factor on your machines (preview).
author: sipastak
ms.topic: how-to
ms.date: 05/04/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Install small form factor deployments of Azure Local on a machine (preview)

This article describes how to install small form factor deployments of Azure Local on supported hardware and extract the ownership vouchers required to connect your machine to Azure.

If you don't have access to physical hardware, you can test small form factor deployments of Azure Local in a Hyper-V virtual machine (VM). For more information, see [Test small form factor deployments of Azure Local in a Hyper-V virtual machine](small-form-factor-vm-installation.md).

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Prerequisites

[Set up your subscription](small-form-factor-subscription-setup.md) and make sure you have the following items.

> [!IMPORTANT]
> If your environment uses firewall restrictions, review [Outbound connectivity](small-form-factor-firewall-requirements.md) before you start.

### Hardware

Use one of these supported devices:

- ASUS NUC 14 Pro
- ASUS NUC 15 Pro
- Lenovo ThinkEdge SE30
- Lenovo ThinkEdge SE100
- OnLogic HX521

> [!NOTE]
> Securing the Baseboard Management Controller (BMC) is essential to protect the integrity of your hardware and the systems running on it. You should always set a strong, unique password and replace any default credentials immediately. The BMC must also be kept off untrusted or public networks and placed instead on a restricted, dedicated management network with strict access controls. Because BMC implementations can vary across manufacturers, we recommend consulting your hardware vendor for their specific security guidance and best practices to ensure your environment is fully protected.

### Software and tools

- A Windows PC with internet access and a USB port
- [Rufus 4.12](https://github.com/pbatard/rufus/releases/download/v4.12/rufus-4.12p.exe)

> [!TIP]
> Use only Rufus. Other USB creation tools can leave the drive in a read-only state, which can prevent ownership voucher extraction.

### Additional equipment

- A USB flash drive with at least 8 GB of capacity
- A USB keyboard
- An HDMI cable and monitor
- A direct Ethernet connection with internet access

## Download the ISO and Configurator App

Download the following artifacts from the Azure portal:

| Download             | Description                                                                                                  |
| -------------------- | ------------------------------------------------------------------------------------------------------------ |
| **Maintenance OS**   | Installs the maintenance environment that remains on the device and supports lifecycle operations.           |
| **Configurator App** | Lets you connect to a device from Windows to diagnose issues, collect logs, and download ownership vouchers. |

To download the files:

1. In the Azure portal, select **Azure Arc** > **Operations** > **Machine Provisioning (preview)** > **Get started** > **View downloads**.

1. In the **Download and Install** pane, review the terms, and select **Download all**.

    :::image type="content" source="media/small-form-factor-download-install.png" alt-text="Screenshot of the Download and Install pane in the Azure portal." border="true" lightbox="media/small-form-factor-download-install.png":::

1. Wait for the downloads to complete. For the Configurator App, select **Open** or **Save as** if prompted by your browser.

    > [!NOTE]
    > Make sure your browser allows multiple downloads. Each file downloads separately.

1. Extract the downloaded archive to access the `provision-os.iso` file.

## Create a bootable USB drive

1. Connect the USB flash drive to your Windows PC.

1. Open **Run** from the Start menu.

1. Enter `rufus`, then select **OK**.

   > [!NOTE]
   > If Rufus isn't installed, download it from [Rufus.ie](https://rufus.ie/en/#download).

1. In Rufus, configure the following settings:
   - **Device**: Your USB drive
   - **Boot selection**: The downloaded ISO file
   - **Partition scheme**: Default
   - **File system**: Default

    :::image type="content" source="media/small-form-factor-prepare-usb.png" alt-text="Screenshot of the USB preparation settings." border="true" lightbox="media/small-form-factor-prepare-usb.png":::

1. Select **START**.
1. If prompted, choose **Write in ISO image mode**.

    :::image type="content" source="media/small-form-factor-prepare-usb-iso-image-mode.png" alt-text="Screenshot of the USB preparation settings ISO prompt." border="true" lightbox="media/small-form-factor-prepare-usb-iso-image-mode.png":::

1. Wait for the process to complete, and then safely eject the USB drive.

## Prepare the physical device

1. Ensure the device can access a network with internet connectivity.
1. If you plan to assign static IP addresses later, reserve the required IPs on the network.

    :::image type="content" source="media/small-form-factor-network-setup.png" alt-text="Diagram of the device network." border="true" lightbox="media/small-form-factor-network-setup.png":::

1. Connect the Ethernet cable to the device.
1. Connect power and turn on the device.

## Install the operating environment

### Boot from the USB drive

1. Connect a monitor and USB keyboard to the target machine.
1. Insert the bootable USB drive.
1. Connect the Ethernet cable.
1. Power on the device.
1. Repeatedly press the boot menu key:
   - **ASUS NUC** devices: `F10`
   - **Lenovo** devices: `F12`
1. From the boot menu, select the USB drive (usually labeled with `UEFI:`).

### Complete the installation

1. Wait for the installer to start.
1. Allow the installation to complete automatically.
1. Don't sign in during the process.
1. Wait for the message `Status: [Succeeded] Maintenance environment setup completed successfully`.
1. Remove the USB drive after the installation finishes.

> [!NOTE]
> Installation typically takes about five minutes and includes an automatic reboot.

## Extract ownership vouchers

The ownership voucher is a `.pem` file that proves the identity of the machine when you connect the provisioned machine to Azure from the Azure portal. In the portal deployment flow, this file is generated during installation and then made available either on the USB drive or on the device, depending on whether a USB drive is present when the voucher is written.

Use the `.pem` file in the next step when you connect the provisioned machine from the Azure portal. Treat this file as required deployment material for that machine.

If the `.pem` file is lost before the machine is connected to Azure, you can't recreate or redownload the same voucher later. In that case, you must redeploy the operating system on the machine to generate a new ownership voucher.

By default, the ownership voucher is written to your USB drive, and the local file on the device is then deleted for security. In that case, obtain the voucher by copying it from the USB drive.

If no USB drive is present when the voucher is written, the voucher remains on the device. In that case, you can obtain it by downloading it with the Configurator App or by using SSH or SCP.

You can obtain the ownership voucher in one of the following ways:

- Copy it from the USB drive
- Download it by using the Configurator App
- Download it by using SSH or SCP

## [USB drive](#tab/usb-drive)

### Copy the voucher from the USB drive

Use this option for the default flow, where the voucher was written to the USB drive during installation.

1. Insert the USB drive into your Windows PC.
1. Open the `vouchers` folder.
1. Open the folder named after the machine’s serial number.
1. Copy the `.pem` file to a secure location.
1. Repeat for each machine.

> [!TIP]
> Store the `.pem` files in a secure, backed-up location. The `.pem` files are needed for connecting the machine to Azure.

> [!IMPORTANT]
> If you lose the `.pem` file before you connect the machine to Azure, you must redeploy the operating system on that machine to generate a new ownership voucher.

## [Configurator App](#tab/configurator-app)

### Download the voucher by using Configurator App

Use this option if the voucher remained on the device and you prefer a Windows UI, need to verify the device status, or want to download the voucher without using command-line tools.

1. Install Configurator App on your Windows PC.
1. Open **Configurator App**.
1. Connect to the device using either:
    - ROE-{device-serial-number}.local, or
    - The device IP address
1. Sign in with the local administrator credentials.
   - Username: `edgeuser`
   - Password: `Password1`
1. Download the ownership voucher.

    :::image type="content" source="media/small-form-factor-download-voucher.png" alt-text="Screenshot of the Download ownership voucher option in Configurator App." border="true" lightbox="media/small-form-factor-download-voucher.png":::

## [SSH or SCP](#tab/ssh-scp)

### Download the voucher by using SSH or SCP

Use this option if the voucher remained on the device and you prefer a command-line approach. You can copy the vouchers from the device file system:

```bash
/var/staging/export/vouchers/<serial-number>/<serial-number>.pem
```

#### Requirements

- The device is powered on and connected to the network.
- You know the device IP address or hostname, such as `ROE-<serial-number>.local`.
- An SCP client is installed.

#### Example using `scp`

```bash
scp -r edgeuser@<device-ip>:/var/staging/export/vouchers/ ./vouchers/
```

When you're prompted, enter `Password1`.

#### Example using PSCP (Windows)

If you’re using PuTTY’s PSCP tool on Windows:

```powershell
# Set variables for your environment
$ip   = "<device-ip-address>"
$user = "edgeuser"
$pass = "Password1"
$src  = "/var/staging/export/vouchers/*/*.pem"
$dst  = "D:\OV"
$pscp = "C:\path\to\pscp.exe"

# Download all voucher .pem files
& $pscp -pw $pass -r "$user@${ip}:$src" $dst
```

#### Example for multiple devices

```powershell
$devices = @("192.168.1.10", "192.168.1.11", "192.168.1.12")
$dst = "D:\OV"

foreach ($ip in $devices) {
    Write-Host "Extracting voucher from $ip..."
    scp -r edgeuser@${ip}:/var/staging/export/vouchers/ "$dst\"
}
```

---

## Review your installation

Before you continue, confirm that:

- The bootable USB drive was created successfully.
- Small form factor deployments of Azure Local are installed on the target machines.
- The installation completion message appeared.
- Ownership vouchers were extracted and stored securely.

## Next steps

- Continue to [Connect a provisioned machine from the Azure portal](small-form-factor-connect-portal.md).