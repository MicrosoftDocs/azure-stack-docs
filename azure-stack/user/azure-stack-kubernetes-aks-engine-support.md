---
title: Support policies for AKS engine on Azure Stack Hub  
description: This topic contains the support policies for AKS engine on Azure Stack Hub.
author: sethmanheim

ms.topic: article
ms.date: 12/20/2022
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 04/23/2021

# Intent: As an Azure Stack Hub user, I want to learn about the limitations of AKS engine on Azure Stack Hub.
# Keyword: AKS engine support policies kubernetes cluster

---


# Support policies for AKS engine on Azure Stack Hub

This article provides details about technical support policies and limitations for AKS engine on Azure Stack Hub. The article also details Kubernetes Marketplace item, third-party open-source components, and security or patch management.

## Self-managed Kubernetes clusters on Azure Stack Hub with AKS engine

Infrastructure as a service (IaaS) cloud components, such as compute or networking components, give users access to low-level controls and customization options. AKS engine allows the user to lay down Kubernetes clusters utilizing these IaaS components transparently, so users can access and affect all aspects of their deployments.

When a cluster is created, the customer defines the Kubernetes masters and worker nodes that AKS engine creates. Customer workloads are executed on these nodes. Customers own and can view or modify the master and worker nodes. Carelessly modified nodes can cause losses of data and workloads and can render the cluster non-functional. Also, AKS engine operations such as Upgrade or Scale will overwrite any out-of-bound changes. For example, if the cluster has static pods, the pods will not be preserved after an AKS engine upgrade operation.

Because customer cluster nodes execute private code and store sensitive data, Microsoft Support can access them in only a limited way. Microsoft Support can't sign in to, execute commands in, or view logs for these nodes without express customer permission or assistance.

## Version support

AKS engine version support follows the pattern established by the rest of the Azure Stack Hub support policy: support of an AKS engine version on Azure Stack Hub is based on the n-2 formula. For example, if the latest version of AKS engine is v0.55.0, the set of supported versions are: 0.48.0, 0.51.0, 0.55.0. It's also important to follow the Azure Stack Hub update version and corresponding mapping to the AKS engine supported version; this mapping is maintained in the [AKS engine release notes](kubernetes-aks-engine-release-notes.md#aks-engine-and-azure-stack-version-mapping).

## AKS engine supported areas

Microsoft provides technical support for issues in the following areas:

-  Issues with AKS engine commands: deploy, generate, upgrade, and scale. The tool should be consistent with its behavior on Azure.
-  Issues with a Kubernetes cluster deployed following the [Overview of AKS engine](azure-stack-kubernetes-aks-engine-overview.md).
-  Issues with connectivity to other Azure Stack Hub services.
-  Issues with Kubernetes API connectivity.
-  Issues with Azure Stack Hub Kubernetes provider functionality and connectivity with Azure Resource Manager.
-  Issues with the AKS engine-generated configuration of Azure Stack Hub native artifacts such as load balancers, Network Security Groups, VNETs, subnets, network interfaces, route tables, availability sets, public IP addresses, storage accounts, and VMs.
-  Issues with network performance and latency. ASK engine on Azure Stack Hub can use the kubenet networking plugin and the Azure CNI networking plugin.
-  Issues with the AKS base image used by AKS engine in disconnected deployments.

## AKS engine areas not supported

Microsoft does not provide technical support for the following areas:

-  Using AKS engine on Azure.
-  Azure Stack Hub Kubernetes Marketplace item.
-  Using the following AKS engine cluster definition options and add-ins.
    -  Not supported add-ins:  
            -  Azure AD Pod Identity  
            -  ACI Connector  
            -  Blobfuse Flex Volume  
            -  Cluster Autoscaler  
            -  Container Monitoring  
            -  KeyVault Flex Volume  
            -  NVIDIA Device Plugin  
            -  Rescheduler  
            -  SMB Flex Volume  
        
    -  Not supported cluster definition options:  
            -  Under KubernetesConfig:  
                    -  cloudControllerManagerConfig  
                    -  enableDataEncryptionAtRest  
                    -  enableEncryptionWithExternalKms  
                    -  enablePodSecurityPolicy  
                    -  etcdEncryptionKey  
                    -  useInstanceMetadata  
                    -  useManagedIdentity  
                    -  azureCNIURLLinux  
                    -  azureCNIURLWindows  
            -  Under masterProfile:  
                    -  availabilityZones  
            -  Under agentPoolProfiles:  
                    -  availabilityZones  
                    -  singlePlacementGroup  
                    -  scaleSetPriority  
                    -  scaleSetEvictionPolicy  
                    -  acceleratedNetworkingEnabled  
                    -  acceleratedNetworkingEnabledWindows

-  Kubernetes configuration changes persisted outside the Kubernetes configuration store etcd. For example, static pods running in nodes of the cluster.
-  Questions about how to use Kubernetes. For example, Microsoft Support doesn't provide advice on how to create custom ingress controllers, use application workloads, or apply third-party or open-source software packages or tools.
-  Third-party open-source projects that aren't provided as part of the Kubernetes cluster deployed by AKS engine. These projects might include Kubeadm, Kubespray, Native, Istio, Helm, Envoy, or others.
-  Third-party software. This software can include security scanning tools and networking devices or software.
-  Issues about multicloud or multivendor build-outs. For example, Microsoft doesn't support issues related to running a federated multipublic cloud vendor solution.
-  Network customizations other than those listed in [AKS engine supported areas](#aks-engine-supported-areas).
-  Production environments should only use highly available Kubernetes clusters, that is, clusters deployed with a minimum of three masters and three agent nodes. Anything less cannot be supported in production deployments.

##  Security issues and patching

If a security flaw is found in one or more components of AKS engine or Kubernetes provider for Azure Stack Hub, Microsoft will make available a patch for customers to patch affected clusters to mitigate the issue. Alternatively, the team will give users upgrade guidance. Notice that patches may require downtime of the cluster. When reboots are required, Microsoft will notify the customers of this requirement. If users don't apply the patches according to Microsoft guidance, their cluster will continue to be vulnerable to the security issue.

## Kubernetes marketplace item

Users can download a Kubernetes Marketplace item, which allows users to deploy Kubernetes clusters using AKS engine indirectly through a template in the Azure Stack Hub user portal. This makes it simpler than using AKS engine directly. The Kubernetes Marketplace item is a useful tool to quickly set up clusters for demonstrations, testing, and development. This tool is not intended for production, so it is not included in the set of items supported by Microsoft.

## Preview features

For features and functionality that require extended testing and user feedback, Microsoft releases new preview features or features behind a feature flag. Consider these features as prerelease or beta features.

Preview features or feature-flag features aren't meant for production. Ongoing functionality changes and behavior, bug fixes, and other changes can result in unstable clusters and downtime. These features are not supported by Microsoft.

## Next steps

- Read about the [AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-overview.md)