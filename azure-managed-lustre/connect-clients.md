---
title: Connect clients to an Azure Managed Lustre file system
description: Describes how to connect Linux clients with supported software versions to an Azure Managed Lustre file system.
ms.topic: overview
author: pauljewellmsft
ms.author: pauljewell
ms.date: 03/15/2024
ms.reviewer: dsundarraj

# Intent: As an IT Pro, XXX.
# Keyword: 

---

# Connect clients to an Azure Managed Lustre file system

This article describes how to prepare clients and mount the Azure Managed Lustre file system from a client machine.

## Client prerequisites

Client machines running Linux can access Azure Managed Lustre. The basic client requirements are as follows:

- **Lustre client software** - Clients must have the appropriate Lustre client package installed. Prebuilt client packages are tested with Azure Managed Lustre. See [Install or upgrade Lustre client software](#install-or-upgrade-lustre-client-software) for instructions and package download options. Client packages are available for several commonly used Linux OS distributions.
- **Network access** to the file system - Client machines need network connectivity to the subnet that hosts the Azure Managed Lustre file system. If the clients are in a different virtual network, you might need to use virtual network peering.
- **Mount** - Clients must be able to use the POSIX `mount` command to connect to the file system.
- **To achieve advertised performance**:
  - Clients must reside in the same Availability Zone in which the cluster resides.
  - [Enable accelerated networking](/azure/virtual-network/create-vm-accelerated-networking-cli#confirm-that-accelerated-networking-is-enabled) on all client VMs. If this option isn't enabled, then [fully enabling accelerated networking requires a stop/deallocate of each VM](/azure/virtual-network/accelerated-networking-overview#enabling-accelerated-networking-on-a-running-vm).
- **Security type** - When selecting the security type for the VM, choose the Standard Security Type. Choosing Trusted Launch or Confidential types prevent the Lustre module from being properly installed on the client.

The basic workflow is as follows:

1. [Install or upgrade Lustre client software](#install-or-upgrade-lustre-client-software) on each client.
1. Use the [`mount` command](#start-the-lustre-client-using-the-mount-command) to make the Azure Managed Lustre file system available on the client.
1. When a client is no longer needed, use the `umount` command without the `-f` (force) or `-l` (lazy) options to cleanly unmount the client before shutting it down. Failure to properly unmount a client before rebooting or deprovisioning can result in performance issues for other clients.

## Install or upgrade Lustre client software

Each client that connects to the Lustre file system must have a Lustre client package that is compatible with the file system's Lustre version (currently 2.15).

You can download prebuilt and tested client packages for Azure Managed Lustre from the [Linux software repository for Microsoft products](/windows-server/administration/linux-package-repository-for-microsoft-software).

Packages and kernel modules are available for the following Linux operating systems. Select the links to go to the installation instructions:

- [AlmaLinux HPC 8.6](install-hpc-alma-86.md)
- [AlmaLinux 8](install-rhel-8.md)
- [Red Hat Enterprise Linux (RHEL) 7](install-rhel-7.md)
- [Red Hat Enterprise Linux (RHEL) 8](install-rhel-8.md)
- [Red Hat Enterprise Linux (RHEL) 9](install-rhel-9.md)
- [Ubuntu 18.04](install-ubuntu-18.md)
- [Ubuntu 20.04](install-ubuntu-20.md)
- [Ubuntu 22.04](install-ubuntu-22.md)

If you need to support a different distribution, contact the support team.

If you need to upgrade an older Lustre client version on your Linux system, see [Upgrade a Lustre client to the current version](client-upgrade.md). You must remove old kernel modules and software packages as part of the upgrade.

> [!NOTE]
> Microsoft will publish new packages within one business day of a new kernel being available. If you experience any issues, please file a support ticket.

## Start the Lustre client using the mount command

> [!NOTE]
> Before you run the `mount` command, make sure that the client host can see the Azure Managed Lustre file system's virtual network. You can do this by pinging the file system's server IP address. If the ping command doesn't succeed, make the file system network a peer to your compute resources network.

Mount all of your clients to the file system's MGS IP address. The **Client connection** page in the Azure portal shows the IP address and gives a sample `mount` command that you can copy and use to mount clients.

:::image type="content" source="media/connect-clients/client-connection.png" alt-text="Screenshot of client connection page in the portal." lightbox="media/connect-clients/client-connection.png":::

The `mount` command includes three components:

- **Client path**: The path on the client machine where the Azure Managed Lustre file system should be mounted. The default value is the file system name, but you can change it. Make sure that this directory path exists on the client machine before you use the `mount` command.
- **MGS IP address**: The IP address for the Azure Managed Lustre file system's Lustre management service (MGS).
- **Mount command options**: Additional recommended options are included in the sample `mount` command.

These components are assembled into a `mount` command with this form:

```bash
sudo mount -t lustre -o noatime,flock <MGS_IP>@tcp:/lustrefs /<client_path>
```

- The `lustrefs` value in the MSG IP term is the system-assigned internal name associated with the Lustre cluster inside the Azure-managed system. Don't change this literal value when you create your own `mount` commands.

- Set the client path to any convenient mount path that exists on your clients. It doesn't need to be the Azure Managed Lustre file system name (which is the default value).

Example `mount` command:

```bash
sudo mount -t lustre -o noatime,flock 10.0.0.4@tcp:/lustrefs /azure-lustre-mount
```

After your clients are connected to the file system, you can use the Azure Managed Lustre file system as you would any mounted file system. For example, you might perform one of the following tasks:

- Access data from your integrated blob container: send the file request directly to the mount point. The create process populates the file system metadata, and the file is added to the Lustre file system when it's read.
- Add data to the file system (if you didn't add a populated blob container at create time).
- Start a compute job.

> [!IMPORTANT]
> When a client is no longer needed, you must cleanly unmount the client without using the `-f` (force) or `-l` (lazy) options before shutting it down. Failure to properly unmount a client before rebooting or deprovisioning can result in performance issues for other clients.
>
> [How to unmount Azure Managed Lustre Filesystem using Scheduled Events](https://techcommunity.microsoft.com/t5/azure-high-performance-computing/how-to-unmount-azure-managed-lustre-filesystem-using-azure/ba-p/3917814)

## Next steps

- [Azure Managed Lustre File System overview](amlfs-overview.md)
