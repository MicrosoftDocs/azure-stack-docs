---
title: Azure Arc VM management prerequisites (preview)
description: Learn about the prerequisites for deploying Azure Arc VM management (preview).
author: ksurjan
ms.author: ksurjan
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/17/2022
---

# Azure Arc VM management prerequisites (preview)

> Applies to: Azure Stack HCI, versions 22H2 and 21H2

This article lists the prerequisites for Azure Arc VM management. We recommend that you review the information carefully before you set up Azure Arc VM management. You can refer back to this information as necessary during the deployment and subsequent operation.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Resource requirements

The resource requirements include:

- A cluster shared volume with at least 50 GB of space. This is required to store configuration details and the OS image for your Arc Resource Bridge VM.
- At least 4 vCPUs
- At least 8 GB of memory

## Azure requirements

The Azure requirements include:

- An Azure subscription ID. This is the Azure subscription GUID where your Arc Resource Bridge, custom location, and cluster extension resources reside.

- The latest version of Azure Command-Line Interface (CLI). You must install this on all servers in your Azure Stack HCI cluster.

  - To install Azure CLI on each server in a cluster, use Remote Desktop Protocol (RDP) connection.
  
  - For instructions on installing Azure CLI, see [Install Azure CLI](/cli/azure/install-azure-cli-windows).
  
    - If you're using a local installation, sign in to the Azure CLI by using the [az login](/cli/azure/reference-index#az-login) command. To finish the authentication process, follow the steps displayed in your terminal. For other sign-in options, see [Sign in with the Azure CLI](/cli/azure/authenticate-azure-cli).

    - When you're prompted, install the Azure CLI extension on first use. For more information about extensions, see [Use extensions with the Azure CLI](/cli/azure/azure-cli-extensions-overview).

    - Run [az version](/cli/azure/reference-index?#az-version) to find the version and dependent libraries that are installed. To upgrade to the latest version, run [az upgrade](/cli/azure/reference-index?#az-upgrade).

- Required Azure permissions:

  - To onboard the Arc Resource Bridge, you must have the [Contributor](/azure/role-based-access-control/built-in-roles#contributor) role for the resource group.
    
  - To read, modify, and delete the Arc resource bridge, you must have the Contributor role for the resource group.

## Networking requirements

The network requirements include:

- A virtual switch of type "External". Make sure the switch has external internet connectivity. This virtual switch and its name must be the same across all servers in the Azure Stack HCI cluster.
- If using DHCP, ensure that DHCP server has at least two IP addresses for Resource Bridge VM ($VMIP_1, $VMIP_2). You can have a tagged or untagged DHCP server.
- Please make sure $VMIP_1 and $VMIP_2 have internet access.
- An IP address of the Kubernetes API server hosting the VM management application that is running inside the Resource Bridge VM($controlPlaneIP). The IP address needs to be in the same subnet as the DHCP scope and must be excluded from the DHCP scope to avoid IP address conflicts.
- Please make sure $controlPlaneIP has internet access.
- The Host must be able to reach the IPs given to the control plane endpoint ($controlPlaneIP) and Arc Resource Bridge VM IPs ($VMIP_1, $VMIP_2). Please work with your network administrator to enable this.
- An IP address for the cloud agent running inside the Resource Bridge. If the Azure Stack HCI cluster servers were assigned static IP addresses, then provide an explicit IP address for the cloud agent. The IP address for the cloud agent must be in the same subnet as the IP addresses of Azure Stack HCI cluster servers.

## Network port requirements

When you deploy Arc Resource Bridge on Azure Stack HCI, the following firewall ports are automatically opened on each server in the cluster.

| **Port** | **Service** |
|:---------|:------------|
| 45000    | wssdagent gRPC server |
| 45001    | wssdagent gRPC authentication |
| 55000    | wssdcloudagent gRPC server |
| 65000    | wssdcloudagent gRPC authentication |

## Firewall URL requirements

Make sure to include the following firewall URLs to your allowlist:

| **URL** | **Port** | **Service** | **Notes** |
|:--------|:---------|:------------|:----------|
| https\://mcr.microsoft.com | 443 | Microsoft container registry | Used for official Microsoft artifacts such as container images |
| https\://*.his.arc.azure.com | 443 | Azure Arc identity service | Used for identity and access control |
| https\://*.dp.kubernetesconfiguration.azure.com | 443 | Kubernetes | Used for Azure Arc configuration |
| https\://*.servicebus.windows.net | 443 | Cluster connect | Used to securely connect to Azure Arc-enabled Kubernetes clusters without requiring any inbound port to be enabled on the firewall |
| https\://guestnotificationservice.azure.com | 443 | Notification service | Used for guest notification operations |
| https\://*.dp.prod.appliances.azure.com | 443 | Data plane service | Used for data plane operations for Resource bridge (appliance) | 
| https\://ecpacr.azurecr.io | 443 | Download agent | Used to download Resource bridge (appliance) container images |
| *.blob.core.windows.net <br> *.dl.delivery.mp.microsoft.com <br> *.do.dsp.mp.microsoft.com | 443 | TCP | Used to download Resource bridge (appliance) images |
| https\://azurearcfork8sdev.azurecr.io | 443 | Kubernetes | Used to download Azure Arc for Kubernetes container images
| https\://adhs.events.data.microsoft.com | 443 | Telemetry | ADHS is a telemetry service running inside the appliance/mariner OS. Used periodically to send required diagnostic data to Microsoft from control plane nodes. Used when telemetry is coming off mariner, which would mean any Kubernetes control plane |
| https\://v20.events.data.microsoft.com  | 443 | Telemetry | Used periodically to send required diagnostic data to Microsoft from the Azure Stack HCI or Windows Server host |
| pypi.org  | 443 | Python package | Validate Kubernetes and Python versions |
| *.pypi.org  | 443 | Python package | Validate Kubernetes and Python versions |

> [!NOTE]
> We currently do not support proxy configurations.

## Next steps

- [Set up Azure Arc VM management using Windows Admin Center](deploy-arc-resource-bridge-using-wac.md)
- [Set up Azure Arc VM management using command line](deploy-arc-resource-bridge-using-command-line.md)
