---
title: Add-ons and extensions available for AKS hybrid
description: Learn about what add-ons and integrations are supported in AKS hybrid
author: sethmanheim
ms.topic: how-to
ms.date: 02/14/2023
ms.author: sethm 
ms.lastreviewed: 02/14/2023
ms.reviewer: baziwane
---

# Add-ons, extensions, and other integrations with AKS hybrid

Azure Kubernetes Service (AKS) hybrid provides augmented functionality
for your Kubernetes cluster mainly through extensions which are
supported by Microsoft. Additionally, numerous integrations offered by
open-source projects and third-party organizations are commonly utilized
with AKS hybrid. It is important to note that these integrations, which
are not supported by AKS hybrid, are not included in the [AKS hybrid
support policy][].

**Add-ons**

Add-ons are a fully supported way to provide extra capabilities for your
AKS hybrid cluster. Add-ons' installation, configuration, and lifecycle
are managed by AKS hybrid. For instructions on how to install each
add-on, see the available add-ons list.

The following rules are used by AKS hybrid for applying updates to
installed add-ons:

-   Any breaking or behavior changes to the add-on will be announced
    well before, usually 60 days in advance of release.

-   Updates to add-ons will be communicated through the release notes
    accompanying each new release of AKS hybrid.

**Available add-ons**

| **Add-on**                           | **Description**                                                  |
|--------------------------------------|------------------------------------------------------------------|
| [<u>Install-AksHciAdAuth</u>][]      | Installs Active Directory authentication.                        |
| [<u>Install-AksHciCsiNfs</u>][]      | Installs the CSI NFS plug-in to a cluster.                       |
| [<u>Install-AksHciCsiSmb</u>][]      | Installs the CSI SMB plug-in to a cluster.                       |
| [<u>Install-AksHciGmsaWebhook</u>][] | Installs gMSA webhook add-on to the cluster.                     |
| [<u>Install-AksHciMonitoring</u>][]  | Installs Prometheus for monitoring in the AKS hybrid deployment. |

**Azure Arc** **Extensions**

Cluster extensions build on top of certain Helm charts and provide an
Azure Resource Manager-driven experience for installation and lifecycle
management of different Azure capabilities on top of your Kubernetes
cluster. These extensions can be [deployed to your clusters][] to
improve cluster management.

**Available extensions**

For more details on the specific cluster extensions for AKS hybrid,
see [<u>Currently available extensions</u>][].

**Difference between extensions and add-ons**

Both extensions and add-ons are supported ways to add functionality to
your AKS hybrid cluster. When you install an add-on, the functionality
is added as part of the AKS hybrid deployment. When you install an
extension, the functionality is added as part of a separate resource
provider in the Azure API.

**Open source and third-party integrations**

You can install many open source and third-party integrations on your
AKS cluster, but these open-source and third-party integrations are not
covered by the [<u>AKS hybrid support
policy</u>][AKS hybrid support policy].

The table below shows a few examples of open-source and third-party
integrations.

