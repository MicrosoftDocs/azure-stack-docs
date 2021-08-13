---
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: include
ms.date: 7/22/2021
ms.reviewer: raymondl
ms.lastreviewed: 7/22/2021
---

### Error thrown when running a PowerShell script

- Applicable: This issue applies to 2002 and later.
- Cause: When running scripts or PowerShell commands using the Azure Stack Hub specific modules, you will need your script or command to be available in the module. 
    You may see the following error:

    ```powershell  
    Method 'get_SerializationSettings' in type 'Microsoft.Azure.Management.Internal.Resources.ResourceManagementClient' from assembly 'Microsoft.Azure.Commands.ResourceManager.Common, Version=4.0.0.0, 
    Culture=neutral, PublicKeyToken=31bf3856ad364e35' does not have an implementation.
    ```
    The current module is the PowerShell Az module, which has replaced the PowerShell AzureRM module. If you attempt to run a script that calls for AzureRM commands when the Az module is installed, your script will throw errors. Or if you attempt to run a script that calls Az commands when the AzureRM module is installed, your script will throw errors. 
- Remediation: Uninstall the AzureRM module and install the Az module. For instructions, see [Install PowerShell Az module for Azure Stack Hub](../operator/powershell-install-az-module.md). If you're using the Azure Stack Hub Tools, use the Az tools. Clone the tools repository from the **az** branch, or download the AzureStack-Tools from the **az** branch. For instructions, see [Download Azure Stack Hub tools from GitHub](../operator/azure-stack-powershell-download.md)
- Occurrence: Common