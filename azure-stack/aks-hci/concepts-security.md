---
title: Concepts - Securing the infrastructure and applications on a Kubernetes cluster for Azure Kubernetes Services (AKS) on Azure Stack HCI
description: Learn about securing the infrastructure and applications on a Kubernetes cluster in AKS on Azure Stack HCI.
author: lahirisl
ms.topic: conceptual
ms.date: 05/05/2021
ms.author: v-susbo
---

# Security concepts
Security in AKS on Azure Stack HCI involves securing the infrastructure and the applications running on the Kubernetes cluster. This topic covers the security hardening applied to AKS on Azure Stack HCI and its built-in security features.

## Infrastructure security
AKS on Azure Stack HCI applies various security measures to secure its infrastructure. The following diagram highlights these security measures:

![Illustrates the infrastructure security of Azure Kubernetes Service on Azure Stack HCI](.\media\concepts\security-infrastructure.png)

The table below describes the security hardening aspects of AKS on Azure Stack HCI that are shown in the above diagram. For conceptual background information on AKS on Azure Stack HCI infrastructure, see [clusters and workloads](./kubernetes-concepts.md). 

| Security aspect |  Description  |
| ------  | --------|
| 1  | The management cluster has access to all of the target clusters and could be single point of compromise. However, access to the  management cluster is carefully controlled as the management cluster's purpose is limited to provisioning target clusters and collecting aggregated cluster metrics. |
| 2 | To reduce deployment cost and complexity, target clusters share the underlying Windows Server. However, depending on the security needs, admins can chose to deploy a target cluster on a dedicated Windows Server. When target clusters share the underlying Windows Server, each target cluster is deployed as a virtual machine which ensures strong isolation guarantees between the target clusters. |
| 3 |  Customer workloads are deployed as containers and share the same virtual machine. The containers are process-isolated from one another, which is a weaker form of isolation compared to strong isolation guarantees offered by virtual machines.  |
| 4 | Containers communicate with each other over an overlay network. Admins can configure Calico policies to define networking isolation rules between containers. [Calico](./calico-networking-policy.md) is an open-source product that is supported as-is, and it supports both Windows and Linux containers.   |
 5 | Communication between built-in Kubernetes components of AKS on Azure Stack HCI, including communication between the API server and the container host, is encrypted via certificates. AKS on Azure Stack HCI offers an out-of-the-box certificate provisioning, renewal, and revocation for built-in certificates.    |
 6 | Communication with the API server from Windows client machines are secured using AD credentials for users.  |
 7 | The VHDs for AKS on Azure Stack HCI VMs are provided by Microsoft in every release and appropriate security patches are always applied.  |

## Application security
The table below describes the various application security options available in AKS on Azure Stack HCI. However, you can still use open source application hardening options available in the open source ecosystem. 

| Option |  Description  |
| ------- | -----------|
| Build security | The goal for securing builds is to prevent vulnerabilities from being injected in the application code and the container images when the images are generated. Integration with Azure GitOps of Arc enabled Kubernetes helps with analysis and observation, allowing developers the opportunity to fix security issues. For more information, see [Deploy configurations using GitOps on an Azure Arc enabled Kubernetes cluster](https://docs.microsoft.com/azure/azure-arc/kubernetes/tutorial-use-gitops-connected-cluster).  |
| Container registry security| The goal for container registry security is to ensure vulnerabilities are not introduced when uploading container images into the registry, while the image is stored in the registry, and during image downloads from the registry. AKS on Azure Stack HCI recommends using Azure Container Registry (ACR). ACR comes with vulnerability scanning and other security features. See the [Azure Container Registry documentation](https://docs.microsoft.com/azure/container-registry/) for more information.  |
| AD identities for Windows workloads using gMSA for containers | Windows container workloads can inherit the identity of the container host and use that for authentication. With new enhancements, container host doesn’t need to be domain joined. |

## Security built-in features
The security built-in features that are currently available in AKS on Azure Stack HCI are listed in the table below. 

|  Security objective  |   Feature  |
|-----------   |  --------- |
| Protect access to API server.  | [Active Directory single sign-in](./ad-sso.md) support for PowerShell and WAC clients. This feature is currently enabled only for target clusters.  |
|  Ensure all communication between built-in Kubernetes components of the control plane, which includes ensuring that communication between the API server and target cluster is secure.| Zero touch built-in certificate solution to provision, renew, and revoke certificates. To learn more, see [Secure communication with certificates](./secure-communication.md). | 
| Rotate encryption keys of the Kubernetes secret store (etcd) using the Key Management Server (KMS) plug-in. | Plug-in for integrating and orchestrating key rotation with specified KMS provider. To learn more, see [Encrypt etcd secrets](./encrypt-secrets.md). |
| Real time threat monitoring for containers and support are workloads on both Windows and Linux containers.  | Integration with Azure Defender for Arc enabled Kubernetes, which is offered as a public preview feature until the GA release of Kubernetes threat detection for Azure Arc enabled Kubernetes. For more information, see [Defend Azure Arc enabled Kubernetes clusters](https://docs.microsoft.com/azure/security-center/defender-for-kubernetes-azure-arc?tabs=k8s-deploy-asc%2Ck8s-verify-asc%2Ck8s-remove-arc). |
| AD identity for Windows workloads.  | This is enabled with [gMSA integration for Windows workloads](./prepare-windows-nodes-gmsa.md). |
| Support for Calico policies to secure traffic between pods  | To use Calico policies, see [Secure traffic between pods using network policies](./calico-network.ing-policy.md). |