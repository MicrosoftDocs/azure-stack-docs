---
title: Unregister and re-register Azure Local machines
description: Learn how to unregister and re-register Azure Local machines without having to install the operating system again.
ms.topic: how-to
ms.author: alkohli
author: alkohli
ms.date: 10/11/2025
---


# Unregister and re-register Azure Local machines via PowerShell cmdlets

> Applies to: Azure Local 2508 and later

This article provides guidance on how to unregister and re-register Azure Local machines without having to install the operating system again. This method uses PowerShell cmdlets.


## About re-registrationof Azure Local machines

Previously there was no way to undo the registration of Azure Local machines. The only method available was to uninstall and install the operating system again on machines. Now, you can use PowerShell cmdlets to re-register Azure Local machines without having to reinstall the operating system.

## Prerequisites

Before you begin, ensure you have the following:

- Azure Local 2508 or later installed.
- PowerShell 7.0 or later.
- The AzStackHCI module installed. You can install it using the following command:

```powershell
Install-Module -Name AzStackHCI -AllowClobber -Force
```

## Re-register Azure Local machine

1. [Connect to the Azure Local machine](../manage/azure-arc-vm-management-prerequisites.md#connect-to-the-system-directly).

1. Open PowerShell as an administrator.

1. To get the Azure Resource Manager access token, `ArmAccessToken`, run the following command:

   ```powershell
   $ArmAccessToken = (Get-AzAccessToken -ResourceUrl "https://management.azure.com/").Token
   ```

1. Unregister the machine. Run the following command:

   ```powershell
   Start-ArcBootstrapReset -ArmAccessToken $ArmAccessToken -Wait
   ```

   Here's a description of the parameters used in the command:
    
   |Parameter  |Description  |
   |---------|---------|
   |`ArmAccessToken`     | [Optional] The Azure Resource Manager access token. If omitted, device code authentication will be prompted.     |
   |`Wait`     | [Optional] When specified, the cmdlet monitors and reports progress until completion. |

   Here is a sample output of the command:    

   ```output
   Unregistering machine...
   Machine unregistered successfully.
   ```

1. This is a long running operation. To monitor the progress of the operation, run the following command:

   ```powershell
   Get-ArcBootstrapResetStatus
   ```

1. After the machine is unregistered, re-register the machine using the steps in [Register Azure Local machines](../deploy/deployment-without-azure-arc-gateway.md#register-azure-local-machines).


## Next steps

- Learn how to register Azure Local machines: [Register Azure Local machines](../deploy/deployment-without-azure-arc-gateway.md#register-azure-local-machines)