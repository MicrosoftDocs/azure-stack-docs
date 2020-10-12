---
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: include
ms.date: 10/10/2020
ms.reviewer: bryanla
ms.lastreviewed: 10/20/2020
---

> [!NOTE]
> Secret rotation for value-add resource providers is currently only supported via PowerShell. 

Like the Azure Stack Hub infrastructure, value-add resource providers use both internal and external secrets. As an operator, you provide external secrets such as the SSL/TLS X509 certificate used to secure resource provider endpoints.

In preparation for the rotation process:

1. Review [Azure Stack Hub public key infrastructure (PKI) certificate requirements](../operator/azure-stack-pki-certs.md#certificate-requirements) for important prerequisite information before acquiring/renewing your X509 certificate, including details on the required PFX format. Also review the requirements specified in the [Optional PaaS certificates section](../operator/azure-stack-pki-certs.md#optional-paas-certificates), for your specific value-add resource provider.

2. If you haven't already, [Install PowerShell Az module for Azure Stack Hub](../operator/powershell-install-az-module.md) before continuing. Version 2.0.2-preview or later is required for Azure Stack Hub secret rotation. For more information, see [Migrate from AzureRM to Azure PowerShell Az in Azure Stack Hub](../operator/migrate-azurerm-az.md).
