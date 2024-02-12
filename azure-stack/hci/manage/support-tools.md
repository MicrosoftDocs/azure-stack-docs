---
title: Support tool for Azure Stack HCI (22H2)
description: This topic provides guidance on the Azure Stack HCI Support Diagnostic Tool for Azure Stack HCI, version 22H2.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 02/12/2024
---

# Support tool for Azure Stack HCI (22H2)

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2.md)]

This topic provides information on the Azure Stack HCI Support Diagnostic Tool, which is designed to help you troubleshoot and diagnose complex issues on Azure Stack HCI. The tool consists of a set of PowerShell commands that simplify troubleshooting, resolution, and data collection of common issues in Azure Stack HCI.

> [!NOTE]
> This tool is currently only available for Azure Stack HCI, version 22H2.

This tool is designed to simplify the support and troubleshooting process and is not a substitute for expert knowledge. If you encounter any issues, we recommend that you reach out to Microsoft Customer Support for assistance.

You can download the Azure Stack HCI Support Diagnostic Tool from the [PowerShell Gallery](https://www.powershellgallery.com/packages?q=hci).

## Benefits

The Azure Stack HCI Support Diagnostic Tool simplifies the support and troubleshooting process by providing simple commands that do not require any knowledge of the underlying product. This means that you can quickly get a first glance at what might be causing an issue, without needing to be an expert on the product. The tool currently offers the following features:

- **Easy installation and updates**: Can be installed and updated natively using PowerShell Gallery, without any additional requirements.

- **Diagnostic checks**: Offers diagnostic checks based on common issues, incidents, and telemetry data.

- **Automatic data collection**: Automatically collects important data in case you want to reach out to Microsoft Customer Support.

- **Regular updates**: Is regularly updated with new checks and useful commands to manage, troubleshoot, and diagnose issues on Azure Stack HCI.

## Prerequisites

Here are a couple things to be aware of to ensure the PowerShell module runs properly:

- You must import the module into an elevated PowerShell window by an account with administrator privileges on the local system.

- The module should be installed on each node of the Azure Stack HCI system.

## Installing and using the tool

To install the tool, run the following command in PowerShell:

```powershell
Install-Module –Name Microsoft.AzureStack.HCI.CSSTools
```

The following command is used to list all diagnostic checks that are available. You can check all diagnostic checks by pressing `CTRL+SPACE` after the parameter `ProductName`.

```powershell
Invoke-AzsSupportDiagnosticCheck –ProductName <BaseSystem,Registration>
```

## Example scenario

For troubleshooting Azure Stack HCI registration issues for example, you can run this cmdlet:

```powershell
Invoke-AzsSupportDiagnosticCheck -ProductName Registration
```

Afterwards, a comprehensive overview of the different components that are required for properly connected Azure Stack HCI systems is created. Based on this overview, you can either follow the troubleshooting guidance or reach out to customer support for further assistance.

## Next steps

For related information, see also:

- [Get support for Azure Stack HCI](get-support.md).
