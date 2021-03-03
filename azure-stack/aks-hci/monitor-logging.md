---
title: Monitor Azure Kubernetes Service on Azure Stack HCI clusters
description: Monitor and view logging data for Azure Kubernetes Service on Azure Stack HCI clusters
author: v-susbo
ms.topic: how-to
ms.date: 01/26/2021
ms.author: v-susbo
ms.reviewer: 
---

# Monitor AKS on Azure Stack HCI clusters

There are two types of monitoring and logging solutions available for AKS on Azure Stack HCI. Here’s a comparison of the two solutions: 

| Solution  | Azure connectivity  | Support and service  | Cost | Deployment |
| ------- |  ------------  | ---------  | --------------  | ---------------- |
| Azure Monitor | Requires connecting the AKS on Azure Stack HCI cluster to Azure using Azure Arc for Kubernetes | Fully supported and serviced by Microsoft | Requires signing up for Azure Monitor service |  Use Azure Arc for [monitoring clusters](#monitor-clusters-using-azure-monitor) |
| On-premises monitoring and logging | Does not require Azure connectivity | Supported as open-source software by Microsoft (no support agreement or SLAs), community and/or external vendors  | Vendor dependent | Customer driven, see [monitor clusters using on-premises monitoring](#monitor-clusters-using-on-premises-monitoring) |

## Monitor clusters using Azure Monitor
To use Azure Monitor with AKS on Azure Stack HCI clusters, follow the steps in the two topics below: 

- [Connect your cluster to Azure using Azure Arc for Kubernetes](./connect-to-arc.md)  
- [Enable Azure Monitor on an Azure Arc enabled Kubernetes cluster](https://docs.microsoft.com/azure/azure-monitor/insights/container-insights-enable-arc-enabled-clusters) 

## Monitor clusters using on-premises monitoring

Monitoring the health, performance, and resource usage of the control plane nodes and workloads on your cluster is crucial when running apps in production. To learn how to set up an on-premises monitoring solution, see [installing Prometheus and Grafana](https://github.com/microsoft/AKS-HCI-Apps/tree/main/Monitoring). This monitoring solution includes the following two tools: 

- **Prometheus** is a monitoring and alerting toolkit you can use for monitoring containerized workloads. Prometheus works with different types of collectors and agents to collect metrics and store them in a database that you can query and view reports. 

- **Grafana** is a tool used to view, query, and visualize metrics on the Grafana dashboards. It is pre-configured to use Prometheus as the data source. 

### Install monitoring tools

To quickly set up a simple monitoring solution in your environment, run the [Setup-Monitoring.ps1](https://github.com/microsoft/AKS-HCI-Apps/tree/main/Monitoring#easy-steps-to-setup-monitoring-to-use-local-port-forward-to-access-grafana) PowerShell script. The script includes all the configuration steps needed to get a monitoring solution up and running quickly. 

If you want to include an ingress controller with Grafana, follow the steps for [using an ingress controller to access Grafana](https://github.com/microsoft/AKS-HCI-Apps/tree/main/Monitoring#detailed-steps-to-setup-monitoring-to-use-ingress-controller-to-access-grafana). An ingress controller is software that provides reverse proxy, configurable traffic routing, and Transport Layer Security (TLS) termination for Kubernetes services.

### On-premises logging

Logging is crucial for troubleshooting and diagnostics. The logging solution in AKS on Azure Stack HCI is based on Elasticsearch, Fluent Bit, and Kibana (EFK). These components are all deployed as containers: 

- Fluent Bit is the log processor and forwarder which collects data and logs from different sources, and then formats, unifies, and stores them in Elasticsearch. 
- Elasticsearch is a distributed search and analytics engine capable of centrally storing the logs for fast searches and data analytics.  
- Kibana provides interactive visualizations in a web dashboard. This tool lets you view and query logs stored in Elasticsearch and then visualize them through graphs and dashboards.

To set up an on-premises logging solution, see these steps to [set up logging to access Kibana](https://github.com/microsoft/AKS-HCI-Apps/tree/main/Logging#easy-steps-to-setup-logging-to-use-local-port-forward-to-access-kibana). This article includes all the components required to collect, aggregate, and query container logs across the cluster. 

For advanced configuration steps, see [Windows logging](https://github.com/microsoft/AKS-HCI-Apps/tree/main/Logging#detailed-steps-to-setup-logging).

## Next steps

- [Deploy a Linux applications on a Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows Server application on a Kubernetes cluster](./deploy-windows-application.md).
- [Kubernetes core concepts](kubernetes-concepts.md).