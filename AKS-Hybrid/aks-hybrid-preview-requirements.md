---
title: System requirements before managing AKS hybrid clusters provisioned from Azure 
description: System requirements before managing AKS hybrid clusters provisioned from Azure 
author: abha
ms.author: abha
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 06/22/2023
---


# System requirements for AKS hybrid cluster provisioning from Azure (preview)

> Applies to: Windows Server 2019, Windows Server 2022, Azure Stack HCI

This article describes the prerequisites for deploying Azure Arc Resource Bridge and AKS hybrid clusters. For an overview of AKS hybrid cluster provisioning from Azure, see [Overview of AKS hybrid cluster provisioning from Azure](aks-hybrid-preview-overview.md)

## Minimum resource requirements

Azure Arc Resource Bridge has the following resource requirements:

- A cluster shared volume with at least 50 GB of space.
- At least 4 vCPUs per physical node.
- At least 8 GB of memory per physical node.

## Azure requirements

Make sure that you have your Azure environment set up. Follow this table to ensure you've covered everything you need for a successful installation.

Windows Server or Azure Stack HCI infrastructure admin:

| Prerequisite |  Item  |  Details  |  Value  |
| -- | ----- | ----- | ------- |
| 1 | Do you have an Azure subscription?  | The Azure Arc Resource Bridge, custom location, and all AKS hybrid clusters will be deployed in this Azure subscription. |  Make sure you have your Azure subscription ID. |
| 2 | Do you have a recent version of Az CLI installed on all nodes in your physical cluster? | Required to run the Az commands. [Install Az CLI](/cli/azure/install-azure-cli-windows?tabs=azure-cli) on all physical nodes in your Windows Server cluster. You can upgrade to the latest version by running `az upgrade`. | Verify that you have Az CLI by running `az -v`. |
| 3 | Have you registered all the right providers on your subscription? Make sure you log in to Azure first. You only need to do this operation once per Azure subscription.  | Run the following command to register the feature: <br> `az account set -s <subscriptionID from step #1>` <br>`az feature register --namespace Microsoft.HybridConnectivity --name hiddenPreviewAccess`. <br> You can check if it's registered using the following command: <br> `az feature show --namespace Microsoft.HybridConnectivity --name hiddenPreviewAccess --query "properties" -o tsv`. <br> Wait until the feature is registered before proceeding with provider registration: <br> `az account set -s <subscriptionID from step #1>` <br> `az provider register --namespace Microsoft.Kubernetes --wait` <br> `az provider register --namespace Microsoft.ExtendedLocation --wait` <br> `az provider register --namespace Microsoft.ResourceConnector --wait` <br> `az provider register --namespace Microsoft.HybridContainerService --wait`  <br> `az provider register --namespace Microsoft.HybridConnectivity --wait ` | If the status shows *registering*, try again after some time. <br> `az provider show --namespace Microsoft.Kubernetes -o table` <br> `az provider show --namespace Microsoft.ExtendedLocation -o table` <br> `az provider show --namespace Microsoft.ResourceConnector -o table` <br> `az provider show --namespace Microsoft.HybridContainerService -o table` <br> `az provider show --namespace Microsoft.HybridConnectivity -o table` | 
| 4 | Did you install the Az CLI extensions on all nodes in your physical cluster? | `az extension add -n k8s-extension` <br> `az extension add -n customlocation` <br> `az extension add -n arcappliance` <br> `az extension add -n hybridaks` | You can check if you have the extensions installed and their versions by running the following command: `az -v` <br> Expected output: <br> `azure-cli >= 2.51.0` <br> `core >= 2.51.0` <br> `telemetry >= 1.0.8` <br> Extensions: <br> `k8s-extension >= 1.3.5`  <br> `customlocation >= 0.1.3` <br>`arcappliance = 0.2.33`<br> `hybridaks = 0.2.2`  |

## PowerShell module prerequisites

Next, make sure you download the correct versions of PowerShell modules directly on each node in your Windows Server cluster. Open a remote PowerShell session in admin mode on each node in your cluster to download the following PowerShell modules.

Install the following ArcHCI PowerShell module on your Azure Stack HCI or Windows Server cluster:

```powershell
Install-Module -Name ArcHci -Force -Confirm:$false -SkipPublisherCheck -AcceptLicense -RequiredVersion 0.2.29
```

## Networking prerequisites

Work with the network administrator of your datacenter to set up the correct networking parameters. You have two options to choose from: static IP and DHCP. For optimum reliability, we strongly recommend using static IP for your Azure Arc Resource Bridge.

Windows Server admin in consultation with the datacenter network admin:

### Option 1: Static IP networking (Highly recommended)

You can skip this section if you have Arc VMs installed on your Azure Stack HCI cluster.

