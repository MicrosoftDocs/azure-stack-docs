---
title: Security Overview for Multi-rack Deployments of Azure Local (preview)
description: Security overview for multi-rack deployments of Azure Local (preview).
author: sipastak
ms.author: sipastak
ms.service: azure-local
ms.topic: conceptual
ms.date: 12/02/2025
---

# Security concepts for multi-rack deployments of Azure Local

This article provides an overview of security for multi-rack deployments of Azure Local. 

Multi-rack deployments of Azure Local are designed and built to both detect and defend against the latest security threats and comply with the strict requirements of government industry security standards. Two cornerstones form the foundation of its security architecture:

* **Security by default**: Security resiliency is an inherent part of the platform with little to no configuration changes needed to use it securely.
* **Assume breach**: The underlying assumption is that any system can be compromised, and as such the goal is to minimize the impact of a security breach if one occurs.

Microsoft cloud-native security tools are leveraged to give you the ability to improve your cloud security posture while allowing you to protect your workloads.

## Platform-wide protection via Microsoft Defender for Cloud

[Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) is a cloud-native application protection platform (CNAPP) that provides the security capabilities needed to harden your resources, manage your security posture, protect against cyberattacks, and streamline security management. These are some of the key features of Microsoft Defender for Cloud:

* **Vulnerability assessment for virtual machines (VMs) and container registries**: Easily enable vulnerability assessment solutions to discover, manage, and resolve vulnerabilities. View, investigate, and remediate the findings directly from within Defender for Cloud.
* **Hybrid cloud security**: Get a unified view of security across all your on-premises and cloud workloads. Apply security policies and continuously assess the security of your hybrid cloud workloads to ensure compliance with security standards. Collect, search, and analyze security data from multiple sources, including firewalls and other partner solutions.
* **Threat protection alerts**: Advanced behavioral analytics and the Microsoft Intelligent Security Graph provide an edge over evolving cyberattacks. Built-in behavioral analytics and machine learning can identify attacks and zero-day exploits. Monitor networks, machines, Azure Storage and cloud services for incoming attacks and post-breach activity. Streamline investigation with interactive tools and contextual threat intelligence.
* **Compliance assessment against a variety of security standards**: Defender for Cloud continuously assesses your hybrid cloud environment to analyze the risk factors according to the controls and best practices in Azure Security Benchmark. When you enable the advanced security features, you can apply a range of other industry standards, regulatory standards, and benchmarks according to your organization’s needs. Add standards and track your compliance with them from the regulatory compliance dashboard.
* **Container security features**: Benefit from vulnerability management and real-time threat protection on your containerized environments.

There are enhanced security options that let you protect your on-premises host servers as well as the Azure Local clusters that run your workloads. These options are described below.

## Bare metal machine host operating system protection via Microsoft Defender for Endpoint

The on-premises compute servers, also called bare-metal machines (BMMs), are protected when you elect to enable the [Microsoft Defender for Endpoint](/microsoft-365/security/defender-endpoint/microsoft-defender-endpoint) solution. Microsoft Defender for Endpoint provides preventative antivirus (AV), endpoint detection and response (EDR), and vulnerability management capabilities.

You have the option to enable Microsoft Defender for Endpoint protection once you have selected and activated a [Microsoft Defender for Servers](/azure/defender-for-cloud/tutorial-enable-servers-plan) plan, as Defender for Servers plan activation is a prerequisite for Microsoft Defender for Endpoint. Once enabled, the Microsoft Defender for Endpoint configuration is managed by the platform to ensure optimal security and performance, and to reduce the risk of misconfigurations.

## Azure Local cluster workload protection via Microsoft Defender for Containers

On-premises Azure Local clusters that run your workloads are protected when you elect to enable the Microsoft Defender for Containers solution. [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) provides run-time threat protection for clusters and Linux nodes as well as cluster environment hardening against misconfigurations.

You have the option to enable Defender for Containers protection within Defender for Cloud by activating the Defender for Containers plan.

## Cloud security is a shared responsibility

It's important to understand that in a cloud environment, security is a [shared responsibility](/azure/security/fundamentals/shared-responsibility) between you and the cloud provider. The responsibilities vary depending on the type of cloud service your workloads run on, whether it's Software as a Service (SaaS), Platform as a Service (PaaS), or Infrastructure as a Service (IaaS), as well as where the workloads are hosted – within the cloud provider’s or your own on-premises datacenters.

Multi-rack deployments run on your on-premises infrastructure, so you're in control of changes to your on-premises environment. Microsoft periodically makes new platform releases available that contain security and other updates. You must then decide when to apply these releases to your environment as appropriate for your organization’s business needs.

## Kubernetes Security Benchmark Scanning

