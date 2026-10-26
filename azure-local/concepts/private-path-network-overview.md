---
title: Overview of private path network architecture for Azure Local
description: Learn about private path network architecture for Azure Local.
author: ronmiab
ms.topic: overview
ms.date: 09/29/2026
ms.author: robess 
ms.reviewer: cedward
---

# What is the private path network for Azure Local?

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article provides an overview of Azure Local private path network architecture that uses Azure Arc gateway and Azure Firewall explicit proxy.

## About private path network for Azure Local

Private path network architecture for Azure Local enables secure outbound connectivity to Azure without exposing your on-premises environment to the public internet. This architecture uses Azure Arc gateway and Azure Firewall explicit proxy to route traffic over private connections such as ExpressRoute or site-to-site virtual private network (VPN).

By centralizing outbound connectivity through Azure-managed services, private path networking helps reduce the attack surface, simplify network configuration, and align Azure Local deployments with enterprise security and compliance requirements.

This article includes:

- **Architecture components:** Understanding the core components required, including Azure Local machines, Arc gateway, Azure Firewall explicit proxy, and Azure networking infrastructure.
- **Traffic categorization:** Clearly distinguishing between different types of network traffic (internal, HTTP, HTTPS, third-party) and their appropriate routing paths.

<!--

- **Configuration steps:** Detailed guidance on setting up Azure Firewall explicit proxy, creating firewall rules, registering Azure Local machines via Arc gateway, and configuring proxy bypass lists.

- **Validation and monitoring:** Instructions for validating proxy configurations across various system components and enabling monitoring through Azure Log Analytics for effective troubleshooting and compliance.

By following this structured approach, IT administrators can ensure secure, efficient, and compliant connectivity between their on-premises Azure Local environments and Azure services, while leveraging existing network infrastructure and security policies.-->

## Key benefits

Here are the key benefits of using Azure Local private path network architecture:

- **Better security:** Keep Azure Local traffic within your on-premises network and Azure by using ExpressRoute or site-to-site VPNs.
- **Easier setup:** Use your existing network and security infrastructure while the Arc gateway manages Azure connectivity.
- **Simpler management:** Fewer endpoints to manage means easier tracking and troubleshooting.

## Architecture overview

Private path networking for Azure Local combines the following components:

:::image type="content" source="media/private-path-network/private-path-architecture.svg" alt-text="Architecture diagram showing Azure Local hosts, Arc proxy, enterprise firewall, private connection, VNet services, and public endpoints." lightbox="media/private-path-network/private-path-architecture.svg":::

- **Azure Local machines** that generate outbound traffic.
- On-premises Azure Local instance.
- **Arc proxy** running on Azure Local hosts, which forwards HTTPS traffic to Arc gateway.
- **Azure Arc gateway**, which allows outbound HTTPS traffic only to Microsoft‑managed endpoints.
- **Enterprise firewall** that is your organization's existing security infrastructure controlling the outbound traffic.
- **Azure virtual network** associated with your instance.
- **Azure Firewall explicit proxy**, which forwards the Arc gateway tunnel and handles required HTTP and HTTPS traffic that doesn't use Arc gateway.
- **ExpressRoute circuit** as the communication path between the on-premises networks and Azure virtual networks.
- **Azure public endpoints**. The local environment requires access to Azure services such as Azure Resource Manager, Key Vault, and Microsoft Graph.

Each traffic type follows a specific routing path based on protocol and destination.

