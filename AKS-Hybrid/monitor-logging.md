---
title: Monitoring and logging data in AKS hybrid
description: Learn how to create and access monitor and logging data for Azure Kubernetes Service (AKS) in AKS hybrid.
author: sethmanheim
ms.topic: how-to
ms.date: 10/24/2022
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: abha

# Intent: As an IT Pro, I want to learn how to monitor and view logging data for AKS.
# Keyword: monitor and logging data, Prometheus

---

# Monitoring and logging data in AKS hybrid

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

This article describes how to monitor your Azure Kubernetes Service (AKS) deployment and collect logging data in AKS hybrid. You'll learn how to set up and access on-premises monitoring using `Prometheus` and `Graphana`, and how to collect and view logs using `Elasticsearch`, `Fluent Bit`, and `Kibana` (EFK).

Two types of monitoring and logging solutions are available, as described in the following table. 

| Solution  | Azure connectivity  | Support and service  | Cost | Deployment |
| ------- |  ------------  | ---------  | --------------  | ---------------- |
| Azure Monitor | Requires connecting the AKS cluster to Azure using Azure Arc for Kubernetes. | Full support and servicing from Microsoft. | Requires signing up for the Azure Monitor service. |  Use Azure Arc for [monitoring clusters](/azure/azure-monitor/containers/container-insights-enable-arc-enabled-clusters?toc=/azure/azure-arc/kubernetes/toc.json). |
| On-premises monitoring and logging | Doesn't require Azure connectivity. | Supported as open-source software by Microsoft (with no support agreement or SLAs), the community, and/or external vendors.  | Vendor-dependent. | Customer-driven. See [Monitor clusters using on-premises monitoring](#use-on-premises-monitoring). |

To use Azure Monitor with AKS clusters, see the [Azure Monitor overview](/azure/azure-monitor/containers/container-insights-overview). 

## Use on-premises monitoring

It's crucial that you monitor the health, performance, and resource usage of the control plane nodes and workloads on your cluster when running apps in production. The recommended monitoring solution includes the following two tools:

- **Prometheus** is a monitoring and alerting toolkit you can use for monitoring containerized workloads. Prometheus works with different types of collectors and agents to collect metrics and store them in a database where you can query the data and view reports. AKS hybrid makes it easy to deploy Prometheus, which is described later in this topic.

- [**Grafana**](https://github.com/grafana/grafana) is a tool used to view, query, and visualize metrics on the Grafana dashboards. You can also configure Grafana to use Prometheus as the data source. You must have your own licensed copy of Grafana with AKS hybrid.

## Monitoring solution overview

As part of Prometheus solution in AKS hybrid, the following components are deployed and automatically configured:

- [Prometheus operator](https://github.com/prometheus-operator/prometheus-operator)
- [Prometheus](https://github.com/prometheus/prometheus)
- [Kube state metrics](https://github.com/kubernetes/kube-state-metrics)
- [Node exporter](https://github.com/prometheus/node_exporter)
- [Windows exporter](https://github.com/prometheus-community/windows_exporter)

The deployment is based on the publicly available [Kube-Prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) helm chart, which is extended to support the Windows exporter and secures metrics scraping between Prometheus and agents. Once the Prometheus solution is deployed, the Node exporter runs on each Linux node, and the Windows exporter runs on each Windows node.

> [!NOTE]
> Since the Prometheus operator, Prometheus, and Kube state metrics components are only supported on Linux, you must provision at least one Linux node in your AKS cluster to deploy this solution. 

The objects and endpoints that the Prometheus solution scrapes include the following items:

- Kube state metrics to collect [various metrics provided by Kubernetes](https://github.com/kubernetes/kube-state-metrics/tree/master/docs#exposed-metrics) 
- Kubernetes API server
- Kubelet
- Node exporter to collect metrics for Linux nodes
- Windows exporter to collect metrics for Windows nodes

To view the Grafana dashboards available in AKS hybrid, see [Grafana dashboards available in AKS hybrid](https://github.com/microsoft/AKS-HCI-Apps/blob/main/Monitoring/Grafana.md#grafana-dashboards-available-in-aks-hci).

## Deploy monitoring solution using PowerShell

This section describes the two options you can use to deploy monitoring on a workload cluster.

### Option 1: Deploy the monitoring solution when creating the workload cluster

To enable monitoring, provide the `-enableMonitoring` parameter when you use [New-AksHciCluster](./reference/ps/new-akshcicluster.md) to create the workload cluster, as shown in the following example:

```powershell
New-AksHciCluster -name mynewcluster -enableMonitoring
```

Monitoring is installed with the following default configuration:

- The size of the persistent volume that's provisioned to store metrics (`storageSizeGB`) is 100 GB.
- The retention time for collected metrics (`retentionTimeHours`) is 240 hours (or 10 days).

### Option 2: Deploy the monitoring solution on an existing workload cluster 

Run the [Install-AksHciMonitoring](./reference/ps/install-akshcimonitoring.md) command to deploy the monitoring solution on an existing workload cluster, as shown below:

```powershell
Install-AksHciMonitoring -Name mycluster -storageSizeGB 100 -retentionTimeHours 240
```

The `-storageSizeGB` parameter sets the size of the persistent volume that's provisioned to store metrics, and the `-retentionTimeHours` parameter sets the amount of time the collected metrics are retained.

The monitoring solution is installed in a separate namespace called _monitoring_ and uses a StorageClass called _monitoring-sc_. Prometheus is exposed on an internal endpoint that is accessible only within the cluster at `http://akshci-monitoring-prometheus-svc.monitoring:9090`.

## Uninstall monitoring solution using PowerShell

Run the `Uninstall-AksHciMonitoring` PowerShell command to uninstall the AKS hybrid monitoring solution, as shown below:

```powershell  
Uninstall-AksHciMonitoring -Name <target cluster name>
```

The uninstall process removes everything, including the namespace, the StorageClass, and the actual data and metrics of the persistent volume.  

## Deploy Grafana, and configure it to use Prometheus

You can follow any guidance for deploying Grafana that's publicly available. You can also view Microsoft's deployment guidance to [use Grafana](https://github.com/microsoft/AKS-HCI-Apps/blob/main/Monitoring/Grafana.md), which details how to deploy and configure Grafana to connect it to an AKS Prometheus instance. This GitHub page also describes how to add Grafana dashboards that Microsoft makes available for AKS hybrid.

## On-premises logging

Logging is crucial for troubleshooting and diagnostics. The logging solution in AKS hybrid is based on Elasticsearch, Fluent Bit, and Kibana (EFK). These components are all deployed as containers: 

- Fluent Bit is the log processor and forwarder that collects data and logs from different sources. It then formats, unifies, and stores them in Elasticsearch. 
- Elasticsearch is a distributed search and analytics engine capable of centrally storing the logs for fast searches and data analytics.  
- Kibana provides interactive visualizations on a web dashboard. This tool lets you view and query logs stored in Elasticsearch, and then you can visualize them through graphs and dashboards.

To set up an on-premises logging solution, see the steps to [set up logging to access Kibana](https://github.com/microsoft/AKS-HCI-Apps/tree/main/Logging#easy-steps-to-setup-logging-to-use-local-port-forward-to-access-kibana). This article includes all the components required to collect, aggregate, and query container logs across the cluster. 

For advanced configuration steps, see [Windows logging](https://github.com/microsoft/AKS-HCI-Apps/tree/main/Logging#detailed-steps-to-setup-logging).

## Next steps

- [Deploy a Linux application on a Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows Server application on a Kubernetes cluster](./deploy-windows-application.md).
- [Kubernetes core concepts](kubernetes-concepts.md).
