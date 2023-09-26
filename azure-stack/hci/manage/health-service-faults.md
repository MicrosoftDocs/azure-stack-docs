---
description: "Learn more about: Health Service faults"
title: View Health Service faults
ms.author: sethm
ms.topic: article
author: sethmanheim
ms.date: 04/17/2023
---

# View Health Service faults

> Applies to: Azure Stack HCI, versions 22H2 and 21H2; Windows Server 2022, Windows Server 2019

The Health Service constantly monitors your Storage Spaces Direct cluster to detect problems and generate "faults." One cmdlet displays any current faults, allowing you to easily verify the health of your deployment without looking at every entity or feature in turn. Faults are designed to be precise, easy to understand, and actionable.

Each fault contains five important fields:
- Severity
- Description of the problem
- Recommended next steps to address the problem
- Identifying information for the faulting entity
- Its physical location (if applicable)

For example, here is a typical fault:

```
Severity: MINOR
Reason: Connectivity has been lost to the physical disk.
Recommendation: Check that the physical disk is working and properly connected.
Part: Manufacturer Contoso, Model XYZ9000, Serial 123456789
Location: Seattle DC, Rack B07, Node 4, Slot 11
```

 >[!NOTE]
 > The physical location is derived from your fault domain configuration. For more information about fault domains, see [Fault domain awareness](/windows-server/failover-clustering/fault-domains). If you do not provide this information, the location field is less helpful. For example, it may only show the slot number.

## Root cause analysis
The Health Service can assess the potential causality among faulting entities to identify and combine faults that are consequences of the same underlying problem. By recognizing chains of effect, this makes for less chatty reporting. For example, if a server is down, it is expected that any drives within the server are also without connectivity. Therefore, only one fault will be raised for the root cause - in this case, the server.

## Usage in PowerShell
To see any current faults in PowerShell, run the following cmdlet:

```PowerShell
Get-HealthFault
```

This returns any faults that affect the overall Storage Spaces Direct cluster. Most often, these faults relate to hardware or configuration. If there are no faults, the cmdlet returns nothing.

>[!NOTE]
> In a non-production environment, and at your own risk, you can experiment with this feature by triggering faults yourself. For example, you can do this by removing one physical disk or shutting down one node. After the fault appears, re-insert the physical disk or restart the node to make the fault disappear.

## Usage in .NET and C#
This section shows how to connect to the Health Service, use discover objects, and run fault queries.

### Connect
In order to query the Health Service, you establish a **CimSession** with the cluster. To do so, you will need some things that are only available in full Microsoft .NET, meaning you cannot readily do this directly from a web or mobile app. The code samples in this section use C\#, the most straightforward choice for this data access layer.

```
using System.Security;
using Microsoft.Management.Infrastructure;

public CimSession Connect(string Domain = "...", string Computer = "...", string Username = "...", string Password = "...")
{
    SecureString PasswordSecureString = new SecureString();
    foreach (char c in Password)
    {
        PasswordSecureString.AppendChar(c);
    }

    CimCredential Credentials = new CimCredential(
        PasswordAuthenticationMechanism.Default, Domain, Username, PasswordSecureString);
    WSManSessionOptions SessionOptions = new WSManSessionOptions();
    SessionOptions.AddDestinationCredentials(Credentials);
    Session = CimSession.Create(Computer, SessionOptions);
    return Session;
}
```

The provided username should be a local administrator of the target computer.

We recommend constructing the Password **SecureString** directly from user input in real-time, so that the password is never stored in memory in cleartext. This helps mitigate a variety of security concerns. But in practice, constructing it as above is common for prototyping purposes.

### Discover objects
With the **CimSession** established, you can query Windows Management Instrumentation (WMI) on the cluster.

Before you can get Faults or Metrics, you need to get instances of several relevant objects. First, get the **MSFT\_StorageSubSystem** that represents Storage Spaces Direct on the cluster. Using that, you can get every **MSFT\_StorageNode** in the cluster, and every **MSFT\_Volume** of the data volumes. Finally, you need to get the **MSCluster\_ClusterHealthService**, the Health Service itself.

```
CimInstance Cluster;
List<CimInstance> Nodes;
List<CimInstance> Volumes;
CimInstance HealthService;

public void DiscoverObjects(CimSession Session)
{
    // Get MSFT_StorageSubSystem for Storage Spaces Direct
    Cluster = Session.QueryInstances(@"root\microsoft\windows\storage", "WQL", "SELECT * FROM MSFT_StorageSubSystem")
        .First(Instance => (Instance.CimInstanceProperties["FriendlyName"].Value.ToString()).Contains("Cluster"));

    // Get MSFT_StorageNode for each cluster node
    Nodes = Session.EnumerateAssociatedInstances(Cluster.CimSystemProperties.Namespace,
        Cluster, "MSFT_StorageSubSystemToStorageNode", null, "StorageSubSystem", "StorageNode").ToList();

    // Get MSFT_Volumes for each data volume
    Volumes = Session.EnumerateAssociatedInstances(Cluster.CimSystemProperties.Namespace,
        Cluster, "MSFT_StorageSubSystemToVolume", null, "StorageSubSystem", "Volume").ToList();

    // Get MSFT_StorageHealth itself
    HealthService = Session.EnumerateAssociatedInstances(Cluster.CimSystemProperties.Namespace,
        Cluster, "MSFT_StorageSubSystemToStorageHealth", null, "StorageSubSystem", "StorageHealth").First();
}
```

