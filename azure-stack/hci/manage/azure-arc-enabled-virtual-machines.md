---
title: VM provisioning through Azure portal on Azure Stack HCI 
description: How to set up Azure Arc enabled Azure Stack HCI for cloud-based virtual machine provisioning and management
author: ksurjan
ms.author: ksurjan
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 03/24/2022
---

# VM provisioning through Azure portal on Azure Stack HCI (preview)

> Applies to: Azure Stack HCI, version 21H2

Azure Stack HCI, version 21H2 enables you to use the Azure portal to provision and manage on-premises Windows and Linux virtual machines (VMs) running on Azure Stack HCI clusters. With [Azure Arc](https://azure.microsoft.com/services/azure-arc/), IT administrators can delegate permissions and roles to app owners and DevOps teams to enable self-service VM management for their Azure Stack HCI clusters through the Azure cloud control plane. Using [Azure Resource Manager](/azure/azure-resource-manager/management/overview) templates, VM provisioning can be easily automated in a secure cloud environment.

To find answers to frequently asked questions about Arc-enabled VMs on Azure Stack HCI, see [FAQs](faqs-arc-enabled-vms.md).

To troubleshoot issues with your Arc-enabled VMs or to know existing known issues and limitations, see [Troubleshoot Arc-enabled virtual machines](troubleshoot-arc-enabled-vms.md).

> [!IMPORTANT]
> VM provisioning through Azure portal on Azure Stack HCI is currently in preview. This preview is provided without a service level agreement, and Microsoft doesn't recommend using it for production workloads. Certain features might not be supported or might have constrained capabilities. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Benefits of Azure Arc-enabled Azure Stack HCI

With Azure Arc-enabled Azure Stack HCI, you can perform various operations from the Azure portal, such as:

- Create a VM
- Start, stop, and restart a VM
- Control access and add Azure tags
- Add and remove virtual disks and network interfaces
- Update memory and virtual CPUs for the VM

By using the Azure portal, you get the same consistent experience when provisioning and managing on-premises VMs or cloud VMs. You can access your VMs only, not the host fabric, enabling role-based access control and self-service.

## What is Azure Arc Resource Bridge?

A resource bridge is required to enable VM provisioning through the Azure portal on Azure Stack HCI. Azure Arc Resource Bridge is a Kubernetes-backed, lightweight VM that enables users to perform full lifecycle management of resources on Azure Stack HCI from the Azure control plane, including the Azure portal, Azure CLI, and Azure PS. Azure Arc Resource Bridge also creates Azure Resource Manager entities for VM disks, VM images, VM interfaces, VM networks, custom locations, and VM cluster extensions.

A **custom location** for an Azure Stack HCI cluster is analogous to an Azure region. As an extension of the Azure location construct, custom locations allow tenant administrators to use their Azure Stack HCI clusters as target location for deploying Azure services.

A **cluster extension** is the on-premises equivalent of an Azure Resource Manager resource provider. The Azure Stack HCI cluster extension helps manage VMs on an Azure Stack HCI cluster in the same way that the "Microsoft.Compute" resource provider manages VMs in Azure, for example.

   > [!NOTE]
   > **Arc Appliance** is an earlier name for Arc Resource Bridge, and you may see the term used in some places like the PowerShell commands or on the Azure portal. The feature has also been called self-service VMs in the past; however, this is only one of the several capabilities available with Arc-enabled Azure Stack HCI.

## Azure Arc Resource Bridge deployment overview

To enable Azure Arc-based VM operations on your Azure Stack HCI cluster, you must:

1. Install Azure Arc Resource Bridge on the Azure Stack HCI cluster and create a VM cluster extension. This can be done using Windows Admin Center or PowerShell.
1. Create a custom location for the Azure Stack HCI cluster.
1. Create virtual network projections which will be used by VM network interfaces.
1. Create OS gallery images for provisioning VMs.

Only one Arc Resource Bridge can be deployed on a cluster. Each Azure Stack HCI cluster can have only one custom location. Each virtual switch on the Azure Stack HCI cluster can have one virtual network. Multiple OS images can be added to the gallery. Additional virtual networks and images can be added any time after the initial setup.

## Prerequisites for deploying Azure Arc Resource Bridge

Deploying Azure Arc Resource Bridge requires the following:

- The latest version of Azure CLI installed on all servers of the cluster.
  - To install Azure CLI on each cluster node, use RDP connection.
  - Follow the instructions in [Install Azure CLI](/cli/azure/install-azure-cli-windows).
- Arc Resource Bridge has the following resource requirements:
  - A cluster shared volume with at least 50GB of space.
  - At least 4 vCPUs
  - At least 8GB of memory
- A virtual switch of type "External". Make sure the switch has external internet connectivity. This virtual switch and its name must be the same across all servers in the Azure Stack HCI cluster.
- A DHCP server with enough IP addresses for Resource Bridge VM. You can have a tagged or untagged DHCP server.
- An IP address for the load balancer running inside the Resource Bridge. The IP address needs to be in the same subnet as the DHCP scope and must be excluded from the DHCP scope to avoid IP address conflicts.
- An IP address for the cloud agent running inside the Resource Bridge. If the Azure Stack HCI cluster servers were assigned static IP addresses, then provide an explicit IP address for the cloud agent. The IP address for the cloud agent must be in the same subnet as the IP addresses of Azure Stack HCI cluster servers.
- A shared cluster volume to store configuration details and the OS image for your Resource Bridge VM.
- An Azure subscription ID where your Resource Bridge, custom location, and cluster extension resources will reside.

> [!NOTE]
> We currently do not support proxy configurations.

## Network port requirements

When you deploy Azure Arc Resource Bridge on Azure Stack HCI, the following firewall ports are automatically opened on each server in the cluster.

| **Port** | **Service** |
|:---------|:------------|
| 45000    | wssdagent gRPC server |
| 45001    | wssdagent gRPC authentication |
| 55000    | wssdcloudagent gRPC server |
| 65000    | wssdcloudagent gRPC authentication |

## Firewall URL exceptions

The following firewall URL exceptions are needed on all servers in the Azure Stack HCI cluster.

| **URL** | **Port** | **Service** | **Notes** |
|:--------|:---------|:------------|:----------|
| https://helm.sh/blog/get-helm-sh/ | 443 | Download agent | Used to download the Helm binaries |
| https://storage.googleapis.com/ | 443 | Cloud init | Downloading Kubernetes binaries |
| https://azurecliprod.blob.core.windows.net/ | 443 | Cloud init | Downloading binaries and containers |
| https://443 | 443 | TCP | Used to support Azure Arc agents |
| *.blob.core.windows.net | 443 | TCP | Required for downloads |
| *.dl.delivery.mp.microsoft.com, *.do.dsp.mp.microsoft.com | 80, 443 | Download agent | Downloading VHD images |
| ecpacr.azurecr.io | 443 | Kubernetes | Downloading container images |
| git://:9418 | 9418 | TCP | Used to support Azure Arc agents |

## Next steps

- [Deploy Azure Arc Resource Bridge using command line](deploy-arc-resource-bridge-using-command-line.md)
- [Deploy Azure Arc Resource Bridge using Windows Admin Center](deploy-arc-resource-bridge-using-wac.md)
