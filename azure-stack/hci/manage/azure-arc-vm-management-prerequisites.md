---
title: Azure Arc VM management prerequisites (preview)
description: Learn about the prerequisites for deploying Azure Arc VM management (preview).
author: ksurjan
ms.author: ksurjan
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 04/26/2023
---

# Azure Arc VM management prerequisites (preview)

[!INCLUDE [hci-applies-to-22h2-21h2](../../includes/hci-applies-to-22h2-21h2.md)]

This article lists the prerequisites for Azure Arc VM management. We recommend that you review the information carefully before you set up Azure Arc VM management. You can refer back to this information as necessary during the deployment and subsequent operation.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Resource requirements

To ensure the successful activation of Arc VM and the availability of sufficient resources for deploying Arc VMs, please make sure that:

- A cluster shared volume with at least 1 TB of space. This is required to store configuration details and the OS image for your Arc Resource Bridge VM.
- At least 4 vCPUs
- At least 16 GB of memory

## Azure requirements

The Azure requirements include:

- An Azure subscription ID. This is the Azure subscription GUID where your Arc Resource Bridge, custom location, and cluster extension resources reside.
  > [!NOTE]
  > Arc VM management for Azure Stack HCI is currently supported in **East US** & **West Europe**. For Arc VM management on Azure Stack HCI, all entities must be registered, enabled or created in the same region. The entities include Azure Stack HCI cluster, Arc Resource Bridge, Custom Location, VM operator, virtual machines created from Arc and Azure Arc for Servers guest management. These entities can be in different or same resource groups as long as all resource groups are in the same region.

