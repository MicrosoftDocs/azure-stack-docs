---
title: Create and deploy an integrity-protected VM image for Azure Local confidential VMs (preview)
description: Learn how to use the Integrity-Protected CVM Image Builder to create Ubuntu-based confidential VM (CVM) images for Azure Local (preview).
author: sipastak
ms.author: sipastak
ms.date: 07/14/2026
ms.topic: how-to
ms.service: azure-local
ms.subservice: hyperconverged
---

# Create and deploy an integrity-protected VM image for Azure Local confidential VMs (preview)

::: moniker range=">=azloc-2607"

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to use the Integrity-Protected CVM Image Builder to create Ubuntu-based confidential virtual machine (CVM) images for Azure Local. The Integrity-Protected CVM Image Builder is available as part of the [AzureStack-Tools](https://github.com/Azure/AzureStack-Tools/tree/master/ConfidentialComputing/CvmImageBuilder) repository.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Why integrity-protected VM images are important

A CVM provides hardware-backed protections, but those protections are only meaningful if the software inside the VM can also be trusted.

The Integrity-Protected CVM Image Builder creates images where:

- The root filesystem is read-only and integrity-protected by using dm-verity.
- The operating system and workload become part of the measured boot process.
- Predictable TPM Platform Configuration Register (PCR) values are generated during image creation.

These properties allow a relying party to verify that:

- The workload is running inside a genuine confidential VM.
- The workload is running on an expected operating system image.
- The image isn't modified since it was built.

Any modification to the operating system, application files, or configuration changes the resulting PCR measurements and produces a different attestation result.

## Attestation and secure key release

The Integrity-Protected CVM Image Builder generates the PCR measurements needed to identify and verify your image. The build process writes these measurements to `calculated_pcrs.txt`.

In subsequent articles, use these measurements to:

- Perform remote attestation from a confidential VM.
- Configure Azure Key Vault for secure key release.
- Release secrets only to approved workloads.

For more information, see [Guest attestation for confidential VMs](../index.yml).

<!-- TODO: Add link to Create the Azure Local attestation sample application. -->
<!-- TODO: Add link to Configure Azure Key Vault for secure key release. -->

## Prerequisites

Run the Integrity-Protected CVM Image Builder directly on Linux or inside Docker. This article uses Docker Desktop with Windows Subsystem for Linux 2 (WSL 2) on Windows.

### Install WSL 2

1. Open PowerShell as an administrator and install Ubuntu 24.04:

   ```powershell
   wsl --install -d "Ubuntu-24.04" --version 2
   ```

1. Restart the machine if you're prompted to.

1. Verify that Ubuntu is running as a WSL 2 distribution:

   ```powershell
   wsl --list --verbose
   ```

1. Verify that you can run commands:

   ```powershell
   wsl -d "Ubuntu-24.04" -- sudo apt update
   ```

### Install Docker Desktop

Install Docker Desktop and make sure that:

- **Use WSL 2 based engine** is enabled.
- **Ubuntu 24.04** is enabled under **WSL Integration**.

Verify Docker access:

```powershell
wsl -d "Ubuntu-24.04" -- docker info
```

At this point, the build environment is configured and Docker is accessible from WSL 2. Continue by using either PowerShell or Bash.

### Install Git

# [PowerShell](#tab/powershell)

If you don't already have it, install [Git for Windows](https://git-scm.com/download/win), and then verify the installation:

```powershell
git --version
```

# [Bash](#tab/bash)

Install Git inside your Ubuntu environment, and then verify the installation:

```bash
sudo apt install -y git
git --version
```

---

## Download the Integrity-Protected CVM Image Builder

Clone the AzureStack-Tools repository:

# [PowerShell](#tab/powershell)

```powershell
git clone https://github.com/Azure/AzureStack-Tools.git --depth 1
cd AzureStack-Tools\ConfidentialComputing\CvmImageBuilder
```

# [Bash](#tab/bash)

```bash
git clone https://github.com/Azure/AzureStack-Tools.git --depth 1
cd AzureStack-Tools/ConfidentialComputing/CvmImageBuilder
```

---

## Generate an SSH key

Use this key to access the virtual machine after deployment. Create a key directory and generate a new SSH key pair:

# [PowerShell](#tab/powershell)

```powershell
mkdir keys
ssh-keygen -t ed25519 -f ".\keys\cvmkey" -N '""'
```

# [Bash](#tab/bash)

```bash
mkdir keys
ssh-keygen -t ed25519 -f "./keys/cvmkey" -N ''
```

---

## Create your first integrity-protected VM image

The simplest image contains only the base operating system.

# [PowerShell](#tab/powershell)

```powershell
.\build-docker.ps1 `
    -Username admin `
    -Image my-first-cvm.vhdx `
    -SshKey ./keys/cvmkey.pub `
    -PasswordlessSudo
```

# [Bash](#tab/bash)

```bash
./docker-build.sh \
    --username admin \
    --image my-first-cvm.vhdx \
    --ssh-key ./keys/cvmkey.pub \
    --passwordless-sudo
```

---

The build process typically takes several minutes. When it finishes, the image is written to the `out` directory.

## Review the build output

The build process generates deployment artifacts and measurement information.

**Output directory:**

| File | Description |
| --- | --- |
| `my-first-cvm.vhdx` | Integrity-protected operating system image. |
| `calculated_pcrs.txt` | Expected TPM PCR measurements. |

**Build directory:**

| File | Description |
| --- | --- |
| `uki.efi` | Unified kernel image. |
| `rootfs.squashfs` | Read-only operating system image. |
| `rootfs.hash` | dm-verity hash tree. |
| `build.log` | Build log. |

Use the `calculated_pcrs.txt` file when you configure attestation policies.

## Customize the image

The builder supports three mechanisms for customizing an image.

| Mechanism | Purpose |
| --- | --- |
| `--packages` | Install packages from Ubuntu repositories. |
| `--package-dir` | Install local `.deb` packages. |
| `--rootfs-overlay` | Add files, configuration, scripts, and services. |

### Install Ubuntu packages

Install packages from Ubuntu repositories during image creation.

# [PowerShell](#tab/powershell)

```powershell
.\build-docker.ps1 `
    -Username admin `
    -Image custom.vhdx `
    -Packages "python3"
```

# [Bash](#tab/bash)

```bash
./docker-build.sh \
    --username admin \
    --image custom.vhdx \
    --packages "python3"
```

---

The integrity-protected VM image includes all packages and their dependencies.

### Install local packages

Install one or more local `.deb` packages.

# [PowerShell](#tab/powershell)

```powershell
mkdir packages
copy custom-app_1.0_amd64.deb packages\
.\build-docker.ps1 `
    -Username admin `
    -Image custom.vhdx `
    -PackageDir ./packages
```

# [Bash](#tab/bash)

```bash
mkdir packages
cp custom-app_1.0_amd64.deb packages/
./docker-build.sh \
    --username admin \
    --image custom.vhdx \
    --package-dir ./packages
```

---

### Add files by using a rootfs overlay

Use the `--rootfs-overlay` option to add files directly into the image. The overlay directory mirrors the target filesystem. For example, this overlay structure:

```output
my-overlay/
└── usr/
    └── local/
        └── bin/
            └── my-app
```

Results in the following path inside the final image:

```output
/usr/local/bin/my-app
```

Use this mechanism to inject applications, scripts, configuration files, and systemd services.

## Example: Add a custom workload and systemd service

This example demonstrates the complete customization workflow. The example:

1. Installs Python 3.
1. Adds a simple Python web server as a custom application.
1. Creates a systemd service.
1. Builds a new integrity-protected VM image.

### Create the overlay structure

# [PowerShell](#tab/powershell)

```powershell
mkdir hello-overlay\usr\local\bin -Force
mkdir hello-overlay\usr\lib\systemd\system -Force
mkdir hello-overlay\usr\lib\systemd\system\multi-user.target.wants -Force
```

# [Bash](#tab/bash)

```bash
mkdir -p hello-overlay/usr/local/bin
mkdir -p hello-overlay/usr/lib/systemd/system
mkdir -p hello-overlay/usr/lib/systemd/system/multi-user.target.wants
```

---

### Create the application

Create the `hello-overlay/usr/local/bin/hello-web.py` file with the following contents:

```python
from http.server import BaseHTTPRequestHandler, HTTPServer

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-Type", "text/plain")
        self.end_headers()
        self.wfile.write(b"Hello from Azure Local CVM")

server = HTTPServer(("0.0.0.0", 8080), Handler)
server.serve_forever()
```

### Create the systemd service

Create the `hello-overlay/usr/lib/systemd/system/hello-web.service` file with the following contents:

```ini
[Unit]
Description=Hello World Web Server
After=network.target

[Service]
ExecStart=/usr/bin/python3 /usr/local/bin/hello-web.py
Restart=always

[Install]
WantedBy=multi-user.target
```

### Enable the service

systemd requires a symbolic link to enable the service.

# [PowerShell](#tab/powershell)

Use WSL to create the symbolic link:

```powershell
$linuxBase = (wsl wslpath -u ($PWD.Path -replace '\\', '/')).Trim()
wsl bash -c "cd '$linuxBase/hello-overlay/usr/lib/systemd/system/multi-user.target.wants' && ln -sf '../hello-web.service' 'hello-web.service'"
```

# [Bash](#tab/bash)

```bash
pushd hello-overlay/usr/lib/systemd/system/multi-user.target.wants
ln -sf ../hello-web.service hello-web.service
popd
```

---

### Build the custom image

The application requires Python 3. The image creation process installs Python by using the `--packages` option.

# [PowerShell](#tab/powershell)

```powershell
.\build-docker.ps1 `
    -Username admin `
    -Image hello-web.vhdx `
    -Packages "python3" `
    -RootfsOverlay ./hello-overlay `
    -SshKey ./keys/cvmkey.pub `
    -PasswordlessSudo
```

# [Bash](#tab/bash)

```bash
./docker-build.sh \
    --username admin \
    --image hello-web.vhdx \
    --packages "python3" \
    --rootfs-overlay ./hello-overlay \
    --ssh-key ./keys/cvmkey.pub \
    --passwordless-sudo
```

---

## Verify the workload

After you complete the steps in this article, the integrity-protected VM image is ready to be deployed to Azure Local.

<!-- TODO: Add link to Deploy the integrity-protected VM image. -->

After you deploy the image and connect to the VM by using SSH, verify that the sample workload is running:

```bash
systemctl status hello-web
```

Verify that the application is responding:

```bash
curl http://localhost:8080
```

The expected output is:

```output
Hello from Azure Local CVM
```

The Python application, service definition, and installed packages are all included within the integrity-protected VM image. Any modification to the application code, service configuration, or installed package set produces different image measurements and different TPM PCR values.

## Command-line reference

### Required parameters

| Parameter (PowerShell/Bash) | Description |
| --- | --- |
| `-UserName` / `--username` | Username for the created user account. |
| `-Image` / `--image` | Output VHDX filename. |

### Common optional parameters

| Parameter (PowerShell/Bash) | Description |
| --- | --- |
| `-SshKey` / `--ssh-key` | SSH public key file. |
| `-PasswordlessSudo` / `--passwordless-sudo` | Enable passwordless sudo. |
| `-Packages` / `--packages` | Ubuntu packages to install. |
| `-PackageDir` / `--package-dir` | Local `.deb` package directory. |
| `-RootfsOverlay` / `--rootfs-overlay` | Overlay directory. |
| `-InsidersFast` / `--insiders-fast` | Enable the `packages.microsoft.com` insiders-fast repository. |
| `-AllowSshPassword` / `--allow-ssh-password` | Enable SSH password authentication. |
| `-AllowSerialConsole` / `--allow-serial-console` | Enable serial console login. |
| `-VerboseOutput` / `--verbose-output` | Enable verbose console output. |

## Install or upgrade the Azure Stack HCI VM extension

To upgrade the extension to the newest version, run the following command:

```azurecli
az extension add --name stack-hci-vm --upgrade
```

Verify that the Azure Stack HCI VM extension version is 1.12.0 or later:

```azurecli
az extension show --name stack-hci-vm
```

## Deploy the integrity-protected VM image

To deploy the image, upload the VHDX file that you created to the Azure Local cluster. For detailed steps, see [Create Azure Local VM from local share images via Azure CLI](virtual-machine-image-local-share.md#add-vm-image-from-image-in-local-share).

## Troubleshooting

### Path separators

Path arguments, such as `-SshKey` and `-PackageDir`, must use Unix-style forward slashes (`/`) rather than Windows backslashes (`\`), because the build script runs inside a Linux container via WSL 2.

### Passphrase for SSH key

If you're prompted for a passphrase when you use your SSH key, the key might be created with double quotes as the passphrase (`""`). Try entering two double quotes (`""`) as the passphrase. This behavior can happen if you generate the key pair by using PowerShell.

### Docker Desktop integration

If Docker Desktop integration isn't working properly:

1. Open Docker Desktop.
1. Select the settings icon (the gear in the upper-right corner).
1. Select **Resources**.
1. Select **WSL Integration**.
1. Make sure that integration is enabled with your WSL 2 distribution (Ubuntu 24.04).
1. Select **Apply & restart**.
1. Verify that Docker is accessible from your WSL 2 distribution:

   ```powershell
   wsl -d "Ubuntu-24.04" docker info
   ```

### Error: load metadata for docker.io/library/ubuntu:24.04

If you get this error while you use the build scripts, run the following command and then retry:

```bash
docker pull ubuntu:24.04
```

### Error: CreateProcessParseCommon:909: getpwuid(1000) failed 0

If you get this error while you use WSL, run the command as your specific user:

```powershell
wsl -d "Ubuntu-24.04" -u <username> -- <command>
```

## Next steps

- [Create and connect to an Azure Local confidential VM](../index.yml)

::: moniker-end

::: moniker range="<=azloc-2606"

This feature is available only in Azure Local 2607 or later.

::: moniker-end
