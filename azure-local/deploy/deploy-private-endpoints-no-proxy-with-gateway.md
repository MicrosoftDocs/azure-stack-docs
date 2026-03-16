---
title: Use Private Endpoints with Azure Local for No Proxy with Arc Gateway
description: Review how Azure Private Endpoints can be used when deploying Azure Local, without an enterprise proxy but with an Arc gateway.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 03/09/2026
ms.topic: concept-article
---

# Use private endpoints to connect to Azure Local for no proxy and with Arc gateway scenario

This article provides an overview of how you can integrate both existing and new Azure private endpoints with Azure Local in a scenario without an enterprise proxy but with an Arc gateway.
For more information about Azure private endpoints on Azure Local and the supported scenarios, see [About Azure private endpoints on Azure Local](./about-private-endpoints.md).

## About Azure private scenario without proxy and with Arc Gateway

**Description:** When Azure Local infrastructure runs without an enterprise proxy server but uses the Arc gateway, you configure all HTTPS traffic to use the Arc proxy as proxy server.

- Arc registration automatically sets the host's WinInet and WinHTTP HTTPS proxy to `http://localhost:40343`. This setting channels all HTTPS traffic through the Arc proxy. For HTTP traffic, the host sends the traffic directly to the default route and the enterprise firewall.
- For Arc resource bridge VM and AKS Clusters, the Arc registration script also automatically configures environment variables proxy configuration as follows:
    - `https`: `http://localhost:40343`
    - `http`: ""
    - `bypasslist`: `localhost,.svc,kubernetes.default.svc,.svc.cluster.local,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12`

    These defaults configure the Arc resource bridge VM proxy during Azure Local deployment. However, during Arc resource bridge VM deployment, the proxy server configuration inside the Arc resource bridge is automatically changed to the Azure Local Cluster IP on port 40343 instead of using `localhost:40343`.

### Outbound connectivity for Azure Local hosts

:::image type="content" source="media/deploy-private-endpoints-no-proxy-with-gateway/image9.png" alt-text="Diagram showing the outbound connectivity for Azure Local hosts scenario with no proxy and with Arc gateway." lightbox="media/deploy-private-endpoints-no-proxy-with-gateway/image9.png":::

**Diagram legend**:
- 10.0.0.0/16 is an example of a private network where you can configure the private endpoint.
- During Arc registration, you don't specify any enterprise proxy server or proxy bypass list. However, the Arc registration script automatically configures the host HTTPS proxy to become `http://localhost:40343`. This is the Arc proxy address the host uses to funnel all HTTPS traffic over the Arc gateway tunnel.
- Azure Local hosts send HTTP traffic directly to the enterprise firewall because Arc gateway doesn't support HTTP.
- All Azure Local hosts send HTTPS outbound traffic to the Arc proxy.
  - If the endpoints are allowed by Arc gateway, the traffic goes directly to the Arc gateway in Azure and from there it reaches the corresponding Azure service endpoint.
  - If the endpoints aren't allowed by Arc gateway, Arc proxy retries the connection to the endpoint over the enterprise firewall. Third party endpoints traffic such as OEM endpoints follow this path. Private endpoints also follow this path.
- Azure Local Hosts HTTPS traffic that isn't allowed by Arc gateway and is sent to the enterprise firewall must be allowed if the endpoint is legit and required.
- Enterprise firewall routes public endpoints over internet.
- Enterprise firewall routes private endpoints over Azure ExpressRoute or S2S VPN.

### Outbound connectivity for Arc resource bridge VM

:::image type="content" source="media/deploy-private-endpoints-no-proxy-with-gateway/image10.png" alt-text="A diagram of a company network showing how outbound connectivity works for an Arc resource bridge VM." lightbox="media/deploy-private-endpoints-no-proxy-with-gateway/image10.png":::

**Diagram legend**:

- 10.0.0.0/16 is just an example of a private network where you can configure the private endpoint.
- You use environment variables proxy and bypass list configuration on Azure Local nodes to configure the proxy inside the Arc resource bridge VM.
- Arc resource bridge has specific endpoints and subnets requirements that you must add to the proxy bypass list. The deployment automatically adds these endpoints, and the following endpoints are added:
  - `localhost,127.0.0.1,0.0.0.0,kubernetes.default.svc,.svc.cluster.local,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16`
- Because Arc gateway is enabled during Arc registration, the Arc resource bridge VM proxy server automatically sets to use the Azure Local Cluster IP on port 40343 and the proxy bypass list uses the environment variables values.
- Arc resource bridge VM sends HTTPS outbound traffic to the cluster IP proxy except those endpoints added to the Environment Variables proxy bypass list. Then the traffic is sent to the Arc proxy and behaves as follows:
  - If HTTPS endpoint is allowed by Arc gateway, the traffic goes over the tunnel to the Azure services endpoints.
  - If HTTPS endpoint isn't allowed by Arc gateway, Arc proxy retries the connection by sending the traffic directly to the customer default route, where the enterprise firewall evaluates the traffic.
  - HTTPS bypassed endpoints are sent directly to the customer default route, where their enterprise firewall evaluates the traffic.
- Arc resource bridge VM sends HTTP traffic directly to the customer default route, where their enterprise firewall evaluates the traffic.
- Enterprise firewall routes public endpoints over internet.
- Enterprise firewall routes private endpoints over Azure ExpressRoute or S2S VPN.

### Outbound connectivity for AKS clusters control plane and worker VMs
 
