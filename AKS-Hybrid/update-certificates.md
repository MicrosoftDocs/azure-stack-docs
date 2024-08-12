---
title: Update certificates in AKS enabled by Azure Arc
description: Learn how to update certificates in AKS enabled by Arc.
author: sethmanheim
ms.topic: conceptual
ms.date: 07/03/2024
ms.author: sethm 
ms.lastreviewed: 04/01/2023
ms.reviewer: sulahiri

# Intent: As an IT Pro, I want to learn how to update certificates to secure communication between in-cluster components on my AKS deployment.
# Keyword: control plane nodes secure communication certificate revocation

---

# Update certificates in AKS enabled by Azure Arc

[!INCLUDE [aks-hybrid-applies-to-azure-stack-hci-windows-server-sku](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

AKS Arc certificate management covers two layers of the stack. First, the infrastructure layer brings up AKS clusters on Windows Server or HCI nodes. This is referred to as the *MOC* (Microsoft On-premises Cloud) layer. The second layer is the AKS Kubernetes layer. This includes the Kubernetes infrastructure certificates auto-provisioned as part of the cluster bootstrapping.

The behavior of the certificates at the MOC layer and AKS Kubernetes layer has a few differences depending on two factors: cluster shutdown and cluster updates.

## Certificate renewal dependencies on cluster shutdown

|             Shutdown                        |     MOC certificates    |   AKS enabled by Arc Kubernetes certificates    |
|-------------------------------------|---------------------------|---------------------------------------------|
|     Shutdown less than 30 days    |     Not impacted          |     Impacted                                |
|     Shutdown more than 30 days    |     Impacted              |     Impacted                                |

## Certificate renewal dependencies on cluster renewal

|              Cluster                               |     MOC certificates    |   AKS enabled by Arc Kubernetes certificates    |
|---------------------------------------------|---------------------------|---------------------------------------------|
|     Cluster updated within 90 days        |     Not impacted          |     Not impacted                            |
|     Cluster not updated within 90 days    |     Not impacted          |     Not impacted                            |

## Commands for fixing certificates

|              Cluster          |     MOC certificates                                                                 |     AKS enabled by Arc Kubernetes Control plane certificates                            |
|------------------------|-------------------------------------------------------------------------------|---------------------------------------------------------------------------------|
|     Management cluster      |     [`Update-AksHciCertificates`](reference/ps/update-akshcicertificates.md)                                                 |     N/A                                                                         |
|     Target cluster    |     [`Update-AksHciClusterCertificates -name -fixCloudCredentials`](reference/ps/update-akshciclustercertificates.md)    |     [`Update-AksHciClusterCertificates -name -fixKubeletCredentials`](reference/ps/update-akshciclustercertificates.md)    |
|     Load balancer    |     [`Update-AksHciClusterCertificates -name -patchLoadBalancer -fixCloudCredentials`](reference/ps/update-akshciclustercertificates.md)    |

## When both MOC and AKS Kubernetes certificates are impacted

When the cluster has been shut down for more than 30 days, run the following commands in the following sequence:

1. `Update-AksHciCertificates` (to fix management cluster certificates).
1. `Update-AksHciClusterCertificates –fixkubeletcredentials` (to fix target cluster control plane certificates).
1. `Update-AksHciClusterCertificates –fixcloudcredentials` (to fix target cluster MOC certificates).

## Next steps

- [Certificates overview](certificates-overview.md)
- [Update-AksHciCertificates](reference/ps/update-akshcicertificates.md)
- [Update-AksHciClusterCertificates](reference/ps/update-akshciclustercertificates.md)
