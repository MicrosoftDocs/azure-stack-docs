---
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: include
ms.date: 10/10/2020
ms.reviewer: bryanla
ms.lastreviewed: 10/10/2020
---

> [!NOTE]
> Secret rotation for value-add resource providers is currently only supported via PowerShell. 

Like the Azure Stack Hub infrastructure, value-add resource providers use both internal and external secrets. As a user, you provide external secrets including the X509 certificate used to secure resource provider endpoints.

Before you begin the rotation process:

1. If you haven't already, be sure to review [Azure Stack Hub public key infrastructure (PKI) certificate requirements](../operator/azure-stack-pki-certs.md#certificate-requirements) for important certificate prerequisite information. Also review the requirements specified in the [Optional PaaS certificates section](../operator/azure-stack-pki-certs.md#optional-paas-certificates), for your specific value-add resource provider.

2. You must use the PowerShell Az module for Azure Stack Hub for secret rotation, version 2.0.2-preview or later. If you have not already installed it, refer to [Install PowerShell Az module for Azure Stack Hub](../operator/powershell-install-az-module.md) before continuing. For more details, refer to [Migrate from AzureRM to Azure PowerShell Az in Azure Stack Hub](../operator/migrate-azurerm-az.md).
