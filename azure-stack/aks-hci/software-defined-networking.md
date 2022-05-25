---
title: How to use AKS on Azure Stack HCI and Windows Server with software defined networking and virtual networking infrastructure (Public Preview)
description: Learn how to use AKS on Azure Stack HCI and Windows Server with software defined networking and virtual networking infrastructure.
author: mattbriggs
ms.topic: how-to
ms.date: 05/31/2022
ms.author: mabrigg 
ms.lastreviewed: 05/31/2022
ms.reviewer: anpaul

# Intent: As an IT pro, I want to XXX so that XXX.
# Keyword: 

---

# How to use AKS on Azure Stack HCI and Windows Server with software defined networking and virtual networking infrastructure (Public Preview)

This documentation will outline how to deploy AKS on Azure Stack HCI and Windows Server on top of a Software Defined Networking (SDN) virtual networking infrastructure using PowerShell.

> [!IMPORTANT]
> Azure Stack HCI and Windows Server with software defined networking and virtual networking infrastructure is currently in PREVIEW.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## Scope of the public preview

This public preview will walk you through how to configure AKS on Azure Stack HCI and Windows Server  to:

-   Attach AKS on Azure Stack HCI and Windows Server  infrastructure and workload VMs to a SDN virtual network.

-   Use the SDN [Software Load Balancer](https://docs.microsoft.com/en-us/azure-stack/hci/concepts/software-load-balancer) (SLB) for all AKS on Azure Stack HCI and Windows Server  load balancing purposes.

[ ![Review infrastructure overview of AKS on Azure Stack HCI and Windows Server with software defined networking.](media/software-defined-networking/architecture-diagram-for-sdn-on-aks.png) ](media/software-defined-networking/architecture-diagram-for-sdn-on-aks.png#lightbox)

## Limitations

The following features are out of scope and not supported for this release:

-   Attaching pods and containers to a SDN virtual network.

    -   Pods will use Flannel or Calico (default) as the network provider.

-   Network policy enforcement using the SDN Access Control Lists.

    -   The SDN Access Control Lists can still be configured outside of AKS on Azure Stack HCI and Windows Server  using SDN tools (REST/Powershell/Windows Admin Center/SCVMM), but Kubernetes NetworkPolicy objects will not configure them.

-   Attaching AKS on Azure Stack HCI and Windows Server  VM NICs to SDN logical networks

-   Installation using Windows Admin Center.

-   Physical host to AKS on Azure Stack HCI and Windows Server  VM connectivity: VM NICs will be joined to a SDN virtual network and thus will not be accessible from the host by default. You can enable this manually by attaching a public IP directly to the VM using SDN's Software Load Balancer.

## Prequisites

To deploy AKS on Azure Stack HCI and Windows Server  with SDN, we need to make sure our environment satisfies the deployment criteria of both AKS on Azure Stack HCI and Windows Server  and SDN.

AKS on Azure Stack HCI and Windows Server  requirements: [Azure Kubernetes Service on Azure Stack HCI requirements](https://docs.microsoft.com/en-us/azure-stack/AKS-HCI/system-requirements)

SDN requirements: [Plan a Software Defined Network infrastructure](https://docs.microsoft.com/en-us/azure-stack/hci/concepts/plan-software-defined-networking-infrastructure)

> [!NOTE]  
> For SDN integration with AKS on Azure Stack HCI and Windows Server , we only require a Network Controller and Software Load Balancer. Gateway VMs are not required and optional.

## Install and preparing software defined networking

### Installing software defined networking

The first step is to install SDN. To install SDN, we recommend [SDN Express](https://docs.microsoft.com/en-us/azure-stack/hci/manage/sdn-express) or [Windows Admin Center](https://docs.microsoft.com/en-us/azure-stack/hci/deploy/sdn-wizard).

A reference configuration file that deploys all the needed SDN infrastructure components can be found here: [Software Load Balancer.psd1](https://github.com/microsoft/SDN/blob/master/SDNExpress/scripts/Sample%20-%20Software%20Load%20Balancer.psd1)

Once the SDN Express deployment has completed, there should be a screen with the status reporting as healthy:

![Your deployment will indicate that the status is active and healthy](media/software-defined-networking/status-active-and-healthy.png)

If anything went wrong or is being reported as unhealthy,  see [Troubleshooting SDN \| Microsoft Docs](https://docs.microsoft.com/en-us/windows-server/networking/sdn/troubleshoot/troubleshoot-software-defined-networking). Feel free to reach out to [AKS on Azure Stack HCI and Windows Server -sdn@microsoft.com](mailto:AKS on Azure Stack HCI and Windows Server -sdn@microsoft.com) for assistance.

It is important that SDN is healthy before proceeding. If you are deploying SDN in a new environment, we also recommend creating test VMs and verifying connectivity to the load balancer VIPs. See [how to create and attach VM's to an SDN virtual network](https://docs.microsoft.com/en-us/azure-stack/hci/manage/vm) using Windows Admin Center.

## Install AKS on Azure Stack HCI and Windows Server 

We will proceed to initialize and prepare all the physical host machines for AKS on Azure Stack HCI and Windows Server .  refer [here](https://docs.microsoft.com/en-us/azure-stack/AKS-HCI/kubernetes-walkthrough-powershell) for most up-to-date instructions.

### Install the AKS on Azure Stack HCI and Windows Server  Powershell module

Refer to instructions [here](https://docs.microsoft.com/en-us/azure-stack/AKS-HCI/kubernetes-walkthrough-powershell#install-the-akshci-powershell-module) to install the AKS on Azure Stack HCI and Windows Server  Powershell module.

> [!NOTE]  
> You might have to change the Powershell ExecutionPolicy to Unrestricted so that you can import and execute some of these scripts. You can do so by running "Set-ExecutionPolicy Unrestricted"

After you complete the previous step, follow instructions [here](https://docs.microsoft.com/en-us/azure-stack/AKS-HCI/kubernetes-walkthrough-powershell#on-all-nodes-in-your-azure-stack-hci-cluster) to install PowershellGet and AksHci modules.

Next, from the extracted "sdn_public_preview.zip" file, copy the updated PowerShell modules. On every physical host:

1.  Replace the contents of the "AksHci.psm1" and "Moc.psm1" PowerShell modules in the "Akshci" and "Moc" directories respectively. These can be found in your PowerShell module path (%ProgramFiles%\\WindowsPowerShell\\Modules).

2.  Similarly, replace or add the "Common.psm1" PowerShell modules used in the "Akshci", "DownloadSdk", "Kva", and "Moc" directories.

> [!NOTE]  
> After completing this step, refresh or reload any opened PowerShell sessions so the modules are reloaded.

### Register the resource provider to your subscription

Follow instructions [here](https://docs.microsoft.com/en-us/azure-stack/AKS-HCI/kubernetes-walkthrough-powershell#register-the-resource-provider-to-your-subscription) to register the resource provider to your subscription.

### Prepare your machines for deployment

Follow instructions [here](https://docs.microsoft.com/en-us/azure-stack/AKS-HCI/kubernetes-walkthrough-powershell#step-1-prepare-your-machines-for-deployment) to prepare your machines for deployment.

### Configure AKS on Azure Stack HCI and Windows Server for installation

Choose one of your HCI machine to drive the creation of AKS on Azure Stack HCI and Windows Server . There are 2 steps that need to be done prior to installation.

1.  Configure the AKS on Azure Stack HCI and Windows Server  network settings for SDN. For example, using:

    1.  SDN Virtual network "10.20.0.0/24" (10.20.0.0 - 10.20.0.255)

        This is a completely virtualized network and you can use any IP subnet. This subnet does not need to exist on your physical network.

    2.  "PublicVIP" Logical network "10.127.132.16/29" (10.127.132.16 - 10.127.132.23)

        This is the "PublicVIP" logical network that you provided when configuring SDN Software Load Balancer.

    3.  Gateway "10.20.0.1"

        This is the gateway for your virtual network.

    4.  DNS Server "10.127.130.7"

        This is the DNS server for your virtual network.

        ```powershell
        \$vnet = New-AksHciNetworkSetting -name "myvnet" -vswitchName "External"
        
        -k8sNodeIpPoolStart "10.20.0.2" -k8sNodeIpPoolEnd "10.20.0.255"
        
        -vipPoolStart "10.127.132.16" -vipPoolEnd "10.127.132.23" -useNetworkController
        
        -ipAddressPrefix "10.20.0.0/24" -gateway "10.20.0.1" -dnsServers "10.127.130.7"
        ```

| Parameter                             | Description                                                                                                                                       |
|---------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| -name                                 | Name of virtual network in AKS on Azure Stack HCI and Windows Server                                                                                                                 |
| -vswitchName                          | Name of external vSwitch on the HCI servers                                                                                                       |
| -k8sNodeIpPoolStart -k8sNodeIpPoolEnd | IP start/end range of SDN virtual network                                                                                                         |
| -vipPoolStart -vipPoolEnd             | IP start/end range of logical network used for load balancer VIP pool. Above, we have used an address range from the "PublicVIP" logical network. |
| -useNetworkController                 | Enable integration with SDN                                                                                                                       |
| -ipAddressPrefix                      | Virtual network subnet in CIDR notation                                                                                                           |
| -gateway -dnsServers                  | Gateway and DNS server                                                                                                                            |

> [!NOTE]  
> For more details about these parameters, see: [New-AksHciNetworkSetting](https://docs.microsoft.com/en-us/azure-stack/AKS-HCI/reference/ps/new-akshcinetworksetting)

1.  In the same PowerShell window used in the last step, create the AKS on Azure Stack HCI and Windows Server  configuration for SDN by providing references to the targeted SDN networks, as well as passing in the network settings (\$vnet) we defined:

```powershell
Set-AksHciConfig -imageDir "C:\\images" -workingDir "C:\\store"

-cloudConfigLocation "C:\\config" -vnet \$vnet -useNetworkController

-networkControllerFqdnOrIpAddress "nc.contoso.com"

-networkControllerLbSubnetRef "/logicalnetworks/PublicVIP/subnets/my\_vip\_subnet"

-networkControllerLnetRef "/logicalnetworks/HNVPA"

-ring "SDNPreview" -catalog AKS on Azure Stack HCI and Windows Server -stable-catalogs-ext -version 1.0.10.40517
```

> [!NOTE]  
> The HNVPA logical network will be used as the underlay provider for the AKS on Azure Stack HCI and Windows Server  virtual network.

> [!NOTE]  
> If you are using static IP address assignment for your Azure Stack HCI cluster nodes, you must also provide the CloudServiceCidr parameter. This is the IP Address of the MOC cloud service and must be in the same subnet as Azure Stack HCI cluster nodes. More details [here](https://docs.microsoft.com/en-us/azure-stack/AKS-HCI/concepts-node-networking#microsoft-on-premises-cloud-service).

| Parameter                         | Description                                                                                                                                                                                                                                                                                                                                                           |
|-----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| -imageDir                         | The path to the directory where VHD images are stored.                                                                                                                                                                                                                                                                                                                |
| -workingDir                       | The path to the directory where AKS on Azure Stack HCI and Windows Server  stores temporary files                                                                                                                                                                                                                                                                                                        |
| -cloudConfigLocation              | The path to the directory where cloud agent configuration is stored                                                                                                                                                                                                                                                                                                   |
| -vnet                             | Name of AksHciNetworkSetting variable created in the previous step                                                                                                                                                                                                                                                                                                    |
| -useNetworkController             | Enable integration with SDN                                                                                                                                                                                                                                                                                                                                           |
| -networkControllerFqdnOrIpAddres  | Network controller FQDN. You can get the FQDN by executing Get-NetworkController on the Network Controller VM and using the RestName parameter.                                                                                                                                                                                                                       |
| -networkControllerLbSubnetRef     | Reference to the public VIP logical network subnet configured in Network Controller. You can get this subnet by executing Get-NetworkControllerLogicalSubnet command. When using this command, use PublicVIP as the LogicalNetworkId. VipPoolStart and vipPoolEnd parameters in the New-AksHciNetworkSetting cmdlet must be part of the subnet referenced here. |
| -networkControllerLnetRef         | Normally, this would be "/logicalnetworks/HNVPA"                                                                                                                                                                                                                                                                                                                      |
| -version                          | Use 1.0.10.40517                                                                                                                                                                                                                                                                                                                                                      |
| -ring                             | Use SDNPreview                                                                                                                                                                                                                                                                                                                                                        |
| -catalog                          | Use AKS on Azure Stack HCI and Windows Server -stable-catalogs-ext                                                                                                                                                                                                                                                                                                                                       |

> [!NOTE]  
> For more details about these parameters, see: [Set-AksHciConfig](https://docs.microsoft.com/en-us/azure-stack/AKS-HCI/reference/ps/set-akshciconfig)

![Check the successful configuration of AKS on Azure Stack HCI and Windows Server.](media/software-defined-networking/configuration-saved.png)


### Login to Azure and configure registration settings

Follow instructions [here](https://docs.microsoft.com/en-us/azure-stack/AKS-HCI/kubernetes-walkthrough-powershell#step-4-log-in-to-azure-and-configure-registration-settings) to configure registration settings.

### Install AKS on Azure Stack HCI and Windows Server

Once the AKS configuration has completed, you are ready to install AKS on Azure Stack HCI and Windows Server :

```powershell
Install-AksHci
```

Once the installation has succeeded, a control plane VM (management cluster) should have been created and its VmNIC attached to your SDN network.

![After it runs, check successful AKS on Azure Stack HCI and Windows Server  installation.](media/software-defined-networking/output-state-online.png)

### Feedback and issues

If you encounter any issues with the instructions in this guide, or would simply like to provide feedback,  reach out to us at [AKS on Azure Stack HCI and Windows Server -sdn@microsoft.com](mailto:AKS on Azure Stack HCI and Windows Server -sdn@microsoft.com). There are also some self-help resources that can be found [here](https://docs.microsoft.com/en-us/windows-server/networking/sdn/troubleshoot/troubleshoot-software-defined-networking) for SDN and [here](https://docs.microsoft.com/en-us/azure-stack/AKS-HCI/known-issues) for AKS on Azure Stack HCI and Windows Server . We sincerely appreciate and thank you for your feedback and participation!

## Next steps

Next, you can create [workload clusters](https://docs.microsoft.com/en-us/azure-stack/AKS-HCI/kubernetes-walkthrough-powershell#step-6-create-a-kubernetes-cluster) and [deploy your applications](https://docs.microsoft.com/en-us/azure-stack/AKS-HCI/deploy-windows-application). All AKS on Azure Stack HCI and Windows Server  VM NICs will seamlessly get attached to the SDN virtual network that was provided during installation. The SDN Software Load Balancer will also be used as the external load balancer for all Kubernetes services, as well as act as the load balancer for the API server on Kubernetes control-plane(s).
