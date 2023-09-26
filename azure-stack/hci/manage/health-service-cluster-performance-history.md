---
description: "Learn more about: Cluster performance history"
title: Cluster performance history
ms.author: sethm
ms.topic: article
author: sethmanheim
ms.date: 04/17/2023
---

# Get cluster performance history

> Applies to: Azure Stack HCI, versions 22H2 and 21H2; Windows Server 2022, Windows Server 2019

The Health Service reduces the work required to get live performance and capacity information from your Storage Spaces Direct cluster. One cmdlet provides a curated list of essential metrics, which are collected efficiently and aggregated dynamically across nodes, with built-in logic to detect cluster membership. All values are real-time and point-in-time only.

## Usage in PowerShell
Use the following cmdlet to get metrics for the entire Storage Spaces Direct cluster:

```PowerShell
Get-ClusterPerformanceHistory
```

>[!TIP]
 > Use the Get-ClusterPerf alias to save some keystrokes.

You can also get metrics for one specific volume or server:

```PowerShell
Get-Volume -FileSystemLabel <Label> | Get-ClusterPerformanceHistory

Get-StorageNode -Name <Name> | Get-ClusterPerformanceHistory
```

## Usage in .NET and C#
This sections shows how to connect to the Health Service, use discover objects, and implement an Observer to begin streaming metrics.

### Connect
In order to query the Health Service, you establish a **CimSession** with the cluster. To do so, you need some things that are only available in full Microsoft .NET, meaning you cannot readily do this directly from a web or mobile app. The code samples in this section use C\#, the most straightforward choice for this data access layer.

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

Before you can get faults or metrics, you need to get instances of several relevant objects. First, get the **MSFT\_StorageSubSystem** that represents Storage Spaces Direct on the cluster. Using that, you can get every **MSFT\_StorageNode** in the cluster, and every **MSFT\_Volume** of the data volumes. Finally, you need to get the **MSCluster\_ClusterHealthService**, the Health Service itself.

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

    // Get MSCluster_ClusterHealthService itself
    HealthService = session.QueryInstances(@"root\MSCluster", "WQL", "SELECT * FROM MSCluster_ClusterHealthService").First();
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

Invoke **GetMetric** to begin streaming samples of an expert-curated list of essential metrics based on provided metric names from **MetricName** parameter, which are collected efficiently and aggregated dynamically across nodes, with built-in logic to detect cluster membership. Samples arrive based on the provided timeframe from the **StreamName** parameter.

For the complete list of available metrics, see [Performance history for Storage Spaces Direct](/windows-server/storage/storage-spaces/performance-history).

### IObserver.OnNext()
This sample code uses the [Observer Design Pattern](/dotnet/standard/events/observer-design-pattern) to implement an Observer whose **OnNext()** method is invoked when each new sample of metrics arrives. Its **OnCompleted()** method is called if/when streaming ends. For example, you might use it to reinitiate streaming, so that it continues indefinitely.

```
class MetricsObserver<T> : IObserver<T>
{
    public void OnNext(T Result)
    {
        // Cast
        CimMethodStreamedResult StreamedResult = Result as CimMethodStreamedResult;

        if (StreamedResult != null)
        {
            CimInstance Metric = (CimInstance)StreamedResult.ItemValue;
            Console.WriteLine("MetricName: " + Metric.CimInstanceProperties["MetricId"].Value);
            IEnumerable<CimInstance> Records = (IEnumerable<CimInstance>)Metric.CimInstanceProperties["Records"].Value;

            foreach (CimInstance Record in Records)
            {
                // Each Record has "TimeStamp" and "Value. For Illustration, just print the metric"
                Console.WriteLine(record.CimInstanceProperties["TimeStamp"] + ": " + record.CimInstanceProperties["Value"]);

            }

            // TODO: Whatever you want!
        }
    }
    public void OnError(Exception e)
    {
        // Handle Exceptions
    }
    public void OnCompleted()
    {
        // Reinvoke BeginStreamingMetrics(), defined in the next section
    }
}
```

### Begin streaming
With the Observer defined, you can begin streaming.

Specify the target **CimInstance** to which you want the metrics scoped. It can be the cluster, any node, or any volume.

The count parameter is the number of samples before streaming ends.

```
CimInstance Target = Cluster; // From among the objects discovered in DiscoverObjects()

public void BeginStreamingMetrics(CimSession Session, CimInstance HealthService, CimInstance Target)
{
    // Set Parameters
    CimMethodParametersCollection MetricsParams = new CimMethodParametersCollection();
    string[] metricNames = new string[] { "ClusterNode.Cpu.Usage,ClusterNode=RRN44-13-01", "ClusterNode.Cpu.Usage.Host,ClusterNode=RRN44-13-01" };
    MetricsParams.Add(CimMethodParameter.Create("MetricName", metricNames, CimType.StringArray, CimFlags.In));
    MetricsParams.Add(CimMethodParameter.Create("StreamName", "LastHour", CimType.String, CimFlags.In));

    // Enable WMI Streaming
    CimOperationOptions Options = new CimOperationOptions();
    Options.EnableMethodResultStreaming = true;
    // Invoke API
    CimAsyncMultipleResults<CimMethodResultBase> InvokeHandler;
    InvokeHandler = Session.InvokeMethodAsync(
        HealthService.CimSystemProperties.Namespace, HealthService, "GetMetric", MetricsParams, Options
        );
    // Subscribe the Observer
    MetricsObserver<CimMethodResultBase> Observer = new MetricsObserver<CimMethodResultBase>(this);
    IDisposable Disposeable = InvokeHandler.Subscribe(Observer);
}
```

These metrics can be visualized, stored in a database, or used in whatever way you see fit.

## Additional references
- [Performance history for Storage Spaces Direct](/windows-server/storage/storage-spaces/performance-history)