| **Name**                | **Description**                                                                                           | **More details**                                                                                                                                                               |
|-------------------------|-----------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [<u>Helm</u>][]         | An open-source packaging tool that helps you install and manage the lifecycle of Kubernetes applications. | [<u>Quickstart: Develop on Azure Kubernetes Service (AKS) with Helm</u>][]                                                                                                     |
| [<u>Couchbase</u>][]    | A distributed NoSQL cloud database.                                                                       | [<u>Install Couchbase and the Operator on AKS</u>][]                                                                                                                           |
| <u>OpenFaaS</u>         | An open-source framework for building serverless functions by using containers.                           | [<u>Use OpenFaaS with AKS</u>][]                                                                                                                                               |
| [<u>Apache Spark</u>][] | An open source, fast engine for large-scale data processing.                                              | Running Apache Spark jobs requires a minimum node size of *Standard\_D3\_v2*. See [<u>running Spark on Kubernetes</u>][] for more details on running Spark jobs on Kubernetes. |
| [<u>Istio</u>][]        | An open-source service mesh.                                                                              | [<u>Istio Installation Guides</u>][]                                                                                                                                           |
| [<u>Linkerd</u>][]      | An open-source service mesh.                                                                              | [<u>Linkerd Getting Started</u>][]                                                                                                                                             |
| [<u>Consul</u>][]       | An open source, identity-based networking solution.                                                       | [<u>Getting Started with Consul Service Mesh for Kubernetes</u>][]                                                                                                             |

  [AKS hybrid support policy]: https://learn.microsoft.com/en-us/azure/aks/hybrid/support-policies
  [<u>Install-AksHciAdAuth</u>]: https://nam06.safelinks.protection.outlook.com/?url=https%3A%2F%2Flearn.microsoft.com%2Fen-us%2Fazure%2Faks%2Fhybrid%2Freference%2Fps%2Finstall-akshciadauth&data=05%7C01%7Craymond.baziwane%40microsoft.com%7C0b5962d7b3884fd1f71408db0aae61b5%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C638115516312932046%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=hIDMo59CBD2rG2CgEtSEW9KqkHeM1vTWddwENJ%2FzarE%3D&reserved=0
  [<u>Install-AksHciCsiNfs</u>]: https://nam06.safelinks.protection.outlook.com/?url=https%3A%2F%2Flearn.microsoft.com%2Fen-us%2Fazure%2Faks%2Fhybrid%2Freference%2Fps%2Finstall-akshcicsinfs&data=05%7C01%7Craymond.baziwane%40microsoft.com%7C0b5962d7b3884fd1f71408db0aae61b5%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C638115516312932046%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=hLBhRigMw0ziRKM7FAQlPtggEtLWO5jVo9zft8oA36I%3D&reserved=0
  [<u>Install-AksHciCsiSmb</u>]: https://nam06.safelinks.protection.outlook.com/?url=https%3A%2F%2Flearn.microsoft.com%2Fen-us%2Fazure%2Faks%2Fhybrid%2Freference%2Fps%2Finstall-akshcicsismb&data=05%7C01%7Craymond.baziwane%40microsoft.com%7C0b5962d7b3884fd1f71408db0aae61b5%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C638115516312932046%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=Q7U0lpalbQyHmtrB3bgQfMssIpk1vL3cgRfxoz2Zd54%3D&reserved=0
  [<u>Install-AksHciGmsaWebhook</u>]: https://nam06.safelinks.protection.outlook.com/?url=https%3A%2F%2Flearn.microsoft.com%2Fen-us%2Fazure%2Faks%2Fhybrid%2Freference%2Fps%2Finstall-akshcigmsawebhook&data=05%7C01%7Craymond.baziwane%40microsoft.com%7C0b5962d7b3884fd1f71408db0aae61b5%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C638115516312932046%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=FnJfcq4aMNWlpW7zm3cuPGYMuOaNpU9kRodLOJNCz30%3D&reserved=0
  [<u>Install-AksHciMonitoring</u>]: https://nam06.safelinks.protection.outlook.com/?url=https%3A%2F%2Flearn.microsoft.com%2Fen-us%2Fazure%2Faks%2Fhybrid%2Freference%2Fps%2Finstall-akshcimonitoring&data=05%7C01%7Craymond.baziwane%40microsoft.com%7C0b5962d7b3884fd1f71408db0aae61b5%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C638115516312932046%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=Zfa8Xo3XGa7GxCTQe8kT4m971L%2FFlpmJrAFVfatrvG4%3D&reserved=0
  [deployed to your clusters]: https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/extensions
  [<u>Currently available extensions</u>]: https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/extensions-release
  [<u>Helm</u>]: https://helm.sh/
  [<u>Quickstart: Develop on Azure Kubernetes Service (AKS) with Helm</u>]:
    https://learn.microsoft.com/en-us/azure/aks/quickstart-helm
  [<u>Couchbase</u>]: https://www.couchbase.com/
  [<u>Install Couchbase and the Operator on AKS</u>]: https://docs.couchbase.com/operator/current/tutorial-aks.html
  [<u>Use OpenFaaS with AKS</u>]: https://learn.microsoft.com/en-us/azure/aks/openfaas
  [<u>Apache Spark</u>]: https://spark.apache.org/
  [<u>running Spark on Kubernetes</u>]: https://spark.apache.org/docs/latest/running-on-kubernetes.html
  [<u>Istio</u>]: https://istio.io/
  [<u>Istio Installation Guides</u>]: https://istio.io/latest/docs/setup/install/
  [<u>Linkerd</u>]: https://linkerd.io/
  [<u>Linkerd Getting Started</u>]: https://linkerd.io/getting-started/
  [<u>Consul</u>]: https://www.consul.io/
  [<u>Getting Started with Consul Service Mesh for Kubernetes</u>]: https://learn.hashicorp.com/tutorials/consul/service-mesh-deploy
