---
title: Upgrade Client Software for Azure Managed Lustre
description: Learn how to upgrade client software for the Azure Managed Lustre file system.
ms.topic: how-to
author: pauljewellmsft
ms.author: pauljewell
ms.reviewer: dsundarraj
ms.date: 04/29/2025

---

# Upgrade Lustre client software to the current version

In this article, you learn how to upgrade an existing Lustre client package to the current version. Upgraded client software is required to connect to an Azure Managed Lustre file system.

If you need to install the client software for the first time, see [Install prebuilt Lustre client software](client-install.md).

For more information on connecting clients to a cluster, see [Connect clients to an Azure Managed Lustre file system](connect-clients.md).

## Upgrade a Lustre client

If your client machine uses an older version of Lustre, you can upgrade the Lustre client package to the current version by using the following steps. It's important that you completely uninstall the previous Lustre client's kernel modules, in addition to removing the client software packages.

### [Red Hat Enterprise Linux / Alma](#tab/rhel)

1. Unmount any containers or mount points that are mounting the Lustre client by using the following command:

    ```bash
    sudo umount <all Lustre mounts>
    ```

1. Uninstall the existing Lustre client version by using the following command:

    ```bash
    sudo dnf remove *lustre*
    ```

1. Install the current version of the Lustre client by using the following command:

    [!INCLUDE [client-upgrade-version-rhel-alma](./includes/client-upgrade-version-rhel-alma.md)]

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

1. Install the current version of the Lustre client by using the following command:

    [!INCLUDE [client-upgrade-version-ubuntu](./includes/client-upgrade-version-ubuntu.md)]

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

1. Install the current version of the Lustre client by using the following command:

    [!INCLUDE [client-upgrade-version-ubuntu](./includes/client-upgrade-version-ubuntu-24.md)]

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
---

After you perform this procedure, you can [mount the client](connect-clients.md#start-the-lustre-client-by-using-the-mount-command) to your Azure Managed Lustre file system.

## Related content

- [Connect clients to an Azure Managed Lustre file system](connect-clients.md)
- [Azure Managed Lustre overview](amlfs-overview.md)
