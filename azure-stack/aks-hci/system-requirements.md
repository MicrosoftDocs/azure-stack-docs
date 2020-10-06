---
title: Azure Kubernetes Service on Azure Stack HCI requirements
description: Before you begin Azure Kubernetes Service on Azure Stack HCI
ms.topic: conceptual
author: abhilashaagarwala
ms.author: abha
ms.date: 09/22/2020
---
# System requirements for Azure Kubernetes Service on Azure Stack HCI

> Applies to: Azure Stack HCI

This article covers the requirements for setting up Azure Kubernetes Service on Azure Stack HCI and using it to create Kubernetes clusters. For an overview of Azure Kubernetes Service on Azure Stack HCI, see [AKS on Azure Stack HCI overview](overview.md).

## Determine hardware requirements

Microsoft recommends purchasing a validated Azure Stack HCI hardware/software solution from our partners. These solutions are designed, assembled, and validated against our reference architecture to ensure compatibility and reliability so you get up and running quickly. Check that the systems, components, devices, and drivers you are using are Windows Server 2019 Certified per the Windows Server Catalog. Visit the [Azure Stack HCI solutions](https://azure.microsoft.com/overview/azure-stack/hci) website for validated solutions.

### General requirements

For Azure Kubernetes Service on Azure Stack HCI to function optimally in an Active Directory environment, ensure the following requirements are fulfilled: 

 - Ensure time synchronization is setup and the divergence is not greater than 2 minutes across all cluster nodes and the domain controller. For information on setting time synchronization visit [Windows Time Service](/windows-server/networking/windows-time-service/windows-time-service-top). 

 - Ensure that the user account(s) adding, updating, and managing Azure Kubernetes Service on Azure Stack HCI clusters have the correct permissions in Active Directory. If you are using Organizational Units (OUs) to manage group policies for servers and services, the user account(s) will require list, read, modify, and delete permissions on all objects in the OU. 

 - We recommend using a separate OU for the servers and services you add your Azure Kubernetes Service on Azure Stack HCI clusters to. This will allow you to control access and permissions with more granularity.

 - If you are using GPO templates on containers in Active Directory, ensure deploying AKS-HCI is exempt from that policy. Server hardening will be available in a subsequent preview release.

### Compute requirements

 - An Azure Stack HCI cluster with a maximum of four servers in the cluster. We recommend that each server in the cluster have at least 24 CPU cores and at least 512 GB RAM.

 - While you can technically run Azure Kubernetes Service on a single node Azure Stack HCI Server, we do not recommend doing so.

 - Other compute requirements for Azure Kubernetes Service on Azure Stack HCI are in line with Azure Stack HCI’s requirements. Visit [Azure Stack HCI Requirements](../hci/deploy/before-you-start.md) for more details on Azure Stack HCI’s server requirements.  

 - This preview release requires that you install the Azure Stack HCI operating system on each server in the cluster using the EN-US region and language selections; changing them after installation isn't sufficient at this time.

### Network requirements 

Azure Kubernetes Service on Azure Stack HCI requires a reliable high-bandwidth, low-latency network connection between each server node. You should verify the following: 

 - Verify that you have an existing, external virtual switch configured if you’re using Windows Admin Center. For Azure Stack HCI clusters, this switch must be the same across all cluster nodes. 

 - Verify that you have disabled IPv6 on all network adapters. 

 - The network must have an available DHCP server to provide TCP/IP addresses to the VMs and VM hosts. The DHCP server should also contain NTP and DNS host information. 

 - We also recommend having a DHCP server with a dedicated scope of IPv4 addresses accessible by the Azure Stack HCI cluster. For example, you can reserve 10.0.1.1 for the default gateway, 10.0.1.2 to 10.0.1.102 for Kubernetes services and use 10.0.1.103-10.0.1.254 for Kubernetes cluster VMs. 

 - The IPv4 addresses provided by the DHCP server should be routable and have a 7-day lease expiration to avoid loss of IP connectivity in case of VM update or reprovisioning.  

 - We don't recommend to have VLAN tags. Use access or untagged ports on your Azure Stack HCI cluster network switches. 

 - We don't recommend to use a dedicated static virtual IP pool for the load balancer virtual IP pool during setup. The DHCP IP pool is used for the virtual machines whereas the virtual IP pool is used for the load balancer, and needs to be routable. The DHCP IP pool does not need to be routable to the external internet.

 - DNS name resolution is required for all nodes to be able to communicate with each other. For Kubernetes external name resolution, we use the DNS servers provided by the DHCP server when the IP address is obtained. For Kubernetes internal name resolution, we use the default Kubernetes core DNS based solution. 

 - For this preview release, we don't support using a proxy server to connect the Windows Admin Center, Azure Stack HCI cluster nodes, and the Azure Kubernetes Service on Azure Stack HCI cluster nodes to the internet.

### Network port and URL requirements 

When creating an Azure Kubernetes Cluster on Azure Stack HCI, we will automatically open the following firewall ports on each server in the cluster. 


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
*.api.cdp.microsoft.com, *.dl.delivery.mp.microsoft.com, *.emdl.ws.microsoft.com | 80, 443 | Download Agent | Downloading metadata 
*.dl.delivery.mp.microsoft.com, *.do.dsp.mp.microsoft.com. | 80, 443 | Download Agent | Downloading VHD images 
ecpacr.azurecr.io | 443 | Kubernetes | Downloading container images 

### Storage requirements 

The following storage implementations are supported by Azure Kubernetes Service on Azure Stack HCI: 

|  Name                         | Storage Type | Required Capacity |
| ---------------------------- | ------------ | ----------------- |
| Azure Stack HCI Cluster          | CSV          | 1 TB              |
| Single Node Azure Stack HCI | Direct Attached Storage | 500 GB|

### Review maximum supported hardware specifications 

Azure Kubernetes Service on Azure Stack HCI deployments that exceed the following specifications are not supported: 

| Resource                     | Maximum |
| ---------------------------- | --------|
| Physical servers per cluster | 4       |
| Kubernetes Clusters            | 4       |
| Total number of VMs          | 200     |

### Windows Admin Center 

Windows Admin Center is the user interface for creating and managing Azure Kubernetes Service on Azure Stack HCI. To use Windows Admin Center with Azure Kubernetes Service on Azure Stack HCI, you must meet all the criteria in the list below. 

#### On your Windows Admin Center system

The machine running the Windows Admin Center gateway must: 

 - Windows 10 (we don't support Windows Admin Center servers right now)
 - 60 GB of free space
 - Registered with Azure
 - In the same domain as the Azure Stack HCI cluster

## Next steps 

After you have satisfied all of the prerequisites above, you can set up a Azure Kubernetes Service host on Azure Stack HCI using:
 - [Windows Admin Center](setup.md)
 - [PowerShell](setup-powershell.md)
