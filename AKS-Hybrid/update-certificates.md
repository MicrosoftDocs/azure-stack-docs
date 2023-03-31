---
title: Update certificates in AKS hybrid
description: Learn how to update certificates in AKS hybrid.
author: sethmanheim
ms.topic: concept
ms.date: 04/01/2023
ms.author: sethm 
ms.lastreviewed: 04/01/2023
ms.reviewer: sulahiri

# Intent: As an IT Pro, I want to learn how to update certificates to secure communication between in-cluster components on my AKS deployment.
# Keyword: control plane nodes secure communication certificate revocation

---

# Update certificates in AKS hybrid

AKS hybrid certificate management covers two layers of the stack. First, the infrastructure layer brings up AKS hybrid clusters on Windows Server or HCI nodes. This is referred to as the MOC (Microsoft On-premises Cloud) layer. The second layer is the AKS hybrid Kubernetes layer. This includes the Kubernetes infrastructure certificates auto-provisioned as part of the cluster bootstrapping.

The behavior of the certificates at the MOC layer and AKS hybrid Kubernetes layer has a few differences depending on two factors: cluster shutdown and cluster updates.

## Certificate renewal dependencies on cluster shutdown

|                                     |     MOC certificates    |   AKS hybrid Kubernetes certificates    |
|-------------------------------------|---------------------------|---------------------------------------------|
|     Shutdown less than 30 days    |     Not impacted          |     Impacted                                |
|     Shutdown more than 30 days    |     Impacted              |     Impacted                                |

## Certificate renewal dependencies on cluster renewal

|                                             |     MOC certificates    |   AKS hybrid Kubernetes certificates    |
|---------------------------------------------|---------------------------|---------------------------------------------|
|     Cluster updated within 90 days        |     Not impacted          |     Not impacted                            |
|     Cluster not updated within 90 days    |     Not impacted          |     Not impacted                            |

## Commands for fixing certificates

|                        |     MOC certificates                                                                 |     AKS hybrid Kubernetes Control plane certificates                            |
|------------------------|-------------------------------------------------------------------------------|---------------------------------------------------------------------------------|
|     Management cluster      |     [`Update-AksHciCertificates`](reference/ps/update-akshcicertificates.md)                                                 |     N/A                                                                         |
|     Target cluster    |     [`Update-AksHciClusterCertificates -name fixCloudCredentials -force`](reference/ps/update-akshciclustercertificates.md)    |     [`Update-AksHciClusterCertificates -name fixKubeletCredentials -force`](reference/ps/update-akshciclustercertificates.md)    |

## Next steps

- [Certificates overview](certificates-overview.md)
- [Update-AksHciCertificates](reference/ps/update-akshcicertificates.md)
- [Update-AksHciClusterCertificates](reference/ps/update-akshciclustercertificates.md)
