---
title: Update AKS on Azure Stack HCI and Windows Server
description: Learn how to update AKS certificates on Azure Stack HCI and Windows Server
author: sethmanheim
ms.topic: how-to
ms.date: 06/15/2022
ms.author: sethm 
ms.lastreviewed: 06/15/2022
ms.reviewer: rbaziwane

# Intent: As an IT pro, I want to update my certificates so that my Kubernetes cluster continues to operate.
# Keyword: certificates cluster 

---

# Update certificates in AKS on Azure Stack HCI and Windows Server

Azure Kubernetes Service (AKS) on Azure Stack HCI and Windows Server uses monthly upgrades to rotate any internal certificates and tokens that cannot be auto-rotated during normal operation of the cluster. During this process, token validity is set to 90 days from the date that a user upgraded.

Microsoft recommends that you update your clusters within 60 days of a new release, not only for ensuring that internal certificates and tokens are kept up to date, but also to make sure that you get access to new features, bug fixes, and stay up to date with critical security patches.

The cloud agent service that is responsible for the underlying orchestration in AKS on Azure Stack HCI and Windows Server requires that clients that it communicates with [have valid certificates and tokens](certificates-and-tokens.md) in order to exchange data.

## Update management cluster certificates and tokens

To update tokens and certificates for all clients in the  management cluster, including NodeAgent, KVA, KMS, CloudOperator, CSI, CertManager, CAPH, and CloudProvider, open a new PowerShell window and run the following cmdlet:

```powershell
Update-AksHciCertificates
```

## Update workload cluster certificates and tokens

To update tokens and certificates of all clients in a target cluster, including KMS, CSI, CertManager, and CloudProvider, open a new PowerShell window and run the following cmdlet:

```powershell
Update-AksHciClusterCertificates -fixCloudCredentials
```

## Rotate the CA certificates

To rotate the CA certificates, open a new PowerShell window and run the following cmdlet:

```powershell
Invoke-AksHciRotateCACertificate
```

The CA certificate will be valid for 1 year before you must renew it.

## Next steps

[Certificates and tokens in Azure Kubernetes Service on Azure Stack HCI and Windows Server](certificates-and-tokens.md)