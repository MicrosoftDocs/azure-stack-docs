---
title: Download Azure Stack Hub tools from GitHub 
description: Learn how to download tools required for working with Azure Stack Hub.
author: sethmanheim
ms.topic: how-to
ms.date: 03/06/2025
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 10/16/2020

# Intent: As an Azure Stack operator, I want to download Azure Stack tools from GitHub so I can use them in Azure Stack.
# Keyword: download azure stack tools

---


# Download Azure Stack Hub tools from GitHub

**AzureStack-Tools** is a [GitHub repository](https://github.com/Azure/AzureStack-Tools) that hosts PowerShell modules for managing and deploying resources to Azure Stack Hub. If you plan to establish VPN connectivity, you can download these PowerShell modules to a Windows-based external client.

[!INCLUDE [Azure Stack Hub Operator Access Workstation](../includes/operator-note-owa.md)]

## Get the tools

You use the tools using the Az PowerShell modules, or the AzureRM modules.

### [Az modules](#tab/az)

To get these tools, clone the GitHub repository from the `az` branch or download the **AzureStack-Tools** folder by running the following script:

```powershell
# Change directory to the root directory.
cd \

# Download the tools archive.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
invoke-webrequest `
  https://github.com/Azure/AzureStack-Tools/archive/az.zip `
  -OutFile az.zip

# Expand the downloaded files.
expand-archive az.zip `
  -DestinationPath . `
  -Force

# Change to the tools directory.
cd AzureStack-Tools-az

```

### [AzureRM modules](#tab/azurerm)

To get these tools, clone the GitHub repository from the `master` branch or download the **AzureStack-Tools** folder by running the following script in an elevated PowerShell prompt:

```powershell
# Change directory to the root directory.
cd \

# Download the tools archive.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
invoke-webrequest `
  https://github.com/Azure/AzureStack-Tools/archive/master.zip `
  -OutFile master.zip

# Expand the downloaded files.
expand-archive master.zip `
  -DestinationPath . `
  -Force

# Change to the tools directory.
cd AzureStack-Tools-master

```
For more information about using the AzureRM module for Azure Stack Hub, see [Install PowerShell AzureRM module for Azure Stack Hub](azure-stack-powershell-install.md)

---

## Functionality provided by the modules

The **AzureStack-Tools** repository has PowerShell modules that support the following functionalities for Azure Stack Hub:  

| Functionality | Description | Who can use this module? |
| --- | --- | --- |
| [CapacityManagement](azure-stack-manage-storage-shares.md) | Use this module to generate Performance and Capacity Dashboard of storage volumes. | Cloud operators|
| [Cloud capabilities](../user/azure-stack-validate-templates.md) | Use this module to get the cloud capabilities of a cloud. For example, you can get cloud capabilities like API version and Azure Resource Manager resources. You can also get the VM extensions for Azure Stack Hub and Azure clouds. | Cloud operators and users |
| [Resource Manager policy for Azure Stack Hub](../user/azure-stack-policy-module.md) | Use this module to configure an Azure subscription or an Azure resource group with the same versioning and service availability as Azure Stack Hub. | Cloud operators and users |
| [Register with Azure](azure-stack-registration.md ) | Use this module to register your Azure Stack Hub instance with Azure. After registering, you can download Azure Marketplace items and use them in Azure Stack Hub. | Cloud operators |
| [Connecting to Azure Stack Hub](azure-stack-powershell-configure-admin.md) | Use this module to configure VPN connectivity to Azure Stack Hub. | Cloud operators and users |
| [Template validator](../user/azure-stack-validate-templates.md) | Use this module to verify if an existing or a new template can be deployed to Azure Stack Hub. | Cloud operators and users|

## Next steps

- [Get started with PowerShell on Azure Stack Hub](../user/azure-stack-powershell-overview.md).
- [Configure the Azure Stack Hub user's PowerShell environment](../user/azure-stack-powershell-configure-user.md).
