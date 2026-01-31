---
title: Register disconnected operations 
description: Learn how to register disconnected operations 
ms.topic: how-to
author: haraldfianbakken
ms.author: hafianba
ms.date: 01/29/2026
ms.reviewer: robess
ai-usage: ai-assisted
---

# Register disconnected operations


::: moniker range=">=azloc-2601"

This article explains how to register your disconnected operations once you have deployed your management cluster containing the control plane. Registration is required in order to stay compliant.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Get registration file

1. On your management cluster - log in to your seed node using local administrator credentials.
1. Import the operations module and initialize the management context:

    ```powershell  
    $applianceConfigBasePath = 'C:\AzureLocalDisconnectedOperations'
    Import-Module "$applianceConfigBasePath\OperationsModule\Azure.Local.DisconnectedOperations.psd1" -Force

    $password = ConvertTo-SecureString 'RETRACTED' -AsPlainText -Force  
    $context = Set-DisconnectedOperationsClientContext -ManagementEndpointClientCertificatePath "${env:localappdata}\AzureLocalOpModuleDev\certs\ManagementEndpoint\ManagementEndpointClientAuth.pfx" -ManagementEndpointClientCertificatePassword $password -ManagementEndpointIpAddress "169.254.53.25"  
    ```  
1. Export the appliance registration data file
    ```powershell 
     $file = 'AzureLocal-managementCluster.reg'
     Export-ApplianceRegistrationData -file $file
    ```
1. Copy this file to a machine that you can use to connect to the internet. 
## Register disconnected operations
1. On an internet connected machine , navigate to https://portal.azure.com 
1. Navigate to your disconnected operations resource 
1. Notice the banner saying your disconnected operations resource is not registered.
1. Click the button 'Register' and upload the registration file.
1. Confirm the registration details and click Register 
1. Wait while the operations completes
1. Registration status changes to Registered.