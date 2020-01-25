---
title: Datacenter integration planning considerations for Azure Stack Hub integrated systems 
description: Learn how to plan and prepare for datacenter integration with Azure Stack Hub integrated systems.
author: mattbriggs

ms.topic: article
ms.date: 1/22/2020
ms.author: mabrigg
ms.reviewer: wfayed
ms.lastreviewed: 09/12/2018
---
 
# Datacenter integration planning considerations for Azure Stack Hub integrated systems

If you're interested in an Azure Stack Hub integrated system, you should understand the major planning considerations around deployment and how the system fits into your datacenter. This article provides a high-level overview of these considerations to help you make important infrastructure decisions for your Azure Stack Hub integrated systems. An understanding of these considerations helps when working with your OEM hardware vendor while they deploy Azure Stack Hub to your datacenter.  

> [!NOTE]  
> Azure Stack Hub integrated systems can only be purchased from authorized hardware vendors.

To deploy Azure Stack Hub, you need to provide planning information to your solution provider before deployment starts to help the process go quickly and smoothly. The information required ranges across networking, security, and identity information with many important decisions that may require knowledge from many different areas and decision makers. You'll need people from multiple teams in your organization to ensure that you have all required information ready before deployment. It can help to talk to your hardware vendor while collecting this information because they might have helpful advice.

While researching and collecting the required information, you might need to make some pre-deployment configuration changes to your network environment. These changes could include reserving IP address spaces for the Azure Stack Hub solution as well as configuring your routers, switches, and firewalls to prepare for the connectivity to the new Azure Stack Hub solution switches. Make sure to have the subject area expert lined up to help you with your planning.

## Capacity planning considerations
When you evaluate an Azure Stack Hub solution for acquisition, you make hardware configuration choices which have a direct impact on the overall capacity of the Azure Stack Hub solution. These include the classic choices of CPU, memory density, storage configuration, and overall solution scale (for example, number of servers). Unlike a traditional virtualization solution, the simple arithmetic of these components to determine usable capacity doesn't apply. The first reason is that Azure Stack Hub is architected to host the infrastructure or management components within the solution itself. The second reason is that some of the solution's capacity is reserved in support of resiliency by updating the solution's software in a way that minimizes disruption of tenant workloads.

