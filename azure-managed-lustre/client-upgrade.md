---
title: Upgrade Client Software for Azure Managed Lustre
description: Learn how to upgrade client software for the Azure Managed Lustre file system.
ms.topic: how-to
author: pauljewellmsft
ms.author: pauljewell
ms.reviewer: dsundarraj
ms.date: 04/23/2026

---

# Upgrade Lustre client software to the current version

In this article, you learn how to upgrade an existing Lustre client package to the current version. Upgraded client software is required to connect to an Azure Managed Lustre file system.

If you need to install the client software for the first time, see [Install Lustre client software](client-install.md). For the supported distribution matrix and to choose between the prebuilt **kmod** and **DKMS** install methods, see [Plan your Lustre client installation](client-install-plan.md).

For more information on connecting clients to a cluster, see [Connect clients to an Azure Managed Lustre file system](connect-clients.md).

## Upgrade a Lustre client

If your client machine uses an older version of Lustre, you can upgrade the Lustre client package to the current version by using the following steps. It's important that you completely uninstall the previous Lustre client's kernel modules, in addition to removing the client software packages.

> [!IMPORTANT]
> **DKMS users: kernel upgrades vs. Lustre version upgrades**
>
> - **Kernel upgrades** (for example, 5.15.0-100 → 5.15.0-105): If you installed the Lustre client by using DKMS, kernel upgrades are handled automatically. DKMS recompiles the Lustre module for the new kernel during the kernel upgrade process. **No action is needed** - you don't need to follow this procedure.
> - **Lustre version upgrades** (for example, 2.15.7 → 2.15.8): To upgrade to a newer Lustre release, follow the steps in this article. The procedure is the same for both kmod and DKMS users - uninstall the old version, then install the new one.

### [Red Hat Enterprise Linux / Alma](#tab/rhel)

1. Unmount any containers or mount points that are mounting the Lustre client by using the following command:

    ```bash
    sudo umount <all Lustre mounts>
    ```

1. Uninstall the existing Lustre client version by using the following command:

    ```bash
    sudo dnf remove *lustre*
    ```

1. Install the current version of the Lustre client:

   #### [Prebuilt kmod](#tab/kmod)

   [!INCLUDE [client-upgrade-version-rhel-alma](./includes/client-upgrade-version-rhel-alma.md)]

   #### [DKMS](#tab/dkms)

   [!INCLUDE [client-upgrade-dkms-rhel](./includes/client-upgrade-dkms-rhel.md)]

   ---

1. Unload the Lustre and Lustre Networking (LNet) kernel modules by using the following command:

    ```bash
    sudo lustre_rmmod
    ```

1. Verify that old kernel modules are removed by using the following command:

    ```bash
    cat /sys/module/lustre/version; lsmod | grep -E 'lustre|lnet'
    ```

    The output should look similar to the following example:

    ```bash
    cat: /sys/module/lustre/version: No such file or directory
    ```

    If the output shows an old version of the Lustre kernel module, we recommend that you restart (`sudo reboot`) the system.

### [Ubuntu 20.04/22.04](#tab/ubuntu)

1. Unmount any containers or mount points that are mounting the Lustre client by using the following command:

    ```bash
    sudo umount <all Lustre mounts>
    ```

1. Uninstall the existing Lustre client version by using the following command:

    ```bash
    sudo apt autoremove *lustre* -y
    ```

1. Install the current version of the Lustre client:

   #### [Prebuilt kmod](#tab/kmod)

   [!INCLUDE [client-upgrade-version-ubuntu](./includes/client-upgrade-version-ubuntu.md)]

   #### [DKMS](#tab/dkms)

   [!INCLUDE [client-upgrade-dkms-ubuntu](./includes/client-upgrade-dkms-ubuntu.md)]

   ---

1. Unload the Lustre and Lustre Networking (LNet) kernel modules by using the following command:

    ```bash
    sudo lustre_rmmod
    ```

1. Verify that old kernel modules are removed by using the following command:

    ```bash
    cat /sys/module/lustre/version; lsmod | grep -E 'lustre|lnet'
    ```

    The output should look similar to the following example:

    ```bash
    cat: /sys/module/lustre/version: No such file or directory
    ```

    If the output shows an old version of the Lustre kernel module, we recommend that you restart (`sudo reboot`) the system.

### [Ubuntu 24.04](#tab/ubuntu24)

1. Unmount any containers or mount points that are mounting the Lustre client by using the following command:

    ```bash
    sudo umount <all Lustre mounts>
    ```

1. Uninstall the existing Lustre client version by using the following command:

    ```bash
    sudo apt autoremove *lustre* -y
    ```

1. Install the current version of the Lustre client:

   #### [Prebuilt kmod](#tab/kmod)

   [!INCLUDE [client-upgrade-version-ubuntu](./includes/client-upgrade-version-ubuntu-24.md)]

   #### [DKMS](#tab/dkms)

   [!INCLUDE [client-upgrade-dkms-ubuntu-24](./includes/client-upgrade-dkms-ubuntu-24.md)]

   ---

1. Unload the Lustre and Lustre Networking (LNet) kernel modules by using the following command:

    ```bash
    sudo lustre_rmmod
    ```

1. Verify that old kernel modules are removed by using the following command:

    ```bash
    cat /sys/module/lustre/version; lsmod | grep -E 'lustre|lnet'
    ```

    The output should look similar to the following example:

    ```bash
    cat: /sys/module/lustre/version: No such file or directory
    ```

    If the output shows an old version of the Lustre kernel module, we recommend that you restart (`sudo reboot`) the system.

### [Azure Linux 3](#tab/azurelinux3)

1. Unmount any containers or mount points that are mounting the Lustre client by using the following command:

    ```bash
    sudo umount <all Lustre mounts>
    ```

1. Unload the Lustre and Lustre Networking (LNet) kernel modules by using the following command:

    ```bash
    sudo lustre_rmmod
    ```

1. Uninstall the existing Lustre client version by using the following command:

    ```bash
    sudo tdnf remove '*lustre*' -y
    ```

1. Install the current version of the Lustre client:

   #### [Prebuilt kmod](#tab/kmod)

   [!INCLUDE [client-upgrade-version-azurelinux-3](./includes/client-upgrade-version-azurelinux-3.md)]

   #### [DKMS](#tab/dkms)

   [!INCLUDE [client-upgrade-dkms-azurelinux-3](./includes/client-upgrade-dkms-azurelinux-3.md)]

   ---

1. Verify the installation by using the following command:

    ```bash
    sudo modprobe lustre
    sleep 5; cat /sys/module/lustre/version; lsmod | grep -E 'lustre|lnet'
    ```

    The output should show the new Lustre version (for example, `2.16.1_22_g584eedc`).
---

After you perform this procedure, you can [mount the client](connect-clients.md#start-the-lustre-client-by-using-the-mount-command) to your Azure Managed Lustre file system.

## Related content

- [Connect clients to an Azure Managed Lustre file system](connect-clients.md)
- [Azure Managed Lustre overview](amlfs-overview.md)
