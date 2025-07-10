---
title: Use the template validation tool in Azure Stack Hub 
description: Check templates for deployment to Azure Stack Hub with a template validation tool.
author: sethmanheim
ms.topic: how-to
ms.date: 03/06/2025
ms.author: sethm
ms.lastreviewed: 10/27/2021

# Intent: As an Azure Stack user, I want to use the template validation tool so I can see if my templates are ready to deploy.
# Keyword: azure stack template validation tool

---

# Use the template validation tool in Azure Stack Hub

Check your [Azure Resource Manager templates](azure-stack-arm-templates.md) with the template validation tool. The tool checks if your template is ready to deploy to Azure Stack Hub. You can get the validation tool from the [Azure Stack Hub tools GitHub repo](../operator/azure-stack-powershell-download.md).

> [!NOTE]  
> The tool validates the Azure Resource Manager template for supported resource types and API versions in Azure Stack. However, the tool doesn't validate the properties supported for each resource type.

## Overview

To validate a template, you must first build a cloud capabilities file, and then run the validation tool. Use the following PowerShell modules from Azure Stack Hub tools:

- In the **CloudCapabilities** folder: **Az.CloudCapabilities.psm1** creates a cloud capabilities JSON file representing the services and versions in an Azure Stack Hub cloud.
- In the **TemplateValidator** folder: **Az.TemplateValidator.psm1** uses a cloud capabilities JSON file to test templates for deployment in Azure Stack Hub.

## Build the cloud capabilities file

Before you use the template validator, run the **Az.CloudCapabilities** PowerShell module to build a JSON file.

> [!NOTE]
> If you update your integrated system, or add any new services or virtual extensions, you should run this module again.

### [Az modules](#tab/az1)

1. Make sure you have connectivity to Azure Stack Hub. These steps can be done from a VPN to connect from your workstation.
1. Import the **Az.CloudCapabilities** PowerShell module:

   ```powershell
   Import-Module .\CloudCapabilities\Az.CloudCapabilities.psm1
   ```

1. Use the `Get-CloudCapabilities` cmdlet to retrieve service versions and create a cloud capabilities JSON file. If you don't specify `-OutputPath`, the file **AzureCloudCapabilities.json** is created in the current directory. Use your actual Azure location:

   ```powershell
   Get-AzCloudCapability -Location <your location> -Verbose
   ```

### [AzureRM modules](#tab/azurerm1)

1. Make sure you have connectivity to Azure Stack Hub. These steps can be done from a VPN to connect from your workstation.
1. Import the **AzureRM.CloudCapabilities** PowerShell module:

   ```powershell
   Import-Module .\CloudCapabilities\AzureRM.CloudCapabilities.psm1
   ```

1. Use the `Get-CloudCapabilities` cmdlet to retrieve service versions and create a cloud capabilities JSON file. If you don't specify `-OutputPath`, the file **AzureCloudCapabilities.json** is created in the current directory. Use your actual Azure location:

   ```powershell
   Get-AzureRMCloudCapability -Location <your location> -Verbose
   ```

---

## Validate templates

Use these steps to validate templates by using the **Az.TemplateValidator** PowerShell module. You can use your own templates, or use the [Azure Stack Hub Quickstart templates](https://github.com/Azure/AzureStack-QuickStart-Templates).

### [Az modules](#tab/az2)

1. Import the **Az.TemplateValidator.psm1** PowerShell module:

   ```powershell
   cd "c:\AzureStack-Tools-az\TemplateValidator"
   Import-Module .\Az.TemplateValidator.psm1
   ```

1. Run the template validator:

   ```powershell
   Test-AzTemplate -TemplatePath <path to template.json or template folder> `
   -CapabilitiesPath <path to cloudcapabilities.json> `
   -Verbose
   ```

### [AzureRM modules](#tab/azurerm2)

1. Import the **AzureRM.TemplateValidator.psm1** PowerShell module:

   ```powershell
   cd "c:\AzureStack-Tools-az\TemplateValidator"
   Import-Module .\AzureRM.TemplateValidator.psm1
   ```

1. Run the template validator:

   ```powershell
   Test-AzureRMTemplate -TemplatePath <path to template.json or template folder> `
   -CapabilitiesPath <path to cloudcapabilities.json> `
   -Verbose
   ```

---

The validator displays template validation warnings or errors in the PowerShell console and writes them to an HTML file in the source directory. The following screenshot is an example of a validation report:

![Template validation report](./media/azure-stack-validate-templates/image1.png)

### Parameters

The template validator cmdlet supports the following parameters.

| Parameter | Description | Required |
| ----- | -----| ----- |
| `TemplatePath` | Specifies the path to recursively find Azure Resource Manager templates. | Yes |
| `TemplatePattern` | Specifies the name of template files to match. | No |
| `CapabilitiesPath` | Specifies the path to the cloud capabilities JSON file. | Yes |
| `IncludeComputeCapabilities` | Includes evaluation of IaaS resources, such as VM sizes and VM extensions. | No |
| `IncludeStorageCapabilities` | Includes evaluation of storage resources, such as SKU types. | No |
| `Report` | Specifies the name of the generated HTML report. | No |
| `Verbose` | Logs errors and warnings to the console. | No|

### Examples

This example validates all the [Azure Stack Hub Quickstart templates](https://github.com/Azure/AzureStack-QuickStart-Templates) downloaded to local storage.

### [Az modules](#tab/az3)

```powershell
test-AzTemplate -TemplatePath C:\AzureStack-Quickstart-Templates `
-CapabilitiesPath .\TemplateValidator\AzureStackCloudCapabilities_with_AddOns_20170627.json `
-TemplatePattern MyStandardTemplateName.json `
-IncludeComputeCapabilities `
-Report TemplateReport.html
```

### [AzureRM modules](#tab/azurerm3)

```powershell
test-AzureRMTemplate -TemplatePath C:\AzureStack-Quickstart-Templates `
-CapabilitiesPath .\TemplateValidator\AzureStackCloudCapabilities_with_AddOns_20170627.json `
-TemplatePattern MyStandardTemplateName.json `
-IncludeComputeCapabilities `
-Report TemplateReport.html
```

---

## Next steps

- [Deploy templates to Azure Stack Hub](azure-stack-arm-templates.md)
- [Develop templates for Azure Stack Hub](azure-stack-develop-templates.md)
