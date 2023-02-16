---
title: Connect clients to an Azure Managed Lustre file system (preview)
description: Describes how to connect Linux clients with supported software versions to an Azure Managed Lustre file system.
ms.topic: overview
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 02/16/2023
ms.reviewer: mayabishop
ms.date: 02/16/2023

# Intent: As an IT Pro, XXX.
# Keyword: 

---

# Connect clients to an Azure Managed Lustre file system (preview)

This article describes how to prepare clients and mount the Azure Managed Lustre file system from a client machine.

## Client prerequisites

Azure Managed Lustre can be accessed by client machines running Linux. These are the basic client requirements:

- **Lustre client software** - Clients must have the appropriate Lustre client package installed. Pre-built client packages that have been tested with Azure Managed Lustre are available from the [Linux software repository for Microsoft products](/windows-server/administration/linux-package-repository-for-microsoft-software). See [Install client software](#install-client-software) for more information. Client packages are available for several commonly used Linux OS distributions.
- **Network access** to the file system - Client machines need network connectivity to the subnet that hosts the Azure Managed Lustre file system. If the clients are in a different virtual network, you might need to use VNet peering.
- **Mount** - Clients must be able to use the POSIX `mount` command to connect to the file system.
- **To achieve advertised performance** -
  - Clients must reside in the same Availability Zone in which the cluster resides.
  - Be sure that [accelerated networking is enabled on all client VMs](/azure/virtual-network/create-vm-accelerated-networking-cli#confirm-that-accelerated-networking-is-enabled). If it's not enabled, note that [fully enabling accelerated networking requires a stop/deallocate of each VM](/azure/virtual-network/accelerated-networking-overview#enabling-accelerated-networking-on-a-running-vm).

## Install client software

Each client that connects to the Lustre file system must have a Lustre client package that is compatible with the file system's Lustre version (currently 2.15).

You can download pre-built and tested client packages for Azure Managed Lustre from the [Linux software repository for Microsoft products](/windows-server/administration/linux-package-repository-for-microsoft-software).

Packages and kernel modules are available for these Linux operating systems. Click the links to go to the installation instructions.

<!-- - [AlmaLinux 8](client-rhel8.md) - NOT SUPPORTED in public preview
- [CentOS Linux 7](client-rhel7.md) - NOT SUPPORTED in public preview
- [CentOS Linux 8](client-rhel8.md) - NOT SUPPORTED in public preview-->
- [Red Hat Enterprise Linux (RHEL) 7](https://developers.redhat.com/products/rhel/download)
- [Red Hat Enterprise Linux (RHEL) 8](https://developers.redhat.com/products/rhel/download)
- [Ubuntu 18.04](https://www.releases.ubuntu.com/18.04/)
- [Ubuntu 20.04](https://www.releases.ubuntu.com/20.04/)
- [Ubuntu 22.04](https://www.releases.ubuntu.com/22.04/)

If you need to support a different distribution, contact the support team as described in [Support information](preview-support.md).

The basic workflow is as follows:

1. [Install the Lustre client software](#update-a-lustre-client-to-the-current-version) on each client.
1. [Use the `mount` command](#mount-command) to make the Azure Managed Lustre file system available on the client.

If you have an older Lustre client on your Linux system, follow the instructions in the [Update a Lustre client to the current version](#update-a-lustre-client-to-the-current-version) section. You must remove the old kernel modules as well as the software packages.

## Update a Lustre client to the current version

If your client machines have been used with an older version of Lustre, make sure you completely uninstall the previous Lustre client's kernel modules in addition to removing the software packages.

Follow this procedure:

1. Unmount the client machine from the Lustre cluster.
1. Run this command to remove the kernel modules: `sudo lustre_rmmod`. Run the command twice, to make sure that everything has been removed.
1. Reboot the system to make sure that all kernel modules are unloaded.
1. Uninstall the old Lustre client packages.
1. If you are also updating your Linux kernel version, install the new kernel now.
1. Reboot the system. <!-- This step is not strictly necessary, but testing has shown that it can prevent a wide variety of problems, including some problems that are difficult to diagnose. -->
1. Install the Azure Managed Lustre-compatible client as described in this article.

After performing this procedure, you can mount the client to your Azure Managed Lustre system.

## Mount command

> [!NOTE]
> Before you run the `mount` command, make sure that the client host can see the Azure Managed Lustre file system's virtual network. You can do this by pinging the file system's server IP address. If the ping command doesn't succeed, make the file system network a peer to your compute resources network.

Mount all of your clients to the file system's MGS IP address.

The **Client connection** page in the Azure portal shows the IP address and gives a sample mount command that you can copy and use to mount clients.

![Screenshot of Client Connection page in the portal, showing the fields to fill in client path and MGS IP, and the copyable mount command populated with those values.](media/connect-clients/client-connection.png)

The mount command includes three components:

- **Client path** - The path on the client machine where the Azure Managed Lustre file system should be mounted. The default value is the file system name, but you can change it.

  Make sure that this directory path exists on the client machine before you use the mount command.

- **MGS IP address** - The IP address for the Azure Managed Lustre file system's Lustre management service (MGS).

- **Mount command options** - Additional recommended options are included in the sample `mount` command.

These components are assembled into a mount command with this form: `sudo mount -t lustre -o noatime,flock *MGS_IP*`@tcp:/lustrefs /<client_path>`

- The `lustrefs` value in the MSG IP term is the system-assigned internal name associated with the Lustre cluster inside the Azure-managed system. Don't change this literal value when you create your own mount commands.

- Set the client path to any convenient mount path that exists on your clients. It doesn't need to be the Azure Managed Lustre file system name (which is the default value).

Example `mount` command:

```bash
sudo mount -t lustre -o noatime,flock 10.0.0.4@tcp:/lustrefs /azure-lustre-mount
```

After your clients are connected to the file system, you can use the Azure Managed Lustre file system as you would any mounted file system. For example, you might perform one of the following tasks:

- Access data from your integrated blob container: send the file request directly to the mount point. The create process pre-populates the file system metadata, and the file will be added to the Lustre file system when it is read.
- Add data to the file system (if you did not add a populated blob container at create time).
- Start a compute job.

## Next steps

- [Azure Managed Lustre File System overview](amlfs-overview.md)
