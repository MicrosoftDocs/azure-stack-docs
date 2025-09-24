---
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.topic: include
ms.date: 09/24/2025
ms.reviewer: alkohli
ms.lastreviewed: 09/24/2025
---

### Create a service principal and client secret

To authenticate your system, you need to create a service principal and a corresponding **Client secret** for Arc Resource Bridge (ARB).

#### Create a service principal for ARB

Follow the steps in [Create a Microsoft Entra application and service principal that can access resources via Azure portal](/entra/identity-platform/howto-create-service-principal-portal) to create the service principal and assign the roles. Alternatively, use the PowerShell procedure to [Create an Azure service principal with Azure PowerShell](/powershell/azure/create-azure-service-principal-azureps).

The steps are also summarized here:

1. Sign in to the [Microsoft Entra admin center](https://entra.microsoft.com/) as at least a Cloud Application Administrator. Browse to **Identity > Applications > App registrations** then select **New registration**.

1. Provide a **Name** for the application, select a **Supported account type**, and then select **Register**.

    :::image type="content" source="./media/create-service-principal-client-secret/create-service-principal-register.png" alt-text="Screenshot showing Register an application for service principal creation." lightbox="./media/create-service-principal-client-secret/create-service-principal-register.png":::

1. Once the service principal is created, go to the **Enterprise applications** page. Search for and select the SPN you created.

   :::image type="content" source="./media/create-service-principal-client-secret/create-service-principal-search.png" alt-text="Screenshot showing search results for the service principal created." lightbox="./media/create-service-principal-client-secret/create-service-principal-search.png":::

1. Under properties, copy the **Application (client) ID**  and the **Object ID** for this service principal.

   :::image type="content" source="./media/create-service-principal-client-secret/create-service-principal-id.png" alt-text="Screenshot showing Application (client) ID and the object ID for the service principal created." lightbox="./media/create-service-principal-client-secret/create-service-principal-id.png":::

    You use the **Application (client) ID** against the `arbDeploymentAppID` parameter and the **Object ID** against the `arbDeploymentSPNObjectID` parameter in the Resource Manager template.

#### Create a client secret for ARB service principal

1. Go to the application registration that you created and browse to **Certificates & secrets > Client secrets**.
1. Select **+ New client** secret.

    :::image type="content" source="./media/create-service-principal-client-secret/create-client-secret-new.png" alt-text="Screenshot showing creation of a new client secret." lightbox="./media/create-service-principal-client-secret/create-client-secret-new.png":::

1. Add a **Description** for the client secret and provide a timeframe when it **Expires**. Select **Add**.

    :::image type="content" source="./media/create-service-principal-client-secret/create-client-secret-add.png" alt-text="Screenshot showing Add a client secret blade." lightbox="./media/create-service-principal-client-secret/create-client-secret-add.png":::

1. Copy the **client secret value** as you use it later.

    > [!Note]
    > For the application client ID, you will need it's secret value. Client secret values can't be viewed except for immediately after creation. Be sure to save this value when created before leaving the page.

    :::image type="content" source="./media/create-service-principal-client-secret/create-client-secret-value.png" alt-text="Screenshot showing client secret value." lightbox="./media/create-service-principal-client-secret/create-client-secret-value.png":::

    You use the **client secret value** against the `arbDeploymentAppSecret` parameter in the ARM template.