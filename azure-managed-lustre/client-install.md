---
title: Install Client Software for Azure Managed Lustre
description: Learn how to install client software for the Azure Managed Lustre file system.
ms.topic: how-to
author: pauljewellmsft
ms.author: pauljewell
ms.reviewer: dsundarraj
ms.date: 12/15/2025
zone_pivot_groups: select-os
---

# Install prebuilt Lustre client software

In this article, you learn how to download and install a Lustre client package. After you install the package, you can set up client virtual machines (VMs) and attach them to an Azure Managed Lustre cluster. Select an operating system version to see the instructions.

## Support matrix

<details id="support-matrix">
<summary><strong>Select to expand</strong></summary>

Each row is a distribution, architecture, Lustre client version, and kernel series combination that Microsoft publishes packages for. Authoritative source: [Linux software repository for Microsoft products](https://packages.microsoft.com).

| OS | Architecture | Lustre client version | Supported kernel package series |
|---|---|---|---|
| [Ubuntu 24.04](https://packages.microsoft.com/repos/amlfs-noble/) | amd64, arm64 | 2.16.1 | [6.8.0-\*-azure](https://packages.microsoft.com/repos/amlfs-noble/pool/main/k/) |
| [Ubuntu 22.04](https://packages.microsoft.com/repos/amlfs-jammy/) | amd64 | 2.15.6, 2.15.7, 2.15.8 | [5.15.0-\*-azure](https://packages.microsoft.com/repos/amlfs-jammy/pool/main/k/) |
| [Ubuntu 20.04](https://packages.microsoft.com/repos/amlfs-focal/) | amd64 | 2.15.6, 2.15.7, 2.15.8 | [5.4.0-\*-azure](https://packages.microsoft.com/repos/amlfs-focal/pool/main/k/) |
| [Ubuntu 18.04](https://packages.microsoft.com/repos/amlfs-bionic/) † | amd64 | 2.15.4 | [4.15.0-\*-azure, 5.4.0-\*-azure](https://packages.microsoft.com/repos/amlfs-bionic/pool/main/k/) |
| [Azure Linux 3](https://packages.microsoft.com/yumrepos/amlfs-al3/) | amd64 | 2.16.1 | [>= 6.6.119.3](https://packages.microsoft.com/yumrepos/amlfs-al3/Packages/k/) |
| [RHEL / AlmaLinux 9.7](https://packages.microsoft.com/yumrepos/amlfs-el9/) | amd64 | 2.15.7, 2.15.8 | [5.14.0-611.\*](https://packages.microsoft.com/yumrepos/amlfs-el9/Packages/k/) |
| [RHEL / AlmaLinux 9.6](https://packages.microsoft.com/yumrepos/amlfs-el9/) | amd64 | 2.15.7, 2.15.8 | [5.14.0-570.\*](https://packages.microsoft.com/yumrepos/amlfs-el9/Packages/k/) |
| [RHEL / AlmaLinux 9.5](https://packages.microsoft.com/yumrepos/amlfs-el9/) | amd64 | 2.15.6, 2.15.7 | [5.14.0-503.\*](https://packages.microsoft.com/yumrepos/amlfs-el9/Packages/k/) |
| [RHEL / AlmaLinux 9.4](https://packages.microsoft.com/yumrepos/amlfs-el9/) | amd64 | 2.15.6, 2.15.7, 2.15.8 | [5.14.0-427.\*](https://packages.microsoft.com/yumrepos/amlfs-el9/Packages/k/) |
| [RHEL / AlmaLinux 9.3](https://packages.microsoft.com/yumrepos/amlfs-el9/) | amd64 | 2.15.6 | [5.14.0-362.\*](https://packages.microsoft.com/yumrepos/amlfs-el9/Packages/k/) |
| [RHEL / AlmaLinux 9.2](https://packages.microsoft.com/yumrepos/amlfs-el9/) | amd64 | 2.15.6, 2.15.7 | [5.14.0-284.\*](https://packages.microsoft.com/yumrepos/amlfs-el9/Packages/k/) |
| [RHEL / AlmaLinux 9.1](https://packages.microsoft.com/yumrepos/amlfs-el9/) | amd64 | 2.15.6 | [5.14.0-162.\*](https://packages.microsoft.com/yumrepos/amlfs-el9/Packages/k/) |
| [RHEL / AlmaLinux 9.0](https://packages.microsoft.com/yumrepos/amlfs-el9/) | amd64 | 2.15.6, 2.15.7 | [5.14.0-70.\*](https://packages.microsoft.com/yumrepos/amlfs-el9/Packages/k/) |
| [RHEL / AlmaLinux 8.10](https://packages.microsoft.com/yumrepos/amlfs-el8/) | amd64 | 2.15.6, 2.15.7, 2.15.8 | [4.18.0-553.\*](https://packages.microsoft.com/yumrepos/amlfs-el8/Packages/k/) |
| [RHEL / AlmaLinux 8.9](https://packages.microsoft.com/yumrepos/amlfs-el8/) | amd64 | 2.15.6, 2.15.7 | [4.18.0-513.\*](https://packages.microsoft.com/yumrepos/amlfs-el8/Packages/k/) |
| [RHEL / AlmaLinux 8.8](https://packages.microsoft.com/yumrepos/amlfs-el8/) | amd64 | 2.15.6, 2.15.7 | [4.18.0-477.\*](https://packages.microsoft.com/yumrepos/amlfs-el8/Packages/k/) |
| [RHEL / AlmaLinux 8.7](https://packages.microsoft.com/yumrepos/amlfs-el8/) | amd64 | 2.15.6, 2.15.7 | [4.18.0-425.\*](https://packages.microsoft.com/yumrepos/amlfs-el8/Packages/k/) |
| [RHEL / AlmaLinux 8.6](https://packages.microsoft.com/yumrepos/amlfs-el8/) | amd64 | 2.15.6, 2.15.7 | [4.18.0-372.\*](https://packages.microsoft.com/yumrepos/amlfs-el8/Packages/k/) |
| [RHEL / CentOS 7.9](https://packages.microsoft.com/yumrepos/amlfs-el7/) † | amd64 | 2.15.4 | [3.10.0-1160.\*](https://packages.microsoft.com/yumrepos/amlfs-el7/Packages/k/) |

† **Frozen** - End of life.

**Notes:**

- **arm64 support:** Only Ubuntu 24.04 currently provides arm64 packages.
- **Frozen distributions:** Ubuntu 18.04 and RHEL 7 are frozen at Lustre 2.15.4. They reached end of life; no further Lustre client updates are published. Existing packages remain available for installation. Upgrade base OS for ongoing updates.
- **Kernel update cadence:** Package availability changes as new Linux kernels are released and as Lustre gains support.  When a new maintenance kernel ships for an already-supported distribution kernel series, Microsoft typically publishes a matching Lustre metapackage within one business day.

</details>

::: zone pivot="alma-86"

## Upgrade client software for AlmaLinux HPC 8.6

This article shows how to install the client package to set up client VMs running AlmaLinux HPC 8.6.

::: zone-end

::: zone pivot="rhel-7"

## Install client software for Red Hat Enterprise Linux 7

This article shows how to install the client package to set up client VMs running Red Hat Enterprise Linux 7 (RHEL 7).

::: zone-end

::: zone pivot="rhel-8"

## Install client software for Red Hat Enterprise Linux 8 or AlmaLinux 8

This article shows how to install the client package to set up client VMs running Red Hat Enterprise Linux 8 (RHEL 8) or AlmaLinux 8.

> [!NOTE]
> For AlmaLinux 8.6 HPC images in Azure Marketplace, see the separate [AlmaLinux 8.6 HPC installation instructions](install-hpc-alma-86.md).

::: zone-end

::: zone pivot="rhel-9"

## Install client software for Red Hat Enterprise Linux 9 or AlmaLinux 9

This article shows how to install the client package to set up client VMs running Red Hat Enterprise Linux 9 (RHEL 9) or AlmaLinux 9.

::: zone-end

::: zone pivot="ubuntu-18"

## Install client software for Ubuntu 18.04

This article shows how to install the client package to set up client VMs running Ubuntu 18.04.

::: zone-end

::: zone pivot="ubuntu-20"

## Install client software for Ubuntu 20.04

This article shows how to install the client package to set up client VMs running Ubuntu 20.04.

::: zone-end

::: zone pivot="ubuntu-22"

## Install client software for Ubuntu 22.04

This article shows how to install the client package to set up client VMs running Ubuntu 22.04.

::: zone-end

::: zone pivot="ubuntu-24"

## Install client software for Ubuntu 24.04

This article shows how to install the client package to set up client VMs running Ubuntu 24.04.

::: zone-end

::: zone pivot="azurelinux-3"

## Install client software for Azure Linux 3

This article shows how to install the client package to set up client VMs running Azure Linux 3.

::: zone-end

### Download and install prebuilt client software

::: zone pivot="alma-86"

> [!WARNING]
> These instructions apply only to the AlmaLinux 8.6 HPC images in Azure Marketplace. For all other AlmaLinux 8 installations, including HPC and general marketplace, refer to the [Red Hat 8 instructions](install-rhel-8.md).

1. Install and configure the Azure Managed Lustre repository for the DNF package manager. Create the following script and name it `repo.bash`:

   ```bash
   #!/bin/bash
   set -ex

   rpm --import https://packages.microsoft.com/keys/microsoft.asc

   DISTRIB_CODENAME=el8

   REPO_PATH=/etc/yum.repos.d/amlfs.repo
   echo -e "[amlfs]" > ${REPO_PATH}
   echo -e "name=Azure Lustre Packages" >> ${REPO_PATH}
   echo -e "baseurl=https://packages.microsoft.com/yumrepos/amlfs-${DISTRIB_CODENAME}" >> ${REPO_PATH}
   echo -e "enabled=1" >> ${REPO_PATH}
   echo -e "gpgcheck=1" >> ${REPO_PATH}
   echo -e "gpgkey=https://packages.microsoft.com/keys/microsoft.asc" >> ${REPO_PATH}
   ```

1. Run the script as a superuser:

   ```bash
   sudo bash repo.bash
   ```

1. Install the metapackage that matches your running kernel:

   [!INCLUDE [client-install-version-hpc-alma-86](./includes/client-install-version-hpc-alma-86.md)]

:::zone-end

::: zone pivot="rhel-7"

> [!WARNING]
> We're no longer publishing new client packages for Red Hat Enterprise Linux 7. Please migrate to one of the supported releases to run newer versions of the Azure Managed Lustre client packages.

1. Install and configure the Azure Managed Lustre repository for the YUM package manager. Create the following script and name it `repo.bash`:

   ```bash
   #!/bin/bash
   set -ex

   rpm --import https://packages.microsoft.com/keys/microsoft.asc

   DISTRIB_CODENAME=el7

   REPO_PATH=/etc/yum.repos.d/amlfs.repo
   echo -e "[amlfs]" > ${REPO_PATH}
   echo -e "name=Azure Lustre Packages" >> ${REPO_PATH}
   echo -e "baseurl=https://packages.microsoft.com/yumrepos/amlfs-${DISTRIB_CODENAME}" >> ${REPO_PATH}
   echo -e "enabled=1" >> ${REPO_PATH}
   echo -e "gpgcheck=1" >> ${REPO_PATH}
   echo -e "gpgkey=https://packages.microsoft.com/keys/microsoft.asc" >> ${REPO_PATH}
   ```

1. Run the script as a superuser:

   ```bash
   sudo bash repo.bash
   ```

1. Install the metapackage that matches your running kernel.

    The metapackage version doesn't always align with the kernel version. You can use the following command to install the proper metapackage:

   [!INCLUDE [client-install-version-rhel-7](./includes/client-install-version-rhel-7.md)]

::: zone-end

::: zone pivot="rhel-8"

1. Install and configure the Azure Managed Lustre repository for the DNF package manager. Create the following script and name it `repo.bash`:

   ```bash
   #!/bin/bash
   set -ex

   rpm --import https://packages.microsoft.com/keys/microsoft.asc

   DISTRIB_CODENAME=el8

   REPO_PATH=/etc/yum.repos.d/amlfs.repo
   echo -e "[amlfs]" > ${REPO_PATH}
   echo -e "name=Azure Lustre Packages" >> ${REPO_PATH}
   echo -e "baseurl=https://packages.microsoft.com/yumrepos/amlfs-${DISTRIB_CODENAME}" >> ${REPO_PATH}
   echo -e "enabled=1" >> ${REPO_PATH}
   echo -e "gpgcheck=1" >> ${REPO_PATH}
   echo -e "gpgkey=https://packages.microsoft.com/keys/microsoft.asc" >> ${REPO_PATH}
   ```

1. Run the script as a superuser:

   ```bash
   sudo bash repo.bash
   ```

1. Install the metapackage that matches your running kernel.

    The metapackage version doesn't always align with the kernel version. You can use the following command to install the proper metapackage:

   [!INCLUDE [client-install-version-rhel-8](./includes/client-install-version-rhel-8.md)]

::: zone-end

::: zone pivot="rhel-9"

1. Install and configure the Azure Managed Lustre repository for the DNF package manager. Create the following script and name it `repo.bash`:

   ```bash
   #!/bin/bash
   set -ex

   rpm --import https://packages.microsoft.com/keys/microsoft.asc

   DISTRIB_CODENAME=el9

   REPO_PATH=/etc/yum.repos.d/amlfs.repo
   echo -e "[amlfs]" > ${REPO_PATH}
   echo -e "name=Azure Lustre Packages" >> ${REPO_PATH}
   echo -e "baseurl=https://packages.microsoft.com/yumrepos/amlfs-${DISTRIB_CODENAME}" >> ${REPO_PATH}
   echo -e "enabled=1" >> ${REPO_PATH}
   echo -e "gpgcheck=1" >> ${REPO_PATH}
   echo -e "gpgkey=https://packages.microsoft.com/keys/microsoft.asc" >> ${REPO_PATH}
   ```

1. Run the script as a superuser:

   ```bash
   sudo bash repo.bash
   ```

1. Install the metapackage that matches your running kernel.

   The metapackage version doesn't always align with the kernel version. You can use the following command to install the proper metapackage:

   [!INCLUDE [client-install-version-rhel-9](./includes/client-install-version-rhel-9.md)]

::: zone-end

::: zone pivot="ubuntu-18"

> [!WARNING]
> We're no longer publishing new client packages for Ubuntu 18.04. Please migrate to one of the supported releases to run newer versions of the Azure Managed Lustre client packages.
>
> Ubuntu 18.04 LTS reached the end of standard support on May 31, 2023. We recommend either migrating to the next Ubuntu LTS release or upgrading to Ubuntu Pro to gain access to extended security and maintenance from Canonical. For more information, see the [announcement](https://techcommunity.microsoft.com/t5/linux-and-open-source-blog/canonical-ubuntu-18-04-lts-reaching-end-of-standard-support/ba-p/3822623).

1. Ensure that you have Ubuntu Pro activated and are on the recommended 5.4 kernel, which the `linux-image-azure` metapackage provides:

   ```bash
   apt list --installed linux-image*
   ```

1. Install and configure the Azure Managed Lustre repository for the APT package manager. Create the following script and name it `repo.bash`:

   ```bash
   #!/bin/bash
   set -ex

   apt update && apt install -y ca-certificates curl apt-transport-https lsb-release gnupg
   source /etc/lsb-release
   echo "deb [arch=amd64] https://packages.microsoft.com/repos/amlfs-${DISTRIB_CODENAME}/ ${DISTRIB_CODENAME} main" | tee /etc/apt/sources.list.d/amlfs.list
   curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

   apt update
   ```

1. Run the script as a superuser:

   ```bash
   sudo bash repo.bash
   ```

1. Install the metapackage that matches your running kernel.

    The following command installs a metapackage that keeps the version of Lustre aligned with the installed kernel. For this alignment to work, you must use `apt full-upgrade` instead of `apt upgrade` when updating your system.

   [!INCLUDE [client-install-version-ubuntu-18](./includes/client-install-version-ubuntu-18.md)]

::: zone-end

::: zone pivot="ubuntu-20"

1. Install and configure the Azure Managed Lustre repository for the APT package manager. Create the following script and name it `repo.bash`:

   ```bash
   #!/bin/bash
   set -ex

   apt update && apt install -y ca-certificates curl apt-transport-https lsb-release gnupg
   source /etc/lsb-release
   echo "deb [arch=amd64] https://packages.microsoft.com/repos/amlfs-${DISTRIB_CODENAME}/ ${DISTRIB_CODENAME} main" | tee /etc/apt/sources.list.d/amlfs.list
   curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

   apt update
   ```

1. Run the script as a superuser:

   ```bash
   sudo bash repo.bash
   ```

1. Install the metapackage that matches your running kernel.

    The following command installs a metapackage that keeps the version of Lustre aligned with the installed kernel. For this alignment to work, you must use `apt full-upgrade` instead of `apt upgrade` when updating your system.

   [!INCLUDE [client-install-version-ubuntu](./includes/client-install-version-ubuntu.md)]

::: zone-end

::: zone pivot="ubuntu-22"

> [!IMPORTANT]
> The Azure Marketplace image for the Ubuntu 22.04 LTS release uses the Hardware Enablement (HWE) kernel by default. However, HWE kernels are supported only for six-month periods, and Lustre support for these kernels is often not available when they're released. We recommend that you switch to the LTS kernel because it gives you more stability and it maintains a kernel version that's supported with the Lustre client.

1. Install the LTS kernel metapackage:

   ```bash
   sudo apt update && sudo apt install linux-image-azure-lts-22.04
   ```

1. Remove the default (HWE) kernel metapackage. The response to the following command also asks you to remove the `linux-azure` metapackage.

   ```bash
   sudo apt remove linux-image-azure
   ```

1. List installed kernels and see which one the LTS metapackage supplies:

   ```bash
   apt list --installed linux-image*
   ```

   Newly provisioned hosts have two kernels, and older hosts might have more. Compare the version that the LTS metapackage provides against the other installed kernels.

1. Remove any kernels newer than the one mentioned in the LTS metapackage.

   ```bash
   sudo apt remove linux-image-6.8.0-1027-azure
   ```

   You receive a warning about removing the kernels, but these steps work if you're following them on a newly provisioned host. If you have concerns, consult Ubuntu documentation on configuring kernels to ensure that they can start after a restart.

1. List installed kernels again to verify that you don't have kernels newer than the one mentioned in the LTS metapackage:

   ```bash
   apt list --installed linux-image*
   ```

1. Restart to load the LTS kernel.

1. Install and configure the Azure Managed Lustre repository for the APT package manager. Create the following script and name it `repo.bash`:

   ```bash
   #!/bin/bash
   set -ex

   apt update && apt install -y ca-certificates curl apt-transport-https lsb-release gnupg
   source /etc/lsb-release
   echo "deb [arch=amd64] https://packages.microsoft.com/repos/amlfs-${DISTRIB_CODENAME}/ ${DISTRIB_CODENAME} main" | tee /etc/apt/sources.list.d/amlfs.list
   curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

   apt update
   ```

1. Run the script as a superuser:

   ```bash
   sudo bash repo.bash
   ```

1. Install the metapackage that matches your running kernel.

    The following command installs a metapackage that keeps the version of Lustre aligned with the installed kernel. For this alignment to work, you must use `apt full-upgrade` instead of `apt upgrade` when updating your system.

   [!INCLUDE [client-install-version-ubuntu](./includes/client-install-version-ubuntu.md)]

::: zone-end

::: zone pivot="ubuntu-24"

> [!IMPORTANT]
> The Azure Marketplace image for the Ubuntu 24.04 LTS release uses the Hardware Enablement (HWE) kernel by default. However, HWE kernels are supported only for six-month periods, and Lustre support for these kernels is often not available when they're released. We recommend that you switch to the LTS kernel because it gives you more stability and it maintains a kernel version that's supported with the Lustre client.

1. Install the LTS kernel metapackage:

   ```bash
   sudo apt update && sudo apt install linux-image-azure-lts-24.04
   ```

1. Remove the default (HWE) kernel metapackage. The response to the following command also asks you to remove the `linux-azure` metapackage.

   ```bash
   sudo apt remove linux-image-azure
   ```

1. List installed kernels and see which one the LTS metapackage supplies:

   ```bash
   apt list --installed linux-image*
   ```

   Newly provisioned hosts have two kernels, and older hosts might have more. Compare the version that the LTS metapackage provides against the other installed kernels.

1. Remove any kernels newer than the one mentioned in the LTS metapackage.

   ```bash
   sudo apt remove linux-image-6.11.0-1013-azure
   ```

   You receive a warning about removing the kernels, but these steps work if you're following them on a newly provisioned host. If you have concerns, consult Ubuntu documentation on configuring kernels to ensure that they can start after a restart.

1. List installed kernels again to verify that you don't have kernels newer than the one mentioned in the LTS metapackage:

   ```bash
   apt list --installed linux-image*
   ```

1. Restart to load the LTS kernel.

1. Install and configure the Azure Managed Lustre repository for the APT package manager. Create the following script and name it `repo.bash`:

   ```bash
    #!/bin/bash
    set -ex

    apt update && apt install -y ca-certificates curl apt-transport-https lsb-release gnupg dpkg-dev
    source /etc/lsb-release
    ARCH=$(dpkg-architecture -q DEB_BUILD_ARCH)
    echo "deb [arch=${ARCH}] https://packages.microsoft.com/repos/amlfs-${DISTRIB_CODENAME}/ ${DISTRIB_CODENAME} main" | tee /etc/apt/sources.list.d/amlfs.list
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

    apt update
   ```

1. Run the script as a superuser:

   ```bash
   sudo bash repo.bash
   ```

1. Install the metapackage that matches your running kernel.

    The following command installs a metapackage that keeps the version of Lustre aligned with the installed kernel. For this alignment to work, you must use `apt full-upgrade` instead of `apt upgrade` when updating your system.

   [!INCLUDE [client-install-version-ubunt-24](./includes/client-install-version-ubuntu-24.md)]

::: zone-end

::: zone pivot="azurelinux-3"

> [!IMPORTANT]
> Azure Linux 3 requires kernel version 6.6.119.3 or newer. Check your kernel version with `uname -r`. If you need to upgrade your kernel, run `sudo tdnf upgrade kernel` and reboot before installing the Lustre client.

1. Install and configure the Azure Managed Lustre repository for the TDNF package manager. Create the following script and name it `repo.bash`:

   ```bash
   #!/bin/bash
   set -ex

   rpm --import https://packages.microsoft.com/keys/microsoft.asc

   DISTRIB_CODENAME=al3

   REPO_PATH=/etc/yum.repos.d/amlfs.repo
   echo -e "[amlfs]" > ${REPO_PATH}
   echo -e "name=Azure Lustre Packages" >> ${REPO_PATH}
   echo -e "baseurl=https://packages.microsoft.com/yumrepos/amlfs-${DISTRIB_CODENAME}" >> ${REPO_PATH}
   echo -e "enabled=1" >> ${REPO_PATH}
   echo -e "gpgcheck=1" >> ${REPO_PATH}
   echo -e "gpgkey=https://packages.microsoft.com/keys/microsoft.asc" >> ${REPO_PATH}
   ```

1. Run the script as a superuser:

   ```bash
   sudo bash repo.bash
   ```

1. Install the metapackage that matches your running kernel.

   The metapackage version doesn't always align with the kernel version. You can use the following command to install the proper metapackage:

   [!INCLUDE [client-install-version-azurelinux-3](./includes/client-install-version-azurelinux-3.md)]

::: zone-end

## Related content

- [Upgrade Lustre client software to the current version](client-upgrade.md)
- [Connect clients to an Azure Managed Lustre file system](connect-clients.md)
- [Use Secure Boot with Azure Managed Lustre file system](client-secure-boot.md)
- [Azure Managed Lustre overview](amlfs-overview.md)
