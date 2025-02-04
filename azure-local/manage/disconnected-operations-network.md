---
title: Understand and plan your network for disconnected operations on Azure Local (preview)
description: Integrate your network with disconnected operations on Azure Local (preview).
ms.topic: concept-article
author: ronmiab
ms.author: robess
ms.date: 01/17/2025
---

# Networking for disconnected operations on Azure Local (preview) 

[!INCLUDE [applies-to](../includes/release-2411-1-later.md)]

This article helps you integrate your network with disconnected operations on Azure Local. It outlines essential design considerations and requirements for operating in a disconnected operations environment.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Understand network requirements

Disconnected operations run on Azure Local, so it's important that you understand Azure Local's network requirements. Ensuring that your network meets these requirements is essential for seamless integration and optimal performance. For more detailed information, see [Physical network requirements for Azure Local](../concepts/physical-network-requirements.md).

With Azure Local deployment, there is flexibility to set up the Azure Local instance according to your specific needs. You deploy the disconnected operations as a virtual machine (VM) appliance, which integrates with the Azure Local network. This setup allows for robust and reliable operations even in environments with intermittent or no internet connectivity.

## Network checklist

Here's a checklist to help you plan your network for disconnected operations on Azure Local:

- Review [Azure Local Networking requirements](../concepts/physical-network-requirements.md)
- Verify [Azure Local System requirements](../concepts/system-requirements.md)  
- Develop the Azure Local network plan (Disconnected operations and Azure Local):  
  - Create the [Host network plan (intents and switches)](../concepts/host-network-requirements.md).
  - Reserve the management IP address pool.
- Configure the network for disconnected operations (Ingress and management network):
  - Assign an Ingress IP within the management IP address pool subnet, ensuring it doesn't overlap with the range provided during deployment.  
  - Ensure the container network range doesn't conflict with the external network.
- Ensure the DNS server is accessible for disconnected operations and configure it during deployment to flow through the Ingress vNIC/IP.
- Verify that the DNS server can resolve the endpoints for the Ingress IP.
- Confirm that the disconnected operations appliance can reach endpoints (IP + port) through the Ingress vNIC/IP.
- Ensure an identity provider is routable and accessible from the disconnected operations appliance on the management network (intent).
- Configure the external network to ensure workloads outside of Azure Local can resolve and route traffic to the disconnected operations Ingress IP (port 443).

## Virtual network interface cards (vNICs) and network integration

The disconnected operations VM appliance uses two different vNICs that plug into the network intent. These are:

- **Management vNIC**  
- **Ingress vNIC**  

You connect these vNICs to the virtual switch created for the management intent, which plugs into your physical network. Next, you configure these vNICs with an IP address that you set during deployment. Then, you use their interfaces to access disconnected operations for various scenarios such as bootstrapping, troubleshooting, operations, and regular usage via the Portal or CLI.
  
:::image type="content" source="./media/disconnected-operations/disconnected-network/network-overview.png" alt-text="Screenshot showing how the Appliance and users or workloads communicate with the service." lightbox=" ./media/disconnected-operations/disconnected-network/network-overview.png":::

## Plan your Ingress IP  

When you plan your Ingress IP, you need to make sure the ingress IP is in the same subnet range as the cluster you configure later, but outside the reserved IP range itself. For example, if your cluster's subnet range is 192.168.1.0/24 and the reserved IP range is 192.168.1.1 - 192.168.1.10, you should choose an ingress IP like 192.168.1.11 or higher, ensuring it doesn't overlap with the reserved range.
  
### IP checklist for the disconnected appliance  

Here's a checklist to help you plan your IP addresses for the disconnected operations appliance:

- **Ingress IP**:
  - Connects to the management intent.
  - Part of the regular network path for the control plane and Azure Local capabilities.
  - Needs Domain Name System (DNS) resolution to the desired Fully Qualified Domain Name (FQDN).
  - Must be in the same subnet as the Azure Local instance, but outside the reserved range used for instance deployment.

- **Management IP**:
  - Connects to management intent.
  - Any valid, unused IP on the local network.
  - Ensure reachability, if accessing lower management Application Programming Interfaces (APIs) from outside the cluster.

> [!NOTE]
> Disconnected operations has a built-in container network range that might interfere with your existing network range. If you're already using the range 10.131.19.0/24, you need to isolate this range from your disconnected operations environment.
>
> - Reconfiguring the built-in container network range is currently not supported.  

## Unsupported features  

For this preview, the following features are unsupported:  

- Configurable VLANs for disconnected operations ingress network that enable you to add VLAN tags to ingress packets on a per-port basis.
- Configurable VLAN for disconnected operations Management network that enable you to isolate management traffic from other network traffic, enhance security, and reduce interference.

### Plan DNS and public key infrastructure (PKI)  

During deployment of disconnected operations, you need an FQDN for your appliance that resolves to the Ingress IP used. It's important to plan your DNS and PKI infrastructure before deploying disconnected operations. Additionally, you should consider how you want to use them to serve clients in your environment.

The Ingress network has several endpoints that are based on the configured FQDN. These endpoints need to be resolvable and secure in your network.

The endpoints exposed through the Ingress IP include:

- his.FQDN  
- login.FQDN  
- hosting.FQDN  
- portal.FQDN  
- graph.FQDN  
- armmanagement.FQDN  
- autonomous-gas.FQDN  
- adminmanagement.FQDN  
- catalogapi.FQDN  
- artifacts.blob.FQDN  
- acrmanagedaccount0.blob.FQDN  
- g1-aszsu-sb.servicebus.FQDN  
- guestnotificationservice.FQDN  
- autonomous.dp.kubernetesconfiguration.FQDN  
- agentserviceapi.FQDN  
- *.edgeacr.FQDN  
- *.vault.FQDN  

> [!NOTE]
> The wildcard endpoints serve as backing services where your users dynamically create services such as Azure Key Vault or Azure Container Registry. Your infrastructure needs to resolve a wildcard for these specific endpoints.

If you plan to connect the appliance to Azure, make sure your DNS infrastructure resolves the necessary Microsoft endpoints. Allow DNS requests from the disconnected operations appliance and ensure there's a network path from disconnected operations to the Ingress network to reach the external endpoints.

For more information, see [Firewall requirements for Azure Local](../concepts/firewall-requirements.md).

## Running with limited connectivity  

You can run the appliance in limited connectivity mode. This makes getting support easier and allows logs and telemetry to be sent directly to Microsoft without an export/import job. There are some special considerations to keep in mind when running in limited connectivity mode, as the appliance needs to resolve Microsoft endpoints.

The disconnected appliance only needs to resolve a subset of these endpoints for observability and diagnostics purposes.

Here are the endpoints that the appliance needs to resolve:

| Observability and diagnostics | Endpoint |
|-------------------------------|----------|
|Geneva Observability Services | gcs.prod.monitoring.core.windows.net <br></br> *.prod.warm.ingest.monitor.core.windows.net  |
| Azure Connected Machine Agent Managed Identity |  login.windows.net <br></br> login.microsoftonline.com <br></br> pas.windows.net <br></br> management.azure.com <br></br> *.his.arc.azure.com <br></br> *.guestconfiguration.azure.com |

<!--## Next steps-->