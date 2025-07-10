---
title: Identity architecture for Azure Stack Hub 
description: Learn about identity architecture for Azure Stack Hub, and the differences between Microsoft Entra ID and AD FS.
author: sethmanheim
ms.topic: article
ms.date: 03/21/2022
ms.author: sethm
ms.reviewer: fiseraci
ms.lastreviewed: 03/21/2022

# Intent: As an Azure Stack operator, I want to know about identity architecture, and the differences between Microsoft Entra ID and AD FS.
# Keyword: azure stack identity architecture

---


# Identity architecture for Azure Stack Hub

When choosing an identity provider to use with Azure Stack Hub, you should understand the important differences between the options of Microsoft Entra ID and Active Directory Federation Services (AD FS).

## Capabilities and limitations

The identity provider that you choose can limit your options, including support for multi-tenancy.

|Capability or scenario        |Microsoft Entra ID  |AD FS  |
|------------------------------|----------|-------|
|Connected to the internet     |Yes       |Optional|
|Support for multi-tenancy     |Yes       |No      |
|Offer items in the Marketplace |Yes       |Yes (requires use of the [offline Marketplace Syndication](azure-stack-download-azure-marketplace-item.md?pivots=state-disconnected) tool)|
|Support for Active Directory Authentication Library (ADAL) |Yes |Yes|
|Support for tools such as Azure CLI, Visual Studio, and PowerShell  |Yes |Yes|
|Create service principals through the Azure portal     |Yes |No|
|Create service principals with certificates      |Yes |Yes|
|Create service principals with secrets (keys)    |Yes |Yes|
|Applications can use the Graph service           |Yes |No|
|Applications can use identity provider for sign-in |Yes |Yes (requires apps to federate with on-premises AD FS instances) |
| Managed identities | No | No |

## Topologies

The following sections discuss the different identity topologies that you can use.

<a name='azure-ad-single-tenant-topology'></a>

### Microsoft Entra ID: single-tenant topology

By default, when you install Azure Stack Hub and use Microsoft Entra ID, Azure Stack Hub uses a single-tenant topology.

A single-tenant topology is useful when:
- All users are part of the same tenant.
- A service provider hosts an Azure Stack Hub instance for an organization.

![Azure Stack Hub single-tenant topology with Microsoft Entra ID](media/azure-stack-identity-architecture/single-tenant.svg)

This topology features the following characteristics:

- Azure Stack Hub registers all apps and services to the same Microsoft Entra tenant directory.
- Azure Stack Hub authenticates only the users and apps from that directory, including tokens.
- Identities for administrators (cloud operators) and tenant users are in the same directory tenant.
- To enable a user from another directory to access this Azure Stack Hub environment, you must [invite the user as a guest](azure-stack-identity-overview.md#guest-users) to the tenant directory.

<a name='azure-ad-multi-tenant-topology'></a>

### Microsoft Entra ID: multi-tenant topology

Cloud operators can configure Azure Stack Hub to allow access to apps by tenants from one or more organizations. Users access apps through the Azure Stack Hub user portal. In this configuration, the administrator portal (used by the cloud operator) is limited to users from a single directory.

A multi-tenant topology is useful when:

- A service provider wants to allow users from multiple organizations to access Azure Stack Hub.

![Azure Stack Hub multi-tenant topology with Microsoft Entra ID](media/azure-stack-identity-architecture/multi-tenant.svg)

This topology features the following characteristics:

- Access to resources should be on a per-organization basis.
- Users from one organization should be unable to grant access to resources to users who are outside their organization.
- Identities for administrators (cloud operators) can be in a separate directory tenant from the identities for users. This separation provides account isolation at the identity provider level.
 
### AD FS

The AD FS topology is required when either of the following conditions is true:

- Azure Stack Hub doesn't connect to the internet.
- Azure Stack Hub can connect to the internet, but you choose to use AD FS for your identity provider.
  
![Azure Stack Hub topology using AD FS](media/azure-stack-identity-architecture/adfs.svg)

This topology features the following characteristics:

- To support the use of this topology in production, you must integrate the built-in Azure Stack Hub AD FS instance with an existing AD FS instance that's backed by Active Directory, through a federation trust.
- You can integrate the Graph service in Azure Stack Hub with your existing Active Directory instance. You can also use the OData-based Graph API service that supports APIs that are consistent with the Azure AD Graph API.

  To interact with your Active Directory instance, the Graph API requires a user credential with read-only permission to your Active Directory instance, and accesses:  
  - The built-in AD FS instance.
  - Your AD FS and Active Directory instances, which must be based on Windows Server 2012 or later.
  
  Between your Active Directory instance and the built-in AD FS instance, interactions aren't restricted to OpenID Connect, and they can use any mutually supported protocol.
  - User accounts are created and managed in your on-premises Active Directory instance.
  - Service principals and registrations for apps are managed in the built-in Active Directory instance.

## Next steps

- [Identity overview](azure-stack-identity-overview.md)
- [Datacenter integration - identity](azure-stack-integrate-identity.md)
