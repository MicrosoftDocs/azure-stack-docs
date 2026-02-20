---
title: Register Disconnected Operations for Azure Local
description: Learn how to register disconnected operations for Azure Local to ensure compliance with deployment requirements.
ms.topic: how-to
author: haraldfianbakken
ms.author: hafianba
ms.date: 02/23/2026
ms.reviewer: robess
ms.subservice: hyperconverged
ai-usage: ai-assisted
---

# Register disconnected operations for Azure Local

::: moniker range=">=azloc-2602"

This article explains how to register disconnected operations for Azure Local after deploying your management cluster with the control plane. Learn how to ensure compliance with Azure Local requirements through proper registration.

## Get the registration file

The registration file contains data about your Azure Local deployment, which is required to complete the registration process in the Azure portal.

To register disconnected operations for Azure Local, first generate a registration file from your management cluster.

> [!NOTE]
> Certain compliance regulations prohibit copying any data from air-gapped environments. When these restrictions prevent copying the registration file, coordinate with your Microsoft representatives to complete appliance registration while maintaining compliance.

Follow these steps to create and export the registration file:

1. On your management cluster, sign in to the seed node by using local administrator credentials.

1. Import the operations module and initialize the management context:

    ```powershell
    # Replace with your actual values.
    $applianceConfigBasePath = 'C:\AzureLocalDisconnectedOperations'
    Import-Module "$applianceConfigBasePath\OperationsModule\Azure.Local.DisconnectedOperations.psd1" -Force

    $password = ConvertTo-SecureString 'RETRACTED' -AsPlainText -Force  
    $context = Set-DisconnectedOperationsClientContext -ManagementEndpointClientCertificatePath "${env:localappdata}\AzureLocalOpModuleDev\certs\ManagementEndpoint\ManagementEndpointClientAuth.pfx" -ManagementEndpointClientCertificatePassword $password -ManagementEndpointIpAddress "169.254.53.25"  
    ```

1. Export the appliance registration data file by using the following command:

    ```powershell
     $file = 'AzureLocal-managementCluster.reg'
     Export-ApplianceRegistrationData -File $file
    ```

1. Copy this file to a machine that you can use to connect to the internet.

## Complete the registration

To finalize the registration process for disconnected operations, follow these steps in the Azure portal.

1. On an internet connected machine, navigate to the [Azure portal](https://portal.azure.com).
1. Navigate to your disconnected operations resource.
1. Check for a banner that indicates that your disconnected operations resource isn't registered.
1. Select the **Register** button, and then upload the registration file.
1. Confirm the registration details and select **Register**.
1. After the operation completes, the **Registration status** changes to **Registered**.

## Related content

- [About updates for disconnected operations](./disconnected-operations-update.md).
- [Backup for disconnected operations for Azure Local](./disconnected-operations-back-up-restore.md).

::: moniker-end

::: moniker range="<=azloc-2601"

This feature is available only in Azure Local 2602 or later.

::: moniker-end
