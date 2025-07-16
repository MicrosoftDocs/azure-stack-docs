---
title: View Health Service faults
description: Learn more about Health Service faults
ms.author: alkohli
ms.topic: how-to
author: alkohli
ms.date: 07/15/2025
---

# View Health Service faults

> Applies to: Azure Local 2311.2 and later; Windows Server 2022, Windows Server 2019

This article provides detailed information about Health Service faults in Azure Local and Windows Server.

## About Health Service faults

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

For reference information about faults, see [Health Service faults reference](#health-service-faults-reference).

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

In order to query the Health Service, you establish a **CimSession** with the cluster. To do so, you will need some things that are only available in full Microsoft .NET, meaning you can't readily do this directly from a web or mobile app. The code samples in this section use C\#, the most straightforward choice for this data access layer.

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

| **Property** | **Example** |
|--|--|
| FaultId | {12345-12345-12345-12345-12345} |
| FaultType | Microsoft.Health.FaultType.Volume.Capacity |
| Reason | "The volume is running out of available space." |
| PerceivedSeverity | 5 |
| FaultingObjectDescription | Contoso XYZ9000 S.N. 123456789 |
| FaultingObjectLocation | Rack A06, RU 25, Slot 11 |
| RecommendedActions | {"Expand the volume.", "Migrate workloads to other volumes."} |

**FaultId**: Unique ID within the scope of one cluster.

**PerceivedSeverity**: PerceivedSeverity = { 4, 5, 6 } = { "Informational", "Warning", and "Error" }, or equivalent colors such as blue, yellow, and red.

**FaultingObjectDescription**: Part information for hardware, typically blank for software objects.

**FaultingObjectLocation**: Location information for hardware, typically blank for software objects.

**RecommendedActions**: List of recommended actions that are independent and in no particular order. Today, this list is often of length 1.

## Fault event properties

The following table presents several key properties of the fault event. For the full schema, inspect the **MSFT\_StorageFaultEvent** class in *storagewmi.mof*.

Note the **ChangeType** that indicates whether a fault is being created, removed, or updated, and the **FaultId**. An event also contains all the properties of the affected fault.

| **Property** | **Example** |
|--|--|
| ChangeType | 0 |
| FaultId | {12345-12345-12345-12345-12345} |
| FaultType | Microsoft.Health.FaultType.Volume.Capacity |
| Reason | "The volume is running out of available space." |
| PerceivedSeverity | 5 |
| FaultingObjectDescription | Contoso XYZ9000 S.N. 123456789 |
| FaultingObjectLocation | Rack A06, RU 25, Slot 11 |
| RecommendedActions | {"Expand the volume.", "Migrate workloads to other volumes."} |

**ChangeType**: ChangeType = { 0, 1, 2 } = { "Create", "Remove", "Update" }.

## Health Service faults reference

The Health Service in Azure Local and Windows Server can detect faults across various system components, including storage, networking, and compute resources.

For a detailed overview of health faults, including fault severity mappings, health settings (data types, fault associations, default values, and descriptions), and the list of collected metrics, download the [Health Service faults](https://github.com/Azure-Samples/AzureLocal/blob/main/health-service-faults/health-service-faults.xlsx) spreadsheet.

Considerations for Health Service faults:

- Some faults are disabled by default. To enable a fault, set the corresponding health setting to true.
 - For example, fault type `Microsoft.Health.FaultType.PhysicalDisk.HighLatency.AverageIO` is disabled by default. To enable it, set the health setting `System.Storage.PhysicalDisk.HighLatency.Threshold.Tail.Enabled` to true.
- The health of storage enclosure components, such as fans, power supplies, and sensors are derived from SCSI Enclosure Services (SES). If your vendor doesn't provide this information, the Health Service cannot display it.

## Additional references

- [Health Service](health-service-overview.md)
