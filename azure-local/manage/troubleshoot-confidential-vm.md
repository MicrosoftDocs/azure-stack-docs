---
title: Troubleshoot Confidential VMs on Azure Local (Preview)
description: Learn how to troubleshoot cluster deployment, VM creation, attestation, and image build problems for confidential VMs (CVMs) on Azure Local.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.service: azure-local
ms.date: 07/27/2026
ms.subservice: hyperconverged
---

# Troubleshoot confidential VMs on Azure Local (preview)

::: moniker range=">=azloc-2607"

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to troubleshoot cluster deployment, VM creation, attestation, and image build problems with confidential VMs (CVMs) on Azure Local. It also lists the current limitations for this preview feature.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Cluster deployment problems

**Problem:** `ConfidentialVmStatus` shows `PartiallyEnabled` or `Disabled` while `ConfidentialVmIntent` is `Enable`.

**Resolution:**

1. On each node, check the registry key `HKLM:\SOFTWARE\Microsoft\AszIGVmAgent\ConfidentialVMHardwareCapability`. The correct value is `1`.
1. Verify that the Microsoft Azure Attestation (MAA) resource details are set and that all nodes show `igvmStatus: Enabled`.
1. Use the REST API to check cluster status with API version `2026-04-01-preview`.

## VM creation failures

1. Ensure the cluster was deployed with `confidentialVmIntent` set to `Enable`.
1. Verify that the Azure Stack HCI VM extension is version 1.12.0 or later.
1. Confirm that the VHDX image was built as an integrity-protected image with dm-verity and a Unified Kernel Image (UKI).

## Attestation problems

1. Verify cloud connectivity to Microsoft Azure Attestation (MAA) and Azure Key Vault (AKV).
1. Confirm that the PCR values in the attestation token match the values in `calculated_pcrs.txt`, generated during the image build.
1. Use `AttestationClient` to retrieve the JWT, then inspect it at [jwt.ms](https://jwt.ms).

## Image build problems

### Path separators

Use Unix-style forward slashes (`/`) instead of Windows backslashes (`\`) for path arguments, such as `-SshKey` and `-PackageDir`. The build script runs inside a Linux container through WSL 2.

### Passphrase for SSH key

If you're prompted for a passphrase when you use your SSH key, the key might have been created with double quotes as the passphrase (`""`). This condition can occur if you generated the key pair by using PowerShell. Try entering two double quotes (`""`) as the passphrase.

### WSL 2 problems

#### Docker Desktop integration

If Docker Desktop integration isn't working properly:

1. Open Docker Desktop.
1. Select the settings icon (the cogwheel in the upper-right corner).
1. Select **Resources**.
1. Select **WSL Integration**.
1. Verify that you enabled integration with your WSL 2 distribution (Ubuntu 24.04).
1. Select **Apply & restart**.
1. Verify that Docker is accessible from your WSL 2 distribution:

   ```powershell
   wsl -d "Ubuntu-24.04" docker info
   ```

#### Error: `ERROR [internal] load metadata for docker.io/library/ubuntu:24.04`

If you encounter this error while you use the build scripts, run the following command, then retry:

```powershell
docker pull ubuntu:24.04
```

#### Error: `ERROR: CreateProcessParseCommon:909: getpwuid(1000) failed 0`

If you encounter this error while you use WSL, run the command as your specific user:

```powershell
wsl -d "Ubuntu-24.04" -u <username> -- <command>
```

## Current limitations

- Linux-only guest OS support. Windows CVM guests aren't available.
- To maintain the security boundary, the service disables guest management features such as remote terminal and diagnostic logging.
- You must prepare images in a clean room.
- Attestation (MAA) and Secure Key Release (AKV) require cloud connectivity.

## Related content

- [Create and connect to an Azure Local confidential VM (preview)](create-connect-confidential-vm.md)
- [Guest attestation for confidential VMs on Azure Local (preview)](guest-attestation-confidential-vm.md)

::: moniker-end

::: moniker range="<=azloc-2606"

This feature is available only in Azure Local 2607 or later.

::: moniker-end
