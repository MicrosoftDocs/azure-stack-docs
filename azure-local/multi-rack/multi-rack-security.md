---
title: Security Overview for Multi-rack Deployments of Azure Local (preview)
description: Read an overview of security features for multi-rack deployments of Azure Local (preview).
author: sipastak
ms.author: sipastak
ms.service: azure-local
ms.topic: concept-article
ms.date: 12/19/2025
---

# Security concepts for multi-rack deployments of Azure Local (preview)

This article provides an overview of security for multi-rack deployments of Azure Local.

Multi-rack deployments of Azure Local are designed and built to detect and defend against the latest security threats. These deployments also comply with the strict requirements of government and industry security standards. The security posture of Azure Local is based on the following two principles:

* **Security by default**: The platform inherently includes security resiliency with few or no configuration changes needed to use it securely.
* **Assume breach**: Assume that any system can be compromised. Minimize the impact if a security breach occurs.

Use Microsoft cloud-native security tools to improve your cloud security posture and protect your workloads.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Platform-wide protection via Microsoft Defender for Cloud

[Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) is a cloud-native application protection platform (CNAPP). It helps you secure your resources, manage your security posture, protect against cyberattacks, and simplify security management. Key features include:

* **Vulnerability assessment**: Scan your VMs and container registries to find security weaknesses. You can view and fix these problems directly in Defender for Cloud.
* **Hybrid cloud security**: See security status across both on-premises and cloud workloads in one place. Apply security policies to ensure your hybrid environment meets security standards. Collect and analyze security data from firewalls and other sources.
* **Threat protection alerts**: Get alerts when attacks are detected. The system uses behavioral analytics and machine learning to identify attacks and zero-day exploits. Monitor your networks, machines, storage, and cloud services for threats. Use investigation tools to understand and respond to attacks.
* **Compliance assessment**: Defender for Cloud checks your environment against security standards like Azure Security Benchmark. You can also track compliance with industry standards and regulatory requirements. View your compliance status in the regulatory compliance dashboard.
* **Container security**: Protect your containerized environments with vulnerability scanning and real-time threat detection.

Enhanced security options let you protect your on-premises host servers (also referred to as bare-metal machines) as well as the Azure Local clusters that run your workloads. These options are described in the following sections.

## Bare metal machine host operating system protection via Microsoft Defender for Endpoint

When you enable the [Microsoft Defender for Endpoint](/microsoft-365/security/defender-endpoint/microsoft-defender-endpoint), it protects the on-premises servers (bare-metal machines or BMMs). Defender for Endpoint provides preventative antivirus (AV), endpoint detection and response (EDR), and vulnerability management capabilities.

To enable Defender for Endpoint, first activate a [Microsoft Defender for Servers](/azure/defender-for-cloud/tutorial-enable-servers-plan) plan. The platform automatically manages the configuration for optimal security and performance.

## Azure Local cluster workload protection via Microsoft Defender for Containers

[Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) protects Azure Local clusters by providing threat detection for clusters and Linux nodes, and by hardening against misconfigurations. Enable Defender for Containers by activating the plan in Defender for Cloud.

## Cloud security is a shared responsibility

In a cloud environment, you and the cloud provider share responsibility for security. The responsibilities vary depending on the type of cloud service your workloads run on, whether it's Software as a Service (SaaS), Platform as a Service (PaaS), or Infrastructure as a Service (IaaS). Responsibilities also vary based on where you host the workloads – within the cloud provider’s or your own on-premises locations.

Multi-rack deployments run on your on-premises infrastructure, so you control changes to your on-premises environment. Microsoft periodically makes new platform releases available that contain security and other updates. You must decide when to apply these releases to your environment based on your organization’s business needs.

## Kubernetes security benchmark scanning

To scan for security compliance, use the following industry standard security benchmarking tools:

