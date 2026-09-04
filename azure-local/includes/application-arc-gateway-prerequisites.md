---
author: ronmiab
ms.author: robess
ms.service: azure-local
ms.topic: include
ms.date: 09/01/2026
---

### Azure prerequisites

- Create an Arc gateway resource in the same subscription that you use to deploy Azure Local. For more information, see [Create the Arc gateway resource in Azure](../deploy/deployment-azure-arc-gateway-overview.md#create-the-arc-gateway-resource-in-azure).

  1. In the Azure portal, go to the Arc gateway resource that you created.
  1. On the **Overview** page, copy the **Resource ID**. You use this Arc gateway ID during registration.

  :::image type="content" source="./media/application-arc-gateway-start/arc-gateway-resource-id.png" alt-text="Screenshot of the Resource ID on the Overview page for an Azure Arc gateway." lightbox="./media/application-arc-gateway-start/arc-gateway-resource-id.png":::
