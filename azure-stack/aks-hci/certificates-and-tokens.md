---
title: Certificates and tokens in Azure Kubernetes Service on Azure Stack HCI and Windows Server 
description: Learn how to use certificates and tokens in Azure Kubernetes Service on Azure Stack HCI and Windows Server 
author: mattbriggs
ms.topic: conceptual
ms.date: 05/26/2022
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: rbaziwane

# Intent: As an IT Pro, I want to learn how to use SSH to connect to my Windows and Linux worker nodes when I need to perform maintenance and troubleshoot issues. 
# Keyword: SSH connection maintenance worker nodes

---

# Certificates and tokens in Azure Kubernetes Service on Azure Stack HCI and Windows Server

The cloud agent service in  Azure Kubernetes Service on Azure Stack HCI and Windows Server is responsible for underlying orchestration of other services. There are many services that communicate with cloud agent, including:
 
 - **Mocctl** - This is an admin service with ultimate access to the cloudagent.
 - **Node agent** - Service on each node that does actual work that is VM creation, and so on.
 - **Kva** - Kubernetes Virtual Appliance, sometimes called the management cluster.
 - **KMS pod** - Key Management Service pod.
 - **Others** - CAPH, Cloud Operator, Certificate Manager, CSI.

## Service identity

To communicate with the cloud agent service, each service requires an identity to be associated with it. This identity defines the Role Based Access Control (RBAC) rules associated with the service. Each identity consists of two entities:
 
 - **A token** - Used for initial authentication, which returns a certificate.
 - **A certificate** - The certificate obtained from the above sign-in process is used for authentication in any communication.
 
Each entity is valid for a specific period of time that is 90 days, at the end of which it expires. For continued access to the cloud agent service, each service requires the certificate to be renewed and the token rotated.
 
Currently, not all services in Azure Kubernetes Service on Azure Stack HCI and Windows Server automatically renew their respective certificates or rotate their tokens. Services that automatically renew the certificate or rotate the tokens are currently doing the auto-rotation and auto-renewal on a frequent basis. 
 
For services that don't have the capability to automatically renew the certificate, there's need to sign in again using a token to continue access. Sometimes these services don't have a valid token and hence require manual rotation of the token. Azure Kubernetes Service on Azure Stack HCI and Windows Server uses the monthly upgrade process to rotate any tokens that can't be auto rotated. During this process, Azure Kubernetes Service on Azure Stack HCI and Windows Server checks that token and certificate validity is set to 90 days from the date that a customer upgraded.
 
Starting with the April 2022 update, Azure Kubernetes Service on Azure Stack HCI and Windows Server changes the default validity period to **90-days**. Azure Kubernetes Service on Azure Stack HCI and Windows Server noticed a growing number of customers who are unable to perform upgrades (and have tokens rotated) within the old 60-day window. The most observable issue that these customers ran into was failure to perform cluster operations when the customer eventually attempted to perform the upgrade. You needed to contact Microsoft support to upgrade the clusters.

## Next steps

- Learn about [Update certificates on AKS on Azure Stack HCI and Windows Server after 60 days](certificates-update-after-sixty-days.md)
- Learn about [Security in AKS on Azure Stack HCI and Windows Server](concepts-security.md)
- Learn about [Secure communication with certificates](secure-communication.md).