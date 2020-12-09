---
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: include
ms.date: 12/9/2020
ms.reviewer: sijuman
ms.lastreviewed: 12/9/2020

---

###  Method get_SerializationSettings error 

- Cause: 

- Remediation: 


- Applicable: This issue applies to 2002 and later
- Cause: The PowerShell Az module and PowerShell Azure Resource Manager modules are not compatible.

    The following error indicates that the Azure Resource Manager modules and Az modules are loaded in the same session: 

    ```powershell  
    >  Method 'get_SerializationSettings' in type 'Microsoft.Azure.Management.Internal.Resources.ResourceManagementClient' from assembly 'Microsoft.Azure.Commands.ResourceManager.Common, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35' does 
    not have an implementation.
    ```
- Remediation: Uninstall the conflicting modules. 

  If you would like to use the Azure Resource Manager modules, uninstall the Az modules. Or uninstall the Azure Resource Manager if you would like to use the Az modules. Close your PowerShell session and uninstall either the Az or Azure Resource Manager modules. 
  
  You can find instructions at [Uninstall existing versions of the Azure Stack Hub PowerShell modules](/azure-stack/operator/#3-uninstall-existing-versions-of-the-azure-stack-hub-powershell-modules).
- Occurrence: Common