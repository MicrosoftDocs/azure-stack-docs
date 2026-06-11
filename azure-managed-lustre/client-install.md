---
title: Install Client Software for Azure Managed Lustre
description: Learn how to install client software for the Azure Managed Lustre file system using prebuilt kmod packages or DKMS.
ms.topic: how-to
author: pauljewellmsft
ms.author: pauljewell
ms.reviewer: dsundarraj
ms.date: 04/23/2026
zone_pivot_groups: select-os
---

# Install Lustre client software

In this article, you learn how to install a Lustre client package. After you install the package, you can set up client virtual machines (VMs) and attach them to an Azure Managed Lustre cluster. Select an operating system version to see the instructions.

Before you install, see [Plan your Lustre client installation](client-install-plan.md) for the support matrix and to choose between the prebuilt **kmod** and **DKMS** install methods.

If you need to upgrade an existing Lustre client to the current version, see [Upgrade Lustre client software to the current version](client-upgrade.md).

For more information on connecting clients to a cluster, see [Connect clients to an Azure Managed Lustre file system](connect-clients.md).

For more information about the behavior of Azure Managed Lustre with Trusted Launch Virtual Machines and Confidential Compute Virtual Machines, refer to [Use Secure Boot with Azure Managed Lustre file system](client-secure-boot.md).

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

### Download and install client software

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

> [!IMPORTANT]
> Microsoft recommends running on RHEL/AlmaLinux **8.10**, the latest (and terminal) RHEL 8 minor release. RHEL 8 is in Maintenance Support phase, and Red Hat ships security errata only for 8.10. Older 8.x minors (8.6 through 8.9) no longer receive Red Hat errata.

1. Verify the running RHEL minor version:

   ```bash
   cat /etc/redhat-release
   ```

   Expected output for a RHEL 8.10 system:

   ```output
   Red Hat Enterprise Linux release 8.10 (Ootpa)
   ```

1. If the system is on an older 8.x minor, upgrade to 8.10:

   ```bash
   sudo dnf upgrade --refresh -y
   sudo reboot
   ```

   > [!NOTE]
   > If the system was previously locked to an older minor with `subscription-manager release --set=8.x` (for example, a paid RHEL 8.6 or 8.8 EUS pin), the upgrade above is blocked by that release lock. Check with `sudo subscription-manager release --show`. To allow the move to 8.10, run `sudo subscription-manager release --unset` before the upgrade. RHEL 8 EUS support ended May 31, 2025, so a pre-existing 8.x EUS pin no longer receives security updates.

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

1. Install the Lustre client package. Choose the install method that best fits your needs:

   #### [Prebuilt kmod](#tab/kmod)

   The metapackage version doesn't always align with the kernel version. Use the following command to install the proper metapackage:

   [!INCLUDE [client-install-version-rhel-8](./includes/client-install-version-rhel-8.md)]

   #### [DKMS](#tab/dkms)

   [!INCLUDE [client-install-dkms-rhel](./includes/client-install-dkms-rhel.md)]

   ---

::: zone-end

::: zone pivot="rhel-9"

> [!IMPORTANT]
> Azure Managed Lustre client packages don't yet support **RHEL/AlmaLinux 9.8** (released May 19, 2026). Support is expected to land with the upcoming **Lustre 2.15.9** release. Before installing the Lustre client, make sure your VM is on a supported minor release. Check the [Support matrix](client-install-plan.md#support-matrix) for the current list — 9.8 will be listed there once Azure Managed Lustre packages ship for it.

