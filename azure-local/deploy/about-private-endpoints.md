---
title: About using Private Endpoints to Connect with Azure Local
description: Review how Azure Private Endpoints can be used when deploying Azure Local, with and without Arc gateway, and with and without Proxy.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 03/09/2026
ms.topic: concept-article
---

# Use Azure private endpoints to connect to Azure Local

This article provides an overview of Azure private endpoints on Azure Local including the supported and unsupported scenarios, and key requirements for successful connectivity.

## About private endpoints

A private endpoint is a network interface that uses a private IP address from the virtual network. Private endpoints enable Azure services to be accessed over a private network connection rather than the public internet. This guidance is intended to help you understand how to connect from Azure Local to different Azure PaaS services such as Azure Storage, Azure Key Vault, Azure SQL Database and Azure Container Registry, using private endpoints.

## Supported private endpoint scenarios

Azure Local infrastructure (including the nodes and the Arc resource bridge VM) supports many [Azure private endpoint types](/azure/private-link/private-endpoint-overview), but Azure Arc Private Link is not supported. Because of this, Azure Local always registers with Azure Arc using public Arc endpoints.

For more information, see [Use Azure Private Link to connect machines to Azure Arc by Using a private endpoint](/azure/azure-arc/servers/private-link-security) and [Troubleshoot Azure Arc resource bridge issues]().

The following table summarizes key points for using supported private endpoints with Azure Local.

| Scenario | Private endpoint outbound path | Supported private endpoint types | Key requirements or limitations |
|----|----|:--:|:--:|
| **1. No proxy, no Arc gateway** | Direct. <br> Routed via Express Route or S2S VPN | Storage, SQL, Key Vault, Azure Container Registry and other PaaS services supporting Private Link | Configure routing and DNS for private endpoints; no proxy bypass needed |
| **2. With proxy, no Arc gateway** | Proxy bypassed. <br> Routed via Express Route or S2S VPN | Storage, SQL, Key Vault, Azure Container Registry and other PaaS services supporting Private Link | Configure routing, DNS and proxy bypass list for private endpoint FQDNs |
| **3. No proxy, with Arc gateway** | AKS cluster IP proxy bypassed. <br> Routed via Express Route or S2S VPN | Storage, SQL, Key Vault, Azure Container Registry and other PaaS services supporting Private Link | Configure routing, DNS and environment variables for AKS/Arc resource bridge after Arc registration to bypass private endpoint FQDNs |
| **4. With proxy, with Arc gateway** | Proxy bypassed. <br> Routed via Express Route or S2S VPN | Storage, SQL, Key Vault, Azure Container Registry and other PaaS services supporting Private Link | Configure routing, DNS and proxy bypass for private endpoint FQDNs |

### DNS requirements

Azure Local infrastructure must always resolve Azure Arc endpoints to public IP addresses. Azure Arc Private Link is not supported for Azure Local nodes or the Arc resource bridge VM.

- If your organization uses Azure Arc Private Link elsewhere, Azure Local must use separate DNS servers that do not resolve Arc endpoints to private IPs.

    - **Required public DNS resolution**: The following Azure Arc endpoints must resolve to public IP addresses on Azure Local nodes and any enterprise proxy:

        - `gbl.his.arc.azure.com`
        - `agentserviceapi.guestconfiguration.azure.com`

    - **Resolution to private IP ranges**: Private IP ranges (10.x.x.x, 192.168.x.x, 172.16.x.x) aren't supported.

- **DNS for Azure PaaS services** - Private endpoints for services such as Key Vaults, Storage Accounts, SQL, Azure Container Registry, or other PaaS offerings alongside Azure Local are supported.

    - DNS infrastructure must resolve the PaaS service FQDN to an internal IP address.
    - Network routing must correctly direct traffic as per the destination:
        -  To the public internet or through Arc gateway for Azure public endpoints.
        -  Through Azure ExpressRoute/Site-to-Site (S2S) VPN for private endpoints.


### Arc resource bridge and AKS reserved network subnets with private endpoints

When deploying Arc Resource Bridge VM in Azure Local:

- Keep in mind that the following IP ranges are reserved for Kubernetes pods and services.


    | **Service** | **Designated IP range** |
    |----|----|
    | Arc resource bridge Kubernetes pods | 10.244.0.0/16 (from 10.244.0.1 to 10.244.255.254) |
    | Arc resource bridge Kubernetes services | 10.96.0.0/12 (from 10.96.0.1 to 10.111.255.54) |

- Ensure that your PaaS services private endpoint IPs on the Azure VNET subnet used by AKS workloads don't overlap with any of reserved Kubernetes subnets.

    For example, if your private endpoint has an IP from an Azure subnet 10.244.1.0/24, AKS understands such IP as reserved and the request doesn't leave the AKS virtual networks and never reaches the private endpoint in the Azure VNET. However, if the private endpoint IP is on an Azure subnet 10.245.0.0/24, AKS resolves the endpoint as external and routes the traffic to reach the private endpoint.

## Unsupported scenarios

Azure Local VMs and AKS don't support Azure Arc Private Link in Azure Local.

## Related steps

Learn how to deploy Azure private endpoints for Azure Local in the following scenarios:
- [Deploy Azure Local with private endpoints, and without proxy, without Arc gateway](./deploy-private-endpoints-no-proxy-no-gateway.md)
- [Deploy Azure Local with private endpoints, and with proxy, without Arc gateway](./deploy-private-endpoints-with-proxy-no-gateway.md)
- [Deploy Azure Local with private endpoints and without proxy, with Arc gateway](./deploy-private-endpoints-no-proxy-with-gateway.md)
- [Deploy Azure Local with private endpoints, with proxy, with Arc gateway](./deploy-private-endpoints-with-proxy-with-gateway.md)