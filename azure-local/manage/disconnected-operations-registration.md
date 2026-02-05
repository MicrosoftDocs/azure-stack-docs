---
title: Register disconnected operations for Azure Local (Preview)
description: Learn how to register disconnected operations for Azure Local (preview) to ensure compliance with deployment requirements.
ms.topic: how-to
author: haraldfianbakken
ms.author: hafianba
ms.date: 01/29/2026
ms.reviewer: robess
ai-usage: ai-assisted
---

# Register disconnected operations for Azure Local

::: moniker range=">=azloc-2601"

This article explains how to register disconnected operations for Azure Local after deploying your management cluster with the control plane. Registration ensures compliance with Azure Local requirements.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Get the registration file

To register disconnected operations for Azure Local, you first need to generate a registration file from your management cluster. This file contains the necessary data to complete the registration process. 

Follow these steps to create and export the registration file:

1. On your management cluster, sign in to the seed node with local administrator credentials.

1. Import the operations module and initialize the management context:

    ```powershell  
    $applianceConfigBasePath = 'C:\AzureLocalDisconnectedOperations'
    Import-Module "$applianceConfigBasePath\OperationsModule\Azure.Local.DisconnectedOperations.psd1" -Force

    $password = ConvertTo-SecureString 'RETRACTED' -AsPlainText -Force  
    $context = Set-DisconnectedOperationsClientContext -ManagementEndpointClientCertificatePath "${env:localappdata}\AzureLocalOpModuleDev\certs\ManagementEndpoint\ManagementEndpointClientAuth.pfx" -ManagementEndpointClientCertificatePassword $password -ManagementEndpointIpAddress "169.254.53.25"  
    ```

1. Export the appliance registration data file by using the following command:

    ```powershell 
     $file = 'AzureLocal-managementCluster.reg'
     Export-ApplianceRegistrationData -file $file
    ```

1. Copy this file to a machine that you can use to connect to the internet.

## Complete the registration

To finalize the registration process for disconnected operations, follow these steps in the Azure portal.

1. On an internet connected machine, navigate to the [Azure portal](https://portal.azure.com).
1. Go to your disconnected operations resource.
1. Check for a banner that indicates that your disconnected operations resource isn't registered.
1. Select the **Register** button, and then upload the registration file.
1. Confirm the registration details and select **Register**.
1. After the operation completes, the **Registration status** changes to **Registered**.

