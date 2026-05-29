---
title: Known issues in Azure Migrate for Azure Local
description: Fix Azure Local migration issues in Azure Migrate. Review common causes and proven solutions, then troubleshoot failures faster—start resolving issues now.
ms.date: 05/15/2026
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.service: azure-local
ms.subservice: hyperconverged
ms.reviewer: simonw, joasa
---

# Known issues in Azure Migrate for Azure Local

This article identifies critical known issues and their workarounds in Azure Migrate for Azure Local.

These release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added.
## Static IP address conflicts during migration

When you migrate a virtual machine (VM) from VMware to Azure Local and retain a static IP address, the migration fails and generates an `InUse` error if the IP address is already assigned to another resource. This problem is common when you migrate domain controller VMs or other role-based VMs.

**Symptoms**

Common symptoms include:

- Migration fails and returns error ID `1000037` and code `InUse`.
- You receive the following error message: **Network interface service found the address already set or in use.**
- You see the following status: `Operation status: Failed.`

**Cause**

The migration process tries to assign a static IP that's already in use. This problem occurs because of current product limitations on network interface handling for certain roles, such as domain controllers.

**Solution**

Use either of the following solutions:

- Create a separate static logical network that excludes affected servers, and then migrate the VM to that network.
- Migrate the VM to a Dynamic Host Configuration Protocol (DHCP) network instead of retaining the static IP.

## Replication failure because of storage account network settings

When you replicate a VMware VM to Azure Local, replication fails if the storage account that you use for migration has public network access disabled.

**Symptoms**

Common symptoms include:

- You see the following error code: `VMwareToAzLocalProtectionStateEnablingFailed`.
- Replication doesn't start.

**Cause**

Replication service operations can't proceed because public network access is disabled on the storage account.

**Solution**

To resolve the problem, follow these steps:

1. Enable public network access for the storage account.
1. Review and adjust permissions.
1. Verify that both migration appliances are operational.

## Migration tool stuck in discovery phase

During migration from VMware to Azure Local, the Azure Migrate portal remains at the **Discovering** phase for more than 48 hours.

**Symptoms**

Common symptoms include:

- The Azure Migrate portal is stuck at **Discovering** even though the appliances show VMs as discovered.
- No errors are reported in diagnostics.
- Clearing the browser cache doesn't fix the problem.

**Cause**

The tool and portal are transitioning from public preview to general availability during discovery. Cached browser data and an in-progress discovery process compound the problem.

**Solution**

To resolve the problem, follow these steps:

1. Update to the general availability version of the tool.
1. Refresh the tool in the portal.
1. Clear your browser cache, and make sure that the portal is up to date.

## Replication failure because of storage account region mismatch

Migrating from VMware to Azure Local fails if the storage account is in a different region than the Azure Migrate project.

**Symptoms**

Common symptoms include:

- Replication setup errors after you enable public network access.
- Additional extension errors.

**Causes**

Common causes include:

- Public network access is disabled on the storage account.
- The storage account region doesn't match the Azure Migrate project region.

**Solution**

To resolve the problem, follow these steps:

1. Enable public network access.
1. Move or re-create the storage account in the same region as the migration project.
1. Verify replication health.

## vTPM not supported on Windows 10 LTSC

After you migrate a Windows 10 Long-Term Servicing Channel (LTSC) VM from VMware to Azure Local, you enable virtual Trust Platform Module (vTPM). In this scenario, the VM doesn't start.

**Symptoms**

Common symptoms include:

- The VM doesn't start if vTPM is enabled.
- The VM starts without any problems if vTPM is disabled.

**Cause**

Azure Local doesn't support Windows 10 LTSC for vTPM.

**Solution**

Disable vTPM or migrate to a supported OS version.

## Migrated VMs appear without disks in portal

After migration, some VMs appear in the portal without a disk attached even though they otherwise start normally.

**Symptoms**

Common symptoms include:

- No OS disk is visible in the Azure Migrate portal.
- An incorrect IP address is registered in the portal.
- VMs are inaccessible until the correct IP is identified.

**Causes**

Common causes include:

- The resource model displays only data disks in the Azure Migrate portal.
- An IP mismatch exists between the portal and the actual VM.

**Solution**

To resolve the problem, follow these steps:

1. Verify that the VM starts normally.
1. Identify and use the correct IP.
1. Run preparation scripts before the migration in order to preserve static IPs.

