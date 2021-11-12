---
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: include
ms.date: 6/1/2021
ms.reviewer: raymondl
ms.lastreviewed: 6/1/2021
---

### Cmdlet New-AzVmss fails when using 2020-09-01-hybrid profile

- Applicable: This issue applies to the 2020-09-01-hybrid profile.
- Cause: The cmdlet **New-AzVmss** does not work with the 020-09-01-hybrid profile.
- Remediation: Use a template for creating virtual machine scale set. 
You can find a sample the Azure Stack Hub Resource Manager templates in the GitHub
Repository [AzureStack-QuickStart-Templates/101-vmss-windows-vm](https://github.com/Azure/AzureStack-QuickStart-Templates/tree/master/101-vmss-windows-vm) and you can find instruction on using Azure Stack Hub Resource Managers with [Visual Studio Code](../user/azure-stack-resource-manager-deploy-template-vscode.md).
- Occurrence: Common