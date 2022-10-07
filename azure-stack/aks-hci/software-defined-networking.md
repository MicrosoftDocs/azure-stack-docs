---
title: How to use AKS on Azure Stack HCI and Windows Server with SDN and virtual networking infrastructure (Public Preview)
description: Learn how to use AKS on Azure Stack HCI and Windows Server with software defined networking and virtual networking infrastructure.
author: sethmanheim
ms.topic: how-to
ms.date: 10/07/2022
ms.author: sethm 
ms.lastreviewed: 10/07/2022
ms.reviewer: anpaul

# Intent: As an IT pro, I want to learn how to use PowerShell to deploy AKS on Azure Stack HCI on top of a software defined cluster.
# Keyword: PowerShell networking software networking virtual networking

---

# QuickStart: Deploy Microsoft Software Defined Networking (SDN) with Azure Kubernetes Service on HCI (AKS-HCI)

In this quickstart, you'll learn how to deploy AKS infrastructure and workload VMs to an SDN Virtual Network leveraging our SDN [Software Load
Balancer][] (SLB) for all AKS-HCI load balancing scenarios.

:::image type="content" source="media/software-defined-networking/architecture-diagram-for-sdn-on-aks.png" alt-text="Image showing architecture of SDNon AKS":::

## Limitations

The following features are out of scope and not supported for this GA release:

- Attaching pods and containers to a SDN virtual network.
  - Pods will use Flannel or Calico (default) as the network provider.
- Network policy enforcement using the SDN Network Security Groups.
  - The SDN Network Security Groups can still be configured outside of AKS-HCI using SDN tools (REST/Powershell/Windows Admin Center/SCVMM), but Kubernetes NetworkPolicy objects will not configure them.
- Attaching AKS-HCI VM NICs to SDN logical networks.
- Installation using Windows Admin Center.
- Physical host to AKS-HCI VM connectivity: VM NICs will be joined to a SDN virtual network and thus will not be accessible from the host by default. For now, you can enable this manually by attaching a public IP directly to the VM using the SDN Software Load Balancer.

## Prerequisites

To deploy AKS-HCI with SDN, make sure your environment satisfies the deployment criteria of both AKS-HCI and SDN.

- AKS-HCI requirements: [Azure Kubernetes Service on Azure Stack HCI requirements][]
- SDN requirements: [Plan a Software Defined Network infrastructure][]

> [!NOTE]
> SDN integration with AKS-HCI only requires Network Controller and Software Load Balancer. Gateway VMs are optional.

## Install and prepare SDN for AKS-HCI

The first step is to install SDN. To install SDN, we recommend [SDN Express][] or [Windows Admin Center][].

A reference configuration file that deploys all the needed SDN infrastructure components can be found here: [Software Load Balancer.psd1][].

Once the SDN Express deployment has completed, there should be a screen that reports the status as healthy.

If anything went wrong or is being reported as unhealthy, see [Troubleshooting SDN][]. Feel free to reach out to aks-hci-sdn@microsoft.com for assistance.

