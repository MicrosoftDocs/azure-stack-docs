---
title: About Private Endpoints with Azure Local
description: Review how Azure Private Endpoints can be used when deploying Azure Local, with and without Arc gateway, and with and without Proxy.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 02/17/2026
ms.topic: concept-article
---

# Using Private Endpoints with Azure Local

This article provides a comprehensive overview of how you can integrate both existing and new Azure private endpoints with Azure Local. A private endpoint for Azure Local is a network interface that uses a private IP address from the virtual network associated with your Azure Local.

Currently, Azure Local offers the following distinct methods for outbound connectivity:

- Deploy Azure Local without an enterprise proxy and without an Arc gateway.

- Deploy Azure Local with an enterprise proxy but without an Arc gateway.

- Deploy Azure Local without an enterprise proxy but with an Arc gateway.

- Deploy Azure Local with both an enterprise proxy and an Arc gateway.

Each of this scenarios is described in the subsequent sections of this article.

## Supported private endpoints for Azure Local

While Azure Local infrastructure (nodes and Arc resource bridge VM) supports a variety of [Private endpoint types](/azure/private-link/private-endpoint-overview), Azure Arc Private Link is not supported. See [Use Azure Private Link to Connect Servers to Azure Arc by Using a private endpoint](/azure/azure-arc/servers/private-link-security). As a result, registering Azure Local with Arc always utilizes Arc public endpoints. [Troubleshoot Azure Arc resource bridge issues - Azure Arc \| Microsoft Learn](/azure/azure-arc/resource-bridge/troubleshoot-resource-bridge#private-link-is-unsupported).

If the customer is already using Azure Arc private link scope for Arc for servers and their corporate DNS is already resolving Arc private endpoints , then they must use a different DNS server for Azure Local infrastructure, to ensure it is always resolving public Arc endpoints.

For example, if name resolution for these two endpoints (**gbl.his.arc.azure.com** and **agentserviceapi.guestconfiguration.azure.com**) returns a private IP address from any of these ranges (10.x.x.x, 192.168.x.x or 172.16.x.x) on the Azure Local nodes or the enterprise proxy, it means Azure Arc Private Link DNS resolution is enabled and is not supported.

Customers intending to use private endpoints for services such as Key Vaults, Storage Accounts, SQL, Azure Container Registry, or other PaaS offerings alongside Azure Local should ensure that their DNS infrastructure resolves the PaaS FQDN to an internal IP address, and their network correctly routes traffic. Traffic is directed either to the public internet for public endpoints or through Azure ExpressRoute/Site-to-Site (S2S) VPN for private endpoints, according to its destination.

## Support for Azure Local VMs and Arc Private Link

Although Azure Local nodes and Arc Resource Bridge VM do not support Arc private link, it is possible to use Arc Private Link inside Azure Local VMs if the DNS servers in use are not the same as those used for the Azure Local infrastructure (Azure Local infrastructure DNS servers must not resolve Arc private endpoints). 

To enable Arc Private Link on existing Azure Local VMs, follow [Use Azure Private Link to Connect Servers to Azure Arc by Using a private endpoint - Azure Arc \| Microsoft Learn](/azure/azure-arc/servers/private-link-security#configure-an-existing-azure-arc-enabled-server). For new Azure Local VMs we don’t support enabling Arc Private Link during deployment yet. This feature will be enabled in upcoming releases.

## Arc resource bridge and AKS reserved network subnets coexistence with private endpoints

By default, when deploying Arc Resource Bridge VM in Azure Local, the following IP ranges are reserved for Kubernetes pods and services. Ensure that your PaaS services private endpoint IPs on the Azure VNET subnet used by AKS workloads do not overlap with any of reserved Kubernetes subnets.

For example, if your private endpoint has an IP from an Azure subnet 10.244.1.0/24, AKS will understand such IP as reserved and the request will not leave the AKS virtual networks and will never reach the private endpoint in the Azure VNET. However, if the private endpoint IP is on an Azure subnet 10.245.0.0/24, AKS will resolve the endpoint as external and will route the traffic to reach the private endpoint.

| **Service** | **Designated IP range** |
|----|----|
| Arc resource bridge Kubernetes pods | 10.244.0.0/16 (from 10.244.0.1 to 10.244.255.254) |
| Arc resource bridge Kubernetes services | 10.96.0.0/12 (from 10.96.0.1 to 10.111.255.54) |

This table summarizes key points for using supported private endpoints with Azure Local.

| Scenario | private endpoints outbound path | Arc Private Link Support | Supported private endpoint Types | Key Requirements / Limitations |
|----|----|:--:|:--:|----|
| **1. No Proxy, No Arc Gateway** | Direct. Routed via Express Route or S2S VPN | No | Storage, SQL, Key Vault, Azure Container Registry and other PaaS services supporting Private Link | Configure routing and DNS for private endpoints; no proxy bypass needed |
| **2. Proxy, No Arc Gateway** | Proxy bypassed. Routed via Express Route or S2S VPN | No | Storage, SQL, Key Vault, Azure Container Registry and other PaaS services supporting Private Link | Configure routing, DNS and proxy bypass list for private endpoint FQDNs |
| **3. No Proxy, Arc Gateway** | AKS Cluster IP Proxy bypassed. Routed via Express Route or S2S VPN | No | Storage, SQL, Key Vault, Azure Container Registry and other PaaS services supporting Private Link | Configure routing, DNS and environment variables for AKS/Arc resource bridge after Arc registration to bypass private endpoint FQDNs |
| **4. Proxy, Arc Gateway** | Proxy bypassed. Routed via Express Route or S2S VPN | No | Storage, SQL, Key Vault, Azure Container Registry and other PaaS services supporting Private Link | Configure routing, DNS and proxy bypass for private endpoint FQDNs |

## Scenario 1: No Proxy, No Arc Gateway

**Description:** Azure Local infrastructure sends HTTP and HTTPS traffic directly via the default route without a proxy or Arc gateway. Enterprise firewall/router can redirect this traffic to various subnets using the public internet or Azure ExpressRoute. Customers must define permitted endpoints on their firewall according to destination needs.

:::image type="content" source="media/deploy-private-endpoints/image1.png" alt-text="A blue and purple rectangle with text AI-generated content may be incorrect.":::Outbound Connectivity for Azure Local hosts:

**Diagram legend**:

- LNET = Logical Network

- 10.0.0.0/16 is just an example of a private network where the private endpoint can be configured.

<!-- -->

- HTTP/HTTPS outbound traffic uses the management network's default route.

- Public endpoints go through the enterprise firewall to the internet.

- Private endpoints are routed by the enterprise firewall via Azure ExpressRoute or S2S VPN.

:::image type="content" source="media/deploy-private-endpoints/image2.png" alt-text="A blue and purple rectangle with text AI-generated content may be incorrect.":::Outbound Connectivity for Arc Resource Bridge VM:

**Diagram legend**:

- LNET = Logical Network

- 10.0.0.0/16 is just an example of a private network where the private endpoint can be configured.

<!-- -->

- HTTP/HTTPS outbound traffic uses the management network's default route.

- Public endpoints go through the enterprise firewall/router to the internet.

- Private endpoints are routed by the enterprise firewall via Azure ExpressRoute or S2S VPN.

:::image type="content" source="media/deploy-private-endpoints/image3.png" alt-text="A blue and purple text and a white rectangle AI-generated content may be incorrect.":::Outbound Connectivity for AKS clusters control plane and worker VMs:

**Diagram legend**:

- LNET = Logical Network

- 10.0.0.0/16 is just an example of a private network where the private endpoint can be configured.

<!-- -->

- When the AKS cluster LNET shares the management network, HTTP and HTTPS outbound traffic follow the default route of the management network.

- If the AKS cluster LNET is separate from the management network, HTTP and HTTPS outbound traffic use the default route of the AKS subnet.

- The enterprise firewall/router directs public endpoint traffic over the internet.

- For private endpoints, the enterprise firewall sends traffic through Azure ExpressRoute or an S2S VPN.

:::image type="content" source="media/deploy-private-endpoints/image4.png" alt-text="A blue and purple line with words AI-generated content may be incorrect.":::Outbound Connectivity for Azure Local VMs:

**Diagram legend**:

- LNET = Logical Network

- 10.0.0.0/16 is just an example of a private network where the private endpoint can be configured.

<!-- -->

- Azure Local VMs can have independent proxy and Arc gateway settings, unrelated to host configuration.

- VMs on Azure Local hosts can run with or without their own proxy setup.

- Without proxy settings, VM traffic uses the VM’s LNET default gateway.

- Proxy details set during VM creation are applied as environment variables; any WinInet or WinHTTP proxy settings for Windows must be configured within the VM. For Linux VMs additional proxy settings might be also required.

### Private endpoints considerations when deploying Azure Local without proxy and without Arc gateway

*Key Vault private endpoints (vault.azure.net):*

Azure Local needs a Key Vault for deployment, which can use a private endpoint. Keep public access enabled until deployment finishes, as the Azure portal and HCI RP configure the Key Vault secrets.

*Storage account private endpoints (blob.core.windows.net):*

Azure Local with 2 nodes requires a Storage Account for deployment. This Storage Account can be on a private endpoint, but public access must be allowed until the initial deployment is complete. Azure portal and HCI RP need to configure the cloud witness during deployment. Once deployment is completed, you can restrict Storage Account access to only allow private networks.



## Scenario 2: Proxy, without Arc gateway

**Description:** Azure Local infrastructure runs with a proxy but no Arc gateway. When using an enterprise proxy, customers can control which endpoints use the proxy and which bypass it. Some endpoints require SSL inspection to be disabled, while local traffic—such as between nodes, domains, clusters, and local subnets—should bypass the proxy. Private endpoints should also be added to the bypass list for direct routing through the enterprise firewall/router and Azure ExpressRoute.

:::image type="content" source="media/deploy-private-endpoints/image5.png" alt-text="A blue and black text AI-generated content may be incorrect."::: Outbound Connectivity for Azure Local hosts:

**Diagram legend**:

- 10.0.0.0/16 is just an example of a private network where the private endpoint can be configured.

<!-- -->

- Customers define the proxy server and bypass list during Arc registration. The Arc registration script auto-configures these settings for WinInet, WinHTTP, and Environment Variables to manage host OS and Arc Resource Bridge VM traffic via the proxy or bypass list.

- Azure Local hosts send HTTP/HTTPS outbound traffic through the enterprise proxy, except for endpoints in the WinInet and WinHTTP bypass lists.

- For HTTPS traffic sent through the proxy, SSL inspection must be disabled for Azure Local required endpoints.

- Traffic bypassing the proxy goes directly via the customer's default route, where it is evaluated by the enterprise firewall.

- The enterprise firewall/router routes public endpoints to the internet and private endpoints over Azure ExpressRoute or S2S VPN.

:::image type="content" source="media/deploy-private-endpoints/image6.png" alt-text="A blue and purple arrow pointing to a white background AI-generated content may be incorrect.":::Outbound Connectivity for Arc Resource Bridge VM:

**Diagram legend**:

- 10.0.0.0/16 is just an example of a private network where the private endpoint can be configured.

<!-- -->

- Configuration of environment variables for proxy and bypass lists is essential to manage Arc Resource Bridge VM traffic routing through the enterprise proxy.

- Arc Resource Bridge requires specific endpoints and subnets to be included in the proxy bypass list. These are automatically appended during deployment, ensuring the following entries are added to the customer-defined proxy bypass list at the time of Arc registration:

  - “localhost,127.0.0.1,0.0.0.0,kubernetes.default.svc,.svc.cluster.local,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16”

- HTTP and HTTPS outbound traffic from the Arc Resource Bridge VM is routed to the enterprise proxy, except for those endpoints specified in the Environment Variables proxy bypass list.

- SSL inspection must be disabled for Arc Resource Bridge VM HTTPS traffic directed through the enterprise proxy.

- HTTP and HTTPS traffic that bypasses the proxy is routed directly via the customer’s default route, where it will be evaluated by the enterprise firewall.

- The enterprise firewall routes public endpoints to the internet and private endpoints over Azure ExpressRoute or S2S VPN.

### Outbound Connectivity for AKS clusters control plane and worker VMs:

:::image type="content" source="media/deploy-private-endpoints/image7.png" alt-text="A blue and white rectangular object with arrows AI-generated content may be incorrect.":::

**Diagram legend**:

- 10.0.0.0/16 is just an example of a private network where the private endpoint can be configured.

<!-- -->

- New AKS clusters in Azure Local using a proxy will have the Control Plane and Worker VMs inherit Arc resource bridge proxy and bypass list settings; add required private endpoints (e.g., Azure Container Registries) to the bypass list during deployment.

- AKS pods can have independent proxy and bypass configurations, defined during application deployment.

- When AKS Clusters LNET uses the management network, HTTP/HTTPS outbound traffic goes through the proxy via management network.

- If AKS Clusters LNETs differs from the management network, HTTP/HTTPS outbound traffic uses the AKS subnet default route to the proxy.

- The enterprise firewall routes public endpoints to the internet and private endpoints over Azure ExpressRoute or S2S VPN.

**  **

:::image type="content" source="media/deploy-private-endpoints/image8.png" alt-text="A blue and purple text AI-generated content may be incorrect.":::Outbound Connectivity for Azure Local VMs:

**Diagram legend**:

- 10.0.0.0/16 is just an example of a private network where the private endpoint can be configured.

<!-- -->

- Azure Local VMs can have independent proxy and Arc gateway settings, unrelated to host configuration.

- VMs on Azure Local hosts using a proxy can run without their own proxy setup.

- Without proxy settings, VM traffic uses the VM’s LNET default gateway.

- Proxy details set during VM creation are applied as environment variables; any WinInet or WinHTTP proxy settings for Windows must be configured within the VM.


### private endpoints Considerations for Deploying Azure Local with Proxy (No Arc Gateway)

*Key Vault private endpoints (vault.azure.net):*

Azure Local deployment requires a Key Vault, which can use a private endpoint. However, public access must be enabled during initial deployment for the Azure portal and HCI RP to configure secrets. After deployment, restrict access to private networks only.

*Storage Account private endpoints (blob.core.windows.net):*

A Storage Account is needed for a 2-node Azure Local deployment. You may use a private endpoint but keep public access open until setup is complete so that Azure portal and HCI RP can configure cloud witness. Restrict access to private networks once deployment finishes.

*Azure Container Registry (ACR) private e*ndpoints for AKS (azurecr.io):

For AKS workloads, customers often pull images from ACR private endpoints. During deployment, add specific ACR FQDNs to your proxy bypass list; wildcards like \*.azurecr.io are not supported because Arc resource bridge VMs require access to specific ACR endpoints, affecting both AKS and Arc resource bridge traffic.

## Scenario 3: No Proxy with Arc Gateway

**Description:** When Azure Local infrastructure runs without an enterprise proxy but uses the Arc gateway, all HTTPS traffic is configured to use the Arc proxy as proxy server. Arc registration automatically sets the host's WinInet and WinHTTP HTTPS proxy to `http://localhost:40343`. This channels all HTTPS traffic through the Arc proxy. For HTTP traffic, the hosts sends the traffic directly to the default route and the enterprise firewall. For Arc Resource Bridge VM and AKS Clusters, environment variables proxy configuration is also automatically configured by the Arc registration script as follow:

- `https`: `http://localhost:40343`

- `http`: ""

- `bypasslist`: localhost,.svc,kubernetes.default.svc,.svc.cluster.local,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12

These defaults are used to configure the Arc Resource Bridge VM proxy during Azure Local deployment. However, instead of using localhost:40343 as proxy server, during Arc Resource Bridge VM deployment, proxy server inside the VM is changed to be the Azure Local Cluster IP on port 40343.

:::image type="content" source="media/deploy-private-endpoints/image9.png" alt-text="A computer screen shot of a message AI-generated content may be incorrect."::: Outbound Connectivity for Azure Local hosts:

**Diagram legend**:

- 10.0.0.0/16 is just an example of a private network where the private endpoint can be configured.

- During Arc registration, the customer does not specify any enterprise proxy or proxy bypass list. However, the Arc registration script will automatically configure the host HTTPS proxy to become `http://localhost:40343`. This is the Arc proxy address used by the host to funnel all HTTPS traffic over the Arc gateway tunnel.

- Azure Local hosts HTTP traffic is sent directly to the enterprise firewall because Arc gateway does not support HTTP.

- All Azure Local hosts HTTPS outbound traffic is sent to the Arc proxy.

  - If the endpoints are allowed by Arc gateway, the traffic will go directly to the Arc gateway in Azure and from there it will reach the corresponding Azure service endpoint.

  - If the endpoints are not allowed by Arc gateway, Arc proxy will retry the connection to the endpoint over the enterprise firewall. Third party endpoints traffic such as OEM endpoints will follow this path. Private endpoints will also follow this path.

- Azure Local Hosts HTTPS traffic that is not allowed by Arc gateway and is sent to the enterprise firewall must be allowed if the endpoint is legit and required.

- Enterprise firewall routes public endpoints over internet.

- Enterprise firewall routes private endpoints over Azure ExpressRoute or S2S VPN.

:::image type="content" source="media/deploy-private-endpoints/image10.png" alt-text="A diagram of a company AI-generated content may be incorrect.":::Outbound Connectivity for Arc Resource Bridge VM:

**Diagram legend**:

- 10.0.0.0/16 is just an example of a private network where the private endpoint can be configured.

- Environment Variables proxy and bypass list configuration on Azure Local nodes is used to configure the proxy inside the Arc Resource Bridge VM.

- Arc Resource Bridge has specific endpoints and subnets requirements that must be added to the proxy bypass list. This is done automatically during deployment, and the following endpoints are added:

  - “localhost,127.0.0.1,0.0.0.0,kubernetes.default.svc,.svc.cluster.local,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16”

- Because Arc gateway is enabled during Arc registration, the Arc Resource Bridge VM proxy server is automatically set to use the Azure Local Cluster IP on port 40343 and the proxy bypass list use the Environment Variables values.

- Arc Resource Bridge VM HTTPS outbound traffic is sent to the cluster IP proxy except those endpoints added to the Environment Variables proxy bypass list. Then the traffic is sent to the Arc proxy and behaves as follows:

  - If HTTPS endpoint is allowed by Arc gateway, the traffic goes over the tunnel to the Azure services endpoints

  - If HTTPS endpoint is not allowed by Arc gateway, Arc proxy retries the connection sending the traffic directly to the customer default route, where the enterprise firewall will evaluate the traffic.

  - HTTPS bypassed endpoints are sent directly to the customer default route, where their enterprise firewall will evaluate the traffic.

- Arc Resource Bridge VM HTTP traffic is sent directly to the customer default route, where their enterprise firewall will evaluate the traffic.

- Enterprise firewall routes public endpoints over internet.

- Enterprise firewall routes private endpoints over Azure ExpressRoute or S2S VPN.

:::image type="content" source="media/deploy-private-endpoints/image11.png" alt-text="A diagram of a diagram AI-generated content may be incorrect.":::Outbound Connectivity for AKS clusters control plane and worker VMs:

**Diagram legend**:

- 10.0.0.0/16 is just an example of a private network where the private endpoint can be configured.

- If customers deploy new AKS clusters in Azure Local, the AKS cluster control plane VMs and Worker VMs will inherit the Arc resource bridge proxy and bypass list configuration. This is important to understand because if AKS workloads require access to some private endpoint such as Azure Container Registries, those endpoints must be added to the Environment Variables proxy bypass list after Arc registration but before starting the Azure Local deployment. For example, if you want to add a specific Azure Container Registry endpoint to be used by AKS workloads, append such endpoint to the existing bypass list

  - “localhost,127.0.0.1,0.0.0.0,kubernetes.default.svc,.svc.cluster.local,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,**<u>customerACR.azureio.cr</u>**”

  - This is particularly important for scenarios where AKS clusters are running on their own LNET and you want the ACR traffic to go directly from the AKS subnet to the enterprise firewall. If the endpoint is not added to the Environment Variables bypass list after Arc registration, the Arc proxy running on the host on the management network will send the request and the firewall must be configured to allow the request from the host.

- Pods running on AKS worker nodes are independent and can have their own proxy and bypass list configuration, which gets defined during POD application deployment.

- Enterprise firewall routes public endpoints over internet.

- Enterprise firewall routes private endpoints over Azure ExpressRoute or S2S VPN.

### Outbound Connectivity for Azure Local VMs:

- Azure Local VMs can have their own proxy and Arc gateway configuration independent from the hosts. There is no dependency from Azure Local hosts configuration.

- If Azure Local VMs do not have proxy configuration, the traffic will be routed over the defined LNET default gateway.

- Arc gateway can be configured independently for Azure Local VMs regardless of whether the infrastructure is using it or not.

- The same or different Arc gateway from the hosts can be used for Azure Local VMs.

### Considerations for private endpoints when deploying Azure Local without proxy but with Arc gateway

#### Key Vault private endpoints: (vault.azure.net)

Azure Local requires a Key Vault for deployment. This Key Vault can be on a private endpoint, but public access must be allowed until the initial deployment is complete. Azure portal and HCI RP need to configure the Key Vault secrets during deployment. Once deployment is completed, you can restrict Key Vault access to only allow private networks.

#### Storage account private endpoints:(blob.core.windows.net)

Azure Local with 2 nodes requires a Storage Account for deployment. This Storage Account can be on a private endpoint, but public access must be allowed until the initial deployment is complete. Azure portal and HCI RP need to configure the cloud witness during deployment. Once deployment is completed, you can restrict Storage Account access to only allow private networks. If your security team wants to ensure that this storage account endpoint is specifically allowed in your firewall from your Azure Local nodes as source IP, you must add the endpoint to the proxy bypass list, so the traffic is sent directly to your firewall instead of going through the Arc gateway tunnel.

#### Azure Container Registry private endpoints for AKS: (azurecr.io)

It is common that customers pull images for their AKS workloads from private Azure Container Registry endpoints. In those scenarios, although it is possible to send the private endpoints traffic over the Arc proxy, it is recommended to include the specific ACR FQDN endpoints to the Environment Variables proxy bypass list after Arc registration but before starting the deployment. It is not supported to use wildcards such as \*.azurecr.io because Arc resource bridge VM uses specific ACR endpoints and the proxy bypass list applies not only to AKS but also to Arc resource bridge VM.

#### Azure Site Recovery private endpoints (privatelink.siterecovery.windowsazure.com)

The ASR private endpoints FQDNs are not allowed by Arc gateway. That means that traffic can follow two outbound paths depending on your security requirements:

- **Outbound path option 1 for ASR private endpoints when using Arc gateway without enterprise proxy: Do not include the FQDNs to the proxy bypass list.** If you don’t add the FQDNs to the proxy bypass list, the traffic will be sent to the Arc proxy but will be rejected. A retry is then sent directly to your enterprise firewall and then to the private endpoint via express route according to your routing policies.

- **Outbound path option 2 for ASR private endpoints when using Arc gateway without enterprise proxy: Include the FQDNs to the proxy bypass list.** If you add the FQDNs to the proxy bypass list, the traffic will be sent directly to your firewall (skipping the Arc proxy) and then to the private endpoint via express route according to your routing policies. In this scenario, even if you don’t use an enterprise proxy you can edit the proxy bypass list to include the ASR endpoints.

If you are planning to use Azure Site Recovery in Azure Local to protect your workloads make sure you configure the private endpoints as described in this article. [Enable replication for private endpoints in Azure Site Recovery - Azure Site Recovery \| Microsoft Learn](/azure/site-recovery/azure-to-azure-how-to-enable-replication-private-endpoints)

## Scenario 4: With proxy and Arc Gateway

**Description:** Azure Local runs with an enterprise proxy and Arc gateway.

During Arc registration, the customer specifies the enterprise proxy and the proxy bypass list. The Arc registration script will automatically configure the host as follows:

- WinInet and WinHTTP HTTPS proxy to become `http://localhost:40343`. This is the Arc proxy address used by the host to funnel all HTTPS traffic over the Arc gateway tunnel. Proxy bypass list defined by the customer will be also configured

- WinInet and WinHTTP HTTP proxy to become the customer enterprise proxy. This is the address used to send HTTP traffic directly to the customer enterprise proxy. Remember that Arc proxy does not support HTTP traffic. Proxy bypass list defined by the customer will be also configured

Proxy server and bypass list for Environment Variables are also automatically configured on each host as follows:

- `https`: `http://localhost:40343`

- `http`: `http://customerproxy:port`

- `bypasslist`: localhost,.svc,kubernetes.default.svc,.svc.cluster.local,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12 + customer defined bypass endpoints.

The bypass list for Environment Variables is automatically constructed by using the customer defined list of endpoints during Arc registration and appending the default required endpoints for Arc resource bridge.

This proxy and bypass list configuration in Environment Variables is used to configure the proxy inside Arc Resource Bridge VM during Azure Local deployment.

:::image type="content" source="media/deploy-private-endpoints/image12.png" alt-text="A screenshot of a computer AI-generated content may be incorrect.":::Outbound Connectivity for Azure Local hosts:

**Diagram legend**:

- 10.0.0.0/16 is just an example of a private network where the private endpoint can be configured.
- During Arc registration, the customer specifies the enterprise proxy and the proxy bypass list. The Arc registration script will automatically configure the host HTTPS proxy to become `http://localhost:40343` because Arc gateway is enabled. This is the Arc proxy address used by the host to funnel all HTTPS traffic over the Arc gateway tunnel.
- The HTTP proxy is set to use the customer enterprise proxy. Azure Local hosts HTTP traffic is sent to the enterprise proxy because Arc gateway does not support HTTP.
- All Azure Local hosts HTTPS outbound traffic except the endpoints added to the proxy bypass list is sent to the Arc proxy.

  - If the endpoints are allowed by Arc gateway, the traffic will go directly to the Arc gateway in Azure and from there it will reach the corresponding Azure service endpoint.

  - If the endpoints are not allowed by Arc gateway, Arc proxy will retry the connection to the endpoint over the enterprise proxy. Third party endpoints traffic such as OEM endpoints will follow this path. Private endpoints will also follow this path of they are not added to the proxy bypass list.

- Azure Local Hosts HTTPS traffic that is not allowed by Arc gateway and is sent to the enterprise proxy must be allowed if the endpoint is legit and required.

- From the enterprise proxy, the non-allowed Arc gateway traffic is then routed to the enterprise firewall, which will route the traffic to public internet or to the private endpoints over Azure ExpressRoute or S2S VPN.

:::image type="content" source="media/deploy-private-endpoints/image13.png" alt-text="A diagram of a flowchart AI-generated content may be incorrect.":::Outbound Connectivity for Arc Resource Bridge VM:

**Diagram legend**:

- 10.0.0.0/16 is just an example of a private network where the private endpoint can be configured.

<!-- -->

- Environment Variables proxy and bypass list configuration on Azure Local nodes is used to configure the proxy inside the Arc Resource Bridge VM.

<!-- -->

- Arc Resource Bridge has specific endpoints and subnets requirements that must be added to the proxy bypass list. This is done automatically during deployment, and the following endpoints are added to the customer defined proxy bypass list :

  - “localhost,127.0.0.1,0.0.0.0,kubernetes.default.svc,.svc.cluster.local,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16”

- Because Arc gateway is enabled during Arc registration, the Arc Resource Bridge VM proxy server is automatically set to use the Azure Local Cluster IP on port 40343 and the proxy bypass list use the Environment Variables values.

- Arc Resource Bridge VM HTTPS outbound traffic is sent to the cluster IP proxy except those endpoints added to the Environment Variables proxy bypass list. Then the traffic is sent to the Arc proxy and behaves as follows:

  - If HTTPS endpoint is allowed by Arc gateway, the traffic goes over the tunnel to the Azure services endpoints

  - If HTTPS endpoint is not allowed by Arc gateway, Arc proxy retries the connection sending the traffic directly to the enterprise proxy.

  - HTTPS bypassed endpoints are sent directly to the enterprise firewall, which will route the traffic to public internet or to the private endpoints over Azure ExpressRoute or S2S VPN.

- Arc Resource Bridge VM HTTP traffic is sent directly to the enterprise proxy.

- From the enterprise proxy, traffic is routed to the enterprise firewall, which will route the traffic to public internet or to the private endpoints over Azure ExpressRoute or S2S VPN.

:::image type="content" source="media/deploy-private-endpoints/image14.png" alt-text="A diagram of a diagram AI-generated content may be incorrect.":::Outbound Connectivity for AKS clusters control plane and worker VMs:

**Diagram legend**:

- 10.0.0.0/16 is just an example of a private network where the private endpoint can be configured.

<!-- -->

- If customers deploy new AKS clusters in Azure Local, the AKS cluster control plane VMs and Worker VMs will inherit the Arc resource bridge proxy and bypass list configuration. This is important to understand because if AKS workloads require access to some private endpoint such as Azure Container Registries, those endpoints must be added to the proxy bypass list during Arc registration. For example, if you want to add a specific Azure Container Registry endpoint to be used by AKS workloads, append such endpoint to the proxy bypass list

  - This is particularly important for scenarios where AKS clusters are running on their own LNET and you want the ACR traffic to go directly from the AKS subnet to the enterprise firewall. If the endpoint is not added to the proxy bypass list during Arc registration, the Arc proxy running on the host on the management network will send the request and the firewall must be configured to allow the request from the host.

- Because Arc gateway is enabled during Arc registration, the AKS Clusters inherits the proxy and proxy bypass list configuration from Arc Resource Bridge, so proxy server is automatically set to use the Azure Local Cluster IP on port 40343

- AKS Cluster VMs HTTPS outbound traffic is sent to the cluster IP proxy except those endpoints added to the proxy bypass list. Then the traffic is sent to the Arc proxy and behaves as follows:

  - If HTTPS endpoint is allowed by Arc gateway, the traffic goes over the tunnel to the Azure services endpoints

  - If HTTPS endpoint is not allowed by Arc gateway, Arc proxy retries the connection sending the traffic directly to the enterprise proxy.

  - HTTPS bypassed endpoints are sent directly to the enterprise firewall, which will route the traffic to public internet or to the private endpoints over Azure ExpressRoute or S2S VPN.

- AKS Cluster VMs HTTP traffic is sent directly to the enterprise proxy.

- From the enterprise proxy, traffic is routed to the enterprise firewall, which will route the traffic to public internet or to the private endpoints over Azure ExpressRoute or S2S VPN.

- 

- PODs running on AKS worker nodes are independent and can have their own proxy and bypass list configuration, which gets defined during POD application deployment.

### Outbound Connectivity for Azure Local VMs:

- Azure Local VMs can have their own proxy and Arc gateway configuration independent from the hosts. There is no dependency from Azure Local hosts configuration.

- If Azure Local VMs do not have proxy configuration, the traffic will be routed over the defined LNET default gateway.

- Arc gateway can be configured independently for Azure Local VMs regardless of whether the infrastructure is using it or not.

- The same or different Arc gateway from the hosts can be used for Azure Local VMs.

### Private endpoints considerations when deploying Azure Local with proxy and Arc gateway

#### Key Vault private endpoints: (vault.azure.net)

Azure Local requires a Key Vault for deployment. This Key Vault can be on a private endpoint, but public access must be allowed until the initial deployment is complete. Azure portal and HCI RP need to configure the Key Vault secrets during deployment. Once deployment is completed, you can restrict Key Vault access to only allow private networks. Other customer Key Vaults used for workloads can have public access restricted without any constraints.

#### Storage account private endpoints:(blob.core.windows.net)

Azure Local with 2 nodes requires a Storage Account for deployment. This Storage Account can be on a private endpoint, but public access must be allowed until the initial deployment is complete. Azure portal and HCI RP need to configure the cloud witness during deployment. Once deployment is completed, you can restrict Storage Account access to only allow private networks. Other customer Storage accounts used for workloads can have public access restricted without any constraints. If your security team wants to ensure that this storage account endpoint is specifically allowed in your firewall from your Azure Local nodes as source IP, you must add the endpoint to the proxy bypass list, so the traffic is sent directly to your firewall instead of going through the Arc gateway tunnel.

#### Azure Container Registry private endpoints for AKS: (azurecr.io)

It is common that customers pull images for their AKS workloads from private Azure Container Registry endpoints. In those scenarios, although it is possible to send the private endpoints traffic over the Arc proxy, it is recommended to include the specific ACR FQDN endpoints to the Environment Variables proxy bypass during Arc. It is not supported to use wildcards such as \*.azurecr.io because Arc resource bridge VM uses specific ACR endpoints and the proxy bypass list applies not only to AKS but also to Arc resource bridge VM.

#### Azure Site Recovery private endpoints (privatelink.siterecovery.windowsazure.com)

The ASR private endpoints FQDNs are not allowed by Arc gateway. That means that traffic can follow two outbound paths depending on your security requirements:

- **Outbound path option 1 for ASR private endpoints: Do not include the FQDNs to the proxy bypass list.** If you don’t add the FQDNs to the proxy bypass list, the traffic will be sent to your enterprise proxy and must have SSL inspection disabled. From the proxy the request will be routed to your firewall and then to the private endpoint via express route according to your routing policies.

- **Outbound path option 2 for ASR private endpoints: Include the FQDNs to the proxy bypass list.** If you add the FQDNs to the proxy bypass list, the traffic will be sent directly to your firewall and then to the private endpoint via express route according to your routing policies.

If you are planning to use Azure Site Recovery in Azure Local to protect your workloads make sure you configure the private endpoints as described in this article. [Enable replication for private endpoints in Azure Site Recovery - Azure Site Recovery \| Microsoft Learn](/azure/site-recovery/azure-to-azure-how-to-enable-replication-private-endpoints)
