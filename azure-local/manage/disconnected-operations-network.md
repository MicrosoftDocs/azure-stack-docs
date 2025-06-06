---
title: Understand and plan your network for disconnected operations on Azure Local (preview)
description: Integrate your network with disconnected operations on Azure Local (preview).
ms.topic: concept-article
author: ronmiab
ms.author: robess
ms.date: 04/22/2025
---

# Plan your network disconnected operations on Azure Local (preview) 

::: moniker range=">=azloc-24112"

[!INCLUDE [applies-to](../includes/release-2411-1-later.md)]

This article helps you plan the integration of your network with disconnected operations on Azure Local. It outlines essential design considerations and requirements for operating in a disconnected operations environment.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Understand network requirements

Disconnected operations run on Azure Local, so it's important that you understand Azure Local's network requirements. Ensuring that your network meets these requirements is essential for seamless integration and optimal performance. For more detailed information, see [Physical network requirements for Azure Local](../concepts/physical-network-requirements.md).

With your Azure Local deployment, there's flexibility to set up the Azure Local instance according to your specific needs. You deploy the disconnected operations as a virtual machine (VM) appliance, which integrates with the Azure Local network. This setup allows for robust and reliable operations even in environments with intermittent or no internet connectivity.

## Network checklist

Here's a checklist to help you plan your network for disconnected operations on Azure Local:

- Review [Physical network requirements for Azure Local](../concepts/physical-network-requirements.md).
- Verify [System requirements for Azure Local](../concepts/system-requirements.md).
- Develop the Azure Local network plan (Disconnected operations and Azure Local):
  - Create the [Host network plan (intents and switches)](../concepts/host-network-requirements.md).
  - Reserve the management IP address pool.
- Configure the network for disconnected operations (ingress and management network):
  - Assign an ingress IP within the management IP address pool subnet, ensuring it doesn't overlap with the range provided during deployment.  
  - Ensure the container network range doesn't conflict with the external network.
- Ensure the domain name system (DNS) server is accessible for disconnected operations and configure it during deployment to flow through the ingress vNIC/IP.
- Verify that the DNS server can resolve the endpoints for the ingress IP.
- Confirm that the disconnected operations appliance can reach endpoints (IP and port) through the ingress vNIC/IP.
- Ensure an identity provider is routable and accessible from the disconnected operations appliance on the management network (intent).
- Configure the external network to ensure workloads outside of Azure Local can resolve and route traffic to the disconnected operations ingress IP (port 443).

## Virtual network interface cards and network integration

The disconnected operations VM appliance uses two different virtual network interface cards (vNICs) that plug into the network intent. These are:

- **Management vNIC**  
- **Ingress vNIC**  

Here's a high-level workflow for vNIC management and deployment:

- Connect the vNICs to the virtual switch for management, which links to your physical network.
- Set an IP address for the vNICs during deployment.
- Use their interfaces for tasks such as bootstrapping, troubleshooting, operations, and regular use through the portal or CLI.
  
:::image type="content" source="./media/disconnected-operations/network/network-overview.png" alt-text="Screenshot showing how the Appliance and users or workloads communicate with the service." lightbox=" ./media/disconnected-operations/network/network-overview.png":::

## Plan your ingress IP  

When you plan your ingress IP, you need to make sure the ingress IP is in the same subnet range as the cluster you configure later, but outside the reserved IP range itself. For example, if your cluster's subnet range is 192.168.1.0/24 and the reserved IP range is 192.168.1.1 - 192.168.1.10, you should choose an ingress IP like 192.168.1.11 or higher, ensuring it doesn't overlap with the reserved range.

> [!NOTE]
> Disconnected operations has a built-in container network range that might interfere with your existing network range. If you're already using the range 10.131.19.0/24, you need to isolate this range from your disconnected operations environment.
>
> - Reconfiguring the built-in container network range is currently not supported.

### IP checklist for the disconnected appliance  

Here's a checklist to help you plan your IP addresses for the disconnected operations appliance:

- **Ingress IP**:
  - Connects to the management intent.
  - Part of the regular network path for the control plane and Azure Local capabilities.
  - Needs DNS resolution to the desired Fully Qualified Domain Name (FQDN).
  - Must be in the same subnet as the Azure Local instance, but outside the reserved range used for the instance deployment.

- **Management IP**:
  - Connects to management intent.
  - Any valid, unused IP on the local network.
  - Ensure reachability if accessing lower management Application Programming Interfaces (APIs) from outside the cluster.

### Plan DNS and public key infrastructure (PKI)  

During deployment of disconnected operations, you need an FQDN for your appliance that resolves to the ingress IP used. It's important to plan your DNS and PKI infrastructure before deploying disconnected operations. Additionally, consider how you want to use them to serve clients in your environment.

The ingress network has several endpoints that are based on the configured FQDN. These endpoints need to be resolvable and secure in your network. For a list of endpoints, see [PKI for disconnected operations](../manage/disconnected-operations-pki.md#ingress-endpoints).

> [!NOTE]
> The wildcard endpoints serve as backing services where your users dynamically create services such as Azure Key Vault or Azure Container Registry. Your infrastructure needs to resolve a wildcard for these specific endpoints.

If you plan to connect the appliance to Azure, make sure your DNS infrastructure resolves the necessary Microsoft endpoints. Allow DNS requests from the disconnected operations appliance and ensure there's a network path from disconnected operations to the ingress network to reach the external endpoints. 

For more information, see [Firewall requirements for Azure Local](../concepts/firewall-requirements.md).

#### Here is an example for how you can configure your DNS server (if you are running Windows Server DNS role):

```console  
$externalFqdn = 'autonomous.cloud.private'
$IngressIPAddress = '192.168.200.115'

Add-DnsServerPrimaryZone -Name $ExternalFqdn -ReplicationScope Domain

Add-DnsServerResourceRecordA -Name "*" -IPv4Address $IngressIpAddress -ZoneName $ExternalFqdn 
```
#### Here is an example of verifying your DNS setup 
```console  
nslookup portal.autonomous.cloud.private
```
#### Here is an example of expected response 
```console  
Name:    portal.autonomous.cloud.private
Address:  192.168.200.115
```




## Run appliance with limited connectivity  

You can run the appliance in limited connectivity mode. This makes getting support easier and allows logs and telemetry to be sent directly to Microsoft without an export/import job. The disconnected appliance only needs to resolve a subset of these endpoints for observability and diagnostics purposes.

When running in limited connectivity mode, the appliance needs to resolve certain Microsoft endpoints for observability and diagnostics.

Here are the endpoints that the appliance needs to resolve:

| Observability and diagnostics | Endpoint |
|-------------------------------|----------|
|Geneva Observability Services | gcs.prod.monitoring.core.windows.net <br></br> *.prod.warm.ingest.monitor.core.windows.net  |
| Azure Connected Machine Agent Managed Identity |  login.windows.net <br></br> login.microsoftonline.com <br></br> pas.windows.net <br></br> management.azure.com <br></br> *.his.arc.azure.com <br></br> *.guestconfiguration.azure.com |

### Unsupported features  

For this preview, the following features are unsupported:  

- Configurable Virtual Local Area Network (VLAN) for disconnected operations ingress network that enables you to add VLAN tags to ingress packets on a per-port basis.
- Configurable VLAN for disconnected operations Management network that enables you to isolate management traffic from other network traffic, enhance security, and reduce interference.

::: moniker-end

::: moniker range="<=azloc-24111"

This feature is available only in Azure Local 2411.2.

::: moniker-end
