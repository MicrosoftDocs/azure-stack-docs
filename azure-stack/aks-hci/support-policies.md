---
title: Support policies for Azure Kubernetes Service on Azure Stack HCI (AKS on Azure Stack HCI and Windows Server)
description: Learn about Azure Kubernetes Service on Azure Stack HCI (AKS on Azure Stack HCI and Windows Server) support policies, shared responsibility, and features that are in preview (or alpha or beta).
services: container-service
ms.topic: article
ms.date: 05/11/2022
author: mattbriggs
ms.author: mabrigg
ms.lastreviewed: 03/30/2022
ms.reviewer: mikek

# Customer intent: As a cluster operator or developer, I want to understand what AKS on Azure Stack HCI components I need to manage, what components are managed and supported by Microsoft (including security patches), and networking and preview features.
# Intent: As an IT Pro, I want to understand the support policies associated with my AKS deployment, including security patches, networking, and preview features.
# Keyword: support policies AKS technical support control plane service updates
---

# Support policies for Azure Kubernetes Service on Azure Stack HCI

This article provides details about technical support policies and limitations for Azure Kubernetes Service on Azure Stack HCI (AKS on Azure Stack HCI and Windows Server). 

This article also details management cluster node management, control plane components, third-party open-source components, and security or patch management.

## Service updates and releases

