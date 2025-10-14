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

This article provides guidance on how to unregister and re-register Azure Local machines without having to install the operating system (OS) again. This method uses PowerShell cmdlets and applies to registration with and without Azure Arc gateway.


## About reregistration Azure Local machines

Previously there was no way to undo the registration of Azure Local machines. The only method available was to uninstall and install the OS again on machines. Now, you can use PowerShell cmdlets to first unregister the Azure Local machines and then re-register the machines without having to reinstall the OS.

## Prerequisites

Before you begin, ensure you have the following:

- Registered Azure Local machines with 2508 or later installed.
- Remote Desktop Protocol (RDP) should be enabled on Azure Local machines. Follow the instructions in [Enable RDP](../deploy/deploy-via-portal.md#enable-rdp).

## Re-register Azure Local machine

1. Connect to the Azure Local machine via RDP.

1. Open PowerShell as an administrator.

1. To get the Azure Resource Manager access token, run the following command:

   ```powershell
   $ArmAccessToken = (Get-AzAccessToken -ResourceUrl "https://management.azure.com/").Token
   ```

1. Unregister the machine. Run the following command:

   ```powershell
   Start-ArcBootstrapReset -ArmAccessToken $ArmAccessToken -TenantId $TenantId -Wait
   ```

   Here's a description of the parameters used in the command:
    
   |Parameter  |Description  |
   |---------|---------|
   |`ArmAccessToken`     | [Optional] The Azure Resource Manager access token. If omitted, device code authentication is prompted.     |
   |`Wait`     | [Optional] When specified, the cmdlet monitors and reports progress until completion. |
   |`TenantId`     | [Required] When specified, the cmdlet monitors and reports progress until completion. |

   Here's a sample output of the command:    

   ```output
      PS C: Start-ArcBootstrapReset  -Wait 
      Arc reset in progress. Elapsed tine: 0.3 minutes. Current status InProgress 
      ExtensionCleanup: InProgress 
      WARNING: 
      To sign in, use a web browser to open the page https://nicrosoft.con/devicelogin and enter the code ABDCDEF1GH to authenticate. 
      GatewayCleanup: NotStarted 
      AzcnAgentCleanup: NotStarted 
      BootstrapCleanup: NotStarted 
      Arc reset in progress. Elapsed time: 0.5 minutes. Current status InProgress
      ExtensionCleanup: InProgress 
   ```

1. This is a long running operation. To monitor the progress of the operation, run the following command:

   ```powershell
   Get-ArcBootstrapResetStatus
   ```

1. After the machine is unregistered, re-register the machine using the steps in [Register Azure Local machines](../deploy/deployment-without-azure-arc-gateway.md).


## Next steps

- Learn how to register Azure Local machines: [Register Azure Local machines](../deploy/deployment-without-azure-arc-gateway.md).