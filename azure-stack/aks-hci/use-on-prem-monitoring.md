---
title: Monitor Azure Kubernetes Service on Azure Stack HCI clusters using on-premises monitoring
description: Monitor data for Azure Kubernetes Service on Azure Stack HCI clusters using on-premises monitoring
author: v-susbo
ms.topic: how-to
ms.date: 06/10/2021
ms.author: subharg
ms.reviewer: 
---

# Use on-premises monitoring for AKS on Azure Stack HCI

Monitoring the health, performance, and resource usage of the control plane nodes and workloads on your cluster is crucial when running apps in production. The recommended monitoring solution includes the following two tools:

- **Prometheus** is a monitoring and alerting toolkit you can use for monitoring containerized workloads. Prometheus works with different types of collectors and agents to collect metrics and store them in a database where you can query the data and view reports. AKS on Azure Stack HCI makes it easy to deploy Prometheus, which is described later in this topic.

- [**Grafana**](https://github.com/grafana/grafana) is a tool used to view, query, and visualize metrics on the Grafana dashboards. You can also configure Grafana to use Prometheus as the data source. You must have your own licensed copy of Grafana to use it with AKS on Azure Stack HCI.

## Monitoring solution overview

As part of Prometheus solution in AKS on Azure Stack HCI, the following components are deployed and automatically configured:

- [Prometheus operator](https://github.com/prometheus-operator/prometheus-operator)
- [Prometheus](https://github.com/prometheus/prometheus)
- [Kube state metrics](https://github.com/kubernetes/kube-state-metrics)
- [Node exporter](https://github.com/prometheus/node_exporter)
- [Windows exporter](https://github.com/prometheus-community/windows_exporter)

The deployment is based on the publicly available [Kube-Prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) helm chart that is extended to support the Windows exporter and secures metrics scraping between Prometheus and agents. Once deployed, the Node exporter runs on each Linux node, and the Windows exporter runs on each Windows node.

> [!NOTE]
> Since the Prometheus operator, Prometheus, and Kube state metrics components are only supported on Linux, you must provision at least one Linux node in your AKS on Azure Stack HCI cluster to deploy this solution. 

The objects and endpoints that the Prometheus solution scrapes include the following items:

- Kube state metrics to collect [various metrics provided by Kubernetes](https://github.com/kubernetes/kube-state-metrics/tree/master/docs#exposed-metrics) 
- Kubernetes API server
- Kubelet
- Node exporter to collect metrics for Linux nodes
- Windows exporter to collect metrics for Windows nodes

To view the Grafana dashboards available in AKS on Azure Stack HCI, see this [GitHub page](https://github.com/microsoft/AKS-HCI-Apps/blob/main/Monitoring/Grafana.md#grafana-dashboards-available-in-aks-hci).

## Deploy the monitoring solution using PowerShell

This section describes the two options you can use to deploy monitoring on a workload cluster.

### Option one: Deploy the monitoring solution when the workload cluster is created.

To enable monitoring, provide the `-enableMonitoring` parameter when creating the workload cluster using [New-AksHciCluster](./new-akshcicluster.md) as shown in the following example:

```powershell
New-AksHciCluster -name mynewcluster -enableMonitoring
```

Monitoring is installed with the following default configuration:

- The size of the persistent volume that's provisioned to store metrics (`storageSizeGB`) is 100 GB.
- The retention time for collected metrics (`retentionTimeHours`) is 240 hours (or 10 days).

### Option two: Deploy the monitoring solution on an existing workload cluster 

Run the [Install-AksHciMonitoring](./install-akshcimonitoring.md) command to deploy the monitoring solution on an existing workload cluster:

```powershell
Install-AksHciMonitoring -Name <target cluster name > -storageSizeGB -retentionTimeHours
```

> [!NOTE]
> `-storageSizeGB` is the size of the persistent volume that's provisioned to store metrics, and `-retentionTimeHours` is the amount of time the collected metrics is retained.

Note that the monitoring solution is installed in a separate namespace called _monitoring_ and uses a StorageClass called _monitoring-sc_. Prometheus is exposed on an internal endpoint that is accessible only within the cluster at http://akshci-monitoring-prometheus-svc.monitoring:9090.

## Uninstall the monitoring solution using PowerShell

Run the `Uninstall-AksHciMonitoring` PowerShell command to uninstall the monitoring solution:

```powershell  
Uninstall-AksHciMonitoring -Name <target cluster name>
```

The uninstall process removes everything including the namespace, StorageClass, and the actual data and metrics of the persistent volume.  

## Deploy Grafana and configure it to use Prometheus

You have the option to follow any guidance for deploying Grafana that's publicly available. You can also view deployment guidance on this [GitHub page](https://github.com/microsoft/AKS-HCI-Apps/blob/main/Monitoring/Grafana.md) which details how to deploy and configure Grafana to connect it to an AKS on Azure Stack HCI Prometheus instance. This GitHub page also describes how to add Grafana dashboards that we have available for AKS on Azure Stack HCI.

## Next steps
- [View logs to collect and review data](./view-logs.md)
- [Get kubelet logs from cluster nodes](./get-kubelet-logs.md)