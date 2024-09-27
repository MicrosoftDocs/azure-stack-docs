---
title: Install client software for Azure Managed Lustre
description: Learn how to install client software for the Azure Managed Lustre File System.
ms.topic: how-to
author: pauljewellmsft
ms.author: pauljewell
ms.reviewer: dsundarraj
ms.date: 03/15/2024
zone_pivot_groups: select-os

---

# Install prebuilt Lustre client software

In this article, you learn how to download and install a Lustre client package. Once installed, you can set up client VMs and attach them to an Azure Managed Lustre cluster. Select an operating system version to see the instructions.

If you need to upgrade an existing Lustre client to the current version, see [Upgrade a Lustre client to the current version](client-upgrade.md).

For more information on connecting clients to a cluster, see [Connect clients to an Azure Managed Lustre file system](connect-clients.md).

::: zone pivot="alma-86"

## Upgrade client software

This tutorial shows how to install the client package to set up client VMs running AlmaLinux HPC 8.6, and attach them to an Azure Managed Lustre cluster.

The instructions apply to client VMs running:

- AlmaLinux HPC 8.6

::: zone-end

::: zone pivot="rhel-7"

## Install client software for Red Hat Enterprise Linux 7

This tutorial shows how to install the client package to set up client VMs running RHEL 7, and attach them to an Azure Managed Lustre cluster.

The instructions apply to client VMs running:

- Red Hat Enterprise Linux 7 (RHEL 7)

::: zone-end

::: zone pivot="rhel-8"

## Install client software for Red Hat Enterprise Linux or AlmaLinux 8

This tutorial shows how to install the client package to set up client VMs running RHEL 8 or Alma 8, and attach them to an Azure Managed Lustre cluster.

The instructions apply to client VMs running:

- Red Hat Enterprise Linux 8 (RHEL 8)
- Alma Linux 8

> [!NOTE]
> For AlmaLinux 8.6 HPC Marketplace images, see the separate [Alma 8.6 HPC install instructions](install-hpc-alma-86.md).

::: zone-end

::: zone pivot="rhel-9"

## Install client software for Red Hat Enterprise Linux 9

This tutorial shows how to install the client package to set up client VMs running RHEL 9, and attach them to an Azure Managed Lustre cluster.

The instructions apply to client VMs running:

- Red Hat Enterprise Linux 9 (RHEL 9)

::: zone-end

::: zone pivot="ubuntu-18"

## Install client software for Ubuntu 18.04

This tutorial shows how to install the client package to set up client VMs running Ubuntu 18.04, and attach them to an Azure Managed Lustre cluster.

The instructions apply to client VMs running:

- Ubuntu 18.04

::: zone-end

::: zone pivot="ubuntu-20"

## Install client software for Ubuntu 20.04

This tutorial shows how to install the client package to set up client VMs running Ubuntu 20.04, and attach them to an Azure Managed Lustre cluster.

The instructions apply to client VMs running:

- Ubuntu 20.04

::: zone-end

::: zone pivot="ubuntu-22"

## Install client software for Ubuntu 22.04

This tutorial shows how to install the client package to set up client VMs running Ubuntu 22.04, and attach them to an Azure Managed Lustre cluster.

The instructions apply to client VMs running:

- Ubuntu 22.04

::: zone-end

### Download and install prebuilt client software

::: zone pivot="alma-86"

> [!WARNING]
 > These instructions only apply to the AlmaLinux 8.6 HPC marketplace images. For all other AlmaLinux 8 installs, including HPC and general marketplace, refer to [Red Hat 8 instructions](install-rhel-8.md).

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

1. Execute script as super-user:

   ```bash
   sudo bash repo.bash
   ```

1. Install the metapackage that matches your running kernel:

   [!INCLUDE [client-install-version-hpc-alma-86](./includes/client-install-version-hpc-alma-86.md)]

:::zone-end

::: zone pivot="rhel-7"

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

1. Execute script as super-user:

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

1. Execute script as super-user:

   ```bash
   sudo bash repo.bash
   ```

1. Install the metapackage that matches your running kernel:

    The metapackage version doesn't always align with the kernel version. You can use the following command to install the proper metapackage:

   [!INCLUDE [client-install-version-rhel-8-9](./includes/client-install-version-rhel-8-9.md)]

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

