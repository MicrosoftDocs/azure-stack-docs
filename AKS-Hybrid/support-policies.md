---
title: Support policies for AKS hybrid
description: Learn about AKS hybrid support policies, shared responsibility, and features that are in preview (or alpha or beta).
services: container-service
ms.topic: article
ms.date: 01/11/2022
author: sethmanheim
ms.author: sethm
ms.lastreviewed: 03/30/2022
ms.reviewer: mikek

# Customer intent: As a cluster operator or developer, I want to understand what AKS components I need to manage, what components are managed and supported by Microsoft (including security patches), and networking and preview features for AKS hybrid.
# Intent: As an IT Pro, I want to understand the support policies associated with my AKS deployment, including security patches, networking, and preview features in AKS hybrid.
# Keyword: support policies AKS technical support control plane service updates
---

# Support policies for AKS hybrid

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

This article provides details about technical support policies and limitations for AKS hybrid. [!INCLUDE [aks-hybrid-description](includes/aks-hybrid-description.md)]

This article also details management cluster node management, control plane components, third-party open-source components, and security or patch management.

## Service updates and releases

* For release information, see [AKS hybrid release notes](https://github.com/Azure/aks-hci/releases).<!--Verify release notes title. Older release notes will have the earlier product name?-->
* For information on features in preview, see [AKS hybrid preview features](https://github.com/Azure/aks-hci/tree/main/preview).<!--Verify topic title.-->

## Supported version policy

Versions for AKS hybrid are expressed as w.z.y.zzzz, where w is the major version, x is the minor version, y is the patch version, and zzzz is the build of the specific version, following Semantic Versioning terminology.

AKS hybrid maintains upgrade support for the three most recent [releases](https://github.com/Azure/aks-hci/releases).

Kubernetes versions in AKS hybrid follow the [Kubernetes version policy](https://kubernetes.io/releases/version-skew-policy/). For details on the supported Kubernetes versions, see [Supported Kubernetes versions](./supported-kubernetes-versions.md).

To keep your AKS hybrid environment in a supported state, we recommended that you stay within a 30-day window of the latest release and not fall behind more than 60 days from the latest update.

After 120 days, Microsoft can't guarantee that older versions of AKS hybrid are still available on the release servers for download. Scale operations, upgrades, reinstallations, and other operations in the cluster will start to fail, requiring that you redeploy your AKS hybrid environment with the latest version.

If your cluster falls behind more than 60 days (2 versions), you'll have to upgrade in multiple steps to get current again.

AKS on Azure Stack HCI and on Windows Server follow the platform version support timeframes for those products. That is, AKS is not supported on unsupported versions of those products. For more information, see their support policies:

* [Azure Stack HCI supported versions information](/hci/release-information#azure-stack-hci-release-summary)
* [Windows Server 2019 Datacenter and above supported versions](/windows-server/get-started/windows-server-release-info#windows-server-current-versions-by-servicing-option)

## Managed features in AKS hybrid

As an AKS on Azure Stack HCI user, you have limited customization and deployment options. In exchange, you don't need to worry about or manage Kubernetes cluster control plane and installation directly. Base infrastructure-as-a-service (IaaS) cloud components, such as compute or networking components, allow you access to low-level controls and customization options.

By contrast, AKS hybrid provides a turnkey Kubernetes deployment that gives you the common set of configurations and capabilities you need for your cluster. As an AKS hybrid user, you have limited customization and deployment options. In exchange, you don't need to worry about or manage Kubernetes cluster control plane and installation directly.

With AKS hybrid, you get a partially managed control plane. The *control plane* contains all of the components and services you need to operate and provide Kubernetes clusters to end users. All Kubernetes components are maintained by Microsoft.

Microsoft maintains the following components through the management cluster and the associated virtual machine base images:

* `kubelet` or Kubernetes API servers
* `etcd` or a compatible key-value store, providing Quality of Service (QoS), scalability, and runtime
* DNS services (for example, `kube-dns` or `CoreDNS`)
* Kubernetes proxy or networking
* Any additional add-on or system component running in the `kube-system` namespace

AKS hybrid isn't a Platform-as-a-Service (PaaS) solution. Some components, such as workload cluster, control plane, and worker nodes, have *shared responsibility*, where users must help maintain the AKS cluster. User input is required, for example, to apply an operating system (OS) security patch or update to a newer Kubernetes version.

The services are *managed* in the sense that Microsoft and the AKS hybrid team provide the tooling that deploys the management cluster, control plane, and agent nodes for workloads clusters. Customers can't alter these managed components. Microsoft limits customization to ensure a consistent and scalable user experience. For a fully customizable solution in the cloud, see [AKS Engine](https://github.com/Azure/aks-engine).

## Shared responsibility

When a cluster is created, you define the Kubernetes agent nodes that AKS hybrid creates. Your workloads are executed on these nodes.

Because your agent nodes execute private code and store sensitive data, Microsoft Support has limited access to them. Microsoft Support can't sign in to, execute commands on, or view logs for these nodes without your express permission or assistance.

Any direct modification of the agent nodes by using any of the IaaS APIs renders the cluster unsupportable. Any modification done to the agent nodes must be done using Kubernetes-native mechanisms such as `Daemon Sets`.

Similarly, while you may add any metadata, such as tags and labels, to the cluster and nodes, changing any of the system-created metadata will render the cluster unsupported.

## AKS hybrid support coverage

Microsoft provides technical support for the following features and components:

* Connectivity to all Kubernetes components that the Kubernetes service provides and supports, such as the API server.

* Kubernetes control plane services (Kubernetes control plane, API server, etcd, and coreDNS, for example).

* Etcd data store.

* Integration with Azure Arc and the Azure Billing service.

* Questions or issues about customization of control plane components such as the Kubernetes API server, etcd, and coreDNS.

* Issues about networking, network access, and functionality. Issues could include DNS resolution, packet loss, and routing. Microsoft supports various networking scenarios:

  * Basic installation support for Flannel and Calico CNI. These CNIs are community driven and supported. CSS provides only basic installation and configuration support.

  * Connectivity to other Azure services and applications

  * Ingress controllers, and ingress or load balancer configurations

  * Network performance and latency

> [!NOTE]
> Any cluster actions taken by Microsoft of AKS hybrid support teams are made with user consent and assistance. Microsoft Support will not log into your cluster unless you configure access for the support engineer.

Microsoft doesn't provide technical support in the following areas:

* Questions about how to use Kubernetes. For example, Microsoft Support doesn't provide advice on how to create custom ingress controllers, use application workloads, or apply third-party or open-source software packages or tools.

  > [!NOTE]
  > Microsoft Support can advise on AKS cluster functionality, customization, and tuning in AKS hybrid - for example, Kubernetes operations issues and procedures.

* Third-party open-source projects that aren't provided as part of the Kubernetes control plane or deployed when AKS clusters are created in AKS hybrid. These projects might include Istio, Helm, Envoy, or others.

  > [!NOTE]
  > Microsoft can provide best-effort support for third-party open-source projects such as Helm. Where the third-party open-source tool integrates with Kubernetes or other AKS hybrid-specific bugs, Microsoft supports examples and applications from Microsoft documentation.

* Third-party closed-source software. This software can include security scanning tools and networking devices or software.
  
* Network customizations other than the ones listed in the [AKS hybrid documentation](./index.yml).

## AKS hybrid support coverage for agent nodes

### Microsoft responsibilities for AKS hybrid agent nodes

Microsoft and users share responsibility for Kubernetes agent nodes where:

* The base OS image has required additions (such as monitoring and networking agents).
* The agent nodes receive OS patches automatically.
* Issues with the Kubernetes control plane components that run on the agent nodes are automatically remediated during the update cycle or when you redeploy an agent node. These components include the following ones:
  * `kube-proxy`
  * Networking tunnels that provide communication paths to the Kubernetes master components
  * `kubelet`
  * `Moby` or `ContainerD`

> [!NOTE]
> If an agent node is not operational, AKS hybrid might restart individual components or the entire agent node. These automated restart operations provide auto-remediation for common issues.

### Customer responsibilities for AKS hybrid agent nodes

Microsoft provides patches and new images for your image nodes monthly but doesn't automatically patch them by default. To keep your agent node OS and runtime components patched, you should keep a regular upgrade schedule or automate patching.

Similarly, AKS hybrid regularly releases new Kubernetes patches and minor versions. These updates can contain security or functionality improvements to Kubernetes. You're responsible for keeping your clusters' Kubernetes version updated according to the [AKS hybrid supported versions policy](supported-kubernetes-versions.md).

#### User customization of agent nodes

> [!NOTE]
> AKS hybrid agent nodes appear in Hyper-V as regular virtual machine resources. These virtual machines are deployed with a custom OS image and supported and managed Kubernetes components. You cannot change the base OS image or do any direct customizations to these nodes using the Hyper-V APIs or resources. Any custom changes that are not done via the AKS on Azure Stack HCI and Windows Server API<!--Verify the API name.--> will not persist through an upgrade, scale, update, or reboot and may render the cluster unsupported.
> Avoid performing changes to the agent nodes unless Microsoft Support directs you to make changes.

AKS hybrid manages the lifecycle and operations of agent node images on your behalf. Modifying the resources associated with the agent nodes is **not supported**. For example, customizing a virtual machine's network settings by manually changing configurations through the Hyper-V API or tools is not supported.

For workload-specific configurations or packages, you should use [Kubernetes `daemon sets`](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/).

When you use Kubernetes privileged `daemon sets` and init containers, you can tune/modify or install third-party software on cluster agent nodes. For example, you can add custom security scanning software or update `sysctl` settings.

While this path is recommended if the above requirements apply, AKS hybrid engineering and support can't help with troubleshooting or diagnosing modifications that render the node unavailable because of a custom-deployed `daemon set`.

### Security issues and patching

If a security flaw is found in one or more of the managed components of AKS hybrid, the AKS hybrid team will patch all affected OS images to mitigate the issue, and the team will give users upgrade guidance.

For agent nodes affected by a security flaw, Microsoft will notify you with details about the impact and the steps to fix or mitigate the security issue - normally, a node image upgrade or a cluster patch upgrade.

### Node maintenance and access

Although you can sign in to and change agent nodes, this operation is discouraged because changes can make a cluster unsupportable.

## Network ports, IP Pools, and access

You may only customize network settings using AKS hybrid defined subnets. You may not customize network settings at the NIC level of the agent nodes. AKS hybrid has egress requirements for specific endpoints, to control egress and ensure the necessary connectivity. For more information, see [AKS hybrid system requirements](./system-requirements.md).

## Stopped or disconnected clusters

As stated earlier, manually de-allocating all cluster nodes via the Hyper-V APIs, CLI, or MMC will render the cluster out of support.

Clusters that are stopped for more than 90 days will no longer be able to be updated. The control planes for clusters in this state will be out of support after 30 days, and they can't be updated to the latest version after 60 days.

If your Azure subscription is suspended or deleted, your cluster will be out of support after 60 days.

## Unsupported alpha and beta Kubernetes features

AKS hybrid only supports stable and beta features within the upstream Kubernetes project. Unless otherwise documented, AKS hybrid doesn't support any alpha feature that is available in the upstream Kubernetes project.

## Preview features or feature flags

For features and functionality that require extended testing and user feedback, Microsoft releases new preview features or features behind a feature flag. Consider these prerelease or beta features.

Preview features or feature-flag features aren't meant for production. Ongoing changes in APIs and behavior, bug fixes, and other changes can result in unstable clusters and downtime.

Features in public preview receive 'best effort' support, as these features are in preview and not meant for production. These features are supported by the AKS hybrid technical support teams during business hours only. For more information, see the [Azure Support FAQ](https://azure.microsoft.com/support/faq/).

## Upstream bugs and issues

Given the speed of development in the upstream Kubernetes project, bugs invariably arise. Some of these bugs can't be patched or worked around within the AKS hybrid system. Instead, bug fixes require larger patches to upstream projects (such as Kubernetes, node or agent operating systems, and kernel). For components that Microsoft owns (such as the cluster API providers for Azure Stack HCI), AKS hybrid and Azure personnel are committed to fixing issues upstream in the community.

When a technical support issue is root-caused by one or more upstream bugs, AKS hybrid support and engineering teams will:

* Identify and link the upstream bugs with any supporting details to help explain why this issue affects your cluster or workload. Customers receive links to the required repositories so they can watch the issues and see when a new release will provide fixes.
* Provide potential workarounds or mitigation. If the issue can be mitigated, a [known issue](https://github.com/Azure/aks-hci/issues?q=is%3Aopen+is%3Aissue+label%3Aknown-issue) will be filed in the AKS on Azure Stack HCI and Windows Server repository.<!--Verify repo name.--> The known-issue filing explains:
  * The issue, including links to upstream bugs.
  * The workaround and details about an upgrade or another persistence of the solution.
  * Rough timelines for the issue's inclusion, based on the upstream release cadence.
