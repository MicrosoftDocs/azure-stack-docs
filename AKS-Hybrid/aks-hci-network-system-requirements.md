---
title: AKS on Azure Stack HCI 23H2 networking system requirements (preview)
description: Learn about AKS on Azure Stack HCI 23H2 networking prerequisites.
ms.topic: overview
ms.date: 12/11/2023
author: sethmanheim
ms.author: sethm 
ms.reviewer: mikek
ms.lastreviewed: 11/17/2023

---

# AKS on Azure Stack HCI 23H2 networking system requirements (preview)

This article describes the required networking prerequisites for installing AKS on Azure Stack HCI 23H2. It's recommended that you work with a network administrator to provide and set up the networking parameters required to deploy AKS.

The following requirements apply to an Azure Stack HCI administrator, in consultation with the corporate network administrator:

## Static IP networking (recommended)

|      Prerequisite     |      Item     |      Details     |      Value     |
|---|---|---|---|
|     1    |     Do you have a static IP subnet?    |     This subnet is used for assigning an IP address to the underlying VMs of the AKS cluster.    |     The IP address prefix of your subnet; for example, 172.16.0.0/16.    |
|     2    |     Do you have at least 4 available IP addresses in the subnet?    |     Ensure that you have at least 4 continuous available IP addresses in this subnet.    |     Ensure and list the range of available IP addresses in your subnet; for example, 172.16.0.3 to 172.16.0.10.    |
|     3    |     What is the default gateway IP address?    |     The IP address of the default gateway of the subnet you provided.    |     The IP address of your gateway; for example, 172.16.0.1.    |
|     4    |     Does the subnet have public DNS resolution access?    |     A minimum of one and a maximum of three DNS server IP addresses can be provided.    |     The IP address(es) of your DNS servers; for example, 172.16.0.2. To specify more than one DNS server use a comma "," to separate them.    |
|     5    |     Do you have an external virtual switch configured on Azure   Stack HCI?    |     You need a virtual switch configured for subnets used to deploy AKS clusters on.    |     The name of the virtual switch.    |
|     6    |     Do you have a VLAN ID?    |     This is an optional parameter. Check with your network administrator if the subnet you provided above is VLAN tagged.    |     The VLAN ID; for example, 7.    |

## DHCP networking

|      Prerequisite     |      Item     |      Details     |      Value     |
|---|---|---|---|
|     1    |     Do you have a DHCP server with a scope of at least 7 IP addresses in your environment?    |     This DHCP server is used to assign an IP address to the underlying VMs of the AKS cluster.    |     Check with your network administrator if your network environment has a DHCP server.    |
|     2    |     Do you have at least 2 IP addresses excluded from the DHCP scope?    |     You need 2 IP addresses to be excluded from the DHCP scope. Apart from 7 required IP addresses in the DHCP scope, we also need to statically assign IP addresses to some important components, so their IP address never changes; for example, the Kubernetes Control Plane IP address.    |     List of at least 2 IP addresses in the same subnet as the DHCP server but excluded from the DHCP scope.    |
|     3    |     Do you have an external virtual switch configured on Azure Stack HCI?    |     You need a virtual switch configured for subnets used to deploy AKS clusters on.    |     The name of the virtual switch.    |
|     4    |     Do you have a VLAN ID?    |     This is an optional parameter. Check with your network administrator if the subnet you provided above is VLAN tagged.    |     The VLAN ID; for example, 7.    |

## Proxy settings

In this preview release, proxy settings are inherited from the underlying Azure Stack HCI system. The functionality to set individual proxy
settings for AKS clusters and change proxy settings will be in a later release.

## Network port requirements

The configuration of required network ports is now incorporated into the Azure Stack HCI 23H2 deployment. Manual configuration of these ports is no longer required. Use the following port list to troubleshoot communication issues between the Arc Resource Bridge and AKS clusters deployed on Azure Stack HCI 23H2 or newer:

