---
title: Azure Kubernetes Service on Azure Stack HCI requirements
description: Before you begin Azure Kubernetes Service on Azure Stack HCI
ms.topic: conceptual
author: abhilashaagarwala
ms.author: abha
ms.date: 12/02/2020
---
# System requirements for Azure Kubernetes Service on Azure Stack HCI

> Applies to: Azure Stack HCI, Windows Server 2019 Datacenter

This article covers the requirements for setting up Azure Kubernetes Service on Azure Stack HCI or on Windows Server 2019 Datacenter and using it to create Kubernetes clusters. For an overview of Azure Kubernetes Service on Azure Stack HCI, see [AKS on Azure Stack HCI overview](overview.md).

## Determine hardware requirements

Microsoft recommends purchasing a validated Azure Stack HCI hardware/software solution from our partners. These solutions are designed, assembled, and validated against our reference architecture to ensure compatibility and reliability so you get up and running quickly. Check that the systems, components, devices, and drivers you are using are Windows Server 2019 Certified per the Windows Server Catalog. Visit the [Azure Stack HCI solutions](https://azure.microsoft.com/overview/azure-stack/hci) website for validated solutions.

## General requirements

For Azure Kubernetes Service on Azure Stack HCI or Windows Server 2019 Datacenter to function optimally in an Active Directory environment, ensure the following requirements are fulfilled: 

 - Ensure time synchronization is set up and the divergence is not greater than 2 minutes across all cluster nodes and the domain controller. For information on setting time synchronization, see [Windows Time Service](/windows-server/networking/windows-time-service/windows-time-service-top). 

 - Ensure the user account(s) that adds updates, and manages Azure Kubernetes Service on Azure Stack HCI or Windows Server 2019 Datacenter clusters has the correct permissions in Active Directory. If you are using Organizational Units (OUs) to manage group policies for servers and services, the user account(s) will require list, read, modify, and delete permissions on all objects in the OU. 

 - We recommend using a separate OU for the servers and services you add your Azure Kubernetes Service on Azure Stack HCI or Windows Server 2019 Datacenter clusters to. This will allow you to control access and permissions with more granularity.

 - If you are using GPO templates on containers in Active Directory, ensure deploying AKS-HCI is exempt from that policy. Server hardening will be available in a subsequent preview release.

## Compute requirements

 - An Azure Stack HCI cluster or a Windows Server 2019 Datacenter failover cluster with a maximum of four servers in the cluster. We recommend that each server in the cluster have at least 24 CPU cores and at least 256 GB RAM.

 - While you can technically run Azure Kubernetes Service on a single node Windows Server 2019 Datacenter, we do not recommend doing so. However, you can run Azure Kubernetes Service on a single node Windows Server 2019 Datacenter for evaluation purposes.

 - Other compute requirements for Azure Kubernetes Service on Azure Stack HCI are in line with Azure Stack HCI’s requirements. Visit [Azure Stack HCI system requirements](../hci/concepts/system-requirements.md#server-requirements) for more details on Azure Stack HCI server requirements.

 - This preview release requires that you install the Azure Stack HCI operating system on each server in the cluster using the EN-US region and language selections; changing them after installation isn't sufficient at this time.

## Network requirements 

The following requirements apply to an Azure Stack HCI cluster as well as a Windows Server 2019 Datacenter failover cluster: 

 - Verify that you have an existing, external virtual switch configured if you’re using Windows Admin Center. For Azure Stack HCI clusters, this switch and its name must be the same across all cluster nodes. 

 - Verify that you have disabled IPv6 on all network adapters. 

 - For a successful deployment, the Azure Stack HCI cluster nodes and the Kubernetes cluster VMs must have external Internet connectivity. 

 - DNS name resolution is required for all nodes to be able to communicate with each other. For Kubernetes external name resolution, use the DNS servers provided by the DHCP server when the IP address is obtained. For Kubernetes internal name resolution, use the default Kubernetes core DNS-based solution. 

 - For this preview release, we provide only single VLAN support for the entire deployment. 

 - For this preview release, we have limited proxy support for Kubernetes clusters created through PowerShell. 
 
### IP Address assignment  
 
There are two options for assigning IP addresses in an AKA HCI cluster: a DHCP automatic assignment or a static IP address assignment. Each one has it's own set of requirements.

#### DHCP
If you are planning to use DHCP for IP address assignment throughout the cluster:  

 - The network must have an available DHCP server to provide TCP/IP addresses to the VMs and VM hosts. The DHCP server should also contain NTP and DNS host information. 

 - We also recommend having a DHCP server with a dedicated scope of IPv4 addresses accessible by the Azure Stack HCI cluster. For example, you can reserve 10.0.1.1 for the default gateway, reserve 10.0.1.2 to 10.0.1.102 for Kubernetes services (using -vipPoolStartIp and -vipPoolEndIp in Set-AksHciConfig), and use 10.0.1.103-10.0.1.254 for Kubernetes cluster VMs. 

How many DHCP addresses to reserve? (minimum)  
  
| User Supplied Value | Required IPs |
|----------|------------------|
| IP Pool Range | At least 3 IP addresses in range, recommended 16 or higher |
| MAC Pool Range | At least 16 IP addresses in the range to allow for multi/single node configurations |

*Management cluster*  
    - One IP for the management node VM (assigned by DHCP)  
    - One IP for the load balancer VM (assigned by DHCP)  
    - One IP for the API server (from above IP address pool)  

*Workload cluster*    
    Control plane cluster:
    - +1*n IP for each control plane node (assigned by DHCP)  
    - +1 for the load balancer VM (assigned by DHCP)  
    - +1 for the kubeapi server VIP (from pool)  
     
*Target cluster*  
    - 1*n for each worker node (assigned by DHCP)  

> [!NOTE]
> N for each service (minimum 1)



 The IPv4 addresses provided by the DHCP server should be routable and have a 30-day lease expiration to avoid loss of IP connectivity in the event of a VM update or reprovisioning.    

#### Static ip  

If you are planning to use static IP address assignments throughout the cluster, you need to ensure the ranges that are made available contain the following minimum amount of IP addresses.
  
| User Supplied Value | Required IPs |
|----------|------------------|
| Subnet Prefix | CIDR |
| Gateway | 1 IP |
| DNS Servers | Up to 3 IPs |
| IP Range | At least 12 IP addresses in the range to allow for multi/single node configurations, recommended 32 or higher |
| MAC Pool Range | At least 16 IPs in range to allow for multi/single node configurations |


_Management cluster:_  
    - One IP for the management node VM   
    - One IP for the load balancer VM  
    - One IP for the API server    

_Workload cluster_  
Control Plane cluster:  
    - +1*n ip for each control plane node  
    - +1 for the kubeapi server vip  
    - +1 for the the load balancer VM 

Target cluster:
    - 1*n for each worker node 

N for each service (minimum 1)
  
### Network port and URL requirements 

When creating an Azure Kubernetes Cluster on Azure Stack HCI, the following firewall ports are automatically opened on each server in the cluster. 


| Firewall Port               | Description         | 
| ---------------------------- | ------------ | 
| 45000           | wssdagent GPRC   server port           |
| 45001             | wssdagent GPRC authentication port  | 
| 55000           | wssdcloudagent GPRC   server port           |
| 55001             | wssdcloudagent GPRC authentication port  | 


Firewall URL exceptions are needed for the Windows Admin Center machine and all nodes in the Azure Stack HCI cluster. 

| URL        | Port | Service | Notes |
| ---------- | ---- | --- | ---- |
https://helm.sh/blog/get-helm-sh/  | 443 | Download Agent, WAC | Used to download the Helm binaries 
https://storage.googleapis.com/  | 443 | Cloud Init | Downloading Kubernetes binaries 
https://azurecliprod.blob.core.windows.net/ | 443 | Cloud Init | Downloading binaries and containers 
https://aka.ms/installazurecliwindows | 443 | WAC | Downloading Azure CLI 
https://:443 | 443 | TCP | Used to support Azure Arc agents 
*.api.cdp.microsoft.com, *.dl.delivery.mp.microsoft.com, *.emdl.ws.microsoft.com | 80, 443 | Download Agent | Downloading metadata 
*.dl.delivery.mp.microsoft.com, *.do.dsp.mp.microsoft.com. | 80, 443 | Download Agent | Downloading VHD images 
ecpacr.azurecr.io | 443 | Kubernetes | Downloading container images 
git://:9418 | 9418 | TCP | Used to support Azure Arc agents 

## Storage requirements 

The following storage implementations are supported by Azure Kubernetes Service on Azure Stack HCI: 

|  Name                         | Storage Type | Required Capacity |
| ---------------------------- | ------------ | ----------------- |
| Azure Stack HCI Cluster          | CSV          | 1 TB              |
| Windows Server 2019 Datacenter failover cluster          | CSV          | 1 TB              |
| Single Node Windows Server 2019 Datacenter | Direct Attached Storage | 500 GB|

## Review maximum supported hardware specifications 

Azure Kubernetes Service on Azure Stack HCI deployments that exceed the following specifications are not supported: 

| Resource                     | Maximum |
| ---------------------------- | --------|
| Physical servers per cluster | 4       |
| Kubernetes Clusters            | 4       |
| Total number of VMs          | 200     |

## Windows Admin Center requirements

Windows Admin Center is the user interface for creating and managing Azure Kubernetes Service on Azure Stack HCI. To use Windows Admin Center with Azure Kubernetes Service on Azure Stack HCI, you must meet all the criteria in the list below. 

Here are the requirements for the machine running the Windows Admin Center gateway: 

 - Windows 10 or Windows Server machine (we don't support running Windows Admin Center on the Azure Stack HCI or Windows Server 2019 Datacenter cluster right now)
 - 60 GB of free space
 - Registered with Azure
 - In the same domain as the Azure Stack HCI or Windows Server 2019 Datacenter cluster

## Next steps 

After you have satisfied all of the prerequisites above, you can set up a Azure Kubernetes Service host on Azure Stack HCI using:
 - [Windows Admin Center](setup.md)
 - [PowerShell](setup-powershell.md)