> [!IMPORTANT]
> For production workloads, Microsoft recommends pinning RHEL 9 systems to a Red Hat Extended Update Support (EUS) minor release before installing the Lustre client. Pinning keeps the kernel inside a stable z-stream that Microsoft actively validates the Lustre client against.
>
> The currently recommended minor for RHEL 9 is **9.6 EUS** (EUS support ends May 31, 2027). For the current list of RHEL EUS minor releases, see [Red Hat Enterprise Linux Life Cycle](https://access.redhat.com/support/policy/updates/errata). For the AMLFS-tested kernel series for each RHEL/AlmaLinux 9 minor, see the [Support matrix](client-install-plan.md#support-matrix).
>
> AlmaLinux 9 doesn't have an EUS program. For the same stability reasons, Microsoft recommends pinning AlmaLinux 9 to a specific minor release (currently **9.6**) so the kernel doesn't roll forward unexpectedly.
>
> If the VM was deployed from the **RHEL 9.6 EUS** image in the Azure Marketplace, EUS is already configured and you can skip the pinning step.
>
> <!-- Doc-authors: re-check this guidance when (a) AMLFS ships the Lustre 2.15.9 client with RHEL 9.8 support (remove the 9.8-unsupported callout above), (b) RHEL 9.6 EUS approaches end of life (May 2027), or (c) Microsoft validates a newer EUS minor. The current RHEL EUS list is maintained at https://learn.microsoft.com/azure/virtual-machines/workloads/redhat/redhat-rhui#rhel-eus-and-version-locking-rhel-vms -->

> [!IMPORTANT]
> The procedure below **pins the system at its current running minor** — it doesn't change which minor the system is on. If `cat /etc/redhat-release` reports a minor newer than **9.6**, this article doesn't cover the rollback.
>
> The most reliable path is to **deploy a new VM from the RHEL 9.6 EUS image** in the Azure Marketplace (or, for AlmaLinux, from a 9.6 image) and re-install the Lustre client there. In-place rollback to an earlier minor depends on the system's subscription type, RHUI versus BYOS configuration, and EUS entitlement; refer to Red Hat documentation or your Red Hat support channel for downgrade procedures.

1. Pin the system to a supported minor release so the kernel doesn't roll forward into an unsupported minor on the next update.

   Use the method that matches your deployment.

   **RHEL with Red Hat Subscription Manager (BYOS or on-premises):**

   ```bash
   sudo subscription-manager release --set=9.6
   sudo subscription-manager repos \
       --disable=rhel-9-for-x86_64-baseos-rpms \
       --disable=rhel-9-for-x86_64-appstream-rpms \
       --enable=rhel-9-for-x86_64-baseos-eus-rpms \
       --enable=rhel-9-for-x86_64-appstream-eus-rpms
   sudo dnf clean all && sudo dnf makecache
   ```

   EUS requires a subscription with the EUS entitlement. Red Hat Enterprise Linux Server Premium subscriptions include EUS; Standard subscriptions require the EUS add-on.

   **RHEL on Azure with pay-as-you-go (RHUI) billing:**

   For PAYG VMs that use Azure RHUI, follow the Microsoft Azure procedure in [Switch a RHEL Server to EUS Repositories](/azure/virtual-machines/workloads/redhat/redhat-rhui#switch-a-rhel-server-to-eus-repositories). Use `9.6` as the `releasever` value in the lock step.

   > [!NOTE]
   > Flipping RHUI repositories in place doesn't change how Azure bills the VM. For correct billing, deploy a fresh VM from the **RHEL 9.6 EUS** Azure Marketplace image.

   **AlmaLinux 9 (minor-version pin, not EUS):**

   AlmaLinux 9 doesn't offer EUS. The steps below pin DNF's `releasever` to 9.6 so the system doesn't roll to a newer minor on the next `dnf upgrade`:

   ```bash
   echo '9.6' | sudo tee /etc/dnf/vars/releasever
   sudo dnf clean all && sudo dnf makecache
   ```

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

1. Install the Lustre client package. Choose the install method that best fits your needs:

   #### [Prebuilt kmod](#tab/kmod)

   The metapackage version doesn't always align with the kernel version. You can use the following command to install the proper metapackage:

   [!INCLUDE [client-install-version-rhel-9](./includes/client-install-version-rhel-9.md)]

   #### [DKMS](#tab/dkms)

   [!INCLUDE [client-install-dkms-rhel](./includes/client-install-dkms-rhel.md)]

   ---

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

1. Install the Lustre client package. Choose the install method that best fits your needs:

   #### [Prebuilt kmod](#tab/kmod)

    The following command installs a metapackage that keeps the version of Lustre aligned with the installed kernel. For this alignment to work, you must use `apt full-upgrade` instead of `apt upgrade` when updating your system.

   [!INCLUDE [client-install-version-ubuntu](./includes/client-install-version-ubuntu.md)]

   #### [DKMS](#tab/dkms)

   [!INCLUDE [client-install-dkms-ubuntu](./includes/client-install-dkms-ubuntu.md)]

   ---

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

1. Install the Lustre client package. Choose the install method that best fits your needs:

   #### [Prebuilt kmod](#tab/kmod)

    The following command installs a metapackage that keeps the version of Lustre aligned with the installed kernel. For this alignment to work, you must use `apt full-upgrade` instead of `apt upgrade` when updating your system.

   [!INCLUDE [client-install-version-ubuntu](./includes/client-install-version-ubuntu.md)]

   #### [DKMS](#tab/dkms)

   [!INCLUDE [client-install-dkms-ubuntu](./includes/client-install-dkms-ubuntu.md)]

   ---

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

1. Install the Lustre client package. Choose the install method that best fits your needs:

   #### [Prebuilt kmod](#tab/kmod)

    The following command installs a metapackage that keeps the version of Lustre aligned with the installed kernel. For this alignment to work, you must use `apt full-upgrade` instead of `apt upgrade` when updating your system.

   [!INCLUDE [client-install-version-ubunt-24](./includes/client-install-version-ubuntu-24.md)]

   #### [DKMS](#tab/dkms)

   [!INCLUDE [client-install-dkms-ubuntu-24](./includes/client-install-dkms-ubuntu-24.md)]

   ---

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

1. Install the Lustre client package. Choose the install method that best fits your needs:

   #### [Prebuilt kmod](#tab/kmod)

   The metapackage version doesn't always align with the kernel version. You can use the following command to install the proper metapackage:

   [!INCLUDE [client-install-version-azurelinux-3](./includes/client-install-version-azurelinux-3.md)]

   #### [DKMS](#tab/dkms)

   [!INCLUDE [client-install-dkms-azurelinux-3](./includes/client-install-dkms-azurelinux-3.md)]

   ---

::: zone-end

## Related content

- [Plan your Lustre client installation](client-install-plan.md)
- [Upgrade Lustre client software to the current version](client-upgrade.md)
- [Connect clients to an Azure Managed Lustre file system](connect-clients.md)
- [Use Secure Boot with Azure Managed Lustre file system](client-secure-boot.md)
- [Azure Managed Lustre overview](amlfs-overview.md)