The [Azure Stack Hub capacity planner spreadsheet](https://aka.ms/azstackcapacityplanner) helps you make informed decisions for planning capacity in two ways. The first is by selecting a hardware offering and attempting to fit a combination of resources. The second is by defining the workload that Azure Stack Hub is intended to run to view the available hardware SKUs that can support it. Finally, the spreadsheet is intended as a guide to help in making decisions related to Azure Stack Hub planning and configuration.

The spreadsheet isn't intended to serve as a substitute for your own investigation and analysis. Microsoft makes no representations or warranties, express or implied, with respect to the information provided within the spreadsheet.

## Management considerations
Azure Stack Hub is a sealed system, where the infrastructure is locked down both from a permissions and network perspective. Network access control lists (ACLs) are applied to block all unauthorized incoming traffic and all unnecessary communications between infrastructure components. This system makes it difficult for unauthorized users to access the system.

For daily management and operations, there's no unrestricted admin access to the infrastructure. Azure Stack Hub operators must manage the system through the administrator portal or through Azure Resource Manager (via PowerShell or the REST API). There's no access to the system by other management tools like Hyper-V Manager or Failover Cluster Manager. To help protect the system, third-party software (for example, agents) can't be installed inside the components of the Azure Stack Hub infrastructure. Interoperability with external management and security software occurs via PowerShell or the REST API.

Contact Microsoft Support when you need a higher level of access for troubleshooting issues that aren't resolved through alert mediation steps. Through support, there's a method to provide temporary full admin access to the system for more advanced operations.

## Identity considerations

### Choose identity provider
You'll need to consider which identity provider you want to use for Azure Stack Hub deployment, either Azure AD or AD FS. You can't switch identity providers after deployment without full system redeployment. If you don't own the Azure AD account and are using an account provided to you by your Cloud Solution Provider, and if you decide to switch provider and use a different Azure AD account, you'll have to contact your solution provider to redeploy the solution for you at your cost.

Your identity provider choice has no bearing on tenant virtual machines (VMs), the identity system, accounts they use, or whether they can join an Active Directory domain, and so on. These things are separate.

You can learn more about choosing an identity provider in the [Azure Stack Hub integrated systems connection models article](./azure-stack-connection-models.md).

### AD FS and Graph integration
If you choose to deploy Azure Stack Hub using AD FS as the identity provider, you must integrate the AD FS instance on Azure Stack Hub with an existing AD FS instance through a federation trust. This integration allows identities in an existing Active Directory forest to authenticate with resources in Azure Stack Hub.

You can also integrate the Graph service in Azure Stack Hub with the existing Active Directory. This integration lets you manage Role-Based Access Control (RBAC) in Azure Stack Hub. When access to a resource is delegated, the Graph component looks up the user account in the existing Active Directory forest using the LDAP protocol.

The following diagram shows integrated AD FS and Graph traffic flow.
![Diagram showing AD FS and Graph traffic flow](media/azure-stack-datacenter-integration/ADFSIntegration.PNG)

## Licensing model
You must decide which licensing model you want to use. The available options depend on if you deploy Azure Stack Hub connected to the internet:
- For a [connected deployment](azure-stack-connected-deployment.md), you can choose either pay-as-you-use or capacity-based licensing. Pay-as-you-use requires a connection to Azure to report usage, which is then billed through Azure commerce. 
- Only capacity-based licensing is supported if you [deploy disconnected](azure-stack-disconnected-deployment.md) from the internet. 

For more information about the licensing models, see [Microsoft Azure Stack Hub packaging and pricing](https://azure.microsoft.com/mediahandler/files/resourcefiles/5bc3f30c-cd57-4513-989e-056325eb95e1/Azure-Stack-packaging-and-pricing-datasheet.pdf).


## Naming decisions

You'll need to think about how you want to plan your Azure Stack Hub namespace, especially the region name and external domain name. The external fully qualified domain name (FQDN) of your Azure Stack Hub deployment for public-facing endpoints is the combination of these two names: &lt;*region*&gt;.&lt;*fqdn*&gt;. For example, *east.cloud.fabrikam.com*. In this example, the Azure Stack Hub portals would be available at the following URLs:

- https://portal.east.cloud.fabrikam.com
- https://adminportal.east.cloud.fabrikam.com

> [!IMPORTANT]
> The region name you choose for your Azure Stack Hub deployment must be unique and will appear in the portal addresses. 

The following table summarizes these domain naming decisions.

| Name | Description | 
| -------- | ------------- | 
|Region name | The name of your first Azure Stack Hub region. This name is used as part of the FQDN for the public virtual IP addresses (VIPs) that Azure Stack Hub manages. Typically, the region name would be a physical location identifier such as a datacenter location.<br><br>The region name must consist of only letters and numbers between 0-9. No special characters (like `-`, `#`, and so on) are allowed.| 
| External domain name | The name of the Domain Name System (DNS) zone for endpoints with external-facing VIPs. Used in the FQDN for these public VIPs. | 
| Private (internal) domain name | The name of the domain (and internal DNS zone) created on Azure Stack Hub for infrastructure management.
| | |

## Certificate requirements

For deployment, you'll need to provide Secure Sockets Layer (SSL) certificates for public-facing endpoints. At a high level, certificates have the following requirements:

- You can use a single wildcard certificate or you can use a set of dedicated certificates, and then use wildcards only for endpoints like storage and Key Vault.
- Certificates can be issued by a public trusted certificate authority (CA) or a customer-managed CA.

For more information about what PKI certificates are required to deploy Azure Stack Hub, and how to obtain them, see, [Azure Stack Hub Public Key Infrastructure certificate requirements](azure-stack-pki-certs.md).  


> [!IMPORTANT]
> The provided PKI certificate information should be used as general guidance. Before you acquire any PKI certificates for Azure Stack Hub, work with your OEM hardware partner. They'll provide more detailed certificate guidance and requirements.


## Time synchronization
You must choose a specific time server which is used to synchronize Azure Stack Hub. Time synchronization is critical to Azure Stack Hub and its infrastructure roles because it's used to generate Kerberos tickets. Kerberos tickets are used to authenticate internal services with each other.

You must specify an IP for the time synchronization server. Although most of the components in the infrastructure can resolve a URL, some only support IP addresses. If you're using the disconnected deployment option, you must specify a time server on your corporate network that you're sure you can reach from the infrastructure network in Azure Stack Hub.

## Connect Azure Stack Hub to Azure

For hybrid cloud scenarios, you'll need to plan how you want to connect Azure Stack Hub to Azure. There are two supported methods to connect virtual networks in Azure Stack Hub to virtual networks in Azure:

- **Site-to-site**: A virtual private network (VPN) connection over IPsec (IKE v1 and IKE v2). This type of connection requires a VPN device or Routing and Remote Access Service (RRAS). For more information about VPN gateways in Azure, see [About VPN Gateway](https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-about-vpngateways). The communication over this tunnel is encrypted and secure. However, bandwidth is limited by the maximum throughput of the tunnel (100-200 Mbps).

- **Outbound NAT**: By default, all VMs in Azure Stack Hub will have connectivity to external networks via outbound NAT. Each virtual network that's created in Azure Stack Hub gets a public IP address assigned to it. Whether the VM is directly assigned a public IP address or is behind a load balancer with a public IP address, it will have outbound access via outbound NAT using the VIP of the virtual network. This method only works for communication that's initiated by the VM and destined for external networks (either internet or intranet). It can't be used to communicate with the VM from outside.

### Hybrid connectivity options

For hybrid connectivity, it's important to consider what kind of deployment you want to offer and where it will be deployed. You'll need to consider whether you need to isolate network traffic per tenant, and whether you'll have an intranet or internet deployment.

- **Single-tenant Azure Stack Hub**: An Azure Stack Hub deployment that looks, at least from a networking perspective, as if it's one tenant. There can be many tenant subscriptions, but like any intranet service, all traffic travels over the same networks. Network traffic from one subscription travels over the same network connection as another subscription and doesn't need to be isolated via an encrypted tunnel.

- **Multi-tenant Azure Stack Hub**: An Azure Stack Hub deployment where each tenant subscription's traffic that's bound for networks that are external to Azure Stack Hub must be isolated from other tenants' network traffic.
 
- **Intranet deployment**: An Azure Stack Hub deployment that sits on a corporate intranet, typically on private IP address space and behind one or more firewalls. The public IP addresses aren't truly public because they can't be routed directly over the public internet.

- **Internet deployment**: An Azure Stack Hub deployment that's connected to the public internet and uses internet-routable public IP addresses for the public VIP range. The deployment can still sit behind a firewall, but the public VIP range is directly reachable from the public internet and Azure.
 
The following table summarizes the hybrid connectivity scenarios with the pros, cons, and use cases.

| Scenario | Connectivity Method | Pros | Cons | Good For |
| -- | -- | --| -- | --|
| Single tenant Azure Stack Hub, intranet deployment | Outbound NAT | Better bandwidth for faster transfers. Simple to implement; no gateways required. | Traffic not encrypted; no isolation or encryption outside the stack. | Enterprise deployments where all tenants are equally trusted.<br><br>Enterprises that have an Azure ExpressRoute circuit to Azure. |
| Multi-tenant Azure Stack Hub, intranet deployment | Site-to-site VPN | Traffic from the tenant VNet to destination is secure. | Bandwidth is limited by site-to-site VPN tunnel.<br><br>Requires a gateway in the virtual network and a VPN device on the destination network. | Enterprise deployments where some tenant traffic must be secured from other tenants. |
| Single tenant Azure Stack Hub, internet deployment | Outbound NAT | Better bandwidth for faster transfers. | Traffic not encrypted; no isolation or encryption outside the stack. | Hosting scenarios where the tenant gets their own Azure Stack Hub deployment and a dedicated circuit to the Azure Stack Hub environment. For example, ExpressRoute and Multiprotocol Label Switching (MPLS).
| Multi-tenant Azure Stack Hub, internet deployment | Site-to-site VPN | Traffic from the tenant VNet to destination is secure. | Bandwidth is limited by site-to-site VPN tunnel.<br><br>Requires a gateway in the virtual network and a VPN device on the destination network. | Hosting scenarios where the provider wants to offer a multi-tenant cloud, where the tenants don't trust each other and traffic must be encrypted.
|  |  |  |  |  |

### Using ExpressRoute

You can connect Azure Stack Hub to Azure via [ExpressRoute](https://docs.microsoft.com/azure/expressroute/expressroute-introduction) for both single-tenant intranet and multi-tenant scenarios. You'll need a provisioned ExpressRoute circuit through [a connectivity provider](https://docs.microsoft.com/azure/expressroute/expressroute-locations).

The following diagram shows ExpressRoute for a single-tenant scenario (where "Customer's connection" is the ExpressRoute circuit).

![Diagram showing single-tenant ExpressRoute scenario](media/azure-stack-datacenter-integration/ExpressRouteSingleTenant.PNG)

The following diagram shows ExpressRoute for a multi-tenant scenario.

![Diagram showing multi-tenant ExpressRoute scenario](media/azure-stack-datacenter-integration/ExpressRouteMultiTenant.PNG)

## External monitoring
To get a single view of all alerts from your Azure Stack Hub deployment and devices, and to integrate alerts into existing IT Service Management workflows for ticketing, you can [integrate Azure Stack Hub with external datacenter monitoring solutions](azure-stack-integrate-monitor.md).

Included with the Azure Stack Hub solution, the hardware lifecycle host is a computer outside Azure Stack Hub that runs OEM vendor-provided management tools for hardware. You can use these tools or other solutions that directly integrate with existing monitoring solutions in your datacenter.

The following table summarizes the list of currently available options.

| Area | External Monitoring Solution |
| -- | -- |
| Azure Stack Hub software | [Azure Stack Hub Management Pack for Operations Manager](https://azure.microsoft.com/blog/management-pack-for-microsoft-azure-stack-now-available/)<br>[Nagios plug-in](https://exchange.nagios.org/directory/Plugins/Cloud/Monitoring-AzureStack-Alerts/details)<br>REST-based API calls | 
| Physical servers (BMCs via IPMI) | OEM hardware - Operations Manager vendor management pack<br>OEM hardware vendor-provided solution<br>Hardware vendor Nagios plug-ins.<br>OEM partner-supported monitoring solution (included) | 
| Network devices (SNMP) | Operations Manager network device discovery<br>OEM hardware vendor-provided solution<br>Nagios switch plug-in |
| Tenant subscription health monitoring | [System Center Management Pack for Windows Azure](https://www.microsoft.com/download/details.aspx?id=50013) | 
|  |  | 

Note the following requirements:
- The solution you use must be agentless. You can't install third-party agents inside Azure Stack Hub components. 
- If you want to use System Center Operations Manager, Operations Manager 2012 R2 or Operations Manager 2016 is required.

## Backup and disaster recovery

Planning for backup and disaster recovery involves planning for both the underlying Azure Stack Hub infrastructure that hosts IaaS VMs and PaaS services, and for tenant apps and data. Plan for these things separately.

### Protect infrastructure components

You can [back up Azure Stack Hub](azure-stack-backup-back-up-azure-stack.md) infrastructure components to an SMB share that you specify:

- You'll need an external SMB file share on an existing Windows-based file server or a third-party device.
- Use this same share for the backup of network switches and the hardware lifecycle host. Your OEM hardware vendor will help provide guidance for backup and restore of these components because these are external to Azure Stack Hub. You're responsible for running the backup workflows based on the OEM vendor's recommendation.

If catastrophic data loss occurs, you can use the infrastructure backup to reseed deployment data such as: 

- Deployment inputs and identifiers
- Service accounts
- CA root certificate
- fFederated resources (in disconnected deployments)
- Plans, offers, subscriptions, and quotas
- RBAC policy and role assignments
- Key Vault secrets

### Protect tenant apps on IaaS VMs

Azure Stack Hub doesn't back up tenant apps and data. You must plan for backup and disaster recovery protection to a target external to Azure Stack Hub. Tenant protection is a tenant-driven activity. For IaaS VMs, tenants can use in-guest technologies to protect file folders, app data, and system state. However, as an enterprise or service provider, you may want to offer a backup and recovery solution in the same datacenter or externally in a cloud.

To back up Linux or Windows IaaS VMs, you must use backup products with access to the guest operating system to protect file, folder, operating system state, and app data. You can use Azure Backup, System Center Datacenter Protection Manager, or supported third-party products.

To replicate data to a secondary location and orchestrate application failover if a disaster occurs, you can use Azure Site Recovery or supported third-party products. Also, apps that support native replication, like Microsoft SQL Server, can replicate data to another location where the app is running.

## Learn more

- For information about use cases, purchasing, partners, and OEM hardware vendors, see the [Azure Stack Hub](https://azure.microsoft.com/overview/azure-stack/) product page.
- For information about the roadmap and geo-availability for Azure Stack Hub integrated systems, see the white paper: [Azure Stack Hub: An extension of Azure](https://azure.microsoft.com/resources/azure-stack-an-extension-of-azure/). 

## Next steps
[Azure Stack Hub deployment connection models](azure-stack-connection-models.md)
