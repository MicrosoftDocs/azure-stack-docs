---
author: ronmiab
ms.author: robess
ms.service: azure-local
ms.topic: include
ms.date: 09/24/2025
ms.lastreviewed: 09/24/2025
---

### Get the object ID for Azure Local Resource Provider

This object ID for the Azure Local Resource Provider (RP) is unique per Azure tenant.

1. In the Azure portal, search for and go to Microsoft Entra ID.

1. Go to the **Overview** tab and search for `00001111-aaaa-2222-bbbb-3333cccc4444`.

1. Select the Service Principal Name that is listed and copy the **Object ID**.

    :::image type="content" source="./media/get-object-id-azure-local-resource-provider/get-object-id.png" alt-text="Screenshot showing the object ID for the Azure Local Resource Provider service principal." lightbox="./media/get-object-id-azure-local-resource-provider/get-object-id.png":::

    Alternatively, you can use Azure CLI or PowerShell to get the object ID of the Azure Local RP service principal. Run the following command:

    # [Azure PowerShell](#tab/azure-powershell)

    ```powershell
    (Get-AzADServicePrincipal -ApplicationId "00001111-aaaa-2222-bbbb-3333cccc4444").Id
    ```

    # [Azure CLI](#tab/azure-cli)

    ```azurecli
    az ad sp list --filter "appId eq '00001111-aaaa-2222-bbbb-3333cccc4444'" --query "[0].id" -o tsv
    ```

    ---
