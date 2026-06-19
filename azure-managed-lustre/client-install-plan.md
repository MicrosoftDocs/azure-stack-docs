---
title: Plan Your Azure Managed Lustre Client Installation
description: Review the support matrix and choose between prebuilt kmod and DKMS install methods before you install the Azure Managed Lustre client.
ms.topic: overview
author: jeffbearer
ms.author: jebearer
ms.reviewer: wdesalvador
ms.date: 06/19/2026
---

# Plan your Lustre client installation

Before you install the Azure Managed Lustre client on a virtual machine (VM), review the support matrix to confirm your distribution, architecture, and kernel are supported. Then choose between the prebuilt **kmod** install method and the **DKMS** install method based on your environment and Secure Boot requirements.

When you're ready to install, see [Install Lustre client software](client-install.md).

## Support matrix

Each row in the following table shows a combination of a distribution, architecture, Lustre client version, and kernel series that Microsoft supports. The authoritative source is the [Linux software repository for Microsoft products](https://packages.microsoft.com).

| OS | Architecture | Lustre client version | DKMS support | Supported kernel package series |
|---|---|---|---|---|
| [Ubuntu 24.04](https://packages.microsoft.com/repos/amlfs-noble/) | amd64, arm64 | 2.17.0 | 2.17.0 | [6.8.0-\*-azure, 6.11.0-\*-azure, 6.14.0-\*-azure, 6.17.0-\*-azure](https://packages.microsoft.com/repos/amlfs-noble/pool/main/k/) |
| [Ubuntu 22.04](https://packages.microsoft.com/repos/amlfs-jammy/) | amd64 | 2.15.6, 2.15.7, 2.15.8 | 2.15.8 | [5.15.0-\*-azure](https://packages.microsoft.com/repos/amlfs-jammy/pool/main/k/) |
| [Ubuntu 20.04](https://packages.microsoft.com/repos/amlfs-focal/) | amd64 | 2.15.6, 2.15.7, 2.15.8 | 2.15.8 | [5.4.0-\*-azure](https://packages.microsoft.com/repos/amlfs-focal/pool/main/k/) |
| [Ubuntu 18.04](https://packages.microsoft.com/repos/amlfs-bionic/) † | amd64 | 2.15.4 | — | [4.15.0-\*-azure, 5.4.0-\*-azure](https://packages.microsoft.com/repos/amlfs-bionic/pool/main/k/) |
| [Azure Linux 3](https://packages.microsoft.com/yumrepos/amlfs-al3/) | amd64 | 2.17.0 | 2.17.0 | [>= 6.6.119.3](https://packages.microsoft.com/yumrepos/amlfs-al3/Packages/k/) |
| [RHEL / AlmaLinux 9.7](https://packages.microsoft.com/yumrepos/amlfs-el9/) | amd64 | 2.15.7, 2.15.8 | 2.15.8 | [5.14.0-611.\*](https://packages.microsoft.com/yumrepos/amlfs-el9/Packages/k/) |
| [RHEL / AlmaLinux 9.6](https://packages.microsoft.com/yumrepos/amlfs-el9/) | amd64 | 2.15.7, 2.15.8 | 2.15.8 | [5.14.0-570.\*](https://packages.microsoft.com/yumrepos/amlfs-el9/Packages/k/) |
| [RHEL / AlmaLinux 9.5](https://packages.microsoft.com/yumrepos/amlfs-el9/) | amd64 | 2.15.6, 2.15.7 | 2.15.8 | [5.14.0-503.\*](https://packages.microsoft.com/yumrepos/amlfs-el9/Packages/k/) |
| [RHEL / AlmaLinux 9.4](https://packages.microsoft.com/yumrepos/amlfs-el9/) | amd64 | 2.15.6, 2.15.7, 2.15.8 | 2.15.8 | [5.14.0-427.\*](https://packages.microsoft.com/yumrepos/amlfs-el9/Packages/k/) |
| [RHEL / AlmaLinux 9.3](https://packages.microsoft.com/yumrepos/amlfs-el9/) | amd64 | 2.15.6 | 2.15.8 | [5.14.0-362.\*](https://packages.microsoft.com/yumrepos/amlfs-el9/Packages/k/) |
| [RHEL / AlmaLinux 9.2](https://packages.microsoft.com/yumrepos/amlfs-el9/) | amd64 | 2.15.6, 2.15.7 | 2.15.8 | [5.14.0-284.\*](https://packages.microsoft.com/yumrepos/amlfs-el9/Packages/k/) |
| [RHEL / AlmaLinux 9.1](https://packages.microsoft.com/yumrepos/amlfs-el9/) | amd64 | 2.15.6 | 2.15.8 | [5.14.0-162.\*](https://packages.microsoft.com/yumrepos/amlfs-el9/Packages/k/) |
| [RHEL / AlmaLinux 9.0](https://packages.microsoft.com/yumrepos/amlfs-el9/) | amd64 | 2.15.6, 2.15.7 | 2.15.8 | [5.14.0-70.\*](https://packages.microsoft.com/yumrepos/amlfs-el9/Packages/k/) |
| [RHEL / AlmaLinux 8.10](https://packages.microsoft.com/yumrepos/amlfs-el8/) | amd64 | 2.15.6, 2.15.7, 2.15.8 | 2.15.8 | [4.18.0-553.\*](https://packages.microsoft.com/yumrepos/amlfs-el8/Packages/k/) |
| [RHEL / AlmaLinux 8.9](https://packages.microsoft.com/yumrepos/amlfs-el8/) | amd64 | 2.15.6, 2.15.7 | 2.15.8 | [4.18.0-513.\*](https://packages.microsoft.com/yumrepos/amlfs-el8/Packages/k/) |
| [RHEL / AlmaLinux 8.8](https://packages.microsoft.com/yumrepos/amlfs-el8/) | amd64 | 2.15.6, 2.15.7 | 2.15.8 | [4.18.0-477.\*](https://packages.microsoft.com/yumrepos/amlfs-el8/Packages/k/) |
| [RHEL / AlmaLinux 8.7](https://packages.microsoft.com/yumrepos/amlfs-el8/) | amd64 | 2.15.6, 2.15.7 | 2.15.8 | [4.18.0-425.\*](https://packages.microsoft.com/yumrepos/amlfs-el8/Packages/k/) |
| [RHEL / AlmaLinux 8.6](https://packages.microsoft.com/yumrepos/amlfs-el8/) | amd64 | 2.15.6, 2.15.7 | 2.15.8 | [4.18.0-372.\*](https://packages.microsoft.com/yumrepos/amlfs-el8/Packages/k/) |
| [RHEL / CentOS 7.9](https://packages.microsoft.com/yumrepos/amlfs-el7/) † | amd64 | 2.15.4 | — | [3.10.0-1160.\*](https://packages.microsoft.com/yumrepos/amlfs-el7/Packages/k/) |

† **Frozen** - End of life.

> [!NOTE]
> - **arm64 support:** Only Ubuntu 24.04 currently provides arm64 packages.
> - **Frozen distributions:** Ubuntu 18.04 and RHEL 7 are frozen at Lustre 2.15.4. They reached end of life; no further Lustre client updates are published. Existing packages remain available for installation. Upgrade base OS for ongoing updates.
> - **Kernel update cadence:** Package availability changes as new Linux kernels are released and as Lustre gains support. When a new maintenance kernel ships for an already-supported distribution kernel series, Microsoft typically publishes a matching Lustre metapackage within one business day.
> - **DKMS support:** When a Lustre version appears in the DKMS support column, that version is also published as a DKMS package that compiles automatically on kernel upgrades. See [Choose an install method](#choose-an-install-method) for the trade-offs against prebuilt kmod packages.

## Choose an install method

Azure Managed Lustre offers two install methods for the Lustre client kernel module: prebuilt **kmod** packages or **DKMS** packages that compile on the target VM.

Choose the method that best fits your environment:

| | Prebuilt kmod | DKMS |
|---|---|---|
| **How it works** | Installs a precompiled kernel module built for your specific kernel version | Compiles the kernel module from source on your VM using DKMS (Dynamic Kernel Module Support) |
| **Install speed** | Fast - no compilation needed | Slower - compiles the module during install (typically 2-5 minutes) |
| **Kernel upgrades** | Requires a new kmod package for each kernel version. If you upgrade your kernel before a matching kmod is published, the Lustre client won't load. | Automatically rebuilds the module when your kernel is upgraded. No manual intervention needed. |
| **Package selection** | Requires matching your kernel version to the package name (might involve `sed` commands on RHEL) | Single package name - no kernel version matching needed |
| **Build dependencies** | None | Requires kernel headers, GCC, and Make (installed automatically as package dependencies) |
| **Secure Boot** | ✅ Modules are pre-signed with the Azure Services Linux Kmod PCA certificate. Works on Trusted Launch VMs without extra configuration. | ⚠️ Modules are compiled locally and unsigned. Requires Secure Boot to be disabled or MOK (Machine Owner Key) enrollment. See [Secure Boot with DKMS](client-secure-boot.md#dkms-compiled-modules-and-secure-boot). |
| **Best for** | Production environments with controlled kernel versions, Secure Boot requirements, or HPC workloads where compile overhead isn't acceptable | Development environments, workloads where kernel versions change frequently, or scenarios where you want zero-maintenance kernel upgrades |

> [!TIP]
> **Not sure which to choose?** Use **prebuilt kmod** if you're running Trusted Launch VMs with Secure Boot enabled, or if you need the fastest possible install. Use **DKMS** if you want your Lustre client to survive kernel upgrades automatically without waiting for a new kmod package to be published.

For **Confidential VM** requirements and full Secure Boot details (signing certificates, MOK enrollment for DKMS), see [Use Secure Boot with Azure Managed Lustre file system](client-secure-boot.md).

If you plan to use DKMS on **Azure Linux 3**, see the kernel lockdown note in [Use Secure Boot with Azure Managed Lustre file system](client-secure-boot.md#dkms-compiled-modules-and-secure-boot) — disabling Secure Boot alone isn't enough.

## Next steps

- [Install Lustre client software](client-install.md)
- [Upgrade Lustre client software to the current version](client-upgrade.md)
- [Use Secure Boot with Azure Managed Lustre file system](client-secure-boot.md)
- [Connect clients to an Azure Managed Lustre file system](connect-clients.md)