| Prerequisite |  Item  |  Details  |  Value  |
| -- | ----- | ------- | ------- |
| 1 | Do you have a static IP subnet? | This subnet will be used for assigning an IP address to the underlying VM of the Azure Arc Resource Bridge. | The IP address prefix of your subnet; for example, **172.16.0.0/16**. |
| 2 | Do you have at least 4 IP addresses in your environment? | Ensure that you have at least 4 available IP addresses in this subnet. <br> | Ensure and list the range of available IP addresses in your subnet; for example, **172.16.0.3** to **172.16.0.10**. |
| 3 | Do you have a gateway? | The IP address of the default gateway of the subnet you provided.  | The IP address of your gateway; for example, **172.16.0.1**. |
| 4 | Do you have one or more DNS servers? | Along with the gateway, this is required for creating a network with a static IP. A minimum of one and a maximum of three DNS servers can be provided.  | The IP address(es) of your DNS servers; for example, **172.16.0.2**. |
| 5 | Do you have an external virtual switch? | You need an external virtual switch for the Azure Arc Resource Bridge. | The name of your virtual switch. |
| 6 | Do you have a VLAN ID? | This is an optional parameter. Check with your network administrator if the subnet you provided above is tagged. | The VLAN ID; for example, **7**. |

### Option 2: DHCP networking

You can skip this section if you have Arc VMs installed on your Azure Stack HCI cluster.

| Prerequisite |  Item  |  Details  |  Value  |
| -- | ----- | ------- | ------- |
| 1 | Do you have a DHCP server with at least 3 IP addresses in your environment? | This DHCP server will be used to assign an IP address to the underlying VM of the Azure Arc Resource Bridge. | Check with your admin if your Windows Server network environment has a DHCP server. |
| 2 | Do you have at least 2 IP addresses in the same subnet as the DHCP server but excluded from the DHCP scope? | You need 2 IP addresses in the same subnet as the DHCP server but excluded from the DHCP scope. <br> Apart from 3 required IP addresses in the DHCP server, we also need to statically assign IP addresses to some important agents, so they are long-lived. | List of at least 2 IP addresses in the same subnet as the DHCP server but excluded from the DHCP scope. |
| 3 | Do you have an external virtual switch? | You need an external virtual switch for the underlying VM of the Azure Arc Resource Bridge. | The name of your virtual switch. |
| 4 | Do you have a VLAN ID? | This is an optional parameter. Check with your network administrator if the subnet you provided above is tagged. | The VLAN ID; for example, **7**. |

### Proxy settings

You can skip this section if you have Arc VMs installed on your Azure Stack HCI cluster.

| Prerequisite |  Item  |  Details |
| -- | ----- | ------- |
| 1 | HTTP URL and port information |  Check with your network admin if your Windows Server or Azure Stack HCI network environment is behind a proxy server. If so, obtain the HTTP URL and port information from your network admin. It should be of the following format: `http://proxy.corp.contoso.com:8080`.  |
| 2 | HTTPS URL and port information | Check with your network admin if your Windows Server or Azure Stack HCI network environment is behind a proxy server. If so, obtain the HTTPS URL and port information from your network admin. It should be of the following format: `https://proxy.corp.contoso.com:8443`. You can reuse the HTTP URL and port information here if you do not have HTTPS URL and port information. |
| 3 | (Optional) Valid credentials for authentication to the proxy server | You can use either a PowerShell credential object containing the username and password to authenticate against the proxy server, or a filename or certificate string of a PFX-formatted client certificate used to authenticate with the proxy server. |

#### Noproxy settings

You can skip this section if you have Arc VMs installed on your Azure Stack HCI cluster.

The following table contains the list of addresses that must be excluded:

|      IP address       |    Reason for exclusion    |  
| ----------------------- | ------------------------------------ | 
| localhost, 127.0.0.1  | Localhost traffic  |
| .svc | Internal Kubernetes service traffic (.svc) where _.svc_ represents a wildcard name. This is similar to saying \*.svc, but none is used in this schema. |
| 10.0.0.0/8 | Private network address space. |
| 172.16.0.0/12 |Private network address space: Kubernetes Service CIDR. |
| 192.168.0.0/16 | Private network address space: Kubernetes Pod CIDR. |
| Your enterprise namespace | You may want to exempt your enterprise namespace (for example, .contoso.com) from being directed through the proxy. To exclude all addresses in a domain, you must add the domain to the `noProxy` list. Use a leading period rather than a wildcard (\*) character. In the sample, the addresses `.contoso.com` excludes addresses `prefix1.contoso.com`, `prefix2.contoso.com`, and so on. |

