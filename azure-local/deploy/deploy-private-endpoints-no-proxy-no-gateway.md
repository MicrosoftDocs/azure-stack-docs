---
title: Use Azure Private Endpoints with Azure Local for No Proxy No Arc Gateway Scenario
description: Review how Azure private endpoints can be used when deploying Azure Local, without an enterprise proxy and without an Arc gateway.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 03/09/2026
ms.topic: concept-article
---

# Use Azure private endpoints to connect to Azure Local for no proxy and no Arc gateway scenario

This article provides an overview of how you can integrate both Azure private endpoints with Azure Local in a scenario without an enterprise proxy and without an Arc gateway.
For more information about Azure private endpoints on Azure Local and the supported scenarios, see [About Azure private endpoints on Azure Local](./about-private-endpoints.md).


## About Azure private endpoint scenario without proxy and without Arc gateway

**Description:** Azure Local infrastructure sends HTTP and HTTPS traffic directly via the default route without a proxy or without an Arc gateway. Enterprise firewall or router can redirect this traffic to various subnets using the public internet or Azure ExpressRoute. You must define permitted endpoints on your firewall according to destination needs.


### Outbound connectivity for Azure Local hosts

:::image type="content" source="media/deploy-private-endpoints-no-proxy-no-gateway/image1.png" alt-text="A diagram of a company network showing how outbound connectivity works for Azure Local hosts where there is no proxy and no Arc gateway." lightbox="media/deploy-private-endpoints-no-proxy-no-gateway/image1.png":::

**Diagram legend**:

- LNET = Logical Network
- 10.0.0.0/16 is just an example of a private network where you can configure the private endpoint.
- HTTP/HTTPS outbound traffic uses the management network's default route.
- Public endpoints go through the enterprise firewall to the internet.
- Private endpoints are routed by the enterprise firewall via Azure ExpressRoute or S2S VPN.

### Outbound connectivity for Arc resource bridge VM

:::image type="content" source="media/deploy-private-endpoints-no-proxy-no-gateway/image2.png" alt-text="A diagram showing how outbound connectivity works for Arc resource bridge VM where there is no proxy and no Arc gateway." lightbox="media/deploy-private-endpoints-no-proxy-no-gateway/image2.png":::

**Diagram legend**:

- LNET = Logical Network
- 10.0.0.0/16 is just an example of a private network where you can configure the private endpoint.
- HTTP/HTTPS outbound traffic uses the management network's default route.
- Public endpoints go through the enterprise firewall or router to the internet.
- Private endpoints are routed by the enterprise firewall via Azure ExpressRoute or S2S VPN.

### Outbound connectivity for AKS clusters and worker VMs

:::image type="content" source="media/deploy-private-endpoints-no-proxy-no-gateway/image3.png" alt-text="A diagram showing how outbound connectivity works for AKS cluster and worker VM with no proxy and no Arc gateway." lightbox="media/deploy-private-endpoints-no-proxy-no-gateway/image3.png":::

**Diagram legend**:

- LNET = Logical Network
- 10.0.0.0/16 is just an example of a private network where you can configure the private endpoint.
- When the AKS cluster LNET shares the management network, HTTP and HTTPS outbound traffic follow the default route of the management network.
- If the AKS cluster LNET is separate from the management network, HTTP and HTTPS outbound traffic use the default route of the AKS subnet.
- The enterprise firewall or router directs public endpoint traffic over the internet.
- For private endpoints, the enterprise firewall sends traffic through Azure ExpressRoute or an S2S VPN.

### Outbound connectivity for Azure Local VMs

:::image type="content" source="media/deploy-private-endpoints-no-proxy-no-gateway/image4.png" alt-text="A diagram showing how outbound connectivity works for Azure Local VMs with no proxy and no Arc gateway." lightbox="media/deploy-private-endpoints-no-proxy-no-gateway/image4.png":::

**Diagram legend**:

- LNET = Logical Network
- 10.0.0.0/16 is just an example of a private network where you can configure the private endpoint.
- Azure Local VMs can have independent proxy and Arc gateway settings that don't relate to the host configuration.
- VMs on Azure Local hosts can run with or without their own proxy setup.
- Without proxy settings, VM traffic uses the VM's LNET default gateway.
- The proxy details you set during VM creation are applied as environment variables. If you need to configure any WinInet or WinHTTP proxy settings for Windows, you must do so within the VM. For Linux VMs, you might also need to provide additional proxy settings.

### Considerations for private endpoint deployment on Azure Local

- **Key Vault private endpoints (vault.azure.net):** Azure Local needs a Key Vault for deployment that can use a private endpoint. Keep the public access enabled during the deployment as the Azure portal and Azure Local resource provider configure the key vault secrets.

- **Storage account private endpoints (blob.core.windows.net):** An Azure Local instance with two nodes requires a storage account for deployment that can use a private endpoint. Keep the public access until the initial deployment is complete. Azure portal and Azure Local resource provider need to configure the cloud witness during deployment. Once the deployment is complete, you can restrict the storage account access to only private networks.

## Next steps

Learn more about using private endpoints with Azure Local in other scenarios:

- [Deploy Azure Local with an enterprise proxy but without an Arc gateway](./deploy-private-endpoints-with-proxy-no-gateway.md).
- [Deploy Azure Local without an enterprise proxy but with an Arc gateway](./deploy-private-endpoints-no-proxy-with-gateway.md).
- [Deploy Azure Local with both an enterprise proxy and an Arc gateway](./deploy-private-endpoints-with-proxy-with-gateway.md).