Industry standard security benchmarking tools are used to scan for security compliance. These tools include [OpenSCAP](https://public.cyber.mil/stigs/scap/), to evaluate compliance with Kubernetes Security Technical Implementation Guide (STIG) controls, and Aqua Security’s [Kube-Bench](https://github.com/aquasecurity/kube-bench/tree/main), to evaluate compliance with the Center for Internet Security (CIS) Kubernetes Benchmarks.

Some controls aren't technically feasible to implement in multi-rack deployments, and these excepted controls are documented below for the applicable layers.

Environmental controls such as RBAC and Service Account tests aren't evaluated by these tools, as the outcomes may differ based on customer requirements.

**NTF = Not Technically Feasible**

### OpenSCAP STIG - V2R2

*Cluster*

:::image type="content" source="media/multi-rack-security-overview/multi-rack-cluster-exceptions.png" alt-text="Screenshot of Cluster OpenSCAP exceptions." lightbox="media/multi-rack-security-overview/multi-rack-cluster-exceptions.png":::

|STIG ID|Recommendation description|Status|Issue|
|---|---|---|---|
|V-242386|The Kubernetes API server must have the insecure port flag disabled|NTF|This check is deprecated in v1.24.0 and greater|
|V-242397|The Kubernetes kubelet staticPodPath must not enable static pods|NTF|Only enabled for control nodes, required for kubeadm|
|V-242403|Kubernetes API Server must generate audit records that identify what type of event has occurred, identify the source of the event, contain the event results, identify any users, and identify any containers associated with the event|NTF|Certain API requests and responses contain secrets and therefore aren't captured in the audit logs|
|V-242424|Kubernetes Kubelet must enable tlsPrivateKeyFile for client authentication to secure service|NTF|Kubelet SANs contains hostname only|
|V-242425|Kubernetes Kubelet must enable tlsCertFile for client authentication to secure service.|NTF|Kubelet SANs contains hostname only|
|V-242434|Kubernetes Kubelet must enable kernel protection.|NTF|Enabling kernel protection isn't feasible for kubeadm in multi-rack deployments|


*Multi-rack Kubernetes Cluster*

:::image type="content" source="media/multi-rack-security-overview/multi-rack-kubernetes-cluster-exceptions.png" alt-text="Screenshot of multi-rack Kubernetes Cluster OpenSCAP exceptions." lightbox="media/multi-rack-security-overview/multi-rack-kubernetes-cluster-exceptions.png":::

|STIG ID|Recommendation description|Status|Issue|
|---|---|---|---|
|V-242386|The Kubernetes API server must have the insecure port flag disabled|NTF|This check is deprecated in v1.24.0 and greater|
|V-242397|The Kubernetes kubelet staticPodPath must not enable static pods|NTF|Only enabled for control nodes, required for kubeadm|
|V-242403|Kubernetes API Server must generate audit records that identify what type of event has occurred, identify the source of the event, contain the event results, identify any users, and identify any containers associated with the event|NTF|Certain API requests and responses contain secrets and therefore aren't captured in the audit logs|
|V-242424|Kubernetes Kubelet must enable tlsPrivateKeyFile for client authentication to secure service|NTF|Kubelet SANs contains hostname only|
|V-242425|Kubernetes Kubelet must enable tlsCertFile for client authentication to secure service.|NTF|Kubelet SANs contains hostname only|
|V-242434|Kubernetes Kubelet must enable kernel protection.|NTF|Enabling kernel protection isn't feasible for kubeadm in multi-rack deployments|


*Cluster Manager*

As a secure service, Azure Kubernetes Service (AKS) complies with SOC, ISO, PCI DSS, and HIPAA standards. The following image shows the OpenSCAP file permission exceptions for the Cluster Manager using AKS.

:::image type="content" source="media/multi-rack-security-overview/multi-rack-cluster-manager-exceptions.png" alt-text="Screenshot of Cluster Manager OpenSCAP exceptions." lightbox="media/multi-rack-security-overview/multi-rack-cluster-manager-exceptions.png":::


### Aquasec Kube-Bench - CIS 1.9

*Cluster*

:::image type="content" source="media/multi-rack-security-overview/multi-rack-cluster-kube-bench.png" alt-text="Screenshot of Cluster Kube-Bench exceptions." lightbox="media/multi-rack-security-overview/multi-rack-cluster-kube-bench.png":::

|CIS ID|Recommendation description|Status|Issue|
|---|---|---|---|
|1|Control Plane Components|||
|1.1|Control Plane Node Configuration Files|||
|1.1.12|Ensure that the etcd data directory ownership is set to `etcd:etcd`|NTF|Multi-rack is `root:root`, etcd user isn't configured for kubeadm|
|1.2|API Server|||
|1.1.12|Ensure that the `--kubelet-certificate-authority` argument is set as appropriate|NTF|Kubelet SANs includes hostname only|


*Multi-rack Kubernetes Cluster*

:::image type="content" source="media/multi-rack-security-overview/multi-rack-kubernetes-cluster-kube-bench.png" alt-text="Screenshot of Multi-rack Kubernetes Cluster Kube-Bench exceptions." lightbox="media/multi-rack-security-overview/multi-rack-kubernetes-cluster-kube-bench.png":::

|CIS ID|Recommendation description|Status|Issue|
|---|---|---|---|
|1|Control Plane Components|||
|1.1|Control Plane Node Configuration Files|||
|1.1.12|Ensure that the etcd data directory ownership is set to `etcd:etcd`|NTF|Multi-rack is `root:root`, etcd user isn't configured for kubeadm|
|1.2|API Server|||
|1.1.12|Ensure that the `--kubelet-certificate-authority` argument is set as appropriate|NTF|Kubelet SANs includes hostname only|

*Cluster Manager*

The Cluster Manager is an AKS implementation. The following image shows the Kube-Bench exceptions for the Cluster Manager. A full report of CIS Benchmark control evaluation for Azure Kubernetes Service (AKS) can be found [here](/azure/aks/cis-kubernetes)

:::image type="content" source="media/multi-rack-security-overview/multi-rack-cluster-manager-kube-bench.png" alt-text="Screenshot of Cluster Manager Kube-Bench exceptions." lightbox="media/multi-rack-security-overview/multi-rack-cluster-manager-kube-bench.png":::

## Encryption at rest

Multi-rack deployments provide persistent storage for virtualized and containerized workloads. Data is stored and encrypted at rest on the storage appliances in the aggregation rack.

Azure Local clusters and Azure Local VMs consume storage from a local disk. Data stored on local disks is encrypted using LUKS2 with the AES256 bit algorithm in XTS mode. All encryption keys are platform managed.