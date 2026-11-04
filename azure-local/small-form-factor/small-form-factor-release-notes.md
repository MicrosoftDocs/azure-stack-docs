---
title: Release Notes for Small Form Factor Deployments of Azure Local (preview)
description: Read about new features, supported devices, and fixed issues in version 2610 of small form factor deployments of Azure Local (preview).
author: sipastak
ms.topic: release-notes
ms.date: 10/28/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Release notes for small form factor deployments of Azure Local (preview)

This article describes new features, supported devices, and fixed issues for small form factor deployments of Azure Local.

> [!IMPORTANT]
> If you're running a release earlier than version 2610, you must reinstall Azure Local small form factor to use version 2610. Follow the [installation instructions](small-form-factor-installation.md).

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Version 2610

### Wi-Fi support

Starting with version 2610, Azure Local small form factor deployments support Wi-Fi.

### K3s included in the base image

Starting with version 2610, K3s is included in the base image for small form factor deployments of Azure Local.

### Disk and GPU subresources

Starting with version 2610, disks and GPUs are available as subresources of a provisioned machine.

### Supported devices

Version 2610 adds support for the NVIDIA Jetson Thor Developer Kit. For the full list of validated devices, see [Supported devices](small-form-factor-overview.md#supported-devices).

### NVIDIA Jetson AGX Thor Devkit devices

- The JIT remote SSH access doesn't automatically set up the expected group memberships (`render`, `video`, `docker`) for the JIT user. Use `sudo` to `clouduser` as a workaround.
- The current SFF2610 OS image for Jetson Thor is Ubuntu 24.05 and includes Jetpack 7.2.
- Security baselines support isn't currently available for this platform in the current release.
- Update functionality isn't currently available for this device platform.

### Fixed issues in version 2610

The following issues are fixed in version 2610.

| Feature area | Issue | Resolution |
|---|---|---|
| ROE install | NUC 15 Pro didn't show status messages on the CLI during ROE install, which could make the installation appear stalled. | CLI status messages now display during ROE install on NUC 15 Pro. |
| Retesting | TPM slot exhaustion could occur after repeated deployments, usually after about 15 runs, causing subsequent deployments to fail. | Fixed the TPM slot exhaustion issue that affected repeated deployments. |
| Network interfaces | A network interface update from the portal could report success without applying the change. | Fixed the issue that prevented network interface changes from being applied despite a successful result. |
| OS provisioning | OS provisioning could intermittently fail because the `LinuxEdgeObservability` extension timed out while retrieving the GCS configuration file after observability tenant registration. Registration could take up to eight minutes, exceeding the Azure Arc extension manager's five-minute enable operation timeout. | Fixed the extension timeout issue that caused intermittent OS provisioning failures. |
| OS provisioning | The Azure portal could display **Action Required!** even though OS provisioning was progressing successfully. | Fixed the incorrect **Action Required!** status during OS provisioning. |

## Related content

- [Known issues for small form factor deployments](small-form-factor-known-issues.md)
- [What are small form factor deployments of Azure Local (preview)?](small-form-factor-overview.md)
