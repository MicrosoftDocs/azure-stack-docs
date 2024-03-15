---
title: Upgrade client software for Azure Managed Lustre
description: Learn how to upgrade client software for the Azure Managed Lustre File System.
ms.topic: how-to
author: pauljewellmsft
ms.author: pauljewell
ms.reviewer: dsundarraj
ms.date: 03/15/2024

---

# Upgrade Lustre client software to the current version

In this article, you learn how to upgrade an existing Lustre client package to the current version. Upgraded client software is required to connect to an Azure Managed Lustre file system.

If you need to install the client software for the first time, see [Install client software for Azure Managed Lustre](client-install.md).

For more information on connecting clients to a cluster, see [Connect clients to an Azure Managed Lustre file system](connect-clients.md).

## Upgrade a Lustre client

If your client machine uses an older version of Lustre, you can upgrade the Lustre client package to the current version using the following steps. It's important that you completely uninstall the previous Lustre client's kernel modules, in addition to removing the client software packages.

Follow these steps to upgrade the Lustre client to the current version:

### [Red Hat Enterprise Linux / Alma](#tab/rhel)

1. Unmount any containers or mount points that are mounting the Lustre client using the following command:

    ```bash
    sudo umount <all Lustre mounts>
    ```

1. Uninstall the existing Lustre client version using the following command:

    ```bash
    sudo dnf remove <lustre-client>
    ```

1. Reboot using `sudo reboot`, or unload the Lustre and Lustre Networking (LNet) kernel modules using the following command:

    ```bash
    sudo lustre_rmmod
    ```

1. Install the current version of the Lustre client using the following command:

    ```bash
    sudo dnf install amlfs-lustre-client-2.15.4_42_gd6d405d-$(uname -r | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
    ```

1. Verify that old kernel modules are removed using the following command:

    ```bash
    cat /sys/module/lustre/version; lsmod | grep -E 'lustre|lnet'
    ```

    The output should look similar to the following example:

    ```bash
    cat: /sys/module/lustre/version: No such file or directory
    ```

    If the output shows an old version of the Lustre kernel module, it's recommended that you reboot the system.

### [Ubuntu](#tab/ubuntu)

1. Unmount any containers or mount points that are mounting the Lustre client using the following command:

    ```bash
    sudo umount <all Lustre mounts>
    ```

1. Uninstall the existing Lustre client version using the following command:

    ```bash
    sudo apt autoremove <lustre-client>
    ```

1. Reboot using `sudo reboot`, or unload the Lustre and Lustre Networking (LNet) kernel modules using the following command:

    ```bash
    sudo lustre_rmmod
    ```

1. Install the current version of the Lustre client using the following command:

    ```bash
    sudo apt install amlfs-lustre-client-2.15.4-42-gd6d405d=$(uname -r)
    ```

1. Verify that old kernel modules are removed using the following command:

    ```bash
    cat /sys/module/lustre/version; lsmod | grep -E 'lustre|lnet'
    ```

    The output should look similar to the following:

    ```bash
    cat: /sys/module/lustre/version: No such file or directory
    ```

    If the output shows an old version of the Lustre kernel module, it's recommended that you reboot the system.

---

After performing this procedure, you can [mount the client](connect-clients.md#start-the-lustre-client-using-the-mount-command) to your Azure Managed Lustre file system.

## Next steps

- [Connect clients to an Azure Managed Lustre file system](connect-clients.md)
- [Azure Managed Lustre File System overview](amlfs-overview.md)