It is important that SDN is healthy before proceeding. If you are deploying SDN in a new environment, we also recommend creating test VMs and verifying connectivity to the load balancer VIPs. See [how to create and attach VM's to an SDN virtual network][] using Windows Admin Center.

## Steps to install AKS-HCI

Initialize and prepare all the physical host machines for AKS-HCI. See [this article][] for the most up-to-date instructions.

### Install the AKS-HCI Powershell module

[See this article](kubernetes-walkthrough-powershell.md#install-the-akshci-powershell-module) for information about installing the AKS-HCI Powershell module.

> [!NOTE]
> After completing this step, refresh or reload any opened PowerShell sessions to reload the modules.

### Register the resource provider to your subscription

[See this article](kubernetes-walkthrough-powershell.md#register-the-resource-provider-to-your-subscription) for information about how to register the resource provider to your subscription.

### Prepare your machines for deployment

[See this article](kubernetes-walkthrough-powershell.md#step-1-prepare-your-machines-for-deployment) for information about how to prepare your machines for deployment.

### Configure AKS-HCI for installation

Choose one of your Azure Stack HCI Servers to drive the creation of AKS-HCI. There are 3 steps that need to be done prior to installation:

1. Configure the AKS-HCI network settings for SDN; for example, using:
   1. SDN Virtual network "10.20.0.0/24" (10.20.0.0 – 10.20.0.255). This is a completely virtualized network, and you can use any IP subnet. This subnet does not need to exist on your physical network.
   2. vSwitch name "External". This is the external vSwitch on the HCI servers. Ensure that you use the same vSwitch that was used for SDN deployment.
   3. Gateway "10.20.0.1". This is the gateway for your virtual network.
   4. DNS Server "10.127.130.7". This is the DNS server for your virtual network.

   ```powershell
   $vnet = New-AksHciNetworkSetting –name "myvnet" –vswitchName "External" -k8sNodeIpPoolStart "10.20.0.2" -k8sNodeIpPoolEnd "10.20.0.255"
   -ipAddressPrefix "10.20.0.0/24" -gateway "10.20.0.1" -dnsServers "10.127.130.7"
   ```

   | Parameter                               | Description                                                                                    |
   |-----------------------------------------|------------------------------------------------------------------------------------------------|
   | **-name**                                   | Name of virtual network in AKS-HCI (must be lowercase).                                        |
   | **–vswitchName**                            | Name of external vSwitch on the HCI servers. Use same vSwitch that was used for SDN deployment. |
   | **-k8sNodeIpPoolStart** <br /> **-k8sNodeIpPoolEnd** | IP start/end range of SDN virtual network.                                                      |
   | **-ipAddressPrefix**                        | Virtual network subnet in CIDR notation.                                                        |
   | **-gateway** <br /> **-dnsServers**                  | Gateway and DNS server of the SDN virtual network.                                              |

   For more details about these parameters, see [New-AksHciNetworkSetting][].

2. In the same PowerShell window used in Step 1, create an AKS-HCI VIP pool to inform AKS of our IPs that can be used from our SDN Load Balancing Logical Network:

   ```powershell
   $VipPool = New-AksHciVipPoolSetting -name "PublicVIP" -vipPoolStart "10.127.132.16" -vipPoolEnd "10.127.132.23
   ```

| Parameter     | Description                                                                                                                                      |
|---------------|--------------------------------------------------------------------------------------------------------------------------------------------------|
| **-name**         | The "PublicVIP" logical network that you provided when configuring SDN Load Balancers.                                                    |
| **–vipPoolStart** | IP start range of logical network used for public load balancer VIP pool. You must use an address range from the "PublicVIP" SDN logical network. |
| **-vipPoolEnd**   | IP end range of logical network used for public load balancer VIP pool. You must use an address range from the "PublicVIP" SDN logical network.   |

3. In the same PowerShell window used in Step 2, create the AKS-HCI configuration for SDN by providing references to the targeted SDN networks, as well as passing in the network settings ($vnet, $vipPool) we have defined:

   ```powershell
   Set-AksHciConfig 
   –imageDir "C:\ClusterStorage\Volume1\ImageStore" 
   –workingDir "C:\ClusterStorage\Volume1\ImageStore"
   –cloudConfigLocation "C:\ClusterStorage\Volume1\ImageStore" 
   –vnet $vnet –useNetworkController
   –NetworkControllerFqdnOrIpAddress "nc.contoso.com" 
   –networkControllerLbSubnetRef "/logicalnetworks/PublicVIP/subnets/my_vip_subnet" 
   –networkControllerLnetRef "/logicalnetworks/HNVPA" 
   -vipPool $vipPool
   ```

The HNVPA logical network will be used as the underlying provider for the AKS-HCI virtual network.

If you are using static IP address assignment for your Azure Stack HCI cluster nodes, you must also provide the CloudServiceCidr parameter. This is the IP address of the MOC cloud service, and must be in the same subnet as Azure Stack HCI cluster nodes. For more information [see this article](concepts-node-networking.md#microsoft-on-premises-cloud-service).

   | Parameter                         | Description                                                                                                                                                                                                                                                                                                                                                             |
   |-----------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
   | **–imageDir**                         | The path to where AKS HCI stores its VHD images. This must be a shared storage path, or an SMB share.                                                                                                                                                                                                                                                                      |
   | **–workingDir**                       | The path to where small files for the module are stored. This must be a shared storage path, or an SMB share.                                                                                                                                                                                                                                                              |
   | **–cloudConfigLocation**              | The path to the directory where cloud agent configuration is stored. This must be a shared storage path, or an SMB share.                                                                                                                                                                                                                                               |
   | **–vnet**                             | Name of `AksHciNetworkSetting` variable created in the previous step                                                                                                                                                                                                                                                                                                      |
   | **–useNetworkController**             | Enable integration with SDN.                                                                                                                                                                                                                                                                                                                                             |
   | **–networkControllerFqdnOrIpAddress** | Network controller FQDN. You can get the FQDN by executing `Get-NetworkController` on the Network Controller VM and using the `RestName` parameter.                                                                                                                                                                                                                         |
   | **–networkControllerLbSubnetRef**     | Reference to the public VIP logical network subnet configured in Network Controller. You can get this subnet by executing the `Get-NetworkControllerLogicalSubnet` cmdlet. When using this cmdlet, use `PublicVIP` as the `LogicalNetworkId`. Note that the `VipPoolStart` and `vipPoolEnd` parameters in the `New-AksHciVipPoolSetting` cmdlet must be part of the subnet referenced here. |
   | **–networkControllerLnetRef**         | Normally, this would be "/logicalnetworks/HNVPA".                                                                                                                                                                                                                                                                                                                        |
   | **-vipPool**                          | VIP pool used as the front end IPs for load balancing.                                                                                                                                                                                                                                                                                                                   |

   For more details about these parameters, see [Set-AksHciConfig][].

### Sign in to Azure and configure registration settings

Follow [the instructions here](kubernetes-walkthrough-powershell.md#step-4-log-in-to-azure-and-configure-registration-settings) to configure registration settings.

> [!NOTE]
> If you don't have owner permissions, it's recommended that you use an [Azure service principal][].

### Install AKS-HCI

Once the AKS configuration has completed, you are ready to install AKS-HCI.

```powershell
Install-AksHci
```

Once the installation has succeeded, a control plane VM (management cluster) should have been created and its VmNIC attached to your SDN network.

### Collect logs from an SDN and AKSHCI environment

With SDN and AKSHCI, we gain isolation of the AKS nodes on Virtual Networks. Since they are isolated, we must import a new SDN AKSHCI log collection script and run a modified command that uses the load balancer to retrieve logs from the nodes.

```powershell
Install-Module -Name AksHciSdnLogCollector -Repository PSGallery
Get-AksHciLogsSdn
```

### Feedback/issues

If you encounter any issues with the instructions or would simply like to provide feedback, please reach out to us at
<aks-hci-sdn@microsoft.com>. There are also some self-help resources that [can be found here][Troubleshooting SDN \| Microsoft Docs] for SDN
[and here](known-issues.yml) for AKS-HCI.

## Next steps

Next, you can create [workload clusters][] and [deploy your applications][]. All AKS-HCI VM NICs will seamlessly get attached to the
SDN virtual network that was provided during installation. The SDN Software load balancer will also be used as the external load balancer
for all Kubernetes services, as well as act as the load balancer for the API server on Kubernetes control-plane(s).

[Software Load Balancer]: ../hci/concepts/software-load-balancer.md
[Azure Kubernetes Service on Azure Stack HCI requirements]: system-requirements.md
[Plan a Software Defined Network infrastructure]: ../hci/concepts/plan-software-defined-networking-infrastructure.md
[SDN Express]: ../hci/manage/sdn-express.md
[Windows Admin Center]: ../hci/deploy/sdn-wizard.md
[Software Load Balancer.psd1]: https://github.com/microsoft/SDN/blob/master/SDNExpress/scripts/Sample%20-%20Software%20Load%20Balancer.psd1
[Troubleshooting SDN \| Microsoft Docs]: /windows-server/networking/sdn/troubleshoot/troubleshoot-software-defined-networking
[how to create and attach VM's to an SDN virtual network]: ../hci/manage/vm.md
[New-AksHciNetworkSetting]: reference/ps/new-akshcinetworksetting.md
[Set-AksHciConfig]: reference/ps/set-akshciconfig.md
[Azure service principal]: reference/ps/set-akshciregistration.md#register-aks-on-azure-stack-hci-and-windows-server-using-a-service-principal
[workload clusters]: kubernetes-walkthrough-powershell.md#step-6-create-a-kubernetes-cluster
[deploy your applications]: deploy-windows-application.md
