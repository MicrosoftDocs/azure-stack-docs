---
title: Install Azure Local Small Form Factor On Your Machines (preview)
description: Learn how to install Azure Local small form factor on your machines (preview).
author: sipastak
ms.topic: how-to
ms.date: 05/04/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
zone_pivot_groups: small-form-factor-installation
---

# Install small form factor deployments of Azure Local on a machine (preview)

:::zone pivot="machine-installation"

This article describes how to install small form factor deployments of Azure Local on supported hardware and extract the ownership vouchers required to connect your machine to Azure.

If you don't have access to physical hardware, you can test small form factor deployments of Azure Local in a Hyper-V virtual machine (VM). For more information, select the **VM installation** option in this article.

> [!NOTE]
> Use [this Azure portal preview link](https://aka.ms/sfflinux/tryit) for testing.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Prerequisites

[Set up your subscription](small-form-factor-subscription-setup.md) and make sure you have the following items.

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
> Use Rufus only. Other USB creation tools can leave the drive in a read-only state, which can prevent ownership voucher extraction.

### Additional equipment

- A USB flash drive with at least 8 GB of capacity
- A USB keyboard
- An HDMI cable and monitor
- A direct Ethernet connection with internet access

> [!IMPORTANT]
> If your environment uses firewall restrictions, review [Outbound connectivity](small-form-factor-firewall-requirements.md) before you start.

## Download the ISO and Configurator App

Download the following artifacts from the [Azure portal](https://aka.ms/sfflinux/tryit):

| Download             | Description                                                                                                  |
| -------------------- | ------------------------------------------------------------------------------------------------------------ |
| **Maintenance OS**   | Installs the maintenance environment that remains on the device and supports lifecycle operations.           |
| **Configurator App** | Lets you connect to a device from Windows to diagnose issues, collect logs, and download ownership vouchers. |

To download the files:

1. Go to the [Azure portal](https://aka.ms/sfflinux/tryit).
1. Select **Azure Arc** > **Operations** > **Machine Provisioning (preview)** > **Get started** > **View downloads**.
1. In the **Download and install** pane, review the terms, and select **Download all**.

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

1. Select **Start**.
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

You'll use the `.pem` file in the next step when you connect the provisioned machine from the Azure portal. Treat this file as required deployment material for that machine.

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

::: zone-end

:::zone pivot="vm-installation"

This article describes how to test small form factor deployments of Azure Local in a Hyper-V virtual machine (VM). You can also use this flow in an Azure VM, but you'll need to use the Azure VM workaround later in the article.

A virtual machine is useful for testing, but it doesn't behave exactly like bare-metal hardware. If you want the closest match to a customer deployment, use a supported physical device. For more information, select the **Machine installation** option in this article.

> [!NOTE]
> Use [this Azure portal preview link](https://aka.ms/sfflinux/tryit) for testing.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Prerequisites

Before you start, make sure you have:

- Completed [Subscription setup](small-form-factor-subscription-setup.md).
- A Windows machine with Hyper-V support and administrator access.
- Internet access from the Windows host.
- Enough local storage for a 256 GB virtual hard disk.
- The ability to run PowerShell as an administrator.

> [!TIP]
> If you're running Hyper-V inside an Azure VM, choose a VM size that supports nested virtualization.

## Install Hyper-V

1. Open **Turn Windows features on or off** from the Start menu.

    :::image type="content" source="media/small-form-factor-turn-windows-features-on-off.png" alt-text="Screenshot of the Turn Windows features on or off search option in the Start menu." border="true" lightbox="media/small-form-factor-turn-windows-features-on-off.png":::

1. Select **Hyper-V** and make sure the child features are selected too.

    :::image type="content" source="media/small-form-factor-hyper-v-selection.png" alt-text="Screenshot of the Windows Features Hyper-V selection." border="true" lightbox="media/small-form-factor-hyper-v-selection.png":::

1. Restart the device if Windows prompts you to do so.

## Download the ISO and Configurator App

Download these two artifacts from the [Azure portal](https://aka.ms/sfflinux/tryit):

| Download | Description |
|--|--|
| Maintenance OS | Installs the maintenance environment used during testing. |
| Configurator App | Lets you connect to the VM, download the ownership voucher, and collect logs. |

To download them:

1. Go to the [Azure portal](https://aka.ms/sfflinux/tryit).
1. Select **Azure Arc** > **Operations** > **Machine Provisioning (preview)** > **Get started** > **View downloads**.
1. Select **Download all**.

    :::image type="content" source="media/small-form-factor-download-install.png" alt-text="Screenshot of the Download and Install pane in the Azure portal showing the Download all option." border="true" lightbox="media/small-form-factor-download-install.png":::

> [!NOTE]
>
>- Leave the ISO in your **Downloads** folder. The ISO is needed for creating the VM.
>- Make sure your browser allows multiple downloads. Each file downloads separately.

## Create the virtual network

The VM needs a network that:

1. Provides DHCP for the initial connection
1. Supports assigning a static IP address later
1. Has internet connectivity

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

## Apply the Azure VM workaround if needed

If you're creating the Hyper-V environment inside an Azure VM, block access to Azure Instance Metadata Service (IMDS) from the guest VM. That prevents the test VM from trying to use the host VM identity.

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
> If you're running Hyper-V inside an Azure VM, apply the [Azure VM workaround](#apply-the-azure-vm-workaround-if-needed) before starting the VM.

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

To troubleshoot VM setup, see [Troubleshoot small form factor deployments of Azure Local](small-form-factor-troubleshoot.md#troubleshoot-vm-setup)

## Review your VM setup

Before you continue, confirm that:

- Hyper-V is installed.
- The VM is Generation 2, has TPM enabled, has Secure Boot disabled, and has at least 4 virtual processors.
- The VM booted the Maintenance OS successfully.
- You downloaded the ownership voucher and stored it securely.

::: zone-end

## Next steps

- Continue to [Connect a provisioned machine from the Azure portal](small-form-factor-connect-portal.md).