:::image type="content" source="media/deploy-private-endpoints-no-proxy-with-gateway/image11.png" alt-text="A diagram of a company network showing how outbound connectivity works for an AKS cluster control plane and worker VMs." lightbox="media/deploy-private-endpoints-no-proxy-with-gateway/image11.png":::

**Diagram legend**:

- 10.0.0.0/16 is just an example of a private network where you can configure the private endpoint.
- If you deploy new AKS clusters in Azure Local, the AKS cluster control plane VMs and worker VMs inherit the Arc resource bridge proxy and bypass list configuration. If AKS workloads require access to some private endpoint such as Azure Container Registries, add those endpoints to the Environment Variables proxy bypass list after Arc registration but before starting the Azure Local deployment. For example, if you want to add a specific Azure Container Registry endpoint to be used by AKS workloads, append such endpoint to the existing bypass list

  - `localhost,127.0.0.1,0.0.0.0,kubernetes.default.svc,.svc.cluster.local,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,<u>customerACR.azureio.cr</u>`

  - This configuration is particularly important for scenarios where AKS clusters are running on their own LNET and you want the ACR traffic to go directly from the AKS subnet to the enterprise firewall. If you don't add the endpoint to the Environment Variables bypass list after Arc registration, the Arc proxy running on the host on the management network sends the request and the firewall must be configured to allow the request from the host.

- Pods running on AKS worker nodes are independent and can have their own proxy and bypass list configuration, which you define during POD application deployment.

- Enterprise firewall routes public endpoints over internet.

- Enterprise firewall routes private endpoints over Azure ExpressRoute or S2S VPN.

### Outbound connectivity for Azure Local VMs

- Azure Local VMs can have their own proxy and Arc gateway configuration independent from the hosts. Azure Local hosts configuration doesn't create any dependency.

- If Azure Local VMs don't have proxy configuration, the traffic goes over the defined LNET default gateway.

- You can configure Arc gateway independently for Azure Local VMs regardless of whether the infrastructure uses it.

- Azure Local VMs can use the same or different Arc gateway from the hosts.

### Considerations for private endpoints when deploying Azure Local without proxy but with Arc gateway

#### Key Vault private endpoints: (vault.azure.net)

Azure Local requires a Key Vault for deployment. You can use a Key Vault on a private endpoint, but you must allow public access until the initial deployment is complete. Azure portal and Azure Local resource provider (RP) need to configure the Key Vault secrets during deployment. Once deployment is completed, you can restrict Key Vault access to only allow private networks.

#### Storage account private endpoints: (blob.core.windows.net)

Azure Local with two nodes requires a Storage Account for deployment. 

You can use a Storage Account on a private endpoint, but you must allow public access until the initial deployment is complete. Azure portal and Azure Local RP need to configure the cloud witness during deployment. Once the deployment is complete, restrict the storage account access to only allow private networks. 

If your security team wants to ensure that this storage account endpoint is specifically allowed in your firewall from your Azure Local nodes as source IP, you must add the endpoint to the proxy bypass list, so the traffic is sent directly to your firewall instead of going through the Arc gateway tunnel.

#### Azure Container Registry private endpoints for AKS: (azurecr.io)

It's common for customers to pull images for their AKS workloads from private Azure Container Registry endpoints. In those scenarios, although it's possible to send the private endpoints traffic over the Arc proxy, include the specific ACR FQDN endpoints to the Environment Variables proxy bypass list after Arc registration but before starting the deployment. It's not supported to use wildcards such as \*.azurecr.io because Arc resource bridge VM uses specific ACR endpoints and the proxy bypass list applies not only to AKS but also to Arc resource bridge VM.

#### Azure Site Recovery private endpoints (privatelink.siterecovery.windowsazure.com)

Arc gateway doesn't allow the Azure Site Recovery private endpoint FQDNs. This restriction means that traffic can follow two outbound paths depending on your security requirements:

- **Outbound path option 1 for Azure Site Recovery private endpoints when using Arc gateway without enterprise proxy:** Don't include the FQDNs in to the proxy bypass list. If you don't add the FQDNs to the proxy bypass list, the traffic goes to the Arc proxy but is rejected. A retry is then sent directly to your enterprise firewall and then to the private endpoint via express route according to your routing policies.

- **Outbound path option 2 for Azure Site Recovery private endpoints when using Arc gateway without enterprise proxy:** Include the FQDNs into the proxy bypass list. The traffic goes directly to your firewall (skipping the Arc proxy) and then to the private endpoint via ExpressRoute as per your routing policies. In this scenario, even if you don't use an enterprise proxy you can edit the proxy bypass list to include the Azure Site Recovery endpoints.

If you plan to use Azure Site Recovery in Azure Local to protect your workloads, make sure you configure the private endpoints as described in this article. [Enable replication for private endpoints in Azure Site Recovery - Azure Site Recovery \| Microsoft Learn](/azure/site-recovery/azure-to-azure-how-to-enable-replication-private-endpoints)

## Next steps

Learn more about using private endpoints with Azure Local in other scenarios:

- [Deploy Azure Local with an enterprise proxy but without an Arc gateway](./deploy-private-endpoints-with-proxy-no-gateway.md).
- [Deploy Azure Local without an enterprise proxy and without an Arc gateway](./deploy-private-endpoints-no-proxy-no-gateway.md).
- [Deploy Azure Local with both an enterprise proxy and an Arc gateway](./deploy-private-endpoints-with-proxy-with-gateway.md).