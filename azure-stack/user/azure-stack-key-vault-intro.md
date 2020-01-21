---
title: Introduction to Key Vault in Azure Stack Hub | Microsoft Docs
description: Learn how Key Vault manages keys and secrets in Azure Stack Hub.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.assetid: 70f1684a-3fbb-4cd1-bf29-9f9882e98fe9
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: conceptual
ms.date: 10/01/2019
ms.author: sethm
ms.lastreviewed: 05/21/2019

---

# Introduction to Key Vault in Azure Stack Hub

## Prerequisites

* Subscribe to an offer that includes the Azure Key Vault service.  
* PowerShell is installed and [configured for use with Azure Stack Hub](azure-stack-powershell-configure-user.md).

## Key Vault basics

Key Vault in Azure Stack Hub helps safeguard cryptographic keys and secrets that cloud apps and services use. By using Key Vault, you can encrypt keys and secrets, such as:

* Authentication keys
* Storage account keys
* Data encryption keys
* .pfx files
* Passwords

Key Vault streamlines the key management process and enables you to maintain control of keys that access and encrypt your data. Developers can create keys for development and testing in minutes, and then seamlessly migrate them to production keys. Security admins can grant (and revoke) permissions to keys as needed.

Anybody with an Azure Stack Hub subscription can create and use key vaults. Although Key Vault benefits developers and security administrators, the operator who manages other Azure Stack Hub services for an organization can implement and manage it. For example, the Azure Stack Hub operator can sign in with an Azure Stack Hub subscription and create a vault for the organization in which to store keys. Once that's done, they can:

* Create or import a key or secret.
* Revoke or delete a key or secret.
* Authorize users or apps to access the key vault so they can then manage or use its keys and secrets.
* Configure key usage (for example, sign or encrypt).

The operator can then provide developers with Uniform Resource Identifiers (URIs) to call from their apps. Operators can also provide security admins with key-usage logging info.

Developers can also manage the keys directly by using APIs. For more info, see the [Key Vault developer's guide](/azure/key-vault/key-vault-developers-guide).

## Scenarios

The following scenarios describe how Key Vault can help meet the needs of developers and security admins.

### Developer for an Azure Stack Hub app

**Problem:** I want to write an app for Azure Stack Hub that uses keys for signing and encryption. I want these keys to be external from my app so that the solution is suitable for an app that is geographically distributed.

**Statement:** Keys are stored in a vault and invoked by a URI when needed.

### Developer for software as a service (SaaS)

**Problem:** I don't want the responsibility or potential liability for my customer's keys and secrets. I want customers to own and manage their keys so that I can concentrate on doing what I do best, which is providing the core software features.

**Statement:** Customers can import and manage their own keys in Azure Stack Hub.

### Chief Security Officer (CSO)

**Problem:** I want to make sure that my organization is in control of the key lifecycle and can monitor key usage.

**Statement:** Key Vault is designed so that Microsoft does not see or extract your keys. When an app needs to perform cryptographic operations by using customer keys, Key Vault uses the keys on behalf of the app. The app does not see the customer keys. Although we use multiple Azure Stack Hub services and resources, you can manage the keys from a single location in Azure Stack Hub. The vault provides a single interface, regardless of how many vaults you have in Azure Stack Hub, which regions they support, and which apps use them.

## Next steps

* [Manage Key Vault in Azure Stack Hub by the portal](azure-stack-key-vault-manage-portal.md)  
* [Manage Key Vault in Azure Stack Hub by using PowerShell](azure-stack-key-vault-manage-powershell.md)
