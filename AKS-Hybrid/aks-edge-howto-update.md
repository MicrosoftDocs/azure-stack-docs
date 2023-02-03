---
title: AKS Edge Essentials update
description: Update your AKS Edge Essentials clusters
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 01/31/2023
ms.custom: template-how-to
---

# Update your AKS Edge Essentials clusters

As newer versions of AKS Edge Essentials are available, you'll want to update your AKS Edge Essentials cluster for the latest features and security improvements. This article describes how to update and upgrade your AKS Edge Essentials devices when fixes and a new version are available.

The AKS Edge Essentials cluster is comprised of two main components that need to be updated. First is the Mariner Linux VM. This virtual machine is installed as a part of the AKS Edge Essentials MSI, and has no package manager, so you can't manually update or change any of the VM components. Instead, the virtual machine is managed with Microsoft Update to keep the components up to date automatically. Second, the Kubernetes platform can be upgraded to stay in sync with the open-source version and the AKS service.  

The AKS Edge Essentials virtual machine is designed to be reliably updated via Microsoft Update. The virtual machine operating system has an A/B update partition scheme to utilize a subset of those to make each update safe and enable a roll-back to a previous version if anything goes wrong during the update process.

AKS Edge Essentials upgrades are sequential and you must upgrade to every version in order, which means that to get to the latest version, you'll have to either do a fresh installation using the latest available version, or apply all the previous servicing updates, up to the desired version.

## Single machine cluster update using Microsoft Update

To receive AKS Edge Essentials updates, configure the Windows host to receive updates for other Microsoft products. By default, Microsoft Updates is turned on during AKS Edge Essentials installation. If custom configuration is needed after installation, you can turn this option on or off with the following steps:

1. Open **Settings** on the Windows host.
1. Select **Updates & Security**.
1. Select **Advanced options**.
1. Toggle the **Receive updates for other Microsoft products when you update Windows** button to **On**.

Microsoft Update in the Windows Update subsystem can now scan for an update for AKS-EE based on the Windows Update policy set on the machine. If you wish to force the scan immediately you can manually trigger the **Check for updates** button.

Once the update is downloaded from either the cloud endpoint or a local WSUS server and staged on the device use, you (or a remote admin) can then manually invoke the update when timing is appropriate for the given use case by running the `Start-AksEdgeUpdate` command:

```powershell
Start-AksEdgeUpdate
```

When this command returns, your version will be running in the new updated/patched version.

## Update a full-deployment cluster

> [!CAUTION]
> Updating full deployments across multi-machines is currently an experimental feature.

You can update nodes of a full deployment that's deployed across multiple machines using the `Start-AksEdgeUpdate` command. On the primary control node, you can update by running the following command:

```PowerShell
Start-AksEdgeUpdate
```

On the secondary control nodes, you can run the following command:

```powershell
Start-AksEdgeUpdate -secondaryControlPlaneUpdate
```

This gives you the option to manually update each of the machines in your full deployment cluster.

## Update using Windows Server Update Services (WSUS)

On-premises updates using WSUS is supported for AKS Edge Essentials updates. For more information about WSUS, see [Device Management Overview - WSUS](/windows/iot/iot-enterprise/device-management/device-management-overview#windows-server-update-services-wsus).

## Upgrade to newer versions

AKS Edge Essentials currently supports Kubernetes version 1.24.3 on both K3s and K8s. As we continue to add support to newer versions, you can use over-the-air updates to the newer versions. To upgrade your clusters to newer versions, set the `Set-AksEdgeUpgrade` command to `true`:

```powershell
Set-AksEdgeUpgrade – AcceptUpgrade $true
```

You can then select the **Check for Updates** button to download and stage an update if applicable. Then, run the `Start-AksEdgeUpdate` to complete the update:

```powershell
Start-AksEdgeUpdate
```

This command then triggers the version upgrade.

## Next steps

* [Overview](aks-edge-overview.md)
* [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