| Port | Source                           | Description                                          | Firewall Notes                                                                                                        |
|----------|--------------------------------------|----------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------|
| 22       | Azure Arc Resource Bridge VM         | Required to collect logs when troubleshooting the system | If you are using separate VLANs, the physical Hyper-V Hosts need to access the AKS cluster VMs on this port.              |
| 6443     | Azure Arc Resource Bridge VM         | Required to communicate with Kubernetes APIs.            | If you are using separate VLANs, the physical Hyper-V Hosts need to access the Azure Arc Resource Bridge VM on this port. |
| 45000    | Physical Hyper-V Hosts               | wssdAgent gRPC Server                                    | No cross-VLAN rules are needed.                                                                                           |
| 45001    | Physical Hyper-V Hosts               | wssdAgent gRPC Authentication                            | No cross-VLAN rules are needed.                                                                                           |
| 46000    | Azure Arc Resource Bridge VM         | wssdCloudAgent to lbagent                                | If you are using separate VLANs, the physical Hyper-V Hosts need to access the Azure Arc Resource Bridge VM on this port. |
| 55000    | Cluster Resource (-CloudServiceCIDR) | Cloud Agent gRPC Server                                  | If you are using separate VLANs, the Azure Arc Resource Bridge VM needs to access the Cluster Resource IP on this port.   |
| 65000    | Cluster Resource (-CloudServiceCIDR) | Cloud Agent gRPC Authentication                          | If you are using separate VLANs, the Azure Arc Resource Bridge VM needs to access the Cluster Resource IP on this port.   |

## Firewall URL exceptions

For information about the Azure Arc firewall/proxy URL allowlist, see the [Azure Arc resource bridge network requirements](/azure/azure-arc/resource-bridge/network-requirements#firewallproxy-url-allowlist) and [Azure Stack HCI 23H2 network requirements](/azure-stack/hci/manage/use-environment-checker?tabs=connectivity#prerequisites).

For deployment and operation of AKS clusters, the following URLs must be reachable from all physical nodes and virtual machines in the
deployment. Ensure that these are allowed in your firewall configuration:

| URL | Port | Service | Notes |
|---|---|---|---|
| `https://mcr.microsoft.com` | 443 | Microsoft container registry | Used for official Microsoft artifacts such as container images. |
| `https://*.his.arc.azure.com` | 443 | Azure Arc identity service | Used for identity and access control. |
| `https://*.dp.kubernetesconfiguration.azure.com` | 443 | Kubernetes | Used for Azure Arc configuration. |
| `https://*.servicebus.windows.net` | 443 | Cluster connect | Used to securely connect to Azure Arc-enabled Kubernetes clusters without requiring any inbound port to be enabled on the firewall. |
| `https://guestnotificationservice.azure.com` | 443 | Notification service | Used for guest notification operations. |
| `https://*.dp.prod.appliances.azure.com` | 443 | Data plane service | Used for data plane operations for Resource bridge (appliance). |
| `https://ecpacr.azurecr.io` | 443 | Download agent | Used to download Resource bridge (appliance) container images. |
| `*.blob.core.windows.net`<br> `*.dl.delivery.mp.microsoft.com` <br> `*.do.dsp.mp.microsoft.com` | 443 | TCP | Used to download Resource bridge (appliance) images. |
| `https://azurearcfork8sdev.azurecr.io` | 443 | Kubernetes | Used to download Azure Arc for Kubernetes container images. |
| `https://adhs.events.data.microsoft.com` | 443 | Telemetry | ADHS is a telemetry service running inside the appliance/mariner OS. Used periodically to send required diagnostic data to Microsoft from control plane nodes. Used when telemetry is coming off mariner, which means any Kubernetes control plane. |
| `https://v20.events.data.microsoft.com`  | 443 | Telemetry | Used periodically to send required diagnostic data to Microsoft from the Windows Server host. |
| `gcr.io` | 443 | Google container registry | Used for Kubernetes official artifacts such as container base images. |
| `pypi.org`  | 443 | Python package | Validate Kubernetes and Python versions. |
| `*.pypi.org`  | 443 | Python package | Validate Kubernetes and Python versions. |
| `https://hybridaks.azurecr.io` | 443 | Container image | Required to access the HybridAKS operator image. |
| `aka.ms` | 443 | az extensions | Required to download Az CLI extensions such as akshybrid and connectedk8s. |

## Next steps

[AKS on Azure Stack HCI 23H2 overview](aks-preview-overview.md)