To set up these components, see the prerequisites in [Register Azure Local with Azure Arc gateway and private path](../deploy/deployment-with-azure-arc-gateway-private-path.md#prerequisites-and-requirements).

## Restrictions and limitations

When you implement Azure Local private path network architecture, be aware of the following restrictions and limitations:

- This solution uses Azure Firewall explicit proxy as a forward proxy. Azure Local doesn't support Transport Layer Security (TLS) inspection on the required endpoints.
- You can't apply TLS certificates to the Azure Firewall explicit proxy.

> [!IMPORTANT]
> Microsoft doesn't validate or support any variation of the Azure Local private path architecture that's different from what this article describes.

## Traffic categories

In a private path deployment, Azure Local routes outbound traffic based on the traffic source, protocol, and destination. Use the following table to identify the traffic category and understand the path that the traffic takes.

| **Traffic category**<br>What traffic is this? | **Protocol**<br>Which protocol does it use? | **Traffic path**<br>How is the traffic routed? | **Traffic flow scenario**<br>Where can I see the detailed flow? |
| --- | --- | --- | --- |
| [Internal, machine-to-machine, and explicitly bypassed Private Link traffic](#machine-os-traffic-that-bypasses-the-proxy) | Service-specific; HTTP and HTTPS where applicable | Uses local routing or private endpoint IPs without the Arc proxy or explicit proxy | [Machine OS traffic that bypasses the proxy](#traffic-flow-for-machine-os-traffic-that-bypasses-the-proxy) |
| [Machine OS HTTP traffic to Azure](#machine-os-http-traffic-via-azure-firewall-explicit-proxy) | HTTP | Routes through Azure Firewall explicit proxy | [Machine OS HTTP traffic via Azure Firewall explicit proxy](#traffic-flow-for-machine-os-http-traffic-via-azure-firewall-explicit-proxy) |
| [Machine OS HTTPS traffic to endpoints supported by Arc gateway](#machine-os-https-traffic-via-arc-proxy) | HTTPS | Routes through the Arc proxy and Arc gateway tunnel | [Machine OS HTTPS traffic via Arc proxy](#machine-os-https-traffic-via-arc-proxy) |
| [Third-party machine OS HTTPS traffic](#third-party-os-https-traffic) | HTTPS | Arc proxy redirects to Azure Firewall explicit proxy | [Machine OS HTTPS traffic via Arc proxy](#machine-os-https-traffic-via-arc-proxy) |
| [Private Link endpoints outside Arc gateway coverage, such as Azure Site Recovery (ASR)](#machine-os-https-traffic-via-arc-proxy) | HTTPS | Arc proxy connects directly to the private IP over the private network, without Azure Firewall explicit proxy or Arc gateway; no bypass entry required | [Machine OS HTTPS traffic via Arc proxy](#machine-os-https-traffic-via-arc-proxy) |
| [Non-bypassed Arc resource bridge and Azure Kubernetes Service (AKS) node traffic](#arc-resource-bridge-and-aks-cluster-traffic) | HTTPS | Uses the cluster IP proxy and host Arc proxy; gateway-supported destinations use the host tunnel | [Arc resource bridge appliance VM HTTPS traffic](#arc-resource-bridge-appliance-vm-https-traffic-via-cluster-ip-proxy) and [AKS cluster HTTPS traffic](#aks-cluster-https-traffic-via-cluster-ip-proxy) |
| [AKS workload traffic](#arc-resource-bridge-and-aks-cluster-traffic) | Workload-specific | Uses customer-controlled workload proxy and egress settings | [AKS cluster HTTPS traffic](#aks-cluster-https-traffic-via-cluster-ip-proxy) |
| [Azure Local VM guest Arc connectivity](#azure-local-vm-https-traffic) | HTTPS | Uses the guest's own outbound proxy and Arc gateway configuration | [Azure Local VM HTTPS traffic](#azure-local-vm-https-traffic) |

The following sections describe each traffic category in more detail.

### Machine OS traffic that bypasses the proxy

Some HTTP and HTTPS connections must bypass Azure Firewall explicit proxy and connect directly to their intended internal destinations. Typically, technical or performance reasons require these exceptions.

Configure this traffic to bypass the proxy so that it can connect directly to its internal destination.
For Private Link connections that must bypass both proxies, add the destination to the proxy bypass list.
Private Link connections don't always require a bypass entry. Private endpoints outside Arc gateway coverage, such as Azure Site Recovery (ASR) private endpoints, can instead use the [direct route from Arc proxy](#machine-os-https-traffic-via-arc-proxy).

### Machine OS HTTP traffic via Azure Firewall explicit proxy

Some OS-level HTTP traffic can't use the Arc proxy and must be routed through Azure Firewall explicit proxy instead. Route this traffic through Azure Firewall explicit proxy to ensure it reaches Azure while complying with internal network and security requirements.

### OS HTTPS traffic via Arc proxy

Some OS-level HTTPS traffic must always be routed through the Arc proxy.

Routing this traffic through the Arc proxy ensures secure, controlled, and consistent connectivity to Azure endpoints by using the Arc gateway’s built-in security and management capabilities.

Make sure you allow all required Arc gateway endpoints for Azure Local. For more information, see [Azure Local Arc gateway required endpoints](/azure/azure-local/deploy/deployment-azure-arc-gateway-overview?tabs=portal#azure-local-endpoints-not-redirected).

### Third-party OS HTTPS traffic

Non-bypassed OS-level HTTPS traffic initially routes to the Arc proxy. However, the Arc gateway allows connections only to supported Microsoft-managed endpoints.

As a result, HTTPS traffic destined for third‑party services—such as original equipment manufacturer (OEM) endpoints, hardware vendor update services, or other third‑party agents installed on your servers, can’t pass through the Arc gateway. This traffic routes through Azure Firewall explicit proxy.

Configure Azure Firewall explicit proxy application rules to explicitly allow access to the required third‑party endpoints. Define these rules based on your organization’s security and connectivity requirements to ensure that third‑party services function correctly.

### Arc resource bridge and AKS cluster traffic

Azure Arc resource bridge is a Kubernetes-based management solution deployed as a virtual appliance (also called the Arc appliance) on your on-premises infrastructure. Its main purpose is to enable your local resources to appear and be managed as Azure resources through Azure Resource Manager.

To achieve this, Arc resource bridge requires outbound connectivity to specific Azure endpoints. Non-bypassed HTTPS uses the cluster IP proxy, which forwards traffic to the host Arc proxy. Gateway-supported destinations use the host's existing Arc gateway tunnel. Bypassed destinations and HTTP use the separate routes shown in the appliance scenario.

For AKS on Azure Local, the control-plane and worker VMs send non-bypassed HTTPS through the cluster IP proxy on TCP port 40343. The cluster IP proxy forwards this node traffic to the host Arc proxy, which uses the existing Arc gateway tunnel for supported destinations. Pods have their own customer-controlled proxy configuration and don't use the cluster IP proxy by default. Configure workload proxy settings and permit the endpoints required by those workloads separately.

## Traffic flow scenarios

The following sections show the routing path for each traffic category described in [Traffic categories](#traffic-categories).

> [!NOTE]
> The network maps distinguish host traffic from workload traffic. In Arc resource bridge and AKS scenarios, the Azure Local host provides the shared Arc proxy and gateway tunnel rather than acting as an independent OS traffic source.

### Traffic flow for machine OS traffic that bypasses the proxy

The following network map shows two ways that traffic can reach internal or private destinations:

- **Solid teal routes**: Traffic from Azure Local machines bypasses the Arc proxy. Traffic to intranet destinations stays on-premises, while Private Link traffic uses the private connection to reach private endpoints in the Azure virtual network.
- **Dashed teal route**: Traffic from the Arc proxy connects directly to the private IP. This traffic doesn't use the Azure Firewall explicit proxy or Arc gateway and doesn't require an entry in the proxy bypass list.

For more information about the direct route from the Arc proxy, see [Machine OS HTTPS traffic via Arc proxy](#machine-os-https-traffic-via-arc-proxy).

:::image type="content" source="media/private-path-network/private-path-overview.svg" alt-text="Network map showing solid teal host bypass and dashed teal direct Arc proxy traffic reaching one generic Private endpoints box." lightbox="media/private-path-network/private-path-overview.svg":::

Typical scenarios include:

- Internal communications within your local intranet.
- Machine-to-machine communications within the Azure Local system.
- Traffic destined for internal management or monitoring systems.
- Traffic destined for Private Link endpoints such as Azure Key Vaults or Azure Storage accounts.

This traffic goes directly to these endpoints without passing through the Arc gateway or Azure Firewall explicit proxy. This approach ensures low latency and efficient internal communication.

When you define your proxy bypass string for your Arc initialization script or when you use the Configurator app, ensure you include the following:

- Include at least the IP address of each Azure Local machine.
- Include at least the IP address of the Azure Local system.
- Include at least the IPs you defined for your infrastructure network. Arc resource bridge, AKS, and future infrastructure services that use these IPs require outbound connectivity.
- Or you can bypass the entire infrastructure subnet.
- Include the NetBIOS name of each machine.
- Include the NetBIOS name of the Azure Local system.
- Include a domain name or domain name with an asterisk * wildcard at the beginning to include any host or subdomain. For example, `192.168.1.*` for subnets or `*.contoso.com` for domain names.
- Parameters must be separated with a comma `,`.
- Classless Inter-Domain Routing (CIDR) notation to bypass subnets isn't supported.
- The use of \<local\> strings isn't supported in the proxy bypass list.

### Traffic flow for machine OS HTTP traffic via Azure Firewall explicit proxy

Non-bypassed machine OS HTTP traffic uses Azure Firewall explicit proxy over the private connection. It doesn't pass through the host Arc proxy or Arc gateway.

The dotted gold connector in the [host traffic diagram](#machine-os-https-traffic-via-arc-proxy) shows this path from the host through the enterprise firewall and private connection to the explicit proxy, then to permitted public endpoints.

- Route HTTP traffic through Azure Firewall explicit proxy. Don't use a `.local` domain as your proxy server name. For example, you can't use `proxy.local:8080` as proxy server. Use the proxy server IP instead if your proxy belongs to a `.local` domain.
- Ensure your enterprise firewall and Azure Firewall explicit proxy allow required endpoints for Azure Local. Your organization's security policies determine whether the traffic is allowed or blocked.

This configuration ensures standard HTTP traffic aligns with your existing security infrastructure.

### Machine OS HTTPS traffic via Arc proxy

The following network map shows the different paths for HTTP and HTTPS traffic:

- **Blue**: HTTPS traffic uses the host Arc gateway HTTP CONNECT tunnel.
- **Dotted gold**: HTTP traffic uses the Azure Firewall explicit proxy without using the Arc proxy or Arc gateway.
- **Rose**: HTTPS traffic to required public endpoints outside Arc gateway coverage uses the Azure Firewall explicit proxy.
- **Dashed teal**: Traffic from the Arc proxy connects directly to private endpoints in the virtual network (VNet).

:::image type="content" source="media/private-path-network/private-path-overview.svg" alt-text="Network map showing host HTTP through the explicit proxy, the Arc gateway HTTPS tunnel, and separate public and private endpoint paths." lightbox="media/private-path-network/private-path-overview.svg":::

For HTTPS traffic, the Arc proxy on each machine determines the route based on the destination:

- For Azure endpoints supported by Arc gateway, the Arc proxy establishes a secure HTTPS tunnel to the Arc gateway public endpoint. Allow the Arc gateway URL in your proxy or firewall.
- For required public HTTPS endpoints outside Arc gateway coverage, the Arc proxy routes traffic through the Azure Firewall explicit proxy for application-rule evaluation. This route doesn't imply TLS inspection. Allow required third-party endpoints for Azure Local, such as OEM Solution Builder Extension (SBE) endpoints, by using the corresponding application rules.
- For private endpoints outside Arc gateway coverage, the Arc proxy can connect directly to the private IP without using the Azure Firewall explicit proxy or Arc gateway. Azure Site Recovery (ASR) private endpoints are an example of this traffic.

> [!NOTE]
> A matching proxy-bypass entry and Arc gateway endpoint coverage are separate routing decisions:
>
> - **Matching bypass entry:** the solid teal path starts at the source and skips Arc proxy, Azure Firewall explicit proxy, and Arc gateway.
> - **No matching bypass entry, and the endpoint is outside Arc gateway coverage:** HTTPS first reaches Arc proxy. In the dashed teal **Direct Private Link** path shown here, Arc proxy connects directly to the private IP without Azure Firewall explicit proxy or Arc gateway.
>
> Both paths require private DNS resolution and permitted network access.

Arc resource bridge and AKS node traffic reach the host Arc proxy through the cluster IP proxy when the destination isn't bypassed. Pods and guest VMs use their own proxy configuration.

Configure private DNS on the Azure Local host so the endpoint FQDN resolves to its private IP, and permit the host-to-private-endpoint network traffic. Explicit host proxy bypass remains a separate option when required by your security policy.

This configuration ensures secure, controlled, and compliant outbound HTTPS connectivity.

### Arc resource bridge appliance VM HTTPS traffic via cluster IP proxy

The following traffic flow diagram shows HTTPS traffic that originates from the Arc resource bridge appliance VM.

:::image type="content" source="media/private-path-network/private-path-resource-bridge.svg" alt-text="Arc resource bridge-focused network map showing appliance-originated bypass and HTTP paths, with non-bypassed HTTPS using the cluster IP proxy and host tunnel." lightbox="media/private-path-network/private-path-resource-bridge.svg":::

- The appliance VM sends non-bypassed HTTPS traffic through the cluster IP proxy.
- The cluster IP proxy forwards traffic to the host Arc proxy. Allowed traffic reuses the host's existing Arc gateway tunnel; the appliance doesn't create a separate tunnel.
- Required public-endpoint HTTPS traffic that's outside Arc gateway coverage uses the explicit-proxy egress path. Arc proxy accesses private endpoints through a separate direct private-network route.
- The solid teal bypass starts at Arc resource bridge and follows the appliance's bypass configuration to internal or private endpoints, skipping the cluster IP proxy, host Arc proxy, Azure Firewall explicit proxy, and Arc gateway.
- The dotted gold HTTP path starts at Arc resource bridge and uses Azure Firewall explicit proxy without entering the cluster IP proxy, host Arc proxy, or Arc gateway.

This process ensures appliance VM traffic is securely managed and compliant with your organization's policies.

### AKS cluster HTTPS traffic via cluster IP proxy

This diagram focuses on AKS node and workload traffic. The Azure Local host remains beside AKS as the provider of Arc proxy and the existing gateway tunnel, not as an independent OS traffic source.

:::image type="content" source="media/private-path-network/private-path-aks.svg" alt-text="AKS-focused map showing node-originated bypass and HTTP, HTTPS through cluster IP proxy TCP 40343, and independent pod egress." lightbox="media/private-path-network/private-path-aks.svg":::

- AKS cluster control plane VM routes non-bypassed HTTPS traffic through the cluster IP proxy on port 40343.
- AKS worker node VM routes non-bypassed HTTPS traffic through the cluster IP proxy on port 40343.
- The cluster IP proxy forwards node traffic to the host Arc proxy and reuses its Arc gateway tunnel for supported Azure endpoints.
- The solid teal bypass starts at the AKS nodes and follows their configured bypass destinations to internal or private endpoints, skipping the cluster IP proxy, host Arc proxy, Azure Firewall explicit proxy, and Arc gateway.
- The dotted gold HTTP path starts at the AKS nodes and uses Azure Firewall explicit proxy without entering the cluster IP proxy, host Arc proxy, or Arc gateway.
- Pods have their own proxy configuration, controlled by the customer. They don't use the cluster IP proxy by default or automatically inherit the node proxy settings.
- The dashed rose route illustrates customer-controlled workload egress. Workload proxy selection, bypass rules, and permitted destinations depend on the customer configuration; the route doesn't mandate a particular proxy for every pod.
- Required node public HTTPS destinations outside Arc gateway coverage use the existing explicit-proxy egress path and need the corresponding application rules. Private endpoints use the separate direct route from Arc proxy.

This process ensures AKS clusters maintain secure and compliant outbound connectivity.

### AKS clusters on separate subnet from infrastructure subnet

This diagram shows AKS nodes and workloads in an AKS subnet separate from the Azure Local infrastructure subnet. Node bypass and HTTP originate in the AKS subnet, not at the Azure Local host. The host provides Arc proxy and participates in the required cross-subnet management links; independent host OS egress isn't shown. The cluster IP and host Arc proxy are in the infrastructure subnet. Allow the required cross-subnet ports and the fully qualified domain name (FQDN) endpoints needed for egress.

:::image type="content" source="media/private-path-network/private-path-aks-separate-subnet.svg" alt-text="AKS-focused subnet map showing node-originated bypass and HTTP, cluster IP access, bidirectional management ports, and independent pod egress." lightbox="media/private-path-network/private-path-aks-separate-subnet.svg":::

The following table lists the firewall requirements for traffic between the AKS subnet and the Azure Local infrastructure subnet. The diagram arrow color shows the corresponding path in the preceding diagram.

| Traffic | Port | Direction | Firewall rule | Diagram arrow |
| --- | --- | --- | --- | --- |
| AKS subnet to and from Azure Local cluster IP | 40343 | Bidirectional | Allow TCP 40343 and permit HTTPS and HTTP CONNECT through the relevant L7 policy | Blue |
| AKS subnet to and from Azure Local cluster IP | 55000 | Bidirectional | Allow TCP | Blue |
| AKS subnet to and from Azure Local cluster IP | 65000 | Bidirectional | Allow TCP | Blue |
| AKS subnet to and from Azure Local infrastructure subnet | 22 | Bidirectional | Allow TCP | Gold |
| AKS subnet to and from Azure Local infrastructure subnet | 6443 | Bidirectional | Allow TCP | Gold |

Only the proxy HTTPS traffic on TCP 40343 forwards through the host Arc proxy and its existing Arc gateway tunnel. TCP 55000 and 65000 are separate TCP requirements, not traffic carried by that proxy tunnel.

Follow the source, destination, and bidirectional cross-VLAN requirements in [AKS network requirements](/azure/aks/aksarc/network-system-requirements#network-port-and-cross-vlan-requirements), including the [additional TCP 40343 requirement with Arc gateway](/azure/aks/aksarc/network-system-requirements#use-azure-arc-gateway-preview-with-azure-local).

> [!NOTE]
> The solid rose path shows required AKS node public HTTPS egress outside Arc gateway coverage. The dashed teal path shows direct private-endpoint access from Arc proxy. Pods and extensions keep their own customer-controlled proxy settings. Their dashed rose egress path is illustrative, not a default route through the cluster IP proxy.

When you run Azure Arc gateway on the Azure Local hosts, AKS reduces the number of HTTPS endpoints that you must open on the AKS subnet, but you still need to allow access to those endpoints that aren't supported by Azure Arc gateway.

For a list of FQDN endpoints required for AKS on a separate subnet when using Arc gateway, see [AKS subnet required FQDN endpoints when using Arc gateway](/azure/aks/aksarc/arc-gateway-aks-arc#confirm-access-to-required-urls).

<a id="azure-local-vms-https-traffic-via-dedicated-arc-proxy"></a>

### Azure Local VM HTTPS traffic

Configure Azure Arc connectivity for each guest VM independently of the Azure Local host. Two choices determine the guest Arc agent's route: whether it uses a customer-configured outbound proxy, and whether the guest is associated with Arc gateway. The outbound proxy is distinct from the Arc proxy running inside a gateway-enabled guest.

> [!NOTE]
> These choices apply to guest Arc connectivity, not to the host private path architecture described in this article. Each configuration still needs a permitted network route and access to its required endpoints. The VM diagrams show forwarding roles, not a prescribed ExpressRoute, VPN, or internet topology.

# [Proxy and Arc gateway](#tab/vm-proxy-gateway)

The guest Arc agent uses its own Arc proxy and a guest-specific Arc gateway tunnel through the configured outbound proxy. Required endpoints outside gateway coverage use separate permitted egress through that proxy. Azure Firewall explicit proxy is the example shown.

:::image type="content" source="media/private-path-network/private-path-vm-proxy-gateway.svg" alt-text="VM Arc connectivity using the guest Arc proxy, an outbound proxy, and a guest-specific tunnel to Arc gateway." lightbox="media/private-path-network/private-path-vm-proxy-gateway.svg":::

# [No proxy or Arc gateway](#tab/vm-direct)

The guest Arc agent connects to required Azure endpoints without an outbound proxy or Arc gateway hop. Required network routing and firewall permissions still apply.

:::image type="content" source="media/private-path-network/private-path-vm-no-proxy-no-gateway.svg" alt-text="VM Arc agent reaching required Azure endpoints without an outbound proxy, guest Arc proxy, or Arc gateway hop." lightbox="media/private-path-network/private-path-vm-no-proxy-no-gateway.svg":::

# [Arc gateway only](#tab/vm-gateway)

The guest Arc agent uses the Arc proxy inside the VM and its own Arc gateway tunnel, without a customer-configured outbound proxy. Endpoints outside gateway coverage still need separate network permission.

:::image type="content" source="media/private-path-network/private-path-vm-no-proxy-gateway.svg" alt-text="VM Arc connectivity using a guest-specific Arc proxy and gateway tunnel without an outbound proxy hop." lightbox="media/private-path-network/private-path-vm-no-proxy-gateway.svg":::

# [Proxy only](#tab/vm-proxy)

The guest Arc agent connects through the configured outbound proxy without a guest Arc proxy or Arc gateway hop. Permit the required Azure and additional service endpoints through the proxy.

:::image type="content" source="media/private-path-network/private-path-vm-proxy-no-gateway.svg" alt-text="VM Arc agent reaching Azure through a customer-configured outbound proxy without an Arc gateway hop." lightbox="media/private-path-network/private-path-vm-proxy-no-gateway.svg":::

# [Compare all four](#tab/vm-compare)

The quadrants show alternative guest configurations, not four simultaneous paths. Firewall and network transport details and other endpoint exceptions are omitted from this comparison, not bypassed.

:::image type="content" source="media/private-path-network/private-path-vm-comparison.svg" alt-text="Four-way comparison of VM Arc connectivity with outbound proxy and Arc gateway independently enabled or disabled." lightbox="media/private-path-network/private-path-vm-comparison.svg":::

---

A gateway-enabled VM uses its own Arc proxy and tunnel, not the host cluster IP proxy or host Arc gateway tunnel. Multiple guests can share the same Azure Arc gateway resource while keeping separate guest connections.

Guest applications retain their own customer-controlled proxy configuration. Enabling Arc gateway for the guest doesn't automatically capture arbitrary application traffic. If a guest application uses Key Vault or Storage Private Link, configure private DNS and the application's proxy-bypass settings as required.

## Next step

- [Deploy private path with Azure Arc gateway on Azure Local](../deploy/deployment-with-azure-arc-gateway-private-path.md)