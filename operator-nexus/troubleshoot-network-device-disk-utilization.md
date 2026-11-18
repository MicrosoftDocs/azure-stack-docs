---
title: Troubleshoot network device disk utilization in Azure Operator Nexus
description: Learn how to investigate high disk utilization on Azure Operator Nexus network devices and safely remove eligible customer-created files with Microsoft Support approval.
author: Satya-talluri
ms.author: stalluri
ms.service: azure-operator-nexus
ms.custom: troubleshooting
ms.topic: troubleshooting
ms.date: 11/12/2026
ai-usage: ai-assisted
---

# Troubleshoot network device disk utilization

High disk utilization on a network device can affect device operations. Use this article to identify the affected file system, determine whether customer-created files are eligible for cleanup, and verify recovery. If a resource operation also fails, investigate its error alongside the disk condition. High disk utilization alone doesn't establish the cause of a provisioning failure.

Use this procedure only for Arista Extensible Operating System (EOS) network devices and files that your organization created or explicitly copied to the device. It doesn't apply to terminal servers, Network Fabric Controller hosts, or Kubernetes nodes.

## Identify the affected device and file system

1. In the Azure portal, open the affected **Network Device** resource and select **Metrics**. The resource type is `Microsoft.ManagedNetworkFabric/networkDevices`.
1. Select **Disk Utilization Percent** (`DiskUtilPercent`), and filter or split by `MountPointName` to identify the affected file system. Use `FabricId` to distinguish fabrics when applicable.
1. Review `DiskAvailableSize`, `DiskSize`, and `DiskUtilSize` for the same device, mount point, and time range. These size metrics are in bytes. Use the trend and your configured alert criteria rather than a single data point.
1. Record the device resource ID, fabric resource ID, mount point, metric timestamps, and any related provisioning error.

For metric descriptions, dimensions, and collection frequency, see [Device performance and interface metrics](./list-of-metrics-collected.md#device-performance-and-interface-metrics).

## Confirm that a file is eligible for cleanup

Connect through your organization's authorized [break-glass access](./howto-use-break-glass-access.md) procedure. Complete its prerequisites and use an appropriately authorized account.

Delete a file only when all the following conditions are met:

- Your organization can verify that it created or explicitly copied the file. A file name, extension, location, or operating-system owner isn't sufficient proof.
- The file is no longer needed, isn't being written, and isn't required for an active investigation or retention obligation.
- You have copied any required evidence to approved storage outside the device and verified the copy. Creating another copy on the same file system doesn't free space.
- The file resides on the file system identified by the disk metrics.
- The file isn't required by the device operating system or the managed Network Fabric service.

For example, a completed packet capture that your organization explicitly created might be eligible after it has been exported and is no longer needed. Don't assume every packet capture or diagnostic archive is customer-created.

> [!WARNING]
> Don't delete operating-system images, boot files, startup or running configuration, certificates, keys, agents, service-managed files, system logs, crash dumps, or files of unknown origin. Don't format storage, reset the device, remove directories recursively, or use wildcard deletion. If the affected partition contains only system-managed files, contact Microsoft Support instead of attempting cleanup.

## Remove one verified customer-created file

The following example requires Microsoft Support confirmation that EOS Bash access and the listed commands are supported for your device, release, and account. If they aren't, stop and use the supported procedure provided by Microsoft Support.

1. From the EOS CLI, enter the Bash shell:

   ```text
   bash
   ```

1. Inspect file-system utilization without changing files:

   ```bash
   df -h
   ```

1. Set `customer_file` to the exact absolute path of one eligible file. The path below is illustrative; it isn't a designated customer storage location. Don't create this directory or copy files to it as part of this procedure.

   ```bash
   customer_file='/mnt/flash/customer-diagnostics/obsolete-capture.pcap'
   ```

1. Inspect the path, its resolved location, and its file system:

   ```bash
   ls -ld -- "$customer_file"
   readlink -f -- "$customer_file"
   df -h -- "$customer_file"
   ```

   Confirm that the target is a regular file, not a directory or symbolic link, and that its resolved path is the intended customer-created file. Compare the `Mounted on` value with the affected file system. Device telemetry and shell output might use different path representations. If you can't establish the mapping, stop and contact Microsoft Support.

1. Recheck the eligibility conditions before proceeding. Delete only that file, using an interactive confirmation:

   ```bash
   rm -i -- "$customer_file"
   ```

   Confirm only if the prompt identifies the exact file you approved. Deletion is irreversible without a retained copy. If the command fails or no confirmation prompt appears, stop and contact Microsoft Support rather than adding force or privilege-elevation options.

1. Verify free space and leave the shell:

   ```bash
   df -h
   exit
   ```

Review the result before selecting another file. Don't automate deletion or apply this example to multiple devices at once.

Don't submit file-deletion commands through `az networkfabric device run-rw`. The [read-write command feature](./concepts-network-fabric-read-write-commands.md) manages device configuration. This procedure doesn't use it for one-time file cleanup. Don't reboot a device, restart services, or change its administrative state as part of this procedure. If Microsoft Support requires additional maintenance, follow the separately approved maintenance procedure.

## Verify recovery or contact support

Check that available space increased on the affected file system. Then review `DiskUtilPercent` and `DiskAvailableSize` for the same device and `MountPointName`. These disk metrics are collected per minute. Allow for collection and ingestion delay before evaluating the trend.

If a removed file was still open, space might not be reclaimed immediately. Don't stop processes or restart the device to reclaim space. Contact Microsoft Support if space doesn't recover, utilization continues to increase, the file system is read-only, no eligible customer-created files exist, or device health is affected.

After confirming disk recovery, investigate any remaining resource operation error independently. Don't assume that cleanup automatically retries or repairs a failed provisioning operation.

Provide Microsoft Support with the affected resource IDs, device software version, mount point, UTC timestamps, before-and-after metrics and `df -h` output, related operation errors and correlation IDs, and a record of the approved files removed. Share diagnostic output through an approved support channel. Don't include credentials or file contents in public issues.

To open a support request, [contact Microsoft Support](https://portal.azure.com/?#blade/Microsoft_Azure_Support/HelpAndSupportBlade).
