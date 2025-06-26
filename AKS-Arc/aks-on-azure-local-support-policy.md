---
title: Support Policies for AKS on Azure Local
description: Learn about technical support policies, limitations, shared responsibilities, and version support for Azure Kubernetes Service (AKS) on Azure Local clusters.
author: sethmanheim
contributors: sethm
ms.topic: concept-article
ms.date: 06/26/2025
ms.author: sethm
ms.reviewer: sumsmith
---

# Support policies for AKS on Azure Local

This article provides details about technical support policies and limitations for AKS on Azure Local.

## Service updates and releases

AKS on Azure Local adheres to the Kubernetes support calendar and releases Kubernetes versions to ensure AKS on Azure Local customers can always operate on a supported version of Kubernetes.

A Kubernetes cluster that operates on a deprecated minor version must be updated to a supported version to be eligible for support. Once a minor version is deprecated, any Kubernetes clusters still running on this version continue to function. You can still perform operations such as scaling up or down.

Once a minor version is deprecated, it's removed from the Microsoft servers. At that point, Kubernetes clusters using this version are unable to update Kubernetes or OS versions and must be upgraded to the latest release. In some cases, this upgrade can also mean full re-deployment if the system is not in a healthy state.

For release information, see the [AKS on Azure Local release notes.](/azure/aks/aksarc/aks-whats-new-23h2)

## Managed features in AKS Arc

As an AKS on Azure Local user, you have limited customization and deployment options. However, you don't need to worry about or manage the Kubernetes cluster control plane and installation directly. Base infrastructure-as-a-service (IaaS) cloud components, such as compute or networking components, allow you access to low-level controls and customization options.

By contrast, AKS Arc provides a turnkey Kubernetes deployment that gives you the common set of configurations and capabilities you need for your cluster. With AKS Arc, you get a partially managed control plane. The control plane contains all of the components and services you need to operate and provide Kubernetes clusters to end users. Microsoft maintains all Kubernetes components.

Microsoft maintains the following components through the Arc Resource Bridge and the associated virtual machine base images for AKS Arc clusters:

- kubelet or Kubernetes API servers.
- etcd or a compatible key-value store, providing Quality of Service (QoS), scalability, and runtime.
- DNS services (for example, kube-dns or CoreDNS).
- Kubernetes proxy or networking.
- Any other add-on or system component running in the kube-system namespace.

AKS Arc isn't a Platform-as-a-Service (PaaS) solution, and AKS clusters on Azure Local have shared responsibility. Users must help maintain the Kubernetes cluster. User input is required, for example, to apply an operating system (OS) security patch or update to a newer Kubernetes version.

The services are *managed* in the sense that Microsoft and the AKS team provide the tooling that deploys the Kubernetes components such as control plane nodes and nodepools for the AKS Arc clusters. Microsoft limits customization to ensure a consistent and scalable user experience.

## Supported version policy

