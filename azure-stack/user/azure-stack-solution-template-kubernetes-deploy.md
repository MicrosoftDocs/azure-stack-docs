---
title: Deploy Kubernetes to use Azure Stack Hub containers 
description: Learn how to deploy Kubernetes to use containers with Azure Stack Hub.
author: sethmanheim

ms.topic: install-set-up-deploy
ms.date: 2/1/2021
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 06/18/2019

# Intent: As an Azure Stack user, I want to deploy and set up the resources for Kubernetes to run containers on Azure Stack.
# Keyword: Azure Stack containers

---


# Deploy Kubernetes to use containers with Azure Stack Hub

> [!NOTE]  
> Only use the Kubernetes Azure Stack Marketplace item to deploy clusters as a proof-of-concept. For supported Kubernetes clusters on Azure Stack, use [the AKS engine](azure-stack-kubernetes-aks-engine-overview.md).

You can follow the steps in this article to deploy and set up the resources for Kubernetes in a single, coordinated operation. The steps use an Azure Resource Manager solution template. You'll need to collect the required information about your Azure Stack Hub installation, generate the template, and then deploy to your cloud. The Azure Stack Hub template doesn't use the same managed AKS service offered in global Azure.

## Kubernetes and containers

You can install Kubernetes using Azure Resource Manager templates generated by the AKS engine on Azure Stack Hub. [Kubernetes](https://kubernetes.io) is an open-source system for automating deployment, scaling, and managing of applications in containers. A [container](https://www.docker.com/what-container) is in an image. The container image is similar to a virtual machine (VM), however, unlike a VM, the container just includes the resources it needs to run an application, such as the code, runtime to execute the code, specific libraries, and settings.

You can use Kubernetes to:

- Develop massively scalable, upgradable, applications that can be deployed in seconds. 
- Simplify the design of your application and improve its reliability by different Helm applications. [Helm](https://github.com/kubernetes/helm) is an open-source packaging tool that helps you install and manage the lifecycle of Kubernetes applications.
- Easily monitor and diagnose the health of your applications.

You'll only be charged for the compute usage required by the nodes supporting your cluster. For more information, see [Usage and billing in Azure Stack Hub](../operator/azure-stack-billing-and-chargeback.md).

## Deploy Kubernetes to use containers

The steps to deploy a Kubernetes cluster on Azure Stack Hub will depend on your identity management service. Verify the identity management solution used by your installation of Azure Stack Hub. Contact your Azure Stack Hub administrator to verify your identity management service.

- **Microsoft Entra ID**  
For instructions on installing the cluster when using Microsoft Entra ID, see [Deploy Kubernetes to Azure Stack Hub using Microsoft Entra ID](azure-stack-solution-template-kubernetes-azuread.md).

- **Active Directory Federated Services (AD FS)**  
For instructions on installing the cluster when using AD FS, see [Deploy Kubernetes to Azure Stack Hub using Active Directory Federated Services (AD FS)](azure-stack-solution-template-kubernetes-adfs.md).

## Connect to your cluster

You're now ready to connect to your cluster. The master can be found in your cluster resource group, and is named `k8s-master-<sequence-of-numbers>`. Use an SSH client to connect to the master. On the master, you can use **kubectl**, the Kubernetes command-line client to manage your cluster. For instructions, see [Kubernetes.io](https://kubernetes.io/docs/reference/kubectl/overview).

You may also find the **Helm** package manager useful for installing and deploying apps to your cluster. For instructions on installing and using Helm with your cluster, see [helm.sh](https://helm.sh/).

## Next steps

[Enable the Kubernetes Dashboard](azure-stack-solution-template-kubernetes-dashboard.md)

[Add a Kubernetes to the Marketplace (for the Azure Stack Hub operator)](../operator/azure-stack-solution-template-kubernetes-cluster-add.md)

[Deploy Kubernetes to Azure Stack Hub using Microsoft Entra ID](azure-stack-solution-template-kubernetes-azuread.md)

[Deploy Kubernetes to Azure Stack Hub using Active Directory Federated Services (AD FS)](azure-stack-solution-template-kubernetes-adfs.md)

[Kubernetes on Azure](/azure/container-service/kubernetes/container-service-kubernetes-walkthrough)