* For release information, see [AKS on Azure Stack HCI and Windows Server release notes](https://github.com/Azure/aks-hci/releases).
* For information on features in preview, see [AKS on Azure Stack HCI and Windows Server preview features](https://github.com/Azure/aks-hci/tree/main/preview).

## Supported version policy
AKS on Azure Stack HCI and Windows Server versions are expressed as w.z.y.zzzz, where w is the major version, x is the minor version, y is the patch version, and zzzz is the build of the specific version  following Semantic Versioning terminology.

AKS on Azure Stack HCI and Windows Server maintains upgrade support for the three most recent [releases](https://github.com/Azure/aks-hci/releases).

Kubernetes versions in AKS on Azure Stack HCI and Windows Server follow the [Kubernetes version policy](https://kubernetes.io/releases/version-skew-policy/). For details on the supported Kubernetes Versions see [Supported Kubernetes Versions](./supported-kubernetes-versions.md).

To keep your AKS on Azure Stack HCI and Windows Server environment in a supported state, we recommended that you  stay within a 30 day window of the latest release and not fall behind more than 60 days from the latest update.

After 120 days, Microsoft can't guarantee that older versions of AKS on Azure Stack HCI and Windows Server are still available on the release servers for download. Scale operations, upgrades, reinstallations and other operations in the cluster will start to fail, requiring that you redeploy your AKS on Azure Stack HCI and Windows Server environment with the latest version.

If your cluster falls behind more than 60 days (2 versions), you'll have to upgrade in multiple steps to get current again.

## Managed features in AKS on Azure Stack HCI and Windows Server

As an AKS on Azure Stack HCI user, you have limited customization and deployment options. In exchange, you don't need to worry about or manage Kubernetes cluster control plane and installation directly. Base infrastructure-as-a-service (IaaS) cloud components, such as compute or networking components, allow you access .to low-level controls and customization options. 

By contrast, AKS on Azure Stack HCI and Windows Server provides a turnkey Kubernetes deployment that gives you the common set of configurations and capabilities you need for your cluster. As an AKS on Azure Stack HCI and Windows Server user, you have limited customization and deployment options. In exchange, you don't need to worry about or manage Kubernetes cluster control plane and installation directly.

With AKS on Azure Stack HCI and Windows Server, you get a partially managed *control plane*. The control plane contains all of the components and services you need to operate and provide Kubernetes clusters to end users. All Kubernetes components are maintained by Microsoft.

Microsoft maintains the following components through the management cluster and the associated Virtual Machine base images:

* Kubelet or Kubernetes API servers.
* Etcd or a compatible key-value store, providing Quality of Service (QoS), scalability, and runtime.
* DNS services (for example, kube-dns or CoreDNS).
* Kubernetes proxy or networking.
* Any additional addon or system component running in the kube-system namespace.

AKS on Azure Stack HCI and Windows Server isn't a Platform-as-a-Service (PaaS) solution. Some components, such as workload cluster control plane and worker nodes, have *shared responsibility*, where users must help maintain the AKS on Azure Stack HCI and Windows Server cluster. User input is required, for example, to apply an operating system (OS) security patch or update to a newer Kubernetes version.

The services are *managed* in the sense that Microsoft and the AKS on Azure Stack HCI and Windows Server team provide the tooling that deploys the management cluster, control plane and agent nodes for workloads clusters. Customers can't alter these managed components. Microsoft limits customization to ensure a consistent and scalable user experience. For a fully customizable solution in the cloud, see [AKS Engine](https://github.com/Azure/aks-engine).

## Shared responsibility

When a cluster is created, you define the Kubernetes agent nodes that AKS on Azure Stack HCI and Windows Server creates. Your workloads are executed on these nodes.

Because your agent nodes execute private code and store sensitive data, Microsoft Support can access them only in a limited way. Microsoft Support can't sign in to, execute commands in, or view logs for these nodes without your express permission or assistance.

Any modification done directly to the agent nodes using any of the IaaS APIs renders the cluster unsupportable. Any modification done to the agent nodes must be done using kubernetes-native mechanisms such as `Daemon Sets`.

Similarly, while you may add any metadata to the cluster and nodes, such as tags and labels, changing any of the system created metadata will render the cluster unsupported.

## AKS on Azure Stack HCI and Windows Server support coverage

Microsoft provides technical support for the following examples:

* Connectivity to all Kubernetes components that the Kubernetes service provides and supports, such as the API server.

* Providing the Kubernetes control plane services (Kubernetes control plane, API server, etcd, and coreDNS, for example).

* Providing the Etcd data store.

* Integration with Azure Arc and the Azure Billing service.

* Questions or issues about customization of control plane components such as the Kubernetes API server, etcd, and coreDNS.

* Issues about networking, network access and functionality issues. Issues could include DNS resolution, packet loss, routing, and so on. Microsoft supports various networking scenarios:

  * Basic installation support for Flannel and Calico CNI. These CNIs are community driven and supported. CSS will provide only basic installation and configuration support.

  * Connectivity to other Azure services and applications.

  * Ingress controllers and ingress or load balancer configurations.

  * Network performance and latency


> [!NOTE]
> Any cluster actions taken by Microsoft/AKS on Azure Stack HCI and Windows Server are made with user consent and assistance. Microsoft Support will not log into your cluster unless you configure access for the support engineer.

Microsoft doesn't provide technical support for the following examples:

* Questions about how to use Kubernetes. For example, Microsoft Support doesn't provide advice on how to create custom ingress controllers, use application workloads, or apply third-party or open-source software packages or tools.
  > [!NOTE]
  > Microsoft Support can advise on AKS on Azure Stack HCI and Windows Server cluster functionality, customization, and tuning (for example, Kubernetes operations issues and procedures).

* Third-party open-source projects that aren't provided as part of the Kubernetes control plane or deployed when AKS on Azure Stack HCI and Windows Server clusters are created. These projects might include Istio, Helm, Envoy, or others.
  > [!NOTE]
  > Microsoft can provide best-effort support for third-party open-source projects such as Helm. Where the third-party open-source tool integrates with  Kubernetes or other AKS on Azure Stack HCI and Windows Server-specific bugs, Microsoft supports examples and applications from Microsoft documentation.

* Third-party closed-source software. This software can include security scanning tools and networking devices or software.
  
* Network customizations other than the ones listed in the [AKS on Azure Stack HCI and Windows Server documentation](./index.yml).


## AKS on Azure Stack HCI and Windows Server support coverage for agent nodes

### Microsoft responsibilities for AKS on Azure Stack HCI and Windows Server agent nodes

Microsoft and users share responsibility for Kubernetes agent nodes where:

* The base OS image has required additions (such as monitoring and networking agents).
* The agent nodes receive OS patches automatically.
* Issues with the Kubernetes control plane components that run on the agent nodes are automatically remediated during the update cycle or when you redeploy an agent node. These components include the below:
  * `Kube-proxy`
  * Networking tunnels that provide communication paths to the Kubernetes master components
  * `Kubelet`
  * `Moby` or `ContainerD`

> [!NOTE]
> If an agent node is not operational, AKS on Azure Stack HCI and Windows Server might restart individual components or the entire agent node. These restart operations are automated and provide auto-remediation for common issues.

### Customer responsibilities for AKS on Azure Stack HCI and Windows Server agent nodes

Microsoft provides patches and new images for your image nodes monthly, but doesn't automatically patch them by default. To keep your agent node OS and runtime components patched, you should keep a regular upgrade schedule or automate it.

Similarly, AKS on Azure Stack HCI and Windows Server regularly releases new Kubernetes patches and minor versions. These updates can contain security or functionality improvements to Kubernetes. You're responsible to keep your clusters' kubernetes version updated and according to the [AKS on Azure Stack HCI and Windows Server Kubernetes Support Version Policy](supported-kubernetes-versions.md).

#### User customization of agent nodes
> [!NOTE]
> AKS on Azure Stack HCI and Windows Server agent nodes appear in Hyper-V as regular virtual machine resources. These virtual machines are deployed with a custom OS image and supported/managed Kubernetes components. You cannot change the base OS image or do any direct customizations to these nodes using the Hyper-V APIs or resources. Any custom changes that are not done via the AKS on Azure Stack HCI and Windows Server API will not persist through an upgrade, scale, update or reboot and may render the cluster unsupported.
> Avoid performing changes to the agent nodes unless Microsoft Support directs you to make changes.

AKS on Azure Stack HCI and Windows Server manages the lifecycle and operations of agent node image on your behalf - modifying the resources associated with the agent nodes is **not supported**. An example of an unsupported operation is customizing a virtual machine network settings by manually changing configurations through the Hyper-V API or tools.

For workload-specific configurations or packages, AKS on Azure Stack HCI and Windows Server recommends using [Kubernetes `daemon sets`](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/).

Using Kubernetes privileged `daemon sets` and init containers enables you to tune/modify or install 3rd party software on cluster agent nodes. Examples of such customizations include adding custom security scanning software or updating sysctl settings.

While this path is recommended if the above requirements apply, AKS on Azure Stack HCI and Windows Server engineering and support can't help with troubleshooting or diagnosing modifications that render the node unavailable due to a custom deployed `daemon set`.

### Security issues and patching

If a security flaw is found in one or more of the managed components of AKS on Azure Stack HCI and Windows Server, the AKS on Azure Stack HCI and Windows Server team will patch all affected OS images to mitigate the issue and the team will give users upgrade guidance.

For agent nodes affected by a security flaw, Microsoft will notify you with details on the impact and the steps to fix or mitigate the security issue (normally a node image upgrade or a cluster patch upgrade).

### Node maintenance and access

Although you can sign in to and change agent nodes, doing this operation is discouraged because changes can make a cluster unsupportable.

## Network ports, IP Pools and access

You may only customize the network settings using AKS on Azure Stack HCI and Windows Server defined subnets. You may not customize network settings at the NIC level of the agent nodes. AKS on Azure Stack HCI and Windows Server has egress requirements to specific endpoints, to control egress and ensure the necessary connectivity, see [System Requirements](./system-requirements.md).

## Stopped or disconnected clusters

As stated earlier, manually de-allocating all cluster nodes via the Hyper-V APIs/CLI/MMC will render the cluster out of support.

Clusters that are stopped for more than 90 days will no longer be able to be updated. The control planes for clusters in this state will be out of support after 30 days, not able to update to the latest version after 60 days.

If your Azure subscription is suspended or deleted, your cluster will be out of support after 60 days.

## Unsupported alpha and beta Kubernetes features

AKS on Azure Stack HCI and Windows Server only supports stable and beta features within the upstream Kubernetes project. Unless otherwise documented, AKS on Azure Stack HCI and Windows Server doesn't support any alpha feature that is available in the upstream Kubernetes project.

## Preview features or feature flags

For features and functionality that requires extended testing and user feedback, Microsoft releases new preview features or features behind a feature flag. Consider these features as prerelease or beta features.

Preview features or feature-flag features aren't meant for production. Ongoing changes in APIs and behavior, bug fixes, and other changes can result in unstable clusters and downtime.

Features in public preview  fall under 'best effort' support as these features are in preview and not meant for production and are supported by the AKS on Azure Stack HCI and Windows Server technical support teams during business hours only. For more information, see:

* [Azure Support FAQ](https://azure.microsoft.com/support/faq/)

## Upstream bugs and issues

Given the speed of development in the upstream Kubernetes project, bugs invariably arise. Some of these bugs can't be patched or worked around within the AKS on Azure Stack HCI and Windows Server system. Instead, bug fixes require larger patches to upstream projects (such as Kubernetes, node or agent operating systems, and kernel). For components that Microsoft owns (such as the cluster API providers for Azure Stack HCI), AKS on Azure Stack HCI and Windows Server and Azure personnel are committed to fixing issues upstream in the community.

When a technical support issue is root-caused by one or more upstream bugs, AKS on Azure Stack HCI and Windows Server support and engineering teams will:

* Identify and link the upstream bugs with any supporting details to help explain why this issue affects your cluster or workload. Customers receive links to the required repositories so they can watch the issues and see when a new release will provide fixes.
* Provide potential workarounds or mitigation. If the issue can be mitigated, a [known issue](https://github.com/Azure/aks-hci/issues?q=is%3Aopen+is%3Aissue+label%3Aknown-issue) will be filed in the AKS on Azure Stack HCI and Windows Server repository. The known-issue filing explains:
  * The issue, including links to upstream bugs.
  * The workaround and details about an upgrade or another persistence of the solution.
  * Rough timelines for the issue's inclusion, based on the upstream release cadence.