## Linux VMs don't start after migration

Migrating Linux VMs (for example, RedHat 8 and CentOS) to Azure Local fails if the initial RAM filesystem (initramfs) image doesn't include the required Hyper-V kernel modules.

**Symptoms**

Common symptoms include:

- The VM starts in emergency mode or doesn't start altogether.
- You encounter missing module errors for `hv_storvsc`, `hv_vmbus`, and `hv_utils`.

**Cause**

The initramfs image isn't configured to have the necessary Hyper-V drivers.

**Solution**

To resolve the problem, follow these steps:

1. Verify the required modules by running `lsinitrd | grep -i hv`.
1. Check the kernel version by running `uname -r`.
1. Back up the initramfs image.
1. Edit `/etc/dracut.conf` to include `add-drivers+=" hv_vmbus hv_netvsc hv_storvsc hv_utils "`.
1. Rebuild the initramfs by running `dracut -f -v`.
1. Verify the image size and driver presence before migration.

## Appliance connectivity issues prevent migration

VM migration to Azure Local fails if Azure PowerShell remoting isn't enabled on cluster nodes.

**Symptoms**

Common symptoms include:

- Credential validation errors
- Encountering error code `60183: FailedToConnectTargetClusterShare`
- Inconsistent connectivity to the cluster

**Cause**

This problem is caused by incorrect configuration of Azure PowerShell remoting and the firewall on the target nodes.

**Solution**

To resolve the problem, follow these steps:

1. Enable Azure PowerShell remoting.
1. Allow required traffic in firewall settings.
1. Test Azure PowerShell remoting (`Enter-PSSession`) from the appliance to the cluster nodes.

## Static IP outside logical network subnet

Migration fails if a VM's static IP isn't within the logical network's configured subnet range.

**Symptoms**

You receive an error message that indicates the IP address is outside the subnet range.

**Cause**

The IP address doesn't match logical network configuration.

**Solution**

Update the logical network configuration to include the required IP range.

## Unsupported migration to Azure Arc

If you try to migrate VMs from VMware to Azure Local by having Azure Arc connectivity enabled, the process fails because of unsupported secure boot requirements and missing drivers.

**Symptoms**

Common symptoms include:

- Windows VMs don't connect to Azure Arc.
- Linux VMs don't start or start into emergency mode.
- Network interface conflicts occur.

**Cause**

This problem occurs if you enable secure boot but don't include the required Hyper-V drivers.

**Solution**

To resolve the problem, follow these steps:

1. Remove leftover resources from failed migrations.
1. Insert required Hyper-V drivers into Linux initramfs.
1. Disable secure boot.

## Seed ISO cleanup failure in Azure Local version 2411

In Azure Local version 2411, migration fails during cleanup of the seed ISO disk.

**Symptoms**

Common symptoms include:

- Failure occurs during the **Preparing protected entities** phase.
- You see the following Windows Management Instrumentation (WMI) error reported: `0x00008000`.
- You can't remove the Hyper-V Synthetic DVD drive.

**Cause**

This is a known problem in version 2411.

**Solution**

Update to version 2503, which contains a fix for this problem.

## Unsupported ESX version

Migration doesn't occur if the VMware Elastic Sky X (ESX) version isn't supported.

**Symptoms**

While you're using ESX version 6.0, you receive the following error message: **No appliance available for replication.**

**Cause**

ESX 6.0 isn't supported.

**Solution**

Upgrade to a supported ESX version.

## Replication stuck at 0 percent (%) progress

Replication stalls if required replication fabric resources are missing from the resource group.

**Symptoms**

Common symptoms include:

- Replication stays at 0 percent for a long time.
- No activity appears in the logs.

**Cause**

The problem occurs if you manually delete or clean up hidden replication fabric resources.

**Solution**

To resolve the problem, follow these steps:

1. Verify that the required resources exist.
1. Create a new migration project, and set up new appliances.

## Appliance failure after Windows license expiration

If a migration appliance shuts down because the Windows license expires, reactivating the license doesn't restore functionality.

**Symptoms**

Common symptoms include:

- Replication times out during the snapshot phase.
- The appliance can't communicate with Azure services.

**Cause**

The appliance environment becomes corrupted after shutdown.

**Solution**

Deploy a new migration appliance.