- [OpenSCAP](https://public.cyber.mil/stigs/scap/) to evaluate compliance with Kubernetes Security Technical Implementation Guide (STIG) controls.
- Aqua Security’s [Kube-Bench](https://github.com/aquasecurity/kube-bench/tree/main) to evaluate compliance with the Center for Internet Security (CIS) Kubernetes Benchmarks.

Some controls aren't technically feasible to implement in multi-rack deployments. The excepted controls are documented in the following sections for the applicable layers.

These tools don't evaluate environmental controls such as RBAC and Service Account tests, as the outcomes might differ based on customer requirements.

### OpenSCAP STIG - V2R2

The status of excepted controls is referred to as **Not Technically Feasible** or NTF.

*Cluster*

:::image type="content" source="media/multi-rack-security-overview/multi-rack-cluster-exceptions.png" alt-text="Screenshot of Cluster OpenSCAP exceptions." lightbox="media/multi-rack-security-overview/multi-rack-cluster-exceptions.png":::

|STIG ID|Recommendation description|Status|Issue|
|---|---|---|---|
|V-242386|The Kubernetes API server must have the insecure port flag disabled.|NTF|This check is deprecated in v1.24.0 and greater.|
|V-242397|The Kubernetes kubelet staticPodPath must not enable static pods.|NTF|Only enabled for control nodes, required for kubeadm.|
|V-242403|Kubernetes API Server must generate audit records that identify what type of event occurred, identify the source of the event, contain the event results, identify any users, and identify any containers associated with the event.|NTF|Certain API requests and responses contain secrets and therefore aren't captured in the audit logs.|
|V-242424|Kubernetes Kubelet must enable tlsPrivateKeyFile for client authentication to secure service.|NTF|Kubelet SANs contains hostname only.|
|V-242425|Kubernetes Kubelet must enable tlsCertFile for client authentication to secure service.|NTF|Kubelet SANs contains hostname only.|
|V-242434|Kubernetes Kubelet must enable kernel protection.|NTF|Enabling kernel protection isn't feasible for kubeadm in multi-rack deployments.|

*Cluster Manager*

The cluster manager uses Azure Kubernetes service (AKS). As a secure service, AKS complies with SOC, ISO, PCI DSS, and HIPAA standards. The following image shows the OpenSCAP file permission exceptions for the Cluster Manager using AKS.

:::image type="content" source="media/multi-rack-security-overview/multi-rack-cluster-manager-exceptions.png" alt-text="Screenshot of Cluster Manager OpenSCAP exceptions." lightbox="media/multi-rack-security-overview/multi-rack-cluster-manager-exceptions.png":::


### Aquasec Kube-Bench - CIS 1.9

The status of excepted controls is referred to as **Not Technically Feasible** or NTF.

*Cluster*

:::image type="content" source="media/multi-rack-security-overview/multi-rack-cluster-kube-bench.png" alt-text="Screenshot of Cluster Kube-Bench exceptions." lightbox="media/multi-rack-security-overview/multi-rack-cluster-kube-bench.png":::

|CIS ID|Recommendation description|Status|Issue|
|---|---|---|---|
|1|Control Plane Components|||
|1.1|Control Plane Node Configuration Files|||
|1.1.12|Ensure that the etcd data directory ownership is set to `etcd:etcd`.|NTF|Multi-rack is `root:root`, etcd user isn't configured for kubeadm.|
|1.2|API Server|||
|1.1.12|Ensure that the `--kubelet-certificate-authority` argument is set as appropriate.|NTF|Kubelet SANs includes hostname only.|

*Cluster Manager*

The following image shows the Kube-Bench exceptions for the Cluster Manager. See a [Full report of CIS Benchmark control evaluation](/azure/aks/cis-kubernetes) for Azure Kubernetes Service (AKS).

:::image type="content" source="media/multi-rack-security-overview/multi-rack-cluster-manager-kube-bench.png" alt-text="Screenshot of Cluster Manager Kube-Bench exceptions." lightbox="media/multi-rack-security-overview/multi-rack-cluster-manager-kube-bench.png":::

## Encryption-at-rest

Multi-rack deployments provide persistent storage for virtualized and containerized workloads. Data is stored and encrypted-at-rest on the SAN storage in the aggregation rack.

Azure Local clusters and Azure Local VMs consume storage from a local disk. Data stored on local disks is encrypted by using LUKS2 with the AES256-bit algorithm in XTS mode. All encryption keys are platform managed.