- The latest version of Azure Command-Line Interface (CLI). You must install this on all servers in your Azure Stack HCI cluster.

  - To install Azure CLI on each server in a cluster, use Remote Desktop Protocol (RDP) connection.
  
  - For instructions on installing Azure CLI, see [Install Azure CLI](/cli/azure/install-azure-cli-windows).
  
    - If you're using a local installation, sign in to the Azure CLI by using the [az login](/cli/azure/reference-index#az-login) command. To finish the authentication process, follow the steps displayed in your terminal. For other sign-in options, see [Sign in with the Azure CLI](/cli/azure/authenticate-azure-cli).

    - When you're prompted, install the Azure CLI extension on first use. For more information about extensions, see [Use extensions with the Azure CLI](/cli/azure/azure-cli-extensions-overview).

    - Run [az version](/cli/azure/reference-index?#az-version) to find the version and dependent libraries that are installed. To upgrade to the latest version, run [az upgrade](/cli/azure/reference-index?#az-upgrade).

- Required Azure permissions:

  - To install the Arc Resource Bridge, you must have the [Contributor](/azure/role-based-access-control/built-in-roles#contributor) role for the resource group.
    
  - To read, modify, and delete the Arc resource bridge, you must have the Contributor role for the resource group.

  - To provision Arc VMs & entities through Azure Portal, users must have Contributor level access at the subscription level.

## Networking requirements

The network requirements include:

- A virtual switch of type *External*. Make sure that the switch has external internet connectivity. This virtual switch and its name must be the same across all servers in the Azure Stack HCI cluster.
- If using DHCP, ensure that DHCP server has at least two IP addresses for Resource Bridge VM (`$VMIP_1`, `$VMIP_2`). You can have a tagged or untagged DHCP server.
- Make sure that `$VMIP_1` and `$VMIP_2` have internet access.
- An IP address of the Kubernetes API server hosting the VM management application that is running inside the Resource Bridge VM(`$controlPlaneIP`). The IP address needs to be in the same subnet as the DHCP scope and must be excluded from the DHCP scope to avoid IP address conflicts.
- The Host must be able to reach the IPs given to the control plane endpoint ($controlPlaneIP) and Arc Resource Bridge VM IPs (`$VMIP_1`, `$VMIP_2`). Work with your network administrator to enable this.
- An IP address for the cloud agent running inside the Resource Bridge (`$cloudServiceIP`). If the Azure Stack HCI cluster servers were assigned static IP addresses, then provide an explicit IP address for the cloud agent. The IP address for the cloud agent must be in the same subnet as the IP addresses of Azure Stack HCI cluster servers.

For more information, see the [networking concepts related to Arc VM management](azure-arc-vm-management-networking.md).

## Network port requirements

When you deploy Arc Resource Bridge on Azure Stack HCI, the following firewall ports are automatically opened on each server in the cluster.

| **Port** | **Service** |
|:---------|:------------|
| 45000    | wssdagent gRPC server |
| 45001    | wssdagent gRPC authentication |
| 55000    | wssdcloudagent gRPC server |
| 65000    | wssdcloudagent gRPC authentication |

## Firewall URL requirements

Make sure to include the following firewall URLs in your allowlist:

| **URL** | **Port** | **Service** | **Notes** |
|:--------|:---------|:------------|:----------|
| https\://mcr.microsoft.com | 443 | Microsoft container registry | Used for official Microsoft artifacts such as container images |
| https\://*.his.arc.azure.com | 443 | Azure Arc identity service | Used for identity and access control |
| https\://*.dp.kubernetesconfiguration.azure.com | 443 | Kubernetes | Used for Azure Arc configuration |
| https\://*.servicebus.windows.net | 443 | Cluster connect | Used to securely connect to Azure Arc-enabled Kubernetes clusters without requiring any inbound port to be enabled on the firewall |
| sts.windows.net | 443 | Secure token service | Used for custom locations |
| hybridaks.azurecr.io  | 443 | Kubernetes | Used for creating Kubernetes extensions |
| https\://guestnotificationservice.azure.com | 443 | Notification service | Used for guest notification operations |
| https\://*.dp.prod.appliances.azure.com | 443 | Data plane service | Used for data plane operations for Resource bridge (appliance) | 
| https\://ecpacr.azurecr.io | 443 | Download agent | Used to download Resource bridge (appliance) container images |
| *.blob.core.windows.net <br> *.dl.delivery.mp.microsoft.com <br> *.do.dsp.mp.microsoft.com | 443 | TCP | Used to download Resource bridge (appliance) images |
| https\://azurearcfork8s.azurecr.io | 443 | Kubernetes | Used to download Azure Arc for Kubernetes container images
| https\://adhs.events.data.microsoft.com | 443 | Telemetry | ADHS is a telemetry service running inside the appliance/mariner OS. Used periodically to send required diagnostic data to Microsoft from control plane nodes. Used when telemetry is coming off mariner, which would mean any Kubernetes control plane |
| https\://v20.events.data.microsoft.com  | 443 | Telemetry | Used periodically to send required diagnostic data to Microsoft from the Azure Stack HCI or Windows Server host |
| *.pypi.org  | 443 | Python package | Validate Kubernetes and Python versions |
| *.pythonhosted.org  | 443 | Python package | Used for downloading python packages during Azure CLI installation |
| msk8s.b.tlu.dl.delivery.mp.microsoft.com | 80 | Resource bridge (appliance) image download | Used for downloading the Arc Resource Bridge OS images |
| msk8s.api.cdp.microsoft.com | 443 | SFS API endpoint | Used when downloading product catalog, product bits, and OS images from SFS |
| msk8s.sb.tlu.dl.delivery.mp.microsoft.com	 | 443 | Resource bridge (appliance) image download | Used for downloading the Arc Resource Bridge OS images |
| kvamanagementoperator.azurecr.io | 443 | Resource bridge components download | Required to pull artifacts for Appliance managed components |
| linuxgeneva-microsoft.azurecr.io | 443 | Log collection for Arc Resource Bridge | Required to push logs for Appliance managed components |
| hybridaksstorage.z13.web.core.windows.net | 443 | Download AZ Extensions | Required to download the AZ CLI Extension azurestackhci |

## Network proxy requirements for setting up Arc VM management

When setting up Arc VM management, if your network requires the use of a proxy server to connect to the internet, this section describes how to create the configuration files with proxy settings. Running these steps alone will not set up Arc VM management. 

For more information, see [Set up Arc VM management](deploy-arc-resource-bridge-using-command-line.md).

> [!NOTE]
> Using an Azure Arc Resource Bridge behind a proxy is supported. However, using Azure Arc VMs behind a network proxy is not supported.

### Proxy server details

You will need the following information about the proxy server to set up Arc VM management for an Arc Resource Bridge:

|Parameter|Description|
|--|--|
|ProxyServerHTTP|Destination proxy for HTTP traffic. It can be HTTP or HTTPS. Example: `http://proxy.corp.contoso.com:8080` or `https://proxy.corp.contoso.com:8443`|
|ProxyServerHTTPS|Destination proxy for HTTPS traffic. It can be HTTP or HTTPS. Example: `http://proxy.corp.contoso.com:8080` or `https://proxy.corp.contoso.com:8443`|
|ProxyServerNoProxy|URLs and IP addresses that you shouldn't relay through the proxy, including:<br>- Localhost traffic: `localhost,127.0.0.1`<br>- Private network address space: `10.0.0.0/8,172.16.0.0/12,192.168.0.0/16`<br>- URLs in your organizations domain: `corp.contoso.com`|
|ProxyServerUsername|Username for proxy authentication|
|ProxyServerPassword|Password for proxy authentication|
|CertificateFilePath|Certificate filename with full path. Example: `C:\Users\Gus\proxycert.crt`|

### Proxy authentication

The supported authentication methods for the proxy server are:

- Use no authentication.
- Use username and password-based authentication.
- Use certificate-based authentication.

PowerShell is used to create the necessary configuration files to set the authentication method.

#### Use no authentication

In a PowerShell window of the host computer, run the following command as an administrator:

```PowerShell
New-ArcHciConfigFiles -subscriptionID $subscription -location $location -resourceGroup $resource_group -resourceName $resource_name -workDirectory $csv_path\ResourceBridge -controlPlaneIP $controlPlaneIP -vipPoolStart $ControlPlaneIP -vipPoolEnd $ControlPlaneIP -k8snodeippoolstart $VMIP_1 -k8snodeippoolend $VMIP_2 -gateway $Gateway -dnsservers $DNSServers -ipaddressprefix $IPAddressPrefix -vswitchName $vswitchName -vLanID $vlanID -proxyServerHTTP http://proxy.corp.contoso.com:8080 -proxyServerHTTPS https://proxy.corp.contoso.com:8443 -proxyServerNoProxy "localhost,127.0.0.1,.svc,172.16.0.0/12,192.168.0.0/16,corp.contoso.com"
```

#### Use username and password authentication

In a PowerShell window of the host computer, run the following command as an administrator:

```PowerShell
New-ArcHciConfigFiles -subscriptionID $subscription -location $location -resourceGroup $resource_group -resourceName $resource_name -workDirectory $csv_path\ResourceBridge -controlPlaneIP $controlPlaneIP -vipPoolStart $controlPlaneIP -vipPoolEnd $controlPlaneIP -k8snodeippoolstart $VMIP_1 -k8snodeippoolend $VMIP_2 -gateway $Gateway -dnsservers $DNSServers -ipaddressprefix $IPAddressPrefix -vswitchName $vswitchName -vLanID $vlanID -proxyServerHTTP http://<username_for_proxy>:<password_for_proxy>@proxy.corp.contoso.com:8080 -proxyServerHTTPS https://<username_for_proxy>:<password_for_proxy>@proxy.corp.contoso.com:8443 -proxyServerNoProxy "localhost,127.0.0.1,.svc,172.16.0.0/12,192.168.0.0/16,corp.contoso.com" 
```

#### Use certificate-based authentication

In a PowerShell window of the host computer, run the following command as an administrator:

```PowerShell
New-ArcHciConfigFiles -subscriptionID $subscription -location $location -resourceGroup $resource_group -resourceName $resource_name -workDirectory $csv_path\ResourceBridge -controlPlaneIP $controlPlaneIP -vipPoolStart $controlPlaneIP -vipPoolEnd $controlPlaneIP -k8snodeippoolstart $VMIP_1 -k8snodeippoolend $VMIP_2 -gateway $Gateway -dnsservers $DNSServers -ipaddressprefix $IPAddressPrefix -vswitchName $vswitchName -vLanID $vlanID -proxyServerHTTP http://proxy.corp.contoso.com:8080 -proxyServerHTTPS https://proxy.corp.contoso.com:8443 -proxyServerNoProxy "localhost,127.0.0.1,.svc,172.16.0.0/12,192.168.0.0/16,corp.contoso.com" -certificateFilePath <file_path_to_cert_file> 
```

### Continue setting up Arc VM management

After proxy settings have been applied, continue with step 1.b. to [Set up Arc VM management](deploy-arc-resource-bridge-using-command-line.md#set-up-arc-vm-management).

## Next steps

- [Set up Azure Arc VM management using Windows Admin Center](deploy-arc-resource-bridge-using-wac.md).
- [Set up Azure Arc VM management using command line](deploy-arc-resource-bridge-using-command-line.md).
