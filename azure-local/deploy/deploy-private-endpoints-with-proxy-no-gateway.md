---
title: Use Private Endpoints with Azure Local for with Proxy no Arc Gateway
description: Review how Azure Private Endpoints can be used when deploying Azure Local, with an enterprise proxy but without an Arc gateway.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 03/06/2026
ms.topic: concept-article
---

# Use private endpoints to connect to Azure Local with proxy and without Arc gateway scenario

This article provides an overview of how you can integrate both existing and new Azure private endpoints with Azure Local in a scenario with enterprise proxy but without an Arc gateway.
For more information about Azure private endpoints on Azure Local and the supported scenarios, see [About Azure private endpoints on Azure Local](./about-private-endpoints.md).


## About Azure private scenario with proxy and without Arc Gateway

**Description:** Azure Local infrastructure runs with a proxy but no Arc gateway. When you use an enterprise proxy, you can control which endpoints use the proxy and which bypass it. Some endpoints require SSL inspection to be disabled, while local traffic - such as traffic between nodes, domains, clusters, and local subnets - should bypass the proxy. Add private endpoints to the bypass list for direct routing through the enterprise firewall/router and Azure ExpressRoute.

### Outbound connectivity for Azure Local hosts

:::image type="content" source="media/deploy-private-endpoints-with-proxy-no-gateway/image5.png" alt-text="A diagram of a company network showing how outbound connectivity works for Azure Local hosts where there is proxy but no Arc gateway." lightbox="media/deploy-private-endpoints-with-proxy-no-gateway/image5.png":::

**Diagram legend**:

- 10.0.0.0/16 is an example of a private network where you can configure the private endpoint.
- You define the proxy server and bypass list during Arc registration. The Arc registration script auto-configures these settings for WinInet, WinHTTP, and Environment Variables to manage host OS and Arc resource bridge VM traffic via the proxy or bypass list.
- Azure Local hosts send HTTP/HTTPS outbound traffic through the enterprise proxy, except for endpoints in the WinInet and WinHTTP bypass lists.
- For HTTPS traffic sent through the proxy, SSL inspection must be disabled for Azure Local required endpoints.
- Traffic bypassing the proxy goes directly via the customer's default route, where the enterprise firewall evaluates it.
- The enterprise firewall/router routes public endpoints to the internet and private endpoints over Azure ExpressRoute or S2S VPN.

### Outbound connectivity for Arc resource bridge VM

:::image type="content" source="media/deploy-private-endpoints-with-proxy-no-gateway/image6.png" alt-text="A diagram of a company network showing how outbound connectivity works for Arc resource bridge where there is proxy but no Arc gateway." lightbox="media/deploy-private-endpoints-with-proxy-no-gateway/image6.png":::

**Diagram legend**:

- 10.0.0.0/16 is an example of a private network where you can configure the private endpoint.
- You must configure environment variables for proxy and bypass lists to manage Arc Resource Bridge VM traffic routing through the enterprise proxy.
- Arc Resource Bridge requires specific endpoints and subnets to be included in the proxy bypass list. These endpoints are automatically appended during deployment, ensuring the following entries are added to the customer-defined proxy bypass list at the time of Arc registration:
  - `localhost,127.0.0.1,0.0.0.0,kubernetes.default.svc,.svc.cluster.local,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16`
- HTTP and HTTPS outbound traffic from the Arc Resource Bridge VM is routed to the enterprise proxy, except for those endpoints specified in the Environment Variables proxy bypass list.
- SSL inspection must be disabled for Arc Resource Bridge VM HTTPS traffic directed through the enterprise proxy.
- HTTP and HTTPS traffic that bypasses the proxy is routed directly via the customer’s default route, where the enterprise firewall evaluates it.
- The enterprise firewall routes public endpoints to the internet and private endpoints over Azure ExpressRoute or S2S VPN.

### Outbound connectivity for AKS clusters control plane and worker VMs

:::image type="content" source="media/deploy-private-endpoints-with-proxy-no-gateway/image7.png" alt-text="A diagram of a company network showing how outbound connectivity works for AKS clusters control plane and worker VMs with proxy but no Arc gateway." lightbox="media/deploy-private-endpoints-with-proxy-no-gateway/image7.png":::

**Diagram legend**:

- 10.0.0.0/16 is an example of a private network where you can configure the private endpoint.
- New AKS clusters in Azure Local using a proxy have the control plane and worker VMs inherit Arc resource bridge proxy and bypass list settings. Add required private endpoints (for example, Azure Container Registries) to the bypass list during deployment.
- AKS pods can have independent proxy and bypass configurations, defined during application deployment.
- When AKS Clusters LNET uses the management network, HTTP/HTTPS outbound traffic goes through the proxy via management network.
- If AKS Clusters LNETs differs from the management network, HTTP/HTTPS outbound traffic uses the AKS subnet default route to the proxy.
- The enterprise firewall routes public endpoints to the internet and private endpoints over Azure ExpressRoute or S2S VPN.

### Outbound connectivity for Azure Local VMs

:::image type="content" source="media/deploy-private-endpoints-with-proxy-no-gateway/image8.png" alt-text="A diagram of a company network showing how outbound connectivity works for Azure Local VMs with proxy but no Arc gateway." lightbox="media/deploy-private-endpoints-with-proxy-no-gateway/image8.png":::

**Diagram legend**:
- 10.0.0.0/16 is an example of a private network where you can configure the private endpoint.
- Azure Local VMs can have independent proxy and Arc gateway settings that don't relate to the host configuration.
- VMs on Azure Local hosts using a proxy can run without their own proxy setup.
- Without proxy settings, VM traffic uses the VM's LNET default gateway.
- Proxy details set during VM creation are applied as environment variables. Any WinInet or WinHTTP proxy settings for Windows must be configured within the VM.

### Considerations for private endpoints when deploying Azure Local with proxy and without Arc gateway

#### Key vault private endpoints: (vault.azure.net)

Azure Local deployment requires a key vault, which can use a private endpoint. However, you must enable public access during initial deployment so the Azure portal and Azure Local resource provider (RP) can configure secrets. After deployment, restrict access to private networks only.

#### Storage account private endpoints: (blob.core.windows.net)

Azure Local with two nodes requires a Storage Account for deployment. You can use a private endpoint but keep public access open until setup is complete so that Azure portal and Azure Local RP can configure cloud witness. Restrict access to private networks once deployment finishes.

#### Azure Container Registry private endpoints for AKS: (azurecr.io)

For AKS workloads, customers often pull images from ACR private endpoints. During deployment, add specific ACR FQDNs to your proxy bypass list. Wildcards like \*.azurecr.io aren't supported because Arc resource bridge VMs require access to specific ACR endpoints, affecting both AKS and Arc resource bridge traffic.


## Next steps

Learn more about using private endpoints with Azure Local in other scenarios:

- [Deploy Azure Local without an enterprise proxy but with an Arc gateway](./deploy-private-endpoints-no-proxy-with-gateway.md).
- [Deploy Azure Local without an enterprise proxy and without an Arc gateway](./deploy-private-endpoints-no-proxy-no-gateway.md).
- [Deploy Azure Local with both an enterprise proxy and an Arc gateway](./deploy-private-endpoints-with-proxy-with-gateway.md).