These are the same objects you get in PowerShell using cmdlets like **Get-StorageSubSystem**, **Get-StorageNode**, and **Get-Volume**.

You can access all the same properties, documented at [Storage Management API Classes](/windows-hardware/drivers/storage/storage-management-api-classes).

```
using System.Diagnostics;

foreach (CimInstance Node in Nodes)
{
    // For illustration, write each node's Name to the console. You could also write State (up/down), or anything else!
    Debug.WriteLine("Discovered Node " + Node.CimInstanceProperties["Name"].Value.ToString());
}
```

### Query faults
Invoke **Diagnose** to get any current faults scoped to the target **CimInstance**, which can be either the cluster or any volume.

The complete list of faults available at each scope in Windows Server 2019 is documented later in the [Coverage](#coverage) section.

```
public void GetFaults(CimSession Session, CimInstance Target)
{
    // Set Parameters (None)
    CimMethodParametersCollection FaultsParams = new CimMethodParametersCollection();
    // Invoke API
    CimMethodResult Result = Session.InvokeMethod(Target, "Diagnose", FaultsParams);
    IEnumerable<CimInstance> DiagnoseResults = (IEnumerable<CimInstance>)Result.OutParameters["DiagnoseResults"].Value;
    // Unpack
    if (DiagnoseResults != null)
    {
        foreach (CimInstance DiagnoseResult in DiagnoseResults)
        {
            // TODO: Whatever you want!
        }
    }
}
```

### Optional: MyFault class
It may make sense to construct and persist your own representation of faults. For example, the **MyFault** class stores several key properties of faults, including the **FaultId**, which can be used later to either associate updates, remove notifications, or deduplicate in the event that the same fault is detected multiple times.

```
public class MyFault {
    public String FaultId { get; set; }
    public String Reason { get; set; }
    public String Severity { get; set; }
    public String Description { get; set; }
    public String Location { get; set; }

    // Constructor
    public MyFault(CimInstance DiagnoseResult)
    {
        CimKeyedCollection<CimProperty> Properties = DiagnoseResult.CimInstanceProperties;
        FaultId     = Properties["FaultId"                  ].Value.ToString();
        Reason      = Properties["Reason"                   ].Value.ToString();
        Severity    = Properties["PerceivedSeverity"        ].Value.ToString();
        Description = Properties["FaultingObjectDescription"].Value.ToString();
        Location    = Properties["FaultingObjectLocation"   ].Value.ToString();
    }
}
```

```
List<MyFault> Faults = new List<MyFault>;

foreach (CimInstance DiagnoseResult in DiagnoseResults)
{
    Faults.Add(new Fault(DiagnoseResult));
}
```

The complete list of properties in each fault (**DiagnoseResult**) is documented later in the [Fault properties](#fault-properties) section.

### Fault events
When faults are created, removed, or updated, the Health Service generates WMI events. These are essential to keeping your application state in sync without frequent polling, and can help with things like determining when to send email alerts, for example. To subscribe to these events, the following sample code uses the Observer Design Pattern.

First, subscribe to **MSFT\_StorageFaultEvent** events.

```
public void ListenForFaultEvents()
{
    IObservable<CimSubscriptionResult> Events = Session.SubscribeAsync(
        @"root\microsoft\windows\storage", "WQL", "SELECT * FROM MSFT_StorageFaultEvent");
    // Subscribe the Observer
    FaultsObserver<CimSubscriptionResult> Observer = new FaultsObserver<CimSubscriptionResult>(this);
    IDisposable Disposeable = Events.Subscribe(Observer);
}
```

Next, implement an Observer whose **OnNext()** method is invoked whenever a new event is generated.

Each event contains **ChangeType** that indicates whether a fault is created, removed, or updated, and the relevant **FaultId**.

In addition, each event contains all the properties of the fault itself.

```
class FaultsObserver : IObserver
{
    public void OnNext(T Event)
    {
        // Cast
        CimSubscriptionResult SubscriptionResult = Event as CimSubscriptionResult;

        if (SubscriptionResult != null)
        {
            // Unpack
            CimKeyedCollection<CimProperty> Properties = SubscriptionResult.Instance.CimInstanceProperties;
            String ChangeType = Properties["ChangeType"].Value.ToString();
            String FaultId = Properties["FaultId"].Value.ToString();

            // Create
            if (ChangeType == "0")
            {
                Fault MyNewFault = new MyFault(SubscriptionResult.Instance);
                // TODO: Whatever you want!
            }
            // Remove
            if (ChangeType == "1")
            {
                // TODO: Use FaultId to find and delete whatever representation you have...
            }
            // Update
            if (ChangeType == "2")
            {
                // TODO: Use FaultId to find and modify whatever representation you have...
            }
        }
    }
    public void OnError(Exception e)
    {
        // Handle Exceptions
    }
    public void OnCompleted()
    {
        // Nothing
    }
}
```

### Understanding the fault lifecycle
Faults are not intended to be marked as either "seen" or resolved by the user. They are created when the Health Service observes a problem, and they are removed automatically only after the Health Service can no longer observe the problem. In general, this reflects that the problem has been fixed.

However, in some cases, faults may be rediscovered by the Health Service, such as after a failover, intermittent connectivity, and so on. For this reason, it may make sense to persist your own representation of faults, so that you can easily deduplicate. This is especially important if you send email alerts or the equivalent.

### Fault properties
The following table presents several key properties of the fault object. For the full schema, inspect the **MSFT\_StorageDiagnoseResult** class in *storagewmi.mof*.

| **Property**              | **Example**                                                     |
|---------------------------|-----------------------------------------------------------------|
| FaultId                   | {12345-12345-12345-12345-12345}                                 |
| FaultType                 | Microsoft.Health.FaultType.Volume.Capacity                      |
| Reason                    | "The volume is running out of available space."                 |
| PerceivedSeverity         | 5                                                               |
| FaultingObjectDescription | Contoso XYZ9000 S.N. 123456789                                  |
| FaultingObjectLocation    | Rack A06, RU 25, Slot 11                                        |
| RecommendedActions        | {"Expand the volume.", "Migrate workloads to other volumes."}   |

**FaultId**: Unique ID within the scope of one cluster.

**PerceivedSeverity**: PerceivedSeverity = { 4, 5, 6 } = { "Informational", "Warning", and "Error" }, or equivalent colors such as blue, yellow, and red.

**FaultingObjectDescription**: Part information for hardware, typically blank for software objects.

**FaultingObjectLocation**: Location information for hardware, typically blank for software objects.

**RecommendedActions**: List of recommended actions that are independent and in no particular order. Today, this list is often of length 1.

## Fault event properties
The following table presents several key properties of the fault event. For the full schema, inspect the **MSFT\_StorageFaultEvent** class in *storagewmi.mof*.

Note the **ChangeType** that indicates whether a fault is being created, removed, or updated, and the **FaultId**. An event also contains all the properties of the affected fault.

| **Property**              | **Example**                                                     |
|---------------------------|-----------------------------------------------------------------|
| ChangeType                | 0                                                               |
| FaultId                   | {12345-12345-12345-12345-12345}                                 |
| FaultType                 | Microsoft.Health.FaultType.Volume.Capacity                      |
| Reason                    | "The volume is running out of available space."                 |
| PerceivedSeverity         | 5                                                               |
| FaultingObjectDescription | Contoso XYZ9000 S.N. 123456789                                  |
| FaultingObjectLocation    | Rack A06, RU 25, Slot 11                                        |
| RecommendedActions        | {"Expand the volume.", "Migrate workloads to other volumes."}   |

**ChangeType**
ChangeType = { 0, 1, 2 } = { "Create", "Remove", "Update" }.

## Coverage
In Windows Server 2019 and Azure Stack HCI, the Health Service provides the following fault coverage:

### **PhysicalDisk (31)**

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.FailedMedia
* Severity: Warning
* Reason: *"The physical disk has failed."*
* RecommendedAction: *"Replace the physical disk."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.LostCommunication
* Severity: Warning
* Reason: *"Connectivity has been lost to the physical disk."*
* RecommendedAction: *"Check that the physical disk is working and properly connected."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.Unresponsive
* Severity: Warning
* Reason: *"The physical disk is exhibiting recurring unresponsiveness."*
* RecommendedAction: *"Replace the physical disk."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.PredictiveFailure
* Severity: Warning
* Reason: *"A failure of the physical disk is predicted to occur soon."*
* RecommendedAction: *"Replace the physical disk."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.UnsupportedHardware
* Severity: Warning
* Reason: *"The physical disk is quarantined because it is not supported by your solution vendor."*
* RecommendedAction: *"Replace the physical disk with supported hardware."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.UnsupportedFirmware
* Severity: Warning
* Reason: *"The physical disk is in quarantine because its firmware version is not supported by your solution vendor."*
* RecommendedAction: *"Update the firmware on the physical disk to the target version."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.UnrecognizedMetadata
* Severity: Warning
* Reason: *"The physical disk has unrecognized meta data."*
* RecommendedAction: *"This disk may contain data from an unknown storage pool. First make sure there is no useful data on this disk, then reset the disk."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.FailedFirmwareUpdate
* Severity: Warning
* Reason: *"Failed attempt to update firmware on the physical disk."*
* RecommendedAction: *"Try using a different firmware binary."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.SblFailedMedia
* Severity: Warning
* Reason: *"The drive failed."*
* RecommendedAction: *"Replace the drive."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.SblUnresponsive
* Severity: Warning
* Reason: *"The physical disk is exhibiting recurring unresponsiveness."*
* RecommendedAction: *"Replace the physical disk."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.FailureBadBlock
* Severity: Warning
* Reason: *"The drive reported bad blocks during writes. An occasional bad block is normal, but too many could mean that the drive is malfunctioning, damaged, or beginning to fail."*
* RecommendedAction: *"If this keeps happening or you observe decreased performance, consider replacing the drive."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.FailureBadBlockRead
* Severity: Warning
* Reason: *"The drive reported bad blocks during reads. An occasional bad block is normal, but too many could mean that the drive is malfunctioning, damaged, or beginning to fail."*
* RecommendedAction: *"If this keeps happening or you observe decreased performance, consider replacing the drive."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.FailureIoRetry 
* Severity: Warning
* Reason: *"The drive needed multiple tries to read or write. If this keeps happening, it could mean that the drive is malfunctioning, damaged, or beginning to fail."*
* RecommendedAction: *"If this keeps happening or you observe decreased performance, consider replacing the drive."*

>[!NOTE]
> This Fault is disabled by default. To enable it, set the health setting System.Storage.PhysicalDisk.MarginalFailure.EventBased.IoRetry.Enabled to true

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.FailureIoFailure 
* Severity: Warning
* Reason: *"The drive failed to read or write. If this keeps happening, it could mean that the drive is malfunctioning, damaged, or beginning to fail."*
* RecommendedAction: *"If this keeps happening or you observe decreased performance, consider replacing the drive."*

>[!NOTE]
> This Fault is disabled by default. To enable it, set the health setting System.Storage.PhysicalDisk.MarginalFailure.EventBased.IoFailure.Enabled to true

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.FailureSmart 
* Severity: Warning
* Reason: *"The drive reported the following potential problems to Windows using SMART (Self-Monitoring, Analysis and Reporting Technology)"*
* RecommendedAction: *"If this keeps happening or you observe decreased performance, consider replacing the drive."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.FailureHighWear
* Severity: Warning
* Reason: *"The drive has reached high percentage of its rated write endurance. The drive may become read-only, meaning it cannot perform any more writes, when it reaches 100% of its rated endurance. Check the data sheet or ask the manufacturer for more details about endurance rating and end-of-life behavior."*
* RecommendedAction: *"If this keeps happening or you observe decreased performance, consider replacing the drive."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.FailureReadOnly
* Severity: Warning
* Reason: *"The drive reached 100% of its rated write endurance and is now read-only, meaning it cannot perform any more writes. Solid-state drives wear out after a certain number of writes, which varies depending on the endurance rating of the drive. For details, check the drive specifications or ask the manufacturer about endurance rating and end-of-life behavior."*
* RecommendedAction: *"If this keeps happening or you observe decreased performance, consider replacing the drive."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.HighLatency.SlowestIO
* Severity: Warning
* Reason: *"The drive has high peak latency."*
* RecommendedAction: *"Monitor the drive's performance and consider replacing the drive."*

>[!NOTE]
> This Fault is disabled by default. To enable it, set the health setting System.Storage.PhysicalDisk.HighLatency.Threshold.Tail.Enabled to true

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.HighLatency.AverageIO
* Severity: Warning
* Reason: *"The drive has high average latency."*
* RecommendedAction: *"Monitor the drive's performance and consider replacing the drive."*

>[!NOTE]
> This Fault is disabled by default. To enable it, set the health setting System.Storage.PhysicalDisk.HighLatency.Threshold.Tail.Enabled to true

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.HighLatency.Outlier.AverageIO
* Severity: Warning
* Reason: *"The drive has high average latency."*
* RecommendedAction: *"Monitor the drive's performance and consider replacing the drive."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.HighLatency.Outlier.SlowestIO
* Severity: Warning
* Reason: *"The drive has high peak latency."*
* RecommendedAction: *"Monitor the drive's performance and consider replacing the drive."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.HighErrorCount.AverageIO
* Severity: Warning
* Reason: *"The drive has high number of errors."*
* RecommendedAction: *"Monitor the drive's performance and consider replacing the drive."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.HighErrorCount.Outlier.AverageIO
* Severity: Warning
* Reason: *"The drive has high number of errors."*
* RecommendedAction: *"Monitor the drive's performance and consider replacing the drive."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.CacheReadOnly
* Severity: Warning
* Reason: *"The cache drive failed some reads or writes, so to protect your data we've moved it onto capacity drives."*
* RecommendedAction: *"Replace the drive or try to clear and reset it."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.CacheReadOnly.Draining
* Severity: Warning
* Reason: *"The cache drive failed some reads or writes. To protect your data, we've stopped writing to the cache drive and we're trying to move its data onto capacity drives."*
* RecommendedAction: *"Hang on while we move the data."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.CacheReadOnly.FailedDrain
* Severity: Warning
* Reason: *"Some data on the cache drive can't be read, preventing us from moving it onto capacity drives."*
* RecommendedAction: *"Replace the drive."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.SedEncKey.RotationFailure
* Severity: Warning
* Reason: *"The attempt to rotate SED encryption key to the new default failed."*
* RecommendedAction: *"Check that the drive is working and properly connected. If the drive has failed, replace it. Restart SED encryption key rotation once the drive is healthy."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.SedEncKey.NotDefault
* Severity: Warning
* Reason: *"The physical disk has a SED encryption key, however it does not match the current default key."*
* RecommendedAction: *"Initiate SED encryption key rotation."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.SedEncKey.NotDefined
* Severity: Warning
* Reason: *"There is no defined default SED encryption key for the drive."*
* RecommendedAction: *"Set a default SED encryption key."*

#### FaultType: Microsoft.Health.FaultType.StorageScaleUnit.SedEncKey.RotationTimeout
* Severity: Warning
* Reason: *"Failed to complete SED encryption key rotation on the server before timeout"*
* RecommendedAction: *"Ensure the server is reachable and that all physical disks are healthy."*

#### FaultType: Microsoft.Health.FaultType.PhysicalDisk.DriveArriveFailure
* Severity: Warning
* Reason: *"Physical Disk is failing queries. "*
* RecommendedAction: *"Please validate network reliability. If the issue persists, consider replacing the device."*

### **Virtual Disk (3)**

#### FaultType: Microsoft.Health.FaultType.VirtualDisks.NeedsRepair
* Severity: Informational
* Reason: *"Some data on this volume is not fully resilient. It remains accessible."*
* RecommendedAction: *"Restoring resiliency of the data."*

#### FaultType: Microsoft.Health.FaultType.VirtualDisks.Detached
* Severity: Critical
* Reason: *"The volume is inaccessible. Some data may be lost."*
* RecommendedAction: *"Check the physical and/or network connectivity of all storage devices. You may need to restore from backup."*

#### FaultType: Microsoft.Health.FaultType.VirtualDisks.NoRedundancy
* Severity: Critical
* Reason: *"All copies of data are unavailable for a region of virtual disk.  Workload may be interrupted and IO failures may be observed."*
* RecommendedAction: *"If a maintenance operation is ongoing, please suspend it and restore access to all storage until the storage stabilizes."*

### **Pool Capacity (2)**

#### FaultType: Microsoft.Health.FaultType.StoragePool.TransactionAndCleanupFailure
* Severity: Warning
* Reason: *"Storage Pool is unable to write to a quorum of metadata devices.  Workload may be interrupted and IO failures may be observed."*
* RecommendedAction: *"If a maintenance operation is ongoing, please suspend it and restore access to all storage until the storage stabilizes."*

#### FaultType: Microsoft.Health.FaultType.StoragePool.PoolCapacityThresholdExceeded
* Severity: Warning
* Reason: *"The storage pool is running out of capacity."*
* RecommendedAction: *"Add additional capacity to the storage pool or free up capacity."*

### **Volume Capacity (5)**<sup>1</sup>

#### FaultType: Microsoft.Health.FaultType.Volume.Capacity
* Severity: Warning
* Reason: *"The volume is running out of available space."*
* RecommendedAction: *"Expand the volume or migrate workloads to other volumes."*

#### FaultType: Microsoft.Health.FaultType.Volume.FileSystem.Corruption.Correctable
* Severity: Warning
* Reason: *"The file system detected a checksum error and was able to correct it."*
* RecommendedAction: *"Initiate Data Integrity scan from task scheduler, storage might be going bad. If there is an update or maintenance operation going on, stop it immediately. You may need to restore from the backup."*

#### FaultType: Microsoft.Health.FaultType.Volume.FileSystem.Corruption.Uncorrectable
* Severity: Warning
* Reason: *"The file system detected a checksum error and was not able to correct it."*
* RecommendedAction: *"Initiate Data Integrity scan from task scheduler, storage might be going bad. If there is an update or maintenance operation going on, stop it immediately. You may need to restore from the backup."*

#### FaultType: Microsoft.Health.FaultType.Volume.FileSystem.Corruption.Uncorrectable.DataRemoved
* Severity: Warning
* Reason: *"The file system detected a corruption on a file or folder. The file or folder has been removed from the file system namespace."*
* RecommendedAction: *"Initiate Data Integrity scan from task scheduler, storage might be going bad. If there is an update or maintenance operation going on, stop it immediately. You may need to restore from the backup."*

#### FaultType: Microsoft.Health.FaultType.Volume.FileSystem.Corruption.Uncorrectable.DataRemovalFailure
* Severity: Warning
* Reason: *"The file system detected a corruption on a file or folder. The file system may have failed to remove it from the file system namespace."*
* RecommendedAction: *"Initiate Data Integrity scan from task scheduler, storage might be going bad. If there is an update or maintenance operation going on, stop it immediately. You may need to restore from the backup."*

### **Server (12)**

#### FaultType: Microsoft.Health.FaultType.Server.Down
* Severity: Critical
* Reason: *"The server cannot be reached."*
* RecommendedAction: *"Start or replace server."*

#### FaultType: Microsoft.Health.FaultType.Server.Isolated
* Severity: Critical
* Reason: *"The server is isolated from the cluster due to connectivity issues."*
* RecommendedAction: *"If isolation persists, check the network(s) or migrate workloads to other nodes."*

#### FaultType: Microsoft.Health.FaultType.Server.Quarantined
* Severity: Critical
* Reason: *"The server is quarantined by the cluster due to recurring failures."*
* RecommendedAction: *"Replace the server or fix the network."*

#### FaultType: Microsoft.Health.FaultType.Server.Temperature
* Severity: Warning
* Reason: *"The server temperature sensor has raised a warning."*
* RecommendedAction: *"Check the server temperature."*

#### FaultType: Microsoft.Health.FaultType.Server.Storage.Degraded
* Severity: Warning
* Reason: *"The server has storage that isn't complete or up-to-date, so we need to sync it with data from other servers in the cluster. This is normal after a server restarts or a drive fails."*
* RecommendedAction: *"Hang on while we sync the storage. Don't remove any drives or restart any servers in the cluster until we confirm that the sync is complete."*

#### FaultType: Microsoft.Health.FaultType.Node.CPUOverloaded
* Severity: Warning
* Reason: *"The server's CPU utilization is consistently over threshold."*
* RecommendedAction: *"Move virtual machines to other servers with lower CPU usage, or consider adding additional compute capacity to the cluster (usually by adding servers)."*

#### FaultType: Microsoft.Health.FaultType.Node.VCPUToLCPU
* Severity: Warning
* Reason: *"The ratio of virtual processors to logical processors (threads) on this server has exceeded your configured threshold."*
* RecommendedAction: *"Move virtual machines to another server with lower CPU usage or consider adding additional compute capacity to the cluster."*

#### FaultType: Microsoft.Health.FaultType.Node.LowFreeRam
* Severity: Warning
* Reason: *"Available memory is below your configured threshold."*
* RecommendedAction: *"Move virtual machines to another server with lower CPU usage or consider adding additional compute capacity to the cluster."*

#### FaultType: Microsoft.Health.FaultType.Node.HighRootPartitionMemoryUsage
* Severity: Warning
* Reason: *"Windows Server is consuming a lot of physical memory, which exceeds your configured threshold."*
* RecommendedAction: *"Check for processes or apps consuming too much memory, move virtual machines to other servers, or add memory to the servers."*

#### FaultType: Microsoft.Health.FaultType.Node.TooHighCpuReservation
* Severity: Warning
* Reason: *"The combined CPU reservation of virtual machines on this server exceeds your configured threshold."*
* RecommendedAction: *"Consider moving virtual machines or reducing their CPU reservations."*

#### FaultType: Microsoft.Health.FaultType.Node.TooHighMemoryUseAfterReclamation
* Severity: Warning
* Reason: *"The combined memory assignment of virtual machines on this server exceeds the your configured threshold."*
* RecommendedAction: *"Consider moving virtual machines or reducing their assigned memory."*

#### FaultType: Microsoft.Health.FaultType.Node.SustainedHighCpuUsage
* Severity: Warning
* Reason: *"The server has CPU usage consistently exceeding threshold."*
* RecommendedAction: *"Move virtual machines to another server with lower CPU usage or consider adding more compute capacity."*

### **Cluster (6)**

#### FaultType: Microsoft.Health.FaultType.ClusterQuorumWitness.Error
* Severity: Critical
* Reason: *"The cluster is one server failure away from going down."*
* RecommendedAction: *"Check the witness resource, and restart as needed. Start or replace failed servers."*

#### FaultType: Microsoft.Health.FaultType.Cluster.ValidationReport.Failed
* Severity: Critical
* Reason: *"Cluster Validation has found problems."*
* RecommendedAction: *"Cluster Validation has found failures in some categories of tests. See cluster validation report."*

#### FaultType: Microsoft.Health.FaultType.Cluster.ValidationReportDcb.Failed
* Severity: Critical
* Reason: *"Validate-DCB has found problems."*
* RecommendedAction: *"Validate-DCB has found networking errors. See DCB validation report."*

#### FaultType: Microsoft.Health.FaultType.Cluster.TooHighCpuReservation
* Severity: Critical
* Reason: *"The combined CPU reservation of virtual machines on this server exceeds your configured threshold."*
* RecommendedAction: *"Consider moving virtual machines or reducing their CPU reservations."*

#### FaultType: Microsoft.Health.FaultType.Cluster.TooHighMemoryUseAfterReclamation
* Severity: Critical
* Reason: *"The combined memory assignment of virtual machines on this server exceeds the your configured threshold."*
* RecommendedAction: *"Consider moving virtual machines or reducing their assigned memory."*

#### FaultType: Microsoft.Health.FaultType.Cluster.SustainedHighCpuUsage
* Severity: Critical
* Reason: *"The server has CPU usage consistently exceeding threshold."*
* RecommendedAction: *"Move virtual machines to another server with lower CPU usage or consider adding more compute capacity."*

### **Network Adapter/Interface (6)**

#### FaultType: Microsoft.Health.FaultType.NetworkAdapter.Disconnected
* Severity: Warning
* Reason: *"The network interface has become disconnected."*
* RecommendedAction: *"Reconnect the network cable."*

#### FaultType: Microsoft.Health.FaultType.NetworkInterface.Missing
* Severity: Warning
* Reason: *"The server {server} has missing network adapter(s) connected to cluster network {cluster network}."*
* RecommendedAction: *"Connect the server to the missing cluster network."*

#### FaultType: Microsoft.Health.FaultType.NetworkAdapter.Hardware
* Severity: Warning
* Reason: *"The network interface has had a hardware failure."*
* RecommendedAction: *"Replace the network interface adapter."*

#### FaultType: Microsoft.Health.FaultType.NetworkAdapter.Disabled
* Severity: Warning
* Reason: *"The network interface {network interface} is not enabled and is not being used."*
* RecommendedAction: *"Enable the network interface."*

#### FaultType: Microsoft.Health.FaultType.StorageSubsystem.RDMA.Alert
* Severity: Warning
* Reason: *"The cluster detected network connectivity issues that prevent Storage Spaces Direct from working properly."*
* RecommendedAction: *"Verify that your network is properly configured and working. If you are using RDMA Over Converged Ethernet (RoCE), verify that Data Center Bridging (DCB), Enhanced Transmission Service (ETS), and Priority Flow Control (PFC) are configured correctly and consistently on every cluster node and physical switch. If you don't know how to do this, ask your vendor or someone you trust to help you."*

#### FaultType: Microsoft.Health.FaultType.StorageSubsystem.RDMA.Disabled
* Severity: Warning
* Reason: *"The cluster detected network connectivity issues that prevent Storage Spaces Direct from working properly. To ensure consistent performance and data safety, Storage Spaces Direct has stopped using remote direct memory access (RDMA) even if RDMA-capable hardware is present and enabled. Storage traffic will continue to flow but with diminished performance using TCP/IP."*
* RecommendedAction: *"Verify that your network is properly configured and working, and then turn RDMA back on. If you are using RDMA Over Converged Ethernet (RoCE), verify that Data Center Bridging (DCB), Enhanced Transmission Service (ETS), and Priority Flow Control (PFC) are configured correctly and consistently on every cluster node and physical switch. If you don't know how to do this, ask your vendor or someone you trust to help you. To continue with RDMA turned off, you can dismiss this alert."*

### **Enclosure (6)**

#### FaultType: Microsoft.Health.FaultType.StorageEnclosure.LostCommunication
* Severity: Warning
* Reason: *"Communication has been lost to the storage enclosure."*
* RecommendedAction: *"Start or replace the storage enclosure."*

#### FaultType: Microsoft.Health.FaultType.StorageEnclosure.FanError
* Severity: Warning
* Reason: *"The fan at position {position} of the storage enclosure has failed."*
* RecommendedAction: *"Replace the fan in the storage enclosure."*

#### FaultType: Microsoft.Health.FaultType.StorageEnclosure.CurrentSensorError
* Severity: Warning
* Reason: *"The current sensor at position {position} of the storage enclosure has failed."*
* RecommendedAction: *"Replace a current sensor in the storage enclosure."*

#### FaultType: Microsoft.Health.FaultType.StorageEnclosure.VoltageSensorError
* Severity: Warning
* Reason: *"The voltage sensor at position {position} of the storage enclosure has failed."*
* RecommendedAction: *"Replace a voltage sensor in the storage enclosure."*

#### FaultType: Microsoft.Health.FaultType.StorageEnclosure.IoControllerError
* Severity: Warning
* Reason: *"The IO controller at position {position} of the storage enclosure has failed."*
* RecommendedAction: *"Replace an IO controller in the storage enclosure."*

#### FaultType: Microsoft.Health.FaultType.StorageEnclosure.TemperatureSensorError
* Severity: Warning
* Reason: *"The temperature sensor at position {position} of the storage enclosure has failed."*
* RecommendedAction: *"Replace a temperature sensor in the storage enclosure."*

### **Firmware Rollout (3)**

#### FaultType: Microsoft.Health.FaultType.FaultDomain.FailedMaintenanceMode
* Severity: Warning
* Reason: *"Currently unable to make progress while performing firmware roll out."*
* RecommendedAction: *"Verify all storage spaces are healthy, and that no fault domain is currently in maintenance mode."*

#### FaultType: Microsoft.Health.FaultType.FaultDomain.FirmwareVerifyVersionFailed
* Severity: Warning
* Reason: *"Firmware roll out was canceled due to unreadable or unexpected firmware version information after applying a firmware update."*
* RecommendedAction: *"Restart firmware roll out once the firmware issue has been resolved."*

#### FaultType: Microsoft.Health.FaultType.FaultDomain.TooManyFailedUpdates
* Severity: Warning
* Reason: *"Firmware roll out was canceled due to too many physical disks failing a firmware update attempt."*
* RecommendedAction: *"Restart firmware roll out once the firmware issue has been resolved."*

### **Storage QoS (3)**<sup>2</sup>

#### FaultType: Microsoft.Health.FaultType.StorQos.InsufficientThroughput
* Severity: Warning
* Reason: *"Storage throughput is insufficient to satisfy reserves."*
* RecommendedAction: *"Reconfigure Storage QoS policies."*

#### FaultType: Microsoft.Health.FaultType.StorQos.LostCommunication
* Severity: Warning
* Reason: *"The Storage QoS policy manager has lost communication with the volume."*
* RecommendedAction: *"Please reboot nodes {nodes}"*

#### FaultType: Microsoft.Health.FaultType.StorQos.MisconfiguredFlow
* Severity: Warning
* Reason: *"One or more storage consumers (usually Virtual Machines) are using a non-existent policy with id {id}."*
* RecommendedAction: *"Recreate any missing Storage QoS policies."*

### **VM/VHD (7)**

#### FaultType: Microsoft.Health.FaultType.Vm.BadHealthState
* Severity: Warning
* Reason: *"The virtual machine health state isn't OK."*
* RecommendedAction: *"Troubleshoot the virtual machine."*

#### FaultType: Microsoft.Health.FaultType.Vm.BadOperationalStatus
* Severity: Warning
* Reason: *"The virtual machine operational status isn't OK."*
* RecommendedAction: *"Troubleshoot the virtual machine."*

#### FaultType: Microsoft.Health.FaultType.Vm.GuestUnhealthy
* Severity: Warning
* Reason: *"The guest operating system in the virtual machine is reporting an unhealthy state."*
* RecommendedAction: *" Troubleshoot the virtual machine."*

#### FaultType: Microsoft.Health.FaultType.Vm.ConfigIsOffline
* Severity: Warning
* Reason: *"The virtual machine configuration resource is offline, meaning the virtual machine cannot be administered."*
* RecommendedAction: *"Bring the virtual machine configuration online."*

#### FaultType: Microsoft.Health.FaultType.Vm.NotRespondingToControlCodes
* Severity: Warning
* Reason: *"The virtual machine isn't responding to cluster control codes."*
* RecommendedAction: *"Check the state of the virtual machine cluster resource."*

#### FaultType: Microsoft.Health.FaultType.Vm.IsNearMemoryLimit
* Severity: Warning
* Reason: *"The virtual machine needs more of its configured maximum memory."*
* RecommendedAction: *"Check for processes or apps consuming too much memory or consider increasing its maximum memory."*

#### FaultType: Microsoft.Health.FaultType.Vhd.IsNearlyFull
* Severity: Warning
* Reason: *"The virtual hard disk has reached its capacity. No more data can be written to it, which may negatively impact the virtual machine(s)."*
* RecommendedAction: *"Resize the virtual hard disk or delete unwanted files."*

<sup>1</sup> Indicates the volume has reached 80% full (minor severity) or 90% full (major severity).
<sup>2</sup> Indicates some .vhd(s) on the volume have not met their Minimum IOPS for over 10% (minor), 30% (major), or 50% (critical) of a rolling 24-hour window.

>[!NOTE]
> The health of storage enclosure components, such as fans, power supplies, and sensors is derived from SCSI Enclosure Services (SES). If your vendor does not provide this information, the Health Service cannot display it.

## Additional references
- [Health Service](health-service-overview.md)
