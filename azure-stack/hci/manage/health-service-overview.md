---
description: "Learn more about how to use the Health Service to monitor clusters"
title: Monitor clusters with the Health Service
ms.author: sethm
ms.topic: article
author: sethmanheim
ms.date: 04/17/2023
---
# Monitor clusters with the Health Service

> Applies to: Azure Stack HCI, versions 22H2 and 21H2; Windows Server 2022, Windows Server 2019, Windows Server 2016

The Health Service, first released in Windows Server 2016, improves the day-to-day monitoring and operational experience for clusters running Storage Spaces Direct.

## Prerequisites
The Health Service is enabled by default with Storage Spaces Direct. No additional action is required to set it up or start it. To learn more about Storage Spaces Direct, see the [Storage Spaces Direct overview](/windows-server/storage/storage-spaces/storage-spaces-direct-overview).

## Cluster performance history
Get live performance and capacity information from your Storage Spaces Direct cluster.
See [Get cluster performance history](health-service-cluster-performance-history.md).

## Health Service faults
Display any current faults to easily verify the health of your deployment.
See [View Health Service faults](health-service-faults.md).

## Health Service actions
Track the progress of Health Service actions that are performed autonomously.
See [Track Health Service actions](health-service-actions.md).

## Automation
This section describes workflows which are automated by the Health Service in the disk lifecycle.

### Disk lifecycle
The Health Service automates most stages of the physical disk lifecycle. Let's say that the initial state of your deployment is in perfect health - which is to say, all physical disks are working properly.

#### Retirement
Physical disks are automatically retired when they can no longer be used, and a corresponding Fault is raised. There are several cases:
- Media Failure: the physical disk is definitively failed or broken, and must be replaced.
- Lost Communication: the physical disk has lost connectivity for over 15 consecutive minutes.
- Unresponsive: the physical disk has exhibited latency of over 5.0 seconds three or more times within an hour.

>[!NOTE]
> If connectivity is lost to many physical disks at once, or to an entire node or storage enclosure, the Health Service will *not* retire these disks since they are unlikely to be the root problem.

If the retired disk was serving as the cache for many other physical disks, these will automatically be reassigned to another cache disk if one is available. No special user action is required.

#### Restoring resiliency
Once a physical disk has been retired, the Health Service immediately begins copying its data onto the remaining physical disks, to restore full resiliency. Once this has completed, the data is completely safe and fault tolerant anew.

>[!NOTE]
> This immediate restoration requires sufficient available capacity among the remaining physical disks.

#### Blinking the indicator light
If possible, the Health Service will begin blinking the indicator light on the retired physical disk or its slot. This will continue indefinitely, until the retired disk is replaced.

>[!NOTE]
> In some cases, the disk may have failed in a way that precludes even its indicator light from functioning - for example, a total loss of power.

#### Physical replacement
You should replace the retired physical disk when possible. Most often, this consists of a hot-swap - i.e. powering off the node or storage enclosure is not required. See the Fault for helpful location and part information.

#### Verification
When the replacement disk is inserted, it will be verified against the Supported Components Document (see the next section).

#### Pooling
If allowed, the replacement disk is automatically substituted into its predecessor's pool to enter use. At this point, the system is returned to its initial state of perfect health, and then the Fault disappears.

## Supported Components Document
The Health Service provides an enforcement mechanism to restrict the components used by Storage Spaces Direct to those on a Supported Components Document provided by the administrator or solution vendor. This can be used to prevent mistaken use of unsupported hardware by you or others, which may help with warranty or support contract compliance. This functionality is currently limited to physical disk devices, including SSDs, HDDs, and NVMe drives. The Supported Components Document can restrict on model, manufacturer (optional), and firmware version (optional).

### Usage
The Supported Components Document uses an XML-inspired syntax. We recommend using your favorite text editor, such as the free [Visual Studio Code](https://code.visualstudio.com/) or Notepad, to create an XML document which you can save and reuse.

#### Sections
The document has two independent sections: `Disks` and `Cache`.

If the `Disks` section is provided, only the drives listed (as `Disk`) are allowed to join pools. Any unlisted drives are prevented from joining pools, which effectively precludes their use in production. If this section is left empty, any drive will be allowed to join pools.

If the `Cache` section is provided, only the drives listed (as `CacheDisk`) are used for caching. If this section is left empty, Storage Spaces Direct attempts to [guess based on media type and bus type](/windows-server/storage/storage-spaces/understand-the-cache#cache-drives-are-selected-automatically). Drives listed here should also be listed in `Disks`.

>[!IMPORTANT]
> The Supported Components Document does not apply retroactively to drives already pooled and in use.

#### Example

```XML
<Components>

  <Disks>
    <Disk>
      <Manufacturer>Contoso</Manufacturer>
      <Model>XYZ9000</Model>
      <AllowedFirmware>
        <Version>2.0</Version>
        <Version>2.1</Version>
        <Version>2.2</Version>
      </AllowedFirmware>
      <TargetFirmware>
        <Version>2.1</Version>
        <BinaryPath>C:\ClusterStorage\path\to\image.bin</BinaryPath>
      </TargetFirmware>
    </Disk>
    <Disk>
      <Manufacturer>Fabrikam</Manufacturer>
      <Model>QRSTUV</Model>
    </Disk>
  </Disks>

  <Cache>
    <CacheDisk>
      <Manufacturer>Fabrikam</Manufacturer>
      <Model>QRSTUV</Model>
    </CacheDisk>
  </Cache>

</Components>

```

To list multiple drives, simply add additional `<Disk>` or `<CacheDisk>` tags.

To inject this XML when deploying Storage Spaces Direct, use the `-XML` parameter:

```PowerShell
$MyXML = Get-Content <Filepath> | Out-String
Enable-ClusterS2D -XML $MyXML
```

To set or modify the Supported Components Document once Storage Spaces Direct has been deployed:

```PowerShell
$MyXML = Get-Content <Filepath> | Out-String
Get-StorageSubSystem Cluster* | Set-StorageHealthSetting -Name "System.Storage.SupportedComponents.Document" -Value $MyXML
```

>[!NOTE]
>The model, manufacturer, and the firmware version properties should exactly match the values that you get using the **Get-PhysicalDisk** cmdlet. This may differ from your "common sense" expectation, depending on your vendor's implementation. For example, rather than "Contoso", the manufacturer may be "CONTOSO-LTD", or it may be blank while the model is "Contoso-XZY9000".

You can verify using the following PowerShell cmdlet:

```PowerShell
Get-PhysicalDisk | Select Model, Manufacturer, FirmwareVersion
```

## Health Service settings
Modify Health Service settings to tune the aggressiveness of faults or actions, turn certain behaviors on or off, and more.
See [Modify Health Service settings](health-service-settings.md).

## Additional References
- [Get cluster performance history](health-service-cluster-performance-history.md)
- [View Health Service faults](health-service-faults.md)
- [Track Health Service actions](health-service-actions.md)
- [Storage Spaces Direct overview](/windows-server/storage/storage-spaces/storage-spaces-direct-overview)
