---
author: alkohli
ms.topic: include
ms.date: 06/14/2024
ms.author: alkohli

---

The Arc gateway works by introducing the following components:

- **Arc gateway resource** – An Azure resource that acts as a common entry point for Azure traffic. This gateway resource has a specific domain or URL that you can use. When you create the Arc Gateway resource, this domain or URL is a part of the success response.  

- **Arc proxy** – A new component that is added to the Arc Agentry. This component runs as a service (Called  the **Azure Arc Proxy**) and works as a forward proxy for the Azure Arc agents and extensions.
    The gateway router doesn't need any configuration from your side. This router is part of the Arc core agentry and runs within the context of an Arc-enabled resource.

With the Arc gateway in place, the traffic flows through these steps: **Arc agentry → Gateway router → Enterprise Proxy → Arc gateway → Target service**.  The traffic flow is illustrated in the following diagram:

  :::image type="content" source="../hci/deploy/media/deployment-azure-arc-gateway/arc-gateway-component-diagram.png" alt-text="Azure Arc gateway component diagram." lightbox="./media/deployment-azure-arc-gateway/arc-gateway-component-diagram.png":::

  Each Azure Stack HCI cluster node has its own Arc agent with the gateway router connecting and creating the tunnel to the Arc gateway resource in Azure.

