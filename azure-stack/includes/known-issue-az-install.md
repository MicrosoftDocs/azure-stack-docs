---
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: include
ms.date: 11/4/2020
ms.reviewer: sijuman
ms.lastreviewed: 08/04/2020

---

### Error thrown when installing the Az modules

- Applicable: This issue applies to 2002 and later
- Description: When installing the module, an error is thrown. The error message begins: `Register-PacakgeSource : A parameter cannot be found that matches parameter name. 'PackageManagementProvider'.`
- Remediation: Run the following cmdlet in the same session:  
    `Install-Module PowershellGet -MinimumumVersion 2.3.0 -Force`  
Close your session and start a new elevated PowerShell session.
- Occurrence: Common