The default value for `noProxy` is `localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16`. While these default values work for many networks, you might need to add more subnet ranges and/or names to the exemption list. For example, you may want to exempt your enterprise namespace (for example, .contoso.com) from being directed through the proxy. You can achieve that by specifying the values in the `noProxy` list.

### Network port requirements

If the Windows Server physical cluster nodes and the Azure Arc Resource Bridge VM are on two isolated vlans, these ports need to be opened at the firewall between them.

| Port   | Source                               | Description                                        | Firewall Notes                                                                               |
|-------|--------------------------------------|----------------------------------------------------|----------------------------------------------------------------------------------------------|
| 22    | Azure Arc Resource Bridge VM                             | Required to collect logs when using `Get-ArcHciLogs`. | If you are using separate VLANs, the physical Hyper-V Hosts need to access the Azure Arc Resource Bridge VM on this port. |
| 6443  | Azure Arc Resource Bridge VM                             | Required to communicate with Kubernetes APIs.       | If you are using separate VLANs, the physical Hyper-V Hosts need to access the Azure Arc Resource Bridge VM on this port. |
| 45000 | Physical Hyper-V Hosts               | wssdAgent gRPC Server                              | No cross-VLAN rules are needed.                                                              |
| 45001 | Physical Hyper-V Hosts               | wssdAgent gRPC Authentication                      | No cross-VLAN rules are needed.                                                              |
| 46000 | Azure Arc Resource Bridge VM                         | wssdCloudAgent to lbagent                          | If you are using separate VLANs, the physical Hyper-V Hosts need to access the Azure Arc Resource Bridge VM on this port. |
| 55000 | Cluster Resource (-CloudServiceCIDR) | Cloud Agent gRPC Server                            | If you are using separate VLANs, the Azure Arc Resource Bridge VM needs to access the Cluster Resource IP on this port.  |
| 65000 | Cluster Resource (-CloudServiceCIDR) | Cloud Agent gRPC Authentication                    | If you are using separate VLANs, the Azure Arc Resource Bridge VM needs to access the Cluster Resource IP on this port.  |

### Firewall URL exceptions

For information about the Azure Arc firewall/proxy URL allowlist, see the [Azure Arc resource bridge network requirements](/azure/azure-arc/resource-bridge/network-requirements#firewallproxy-url-allowlist).

The following firewall URL exceptions are needed on all servers in the Windows Server cluster:

| URL | Port | Service | Notes |
|:--------|:---------|:------------|:----------|
| https\://mcr.microsoft.com | 443 | Microsoft container registry | Used for official Microsoft artifacts such as container images. |
| https\://*.his.arc.azure.com | 443 | Azure Arc identity service | Used for identity and access control. |
| https\://*.dp.kubernetesconfiguration.azure.com | 443 | Kubernetes | Used for Azure Arc configuration. |
| https\://*.servicebus.windows.net | 443 | Cluster connect | Used to securely connect to Azure Arc-enabled Kubernetes clusters without requiring any inbound port to be enabled on the firewall. |
| https\://guestnotificationservice.azure.com | 443 | Notification service | Used for guest notification operations. |
| https\://*.dp.prod.appliances.azure.com | 443 | Data plane service | Used for data plane operations for Resource bridge (appliance). |
| https\://ecpacr.azurecr.io | 443 | Download agent | Used to download Resource bridge (appliance) container images. |
| `*.blob.core.windows.net` <br> `*.dl.delivery.mp.microsoft.com <br>` `*.do.dsp.mp.microsoft.com` | 443 | TCP | Used to download Resource bridge (appliance) images. |
| https\://azurearcfork8sdev.azurecr.io | 443 | Kubernetes | Used to download Azure Arc for Kubernetes container images.
| https\://adhs.events.data.microsoft.com | 443 | Telemetry | ADHS is a telemetry service running inside the appliance/mariner OS. Used periodically to send required diagnostic data to Microsoft from control plane nodes. Used when telemetry is coming off mariner, which means any Kubernetes control plane. |
| https\://v20.events.data.microsoft.com  | 443 | Telemetry | Used periodically to send required diagnostic data to Microsoft from the Windows Server host. |
| gcr.io  | 443 | Google container registry | Used for Kubernetes official artifacts such as container base images. |
| pypi.org  | 443 | Python package | Validate Kubernetes and Python versions. |
| *.pypi.org  | 443 | Python package | Validate Kubernetes and Python versions. |
| https\://hybridaks.azurecr.io | 443 | Container image | Required for accessing the HybridAKS operator image. |
| aka.ms | 443 | az extensions | Required to download Az CLI extensions such as `hybridaks`.

## Next steps

- [Deploy Azure Arc Resource Bridge on Windows Server using command line](deploy-arc-resource-bridge-windows-server.md)
- [Deploy AKS hybrid extension if you have Arc VMs set up](deploy-aks-service-hci.md)