Kubernetes versions in AKS Arc follow the [Kubernetes version policy](https://kubernetes.io/releases/version-skew-policy/).

AKS Arc doesn't make any runtime (or other) guarantees for clusters outside of the supported versions list. "Outside of support" means that:

Your cluster operates on a deprecated minor version. The version you're running is outside of the supported versions list.

You are asked to upgrade the cluster to a supported version when requesting support.

For information about the supported Kubernetes versions, see [Supported Kubernetes versions](supported-kubernetes-versions.md).

AKS Arc follows the platform version support timeframes for those products. That is, AKS Arc is not supported on unsupported versions of those products. For more information, see [Azure Local supported versions information](/azure/azure-local/release-information-23h2).

## Shared responsibility

When an AKS Arc cluster is created, you define the Kubernetes node pools that AKS Arc creates. Your workloads are executed on these node pools.

Because your node pools execute private code and store sensitive data, Microsoft Support has limited access to them. Microsoft Support can't sign in to execute commands on, or view logs for these nodes without your express permission or assistance. Any direct modification of the agent nodes by using any of the IaaS APIs renders the cluster unsupportable. Any modification done to the node pools must be done using Kubernetes-native mechanisms such as  Daemon Sets.

Similarly, while you can add any metadata, such as tags and labels, to the AKS Arc cluster and nodes, changing any of the system-created metadata renders the AKS Arc cluster unsupported.

## AKS Arc support coverage

Microsoft provides technical support for the following features and components:

- Connectivity to all Kubernetes components that the Kubernetes service provides and supports, such as the API server.
- Kubernetes control plane services (for example, Kubernetes control plane, API server, etcd, and coreDNS).
- Etcd data store.
- Integration with Azure Arc and Arc enabled Kubernetes extensions.
- Questions or issues about customization of control plane components such as the Kubernetes API server, etcd, and coreDNS.
- Issues with networking, network access, and functionality. Issues could include DNS resolution, packet loss, and routing.

Microsoft supports various networking scenarios:

- Basic installation support for Calico CNI. Calico CNI is community driven and supported. Microsoft Support provides only basic installation support.
- Connectivity to other Azure services and applications.
- Network performance and latency.

> [!NOTE]
> Any cluster actions taken by Microsoft AKS Arc support teams are made with user consent and assistance. Microsoft Support doesn't log into your AKS Arc cluster unless you configure access for the support engineer.

Microsoft doesn't provide technical support for questions about how to use Kubernetes. For example, Microsoft Support doesn't provide advice on:

- How to create custom ingress controllers
- Use application workloads
- Apply third-party or open-source software packages or tools.
- Third-party open-source projects that aren't provided as part of the Kubernetes control plane or deployed when AKS Arc clusters are created. These projects might include Istio, Helm, Envoy, or others.
- Third-party closed-source software. This software can include security scanning tools and networking devices or software.
- Network customizations other than the ones listed in the [AKS Arc documentation](aks-hci-network-system-requirements.md).

> [!NOTE]
> Microsoft Support can advise on cluster functionality, customization, and tuning in AKS Arc, for example, Kubernetes operations issues and procedures.

> [!NOTE]
> Microsoft can provide best-effort support for third-party open-source projects such as Helm. Where the third-party open-source tool integrates with Kubernetes or other AKS Arc-specific bugs, Microsoft supports examples and applications from Microsoft documentation.

## AKS Arc support coverage for node pools

### Microsoft responsibilities for AKS Arc node pools

Microsoft and users share responsibility for Kubernetes agent nodes where:

- The base OS image required additions (such as monitoring and networking agents).
- The agent nodes receive OS patches automatically.
- Issues with the Kubernetes control plane components that run on the agent nodes are automatically remediated during the update cycle or when you redeploy an agent node. These components include kube-proxy, etc.
- Networking tunnels that provide communication paths to the Kubernetes master components:
  - kubelet
  - ContainerD

> [!NOTE]
> If a node pool is not operational, AKS Arc might restart individual components or the entire node pool. These automated restart operations provide auto-remediation for common issues.

### Customer responsibilities for AKS Arc node pools

AKS Arc regularly releases new Kubernetes patches and minor versions. These updates can contain security or functionality improvements to Kubernetes. You're responsible for keeping your cluster's Kubernetes version and therefore node pool versions are updated according to the [AKS Arc supported versions policy.](/azure/aks/aksarc/aks-whats-new-23h2)

### User customization of node pools

> [!NOTE]
> AKS Arc agent nodes appear in Hyper-V as regular virtual machine resources. These virtual machines are deployed with a custom OS image, and supported and managed Kubernetes components. You cannot change the base OS image or do any direct customizations to these nodes using the Hyper-V APIs or resources. Any custom changes that are not done via the AKS Arc API do not persist through an upgrade, scale, update, or reboot, and can render the Kubernetes cluster unsupported. Avoid performing changes to the agent nodes unless Microsoft Support directs you to make changes.

AKS Arc manages the lifecycle and operations of node pool images on your behalf. Modifying the resources associated with the node pools is not supported. For example, customizing a virtual machine's network settings by manually changing configurations through the Hyper-V API or tools is not supported.

For Kubernetes workload-specific configurations or packages, you should use [Kubernetes daemon sets](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/).

When you use Kubernetes privileged daemon sets and init containers, you can tune/modify or install third-party software on cluster agent nodes. For example, you can add custom security scanning software or update sysctl settings. While this path is recommended if the previous requirements apply, AKS Arc engineering and support can't help with troubleshooting or diagnosing modifications that render the node unavailable because of a custom-deployed daemon set.

### Security issues and patching

If a security flaw is found in one or more of the managed components of AKS Arc, the AKS Arc team patches all affected OS images to mitigate the issue, and the team gives users upgrade guidance.

For node pools affected by a security flaw, Microsoft notifies you with details about the impact and the steps to fix or mitigate the security issue. Usually, the steps include a cluster patch upgrade.

### Node maintenance and access

Although you can sign into your Azure Local clusters change the node pool VMs, this operation is discouraged because changes can make an AKS Arc cluster unsupportable.

You can only customize network settings using AKS Arc defined logical networks. You can't customize network settings at the NIC level of the node pools. AKS Arc has egress requirements for specific endpoints, to control egress and ensure the necessary connectivity. For more information, see [AKS Arc system requirements](aks-hci-network-system-requirements.md).

## Stopped or disconnected AKS Arc clusters

As previously described, manually de-allocating all cluster nodes via the Hyper-V APIs, CLI, or MMC renders the cluster out of support.

Clusters that are stopped for more than 30 days can no longer be updated. The control planes for AKS Arc clusters in this state are out of support after 30 days, and they can't be updated to the latest Kubernetes version. For more information, see the [AKS Arc connectivity modes.](/azure/aks/aksarc/connectivity-modes)

## Deleted or suspended subscription

If your Azure subscription is suspended or deleted, your AKS cluster(s) are out of support after 60 days, unless the subscription is reinstated before the 60-day limit is reached. All other limitations described previously also apply. Once the subscription is deleted, the cluster connection to Azure cannot be recovered and Azure Local and AKS Arc must be re-deployed.

## Unsupported preview and beta Kubernetes features

AKS Arc only supports stable and beta features in the upstream Kubernetes project. Unless otherwise documented, AKS Arc doesn't support any preview feature that is available in the upstream Kubernetes project.

## Preview features or feature flags

For features and functionality that require extended testing and user feedback, Microsoft releases new preview features or features behind a feature flag. Consider these prerelease or beta features. Preview features or feature-flag features aren't meant for production. Ongoing changes in APIs and behavior, bug fixes, and other changes can result in unstable clusters and downtime.

Features in public preview receive "best effort" support, as these features are in preview and not meant for production. These features are supported by the AKS Arc technical support teams during business hours only. For more information, see the [Azure support FAQ](https://azure.microsoft.com/support/faq/).

## Upstream bugs and issues

Given the speed of development in the upstream Kubernetes project, bugs invariably arise. Some of these bugs can't be patched or worked around within the AKS Arc system. Instead, bug fixes require larger patches to upstream projects (such as Kubernetes, node or agent operating systems, and kernel). For components that Microsoft owns (such as the cluster API providers for Azure Local), AKS Arc and Azure personnel are committed to fixing issues upstream in the community.

When a technical support issue is root-caused by one or more upstream bugs, AKS Arc support and engineering teams will do the following:

- Identify and link the upstream bugs with any supporting details to help explain why this issue affects your cluster or workload. Customers receive links to the required repositories, so they can watch the issues and see when a new release will provide fixes.
- Provide potential workarounds or mitigation. If the issue can be mitigated, a [known issue is filed in the AKS on Azure Local and Windows Server repository](https://github.com/Azure/aksArc/issues?q=is%3Aopen+is%3Aissue+label%3Aknown-issue). The known-issue filing explains:
  - The issue, including links to upstream bugs.
  - The workaround and details about an upgrade or another option for the solution.
  - Rough timelines for the issue's inclusion, based on the upstream release cadence.

## Next steps

- [Open a support ticket](help-support.md)
- [Learn more about resource limits and scaling](concepts-support.md)
