---
title: Certificates and tokens in AKS hybrid
description: Learn how to repair AKS certificates in AKS hybrid.
author: sethmanheim
ms.topic: how-to
ms.date: 01/24/2023
ms.author: sethm 
ms.lastreviewed: 01/24/2023
ms.reviewer: rbaziwane

# Intent: As an IT pro, I want to update my certificates so that my Kubernetes cluster continues to operate.
# Keyword: certificates cluster 

---

# Update certificates in AKS hybrid

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

AKS hybrid uses a combination of certificate and token-based authentication to secure communication between services (or agents) responsible for different operations within the platform. Certificate-based authentication uses a digital certificate to identify an entity (agent, machine, user, or device) before granting access to a resource. AKS hybrid supports hybrid deployment options for Azure Kubernetes Service (AKS).<!--PLACEHOLDER: I drafted this AKS hybrid desription because the standard product name expansion doesn't work in this context.-->

## Cloud agent

When you deploy AKS hybrid, AKS installs agents that are used to perform various functions within the cluster. These agents include:

- Cloud agent: a service that is responsible for the underlying platform orchestration.
- Node agent: a service that resides on each node that does the actual work of virtual machine creation, deletion, etc.
- Key Management System (KMS) pod: a service responsible for key management.
- Other services - cloud operator, certificate manager, etc.

The cloud agent service in AKS hybrid is responsible for orchestrating the create, read, update, and delete (CRUD) operations of infrastructure components such as Virtual Machines (VMs), Virtual Network Interfaces (VNICs), and Virtual Networks (VNETs) in the cluster.

To communicate with the cloud agent, clients require certificates to be provisioned in order to secure this communication. Each client requires an identity to be associated with it, which defines the Role Based Access Control (RBAC) rules associated with the client. Each identity consists of two entities:

- A token, used for initial authentication, which returns a certificate, and
- A certificate, obtained from the above sign-in process, and used for authentication in any communication.

Each entity is valid for a specific period (the default is 90 days), at the end of which it expires. For continued access to the cloud agent, each client requires the certificate to be renewed and the token rotated.

## Certificate types

There are two types of certificates used in AKS hybrid:

- Cloud agent CA certificate: the certificate used to sign/validate client certificates. This certificate is valid for 365 days (1 year).
- Client certificates: certificates issued by the cloud agent CA certificate for clients to authenticate to the cloud agent. These certificates are usually valid for 90 days.

Currently, not all clients automatically renew their respective certificates or rotate tokens on a regular basis. Clients that automatically renew the certificate or rotate the tokens currently do the auto-rotation and auto-renewal on a frequent basis. Clients that don't have the capability to automatically renew the certificate must sign back in using a token to continue accessing the cloud agent. Sometimes these clients won't have a valid token and thus require manual rotation of the token.

Microsoft recommends that you update clusters within 60 days of a new release, not only for ensuring that internal certificates and tokens are kept up to date, but also to make sure that you get access to new features, bug fixes, and to stay up to date with critical security patches. During these monthly updates, the update process rotates any tokens that can't be auto-rotated during normal operations of the cluster. Certificate and token validity is reset to the default 90 days from the date that the cluster is updated.

Starting with the May 2022 update, customers who are unable to update within the 60-day window can still ensure that internal certificates and tokens are up to date by manually triggering the renew/rotation of these entities.

## Update management cluster certificates and tokens

To update tokens and certificates for all clients in the management cluster, including NodeAgent, KVA, KMS, CloudOperator, CSI, CertManager, CAPH, and CloudProvider, open a new PowerShell window and run the following cmdlet:

```powershell
Update-AksHciCertificates
```

## Update workload cluster certificates and tokens

Update certificates and rotate tokens for all clients in a target cluster, including KMS, CSI, CertManager, and CloudProvider by following these steps:

1. Open a PowerShell window and run the following command to repair kubelet certificates:

   ```powershell
   Update-AksHciClusterCertificates -Name <cluster name> -fixKubeletCredentials
   ```

2. Run the following command to repair the cloud operator certificates:

   ```powershell
   Update-AksHciClusterCertificates -Name <cluster name> -fixCloudCredentials
   ```

## Next steps

- [Security concepts in AKS hybrid](concepts-security.md)
- [Secure communication with certificates](secure-communication.md)
- [Certificates and tokens in AKS hybrid](/azure-stack/aks-hci/certificates-update-after-sixty-days)
