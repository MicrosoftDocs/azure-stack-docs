---
title: Validate deployment for Azure Stack HCI version 22H2 (preview)
description: Learn how to validate deployment for Azure Stack HCI version 22H2 (preview)
author: dansisson
ms.topic: how-to
ms.date: 08/29/2022
ms.author: v-dansisson
ms.reviewer: alkohli
---

# Validate deployment for Azure Stack HCI version 22H2 (preview)

> Applies to: Azure Stack HCI, version 22H2 (preview)

Once your deployment has successfully completed, you should verify and validate your deployment:

## Validate deployment in Azure portal

After deployment, you can validate that your cluster exists and is registered in Azure:

1. Run PowerShell as administrator.

1. Establish a remote PowerShell session with the server node and run the following command:

    ```powershell
    Enter-PSSession -ComputerName <server_IP_address>  -Credential <username\password for the server> 
    ```

1. Get the information for the cluster you created:

    ```powershell
    Get-AzureStackHCI 
    ```
    Here is a sample output:

    ```powershell
    PS C:\Users\Administrator> Enter-PSSession -ComputerName 100.96.113.220 -Credential localhost\administrator 

    [100.96.113.220]: PS C:\Users\Administrator\Documents> Get-AzureStackHCI 

    ClusterStatus      : Clustered 
    RegistrationStatus : Registered 
    RegistrationDate   : 7/6/2022 1:01:02 AM 
    AzureResourceName  : cluster-c0bca4ca3d654d689c7b624732af3727 
    AzureResourceUri   : /Subscriptions/5c17413c-1135-479b-a046-847e1ef9fbeb/resourceGroups/ASZRegistrationRG/providers/Microsoft.AzureStackHCI/clusters/cluster-c0bca4ca3d654d689c7b624732af3727

    ConnectionStatus   : Connected
    LastConnected      : 7/6/2022 2:00:02 PM
    IMDSAttestation    : Disabled
    DiagnosticLevel    : Basic

    [100.96.113.220]: PS C:\Users\Administrator\Documents>
    ```

1. Write down the `AzureResourceName` value. You'll need this to do a search in the Azure portal.

1. Sign in to the Azure portal. Make sure that you have used the appropriate Azure account ID and password.

1. In the Azure portal, search for the `AzureResourceName` value, then select the corresponding cluster resource.

1. On the **Overview** page for the cluster resource, view the **Server** information.  

    :::image type="content" source="media/deployment-tool/validate-deployment.png" alt-text="Screenshot of Azure portal." lightbox="media/deployment-tool/validate-deployment.png":::

## Next steps

If needed, [troubleshoot deployment](deployment-tool-troubleshoot.md).
