---
title: Overview of AKS hybrid cluster provisioning from Azure
description: Overview of AKS hybrid cluster provisioning from Azure
ms.topic: overview
ms.date: 10/03/2022
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 10/03/2022
ms.reviewer: abha
# Intent: As an IT Pro, I want to learn how to create and manage AKS hybrid clusters on-premises from Azure
# Keyword: 
---

# Overview of AKS hybrid clusters provisioned from Azure (preview)

Currently you can manage the lifecycle of AKS on Azure Stack HCI or AKS on Windows Server clusters through PowerShell and Windows Admin Center. Through AKS hybrid cluster provisioning from Azure, you will be able to manage AKS clusters on Azure Stack HCI and Windows Server using Azure. Furthermore, your AKS hybrid clusters managed via Azure are always automatically connected to Azure Arc.

At this time, you can perform the following operations through the Azure portal and Azure CLI:

- [Azure Portal, Azure CLI] Create/list/show AKS hybrid clusters
- [Azure Portal, Azure CLI] Give users access to ARM resources like AKS hybrid clusters, nodepools and vnet object through Azure RBAC
- [Azure CLI] Access the AKS hybrid cluster using kubectl and your AAD identity
- [Azure CLI] Add/list/show nodepools on your AKS hybrid cluster
- [Azure CLI] Delete your AKS hybrid clusters and nodepools 
- [Local PowerShell] Collect logs for troubleshooting

Through Azure Arc, you can use the following Azure services on your AKS hybrid cluster provisioned from Azure:

- Azure Defender
- GitOps v2
- Open Service Mesh
- Azure Key Vault

## Supporting technologies

### AKS on Azure Stack HCI (AKS-HCI)

If you aren't familiar with AKS on Azure Stack HCI or AKS on Windows Server, see [What is AKS on Azure Stack HCI and AKS on Windows Server?](overview.md). AKS on Azure Stack HCI and AKS on Windows Server is generally available since June 2021. You can create AKS clusters on Azure Stack HCI and Windows Server using PowerShell and Windows Admin Center. 

### AKS host/management cluster

The management cluster is created for you when you install AKS on Azure Stack HCI or AKS on Windows Server. The management cluster is a specialized Kubernetes cluster that provisions and manages all AKS workload clusters (these Kubernetes workload clusters run your applications). These AKS workload clusters can only be managed using Windows Admin Center and PowerShell. The management cluster today is backed by a single VM. You can check that this VM exists by looking at Hyper-V or the Windows Admin Center VM extension.

### Azure Arc Resource Bridge

Azure Arc Resource Bridge connects a private cloud (for example, Azure Stack HCI, VMWare/VSPhere, OpenStack, or SCVMM) to Azure and enables on-premises resource management from Azure. Azure Arc Resource Bridge provides the line of sight to private clouds required to manage resources such as VMs and Kubernetes clusters on-premises through Azure. Think of Azure Arc Resource Bridge as an advanced AKS management cluster that can be configured and managed from Azure.
Today, you can manage AKS clusters on Azure Stack HCI and Windows Server through PowerShell and Windows Admin Center. This preview feature enables you to manage AKS hybrid clusters through the Azure portal. To use this preview feature, you must install Azure Arc Resource Bridge in your datacenter as a pre-requisite.

### Arc Kubernetes cluster extensions

A cluster extension is the on-premises equivalent of an Azure Resource Manager resource provider. Just as you have the `Microsoft.ContainerService` resource provider that manages AKS clusters in Azure, the AKS hybrid cluster extension, once added to your Arc Resource Bridge, helps manage AKS hybrid clusters via Azure.

### Custom location

A custom location is the on-premises equivalent of an Azure region and is an extension of the Azure location construct. Custom locations provide a way for tenant administrators to use their data center with the right extensions installed, as target locations for deploying Azure service instances.

## Personas and roles

### Admin role

The role of the infrastructure administrator is to set up the platform components: for example, setting up Azure Stack HCI or Windows Server, the AKS management cluster, Arc resource bridge, the cluster extension, and the custom location. The admin role then creates on-premises networks that the "end-user" will use while creating AKS hybrid clusters. 

Apart from the above on-premises work, the admin also assigns permissions to "AAD users" on the Azure subscription to create and access AKS hybrid clusters. 
The end goal with this preview is that the admin can do the previous operations without having to know a lot about Kubernetes.

### User/Dev role

The role of the user/dev is to create AKS hybrid clusters and run applications on their on-premises Kubernetes clusters. In this preview program, the user will be given pertinent information about creating AKS hybrid clusters, such as subscription, custom location, and AKS hybrid network by the admin. The user will also be given Azure RBAC access to create the cluster by the administrator.

Once the user has the details described in the previous paragraph, they are free to create an AKS on Azure Stack HCI cluster as they see fit - Windows/Linux node pools, Kubernetes versions, etc. The user can then run their containerized applications by downloading the cluster *kubeconfig*.

## Next steps

[Quickly test AKS hybrid cluster provisioning from Azure on an Azure VM](aks-hybrid-preview-azure-vm.md)
