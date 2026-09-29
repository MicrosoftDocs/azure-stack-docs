---
title: Overview of private path network architecture for Azure Local
description: Learn about private path network architecture for Azure Local.
author: ronmiab
ms.topic: overview
ms.date: 08/25/2026
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

:::image type="content" source="media/private-path-network/private-path-network.svg" alt-text="Diagram showing Azure Local with Arc gateway outbound connectivity." lightbox="media/private-path-network/private-path-network.svg":::

- **Azure Local machines** that generate outbound traffic.
- On-premises Azure Local instance.
- **Arc proxy** running on Azure Local hosts, which forwards HTTPS traffic to Arc gateway.
- **Azure Arc gateway**, which allows outbound HTTPS traffic only to Microsoft‑managed endpoints.
- **Enterprise firewall** that is your organization's existing security infrastructure controlling the outbound traffic.
- **Azure virtual network** associated with your instance.
- **Azure Firewall explicit proxy**, which handles HTTP traffic and HTTPS traffic not permitted by Arc gateway.
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

In a private path deployment, Azure Local categorizes outbound traffic based on protocol and destination. Correctly identifying each category is critical to ensuring secure and reliable connectivity.

The following table summarizes each traffic category, its routing decision, and the traffic flow scenario that shows the path in detail:

| Traffic category | Protocol | Routing decision | Traffic flow scenario |
| --- | --- | --- | --- |
| Internal, machine-to-machine, and Private Link traffic | HTTP and HTTPS | Bypasses the proxy and connects directly to internal endpoints | [Machine OS traffic bypassing Azure Firewall explicit proxy](#machine-os-traffic-bypassing-azure-firewall-explicit-proxy) |
| OS HTTP traffic to Azure | HTTP | Routes through Azure Firewall explicit proxy | [Machine OS HTTP traffic via Azure Firewall explicit proxy](#machine-os-http-traffic-via-azure-firewall-explicit-proxy) |
| OS HTTPS traffic to Microsoft-managed endpoints | HTTPS | Routes through the Arc proxy and Arc gateway tunnel | [Machine OS HTTPS traffic via Arc proxy](#machine-os-https-traffic-via-arc-proxy) |
| Third-party OS HTTPS traffic | HTTPS | Arc proxy redirects to Azure Firewall explicit proxy | [Machine OS HTTPS traffic via Arc proxy](#machine-os-https-traffic-via-arc-proxy) |
| Arc resource bridge and Azure Kubernetes Service (AKS) cluster traffic | HTTPS | Routes through the cluster IP proxy and Arc gateway tunnel | [Azure resource bridge appliance VM HTTPS traffic](#azure-resource-bridge-appliance-vm-https-traffic-via-cluster-ip-proxy) and [AKS cluster HTTPS traffic](#aks-cluster-https-traffic-via-cluster-ip-proxy) |

The following sections describe each traffic category in more detail.

### OS traffic that bypasses the proxy

Some HTTP and HTTPS connections must bypass Azure Firewall explicit proxy and connect directly to their intended internal destinations. Typically, technical or performance reasons require these exceptions.

Configure these connections to bypass the proxy so they can reach their internal endpoints directly.
Add Private Link endpoints, such as Azure Key Vault or Azure Storage accounts, to the proxy bypass list if your organization requires their use.

### OS HTTP traffic via Azure Firewall explicit proxy

Some OS-level HTTP traffic can't use the Arc proxy and must be routed through Azure Firewall explicit proxy instead. Route this traffic through Azure Firewall explicit proxy to ensure it reaches Azure while complying with internal network and security requirements.

### OS HTTPS traffic via Arc proxy

Some OS-level HTTPS traffic must always be routed through the Arc proxy.

Routing this traffic through the Arc proxy ensures secure, controlled, and consistent connectivity to Azure endpoints by using the Arc gateway’s built-in security and management capabilities.

Make sure you allow all required Arc gateway endpoints for Azure Local. For more information, see [Azure Local Arc gateway required endpoints](/azure/azure-local/deploy/deployment-azure-arc-gateway-overview?tabs=portal#azure-local-endpoints-not-redirected).

### Third-party OS HTTPS traffic

All OS-level HTTPS traffic initially routes to the Arc proxy. However, the Arc gateway allows connections only to Microsoft‑managed endpoints.

As a result, HTTPS traffic destined for third‑party services—such as original equipment manufacturer (OEM) endpoints, hardware vendor update services, or other third‑party agents installed on your servers, can’t pass through the Arc gateway. This traffic routes through Azure Firewall explicit proxy.

Configure Azure Firewall explicit proxy application rules to explicitly allow access to the required third‑party endpoints. Define these rules based on your organization’s security and connectivity requirements to ensure that third‑party services function correctly.

### Arc resource bridge and AKS cluster traffic

Azure Arc resource bridge is a Kubernetes-based management solution deployed as a virtual appliance (also called the Arc appliance) on your on-premises infrastructure. Its main purpose is to enable your local resources to appear and be managed as Azure resources through Azure Resource Manager.

To achieve this, the Arc resource bridge requires outbound connectivity to specific Azure endpoints. In an Azure Local environment, this outbound traffic routes through the cluster IP as proxy, which then securely forwards the traffic through the Arc gateway tunnel established by your Azure Local machines. This approach simplifies network configuration, enhances security, and ensures compliance with your organization's network policies.

Also, when deploying AKS cluster in Azure Local, by default the control plane VM and the pods also use the cluster IP as proxy to send the outbound traffic through the Arc gateway. However, for some services running inside your AKS clusters you might also need to allow additional endpoints that go directly to your firewall.

## Traffic flow scenarios

The following sections show the routing path for each traffic category described in [Traffic categories](#traffic-categories). Each scenario includes a diagram of how traffic moves through the private path deployment.

> [!NOTE]
> In the following diagrams, labels such as **Node1** and **Node2** represent Azure Local machines.

### Machine OS traffic bypassing Azure Firewall explicit proxy

The following diagram shows traffic from Azure Local machines that bypasses the Arc proxy entirely.

:::image type="content" source="media/private-path-network/private-path-network-1.svg" alt-text="Diagram showing Azure Local machine OS traffic bypassing proxy." lightbox="media/private-path-network/private-path-network-1.svg":::

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

### Machine OS HTTP traffic via Azure Firewall explicit proxy

This diagram shows how standard HTTP (non-HTTPS) traffic from Azure Local machines is managed:

:::image type="content" source="media/private-path-network/private-path-network-2.svg" alt-text="Diagram showing Azure Local machine OS HTTP traffic." lightbox="media/private-path-network/private-path-network-2.svg":::

- Route HTTP traffic through Azure Firewall explicit proxy. Don't use a `.local` domain as your proxy server name. For example, you can't use `proxy.local:8080` as proxy server. Use the proxy server IP instead if your proxy belongs to a `.local` domain.
- Ensure your enterprise firewall and Azure Firewall explicit proxy allow required endpoints for Azure Local. Your organization's security policies determine whether the traffic is allowed or blocked.

This configuration ensures standard HTTP traffic aligns with your existing security infrastructure.

### Machine OS HTTPS traffic via Arc proxy

This diagram explains how HTTPS traffic from Azure Local machines is securely routed:

:::image type="content" source="media/private-path-network/private-path-network-3.svg" alt-text="Diagram showing Azure Local machine OS HTTPS traffic." lightbox="media/private-path-network/private-path-network-3.svg":::

- The Arc proxy running on each machine routes HTTPS traffic destined for allowed Azure endpoints. Ensure you allowed your Arc gateway URL in your proxy or firewall.
- The Arc proxy establishes a secure HTTPS tunnel to the Arc gateway public endpoint hosted in Azure.
- The Arc proxy redirects traffic it doesn't allow (non-approved endpoints) to Azure Firewall explicit proxy for further inspection or blocking. Ensure you allow the required third-party HTTPS endpoints for Azure Local, such as the OEM Solution Builder Extension (SBE) endpoints, in Azure Firewall explicit proxy by using the corresponding application rules.

This configuration ensures secure, controlled, and compliant outbound HTTPS connectivity.

### Azure resource bridge appliance VM HTTPS traffic via cluster IP proxy

This diagram illustrates HTTPS traffic handling for the Azure resource bridge appliance VM.

:::image type="content" source="media/private-path-network/private-path-network-4.svg" alt-text="Diagram showing ARB appliance VM HTTPS traffic." lightbox="media/private-path-network/private-path-network-4.svg":::

- Appliance VM sends HTTPS traffic through a cluster IP proxy.
- The cluster IP proxy securely routes allowed traffic through the Arc gateway's HTTPS tunnel to Azure.
- Non-allowed traffic is redirected to your firewall or proxy for security enforcement.

This process ensures appliance VM traffic is securely managed and compliant with your organization's policies.

### AKS cluster HTTPS traffic via cluster IP proxy

This diagram shows HTTPS traffic handling for AKS clusters within Azure Local:

:::image type="content" source="media/private-path-network/private-path-network-5.svg" alt-text="Diagram showing AKS cluster HTTPS traffic." lightbox="media/private-path-network/private-path-network-5.svg":::

- AKS cluster control plane VM routes HTTPS traffic through the cluster IP proxy on port 40343.
- AKS Worker Node VM routes HTTPS traffic through the cluster IP proxy on port 40343.
- The Cluster IP proxy securely forwards allowed traffic through the Arc gateway's HTTPS tunnel to Azure endpoints.
- AKS Pods creates the Arc gateway connection to route HTTPS traffic over the Arc gateway HTTP connect tunnel.
- Traffic that the Arc gateway doesn't permit is sent to your firewall or proxy for further security checks.

This process ensures AKS clusters maintain secure and compliant outbound connectivity.

### AKS clusters on separate subnet from infrastructure subnet

This diagram shows HTTPS traffic handling and firewall requirements for AKS cluster when running on separate subnet from the Azure Local infrastructure subnet. This example represents how each type of TCP and HTTPS traffic from the AKS subnet is routed to help security teams understand what ports or fully qualified domain name (FQDN) endpoints they must open in their firewall or proxy that filters traffic from AKS subnet to infrastructure subnet and internet.

The following table lists the firewall requirements for traffic between the AKS subnet and the Azure Local infrastructure subnet. The diagram arrow color shows the corresponding path in the preceding diagram.

| Traffic | Port | Direction | Firewall rule | Diagram arrow |
| --- | --- | --- | --- | --- |
| AKS subnet to Azure Local Cluster IP | 40343 | Outbound | Allow in both L4 and L7 for HTTPS and HTTP Connect | Light blue |
| AKS subnet to Azure Local Cluster IP | 55000 | Outbound | Allow TCP | Light blue |
| AKS subnet to Azure Local Cluster IP | 65000 | Outbound | Allow TCP | Light blue |
| AKS subnet to and from Azure Local infrastructure subnet | 22 | Bidirectional | Allow TCP | Light yellow |
| AKS subnet to and from Azure Local infrastructure subnet | 6443 | Bidirectional | Allow TCP | Light yellow |

For more information about required firewall, see [AKS subnet required ports when using Arc gateway](/azure/aks/aksarc/network-system-requirements#network-port-and-cross-vlan-requirements).

> [!NOTE]
> Firewall requirements on AKS subnet for HTTPS traffic not supported by Arc gateway (pink arrow traffic)

When you run Azure Arc gateway on the Azure Local hosts, AKS reduces the number of HTTPS endpoints that you must open on the AKS subnet, but you still need to allow access to those endpoints that aren't supported by Azure Arc gateway.

:::image type="content" source="media/private-path-network/private-path-network-5-1.svg" alt-text="Diagram showing AKS cluster HTTPS traffic on a separated subnet." lightbox="media/private-path-network/private-path-network-5-1.svg":::

For a list of FQDN endpoints required for AKS on a separate subnet when using Arc gateway, see [AKS subnet required FQDN endpoints when using Arc gateway](/azure/aks/aksarc/arc-gateway-aks-arc#confirm-access-to-required-urls).

### Azure Local VMs HTTPS traffic via dedicated Arc proxy

This diagram explains HTTPS traffic handling for Azure Local VMs:

:::image type="content" source="media/private-path-network/private-path-network-6.svg" alt-text="Diagram showing Azure Local VMs HTTPS traffic." lightbox="media/private-path-network/private-path-network-6.svg":::

- Each Azure Local VM uses its own dedicated Arc proxy to route HTTPS traffic.
- Allowed HTTPS traffic is securely tunneled through the Arc gateway to Azure public endpoints.
- Non-allowed traffic is redirected to Azure Firewall explicit proxy for security enforcement.
- VM traffic using Key Vault Private Link has the Key Vault FQDN configured on DNS to use Private Link.

This configuration ensures Azure Local VMs have secure, controlled, and compliant outbound connectivity.

## Next step

- [Deploy private path with Azure Arc gateway on Azure Local](../deploy/deployment-with-azure-arc-gateway-private-path.md)