1. Execute script as super-user:

   ```bash
   sudo bash repo.bash
   ```

1. Install the metapackage that matches your running kernel.

   The metapackage version doesn't always align with the kernel version. You can use the following command to install the proper metapackage:

   [!INCLUDE [client-install-version-rhel-8-9](./includes/client-install-version-rhel-8-9.md)]

::: zone-end

::: zone pivot="ubuntu-18"

> [!CAUTION]
> Ubuntu 18.04 LTS reached the end of Standard Support on May 31, 2023. Microsoft recommends either migrating to the next Ubuntu LTS release or upgrading to Ubuntu Pro to gain access to extended security and maintenance from Canonical. For more information, see the [announcement](https://techcommunity.microsoft.com/t5/linux-and-open-source-blog/canonical-ubuntu-18-04-lts-reaching-end-of-standard-support/ba-p/3822623).

1. Ensure you have Ubuntu Pro activated and are on the recommended 5.4 kernel, which is provided by the linux-image-azure metapackage:

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

1. Execute script as a super-user:

   ```bash
   sudo bash repo.bash
   ```

1. Install the metapackage that matches your running kernel.

    The following command installs a metapackage that keeps the version of Lustre aligned with the installed kernel. For this to work, you must use `apt full-upgrade` instead of `apt upgrade` when updating your system.

   [!INCLUDE [client-install-version-ubuntu](./includes/client-install-version-ubuntu.md)]

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

1. Execute script as a super-user:

   ```bash
   sudo bash repo.bash
   ```

1. Install the metapackage that matches your running kernel.

    The following command installs a metapackage that keeps the version of Lustre aligned with the installed kernel. For this to work, you must use `apt full-upgrade` instead of `apt upgrade` when updating your system.

   [!INCLUDE [client-install-version-ubuntu](./includes/client-install-version-ubuntu.md)]

::: zone-end

::: zone pivot="ubuntu-22"

> [!IMPORTANT]
> The Azure Marketplace image for the Ubuntu 22.04 LTS release uses the Hardware Enablement (HWE) kernel by default. However, these kernels are only supported for 6 month periods, and Lustre support for these kernels is often not available when they're released. Therefore, we recommend that you switch to the LTS kernel because it gives you more stability as well as maintains a kernel version that is supported with the Lustre Client.

1. Install the LTS kernel metapackage.

   ```bash
   sudo apt update && sudo apt install linux-image-azure-lts-22.04
   ```

1. Remove the HWE kernel metapackage.

   Remove the default (Hardware Enablement) kernel metapackage. It will also ask to remove the linux-azure metapackage.  This is expected.

   ```bash
   sudo apt remove linux-image-azure
   ```

1. List installed kernels and see which one is supplied by the LTS metapackage.

   After the metadata package is removed, check to see what kernels are currently installed.  Newly provisioned hosts will have two kernels and older hosts might have more. Compare the version that the LTS metapackage provides against the other installed kernels.  Here you see that a 6.2 kernel is still installed previously from the linux-image-azure metapackage.

   ```bash
   apt list --installed linux-image*
   ```

1. Remove any kernels newer than the one mentioned in the LTS metapackage.

   You'll receive a warning about removing the kernel, but these steps work if you're following them on a newly provisioned host. However, if you have concerns, consult Ubuntu documentation on configuring kernels to ensure it's able to boot after a reboot.

   ```bash
   sudo apt remove linux-image-5.15.0-1053-azure
   ```

1. Verify that you don't have kernels newer than the one mentioned in the LTS metapackage.

   ```bash
   apt list --installed linux-image*
   ```

1. Reboot to load the LTS kernel.

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

1. Execute script as a super-user:

   ```bash
   sudo bash repo.bash
   ```

1. Install the metapackage that matches your running kernel.

    The following command installs a metapackage that keeps the version of Lustre aligned with the installed kernel. For this to work, you must use `apt full-upgrade` instead of `apt upgrade` when updating your system.

   [!INCLUDE [client-install-version-ubuntu](./includes/client-install-version-ubuntu.md)]

::: zone-end

## Next steps

- [Connect clients to an Azure Managed Lustre file system](connect-clients.md)
- [Azure Managed Lustre File System overview](amlfs-overview.md)
