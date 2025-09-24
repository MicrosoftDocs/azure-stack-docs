---
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.topic: include
ms.date: 09/24/2025
ms.reviewer: alkohli
ms.lastreviewed: 09/24/2025
---

### Get the object ID for Azure Local Resource Provider

This object ID for the Azure Local Resource Provide (RP) is unique per Azure tenant.

1. In the Azure portal, search for and go to Microsoft Entra ID.  
1. Go to the **Overview** tab and search for *Microsoft.AzureStackHCI Resource Provider*.

    :::image type="content" source="./media/get-object-id-azure-local-resource-provider/search-resource-provider.png" alt-text="Screenshot showing the search for the Azure Local Resource Provider service principal." lightbox="./media/get-object-id-azure-local-resource-provider/search-resource-provider.png":::

1. Select the Service Principal Name that is listed and copy the **Object ID**.

    :::image type="content" source="./media/get-object-id-azure-local-resource-provider/get-object-id.png" alt-text="Screenshot showing the object ID for the Azure Local Resource Provider service principal." lightbox="./media/get-object-id-azure-local-resource-provider/get-object-id.png":::

    Alternatively, you can use PowerShell to get the object ID of the Azure Local RP service principal. Run the following command in PowerShell:

    ```powershell
    Get-AzADServicePrincipal -DisplayName "Microsoft.AzureStackHCI Resource Provider"
    ```