---
title: Understand and plan your network for disconnected operations on Azure Local (preview)
description: Integrate your network with disconnected operations on Azure Local (preview).
ms.topic: concept-article
author: ronmiab
ms.author: robess
ms.date: 06/16/2025
ai-usage: ai-assisted
---

# Plan your network disconnected operations on Azure Local (preview) 

::: moniker range=">=azloc-24112"

This article helps you plan the integration of your network with disconnected operations on Azure Local. It outlines essential design considerations and requirements for operating in a disconnected operations environment.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Understand network requirements

Disconnected operations run on Azure Local, so it's important that you understand Azure Local's network requirements. Ensuring that your network meets these requirements is essential for seamless integration and optimal performance. For more detailed information, see [Physical network requirements for Azure Local](../concepts/physical-network-requirements.md).

Azure Local lets you set up the instance to fit your needs. Deploy the disconnected operations as a virtual machine (VM) appliance that integrates with the Azure Local network. This setup supports robust and reliable operations even when internet connectivity is intermittent or unavailable.

## Network checklist

Use this checklist to plan your network for disconnected operations on Azure Local:

- Review [Physical network requirements for Azure Local](../concepts/physical-network-requirements.md).

- Check [System requirements for Azure Local](../concepts/system-requirements.md).

- Develop the Azure Local network plan (Disconnected operations and Azure Local):
  
  - Create the [host network plan (intents and switches)](../plan/cloud-deployment-network-considerations.md).
  
  - Reserve the management IP address pool.

- Set up the network for disconnected operations (ingress and management network):

  - Assign an ingress IP within the management IP address pool subnet. Make sure it doesn't overlap with the range provided during deployment.

  - Check that the container network range doesn't conflict with the external network.

- Make sure the domain name system (DNS) server is accessible for disconnected operations. Set it up during deployment to flow through the ingress vNIC/IP.

- Check that the DNS server can resolve the endpoints for the ingress IP.

- Check that the disconnected operations appliance can reach endpoints (IP and port) through the ingress vNIC/IP.

- Make sure an identity provider is routable and accessible from the disconnected operations appliance on the management network (intent).

- Set up the external network so services outside Azure Local can resolve and route traffic to the disconnected operations ingress IP (port 443).

## Virtual network interface cards and network integration

The disconnected operations VM appliance uses two different virtual network interface cards (vNICs) that plug into the network intent. These are:

- **Management vNIC**  
- **Ingress vNIC**  

Here's a high-level workflow for vNIC management and deployment:

- Connect the vNICs to the virtual switch for management, which links to your physical network.
- Set an IP address for the vNICs during deployment.
- Use the vNIC interfaces for bootstrapping, troubleshooting, operations, and regular use through the portal or CLI.
  
:::image type="content" source="./media/disconnected-operations/network/network-overview.png" alt-text="Screenshot showing how the Appliance and users or workloads communicate with the service." lightbox=" ./media/disconnected-operations/network/network-overview.png":::

## Plan your ingress IP  

When you plan your ingress IP, make sure it's in the same subnet range as the cluster you configure later, but outside the reserved IP range. For example, if your cluster's subnet range is 192.168.1.0/24 and the reserved IP range is 192.168.1.1 - 192.168.1.10, choose an ingress IP like 192.168.1.11 or higher, so it doesn't overlap with the reserved range.

> [!NOTE]
> Disconnected operations has a built-in container network range that can interfere with your existing network range. If you already use the range 10.131.19.0/24, isolate this range from your disconnected operations environment.
>
> - You can't reconfigure the built-in container network range.

### IP checklist for the disconnected appliance  

Use this checklist to plan your IP addresses for the disconnected operations appliance:

- **Ingress IP**:
  - Connects to the management intent.
  - Is part of the regular network path for the control plane and Azure Local capabilities.
  - Needs DNS resolution to the desired Fully Qualified Domain Name (FQDN).
  - Is in the same subnet as the Azure Local instance, but outside the reserved range used for the instance deployment.

- **Management IP**:
  - Connects to management intent.
  - Is any valid, unused IP on the local network.
  - Is reachability if you access lower management application programming interfaces (APIs) from outside the cluster.

### Plan DNS and public key infrastructure (PKI)  

During deployment of disconnected operations, you need an FQDN for your appliance that resolves to the ingress IP. It's important to plan your DNS and PKI infrastructure before you deploy disconnected operations. Also, consider how you want to use them to serve clients in your environment.

The ingress network has several endpoints based on the configured FQDN. These endpoints must be resolvable and secure in your network. For a list of endpoints, see [PKI for disconnected operations](../manage/disconnected-operations-pki.md#ingress-endpoints).

> [!NOTE]
> The wildcard endpoints serve as backing services where your users dynamically create services such as Azure Key Vault or Azure Container Registry. Your infrastructure needs to resolve a wildcard for these specific endpoints.

If you plan to connect the appliance to Azure, make sure your DNS infrastructure resolves the required Microsoft endpoints. Allow DNS requests from the disconnected operations appliance and make sure there's a network path from disconnected operations to the ingress network to reach the external endpoints.

For more information, see [Firewall requirements for Azure Local](../concepts/firewall-requirements.md).

#### Configure your DNS server (if you are running Windows Server DNS role):

Here is an example:

```powershell  
$externalFqdn = 'autonomous.cloud.private'
$IngressIPAddress = '192.168.200.115'

Add-DnsServerPrimaryZone -Name $ExternalFqdn -ReplicationScope Domain

Add-DnsServerResourceRecordA -Name "*" -IPv4Address $IngressIpAddress -ZoneName $ExternalFqdn 
```
#### Verify your DNS setup

Here is an example:

```console  
nslookup portal.autonomous.cloud.private
```

Here's a sample output:

```console  
Name:    portal.autonomous.cloud.private
Address:  192.168.200.115
```

## Run appliance with limited connectivity  

Run the appliance in limited connectivity mode to make support easier and let logs and telemetry go directly to Microsoft without an export or import job. The disconnected appliance only needs to resolve a subset of these endpoints for observability and diagnostics.

In limited connectivity mode, the appliance resolves certain Microsoft endpoints for observability and diagnostics.

Here are the endpoints that the appliance needs to resolve:

| Observability and diagnostics | Endpoint |
|-------------------------------|----------|
|Geneva Observability Services | gcs.prod.monitoring.core.windows.net <br></br> *.prod.warm.ingest.monitor.core.windows.net  |
| Azure Connected Machine Agent Managed Identity |  login.windows.net <br></br> login.microsoftonline.com <br></br> pas.windows.net <br></br> management.azure.com <br></br> *.his.arc.azure.com <br></br> *.guestconfiguration.azure.com |

### Unsupported features  

The following features aren't supported in this preview:

- Configurable Virtual Local Area Network (VLAN) for disconnected operations ingress network that let you add VLAN tags to ingress packets on a per-port basis.
- Configurable VLAN for disconnected operations management network that lets you isolate management traffic from other network traffic, enhance security, and reduce interference.

::: moniker-end

::: moniker range="<=azloc-24111"

This feature is available only in Azure Local 2411.2.

::: moniker-end
