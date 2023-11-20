---
title: How to use AKS hybrid with SDN and virtual networking infrastructure
description: Learn how to use AKS hybrid with software defined networking and virtual networking infrastructure.
author: sethmanheim
ms.topic: how-to
ms.date: 11/20/2023
ms.author: sethm 
ms.lastreviewed: 10/07/2022
ms.reviewer: anpaul

# Intent: As an IT pro, I want to learn how to use PowerShell to deploy AKS on Azure Stack HCI on top of a software defined cluster.
# Keyword: PowerShell networking software networking virtual networking

---

# Deploy Microsoft Software Defined Networking (SDN) with AKS hybrid

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

This article describes how to deploy AKS infrastructure and workload VMs to an SDN Virtual Network using our SDN [Software Load
Balancer][] (SLB) for all AKS hybrid load balancing scenarios. Azure Kubernetes Service hybrid deployment options ("AKS hybrid") offers a fully supported container platform that can run cloud-native applications on the [Kubernetes container orchestration platform](https://kubernetes.io/). The architecture supports running virtualized Windows and Linux workloads.

## Limitations

The following features are out of scope and not supported for this GA release:

- Attaching pods and containers to an SDN virtual network.
  - Pods use Flannel or Calico (default) as the network provider.
- Network policy enforcement using the SDN Network Security Groups.
  - The SDN Network Security Groups can still be configured outside of AKS hybrid using SDN tools (REST/PowerShell/Windows Admin Center/SCVMM), but Kubernetes NetworkPolicy objects don't configure them.
- Attaching AKS hybrid VM NICs to SDN logical networks.
- Installation using Windows Admin Center.
- Physical host to AKS hybrid VM connectivity: VM NICs are joined to an SDN virtual network and thus aren't accessible from the host by default. For now, you can enable this connectivity manually by attaching a public IP directly to the VM using the SDN Software Load Balancer.

## Prerequisites

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

To deploy AKS hybrid with SDN, make sure your environment satisfies the deployment criteria of both AKS hybrid and SDN.

- [AKS hybrid requirements][]
- SDN requirements: [Plan a Software Defined Network infrastructure][]

> [!NOTE]
> SDN integration with AKS hybrid only requires Network Controller and Software Load Balancer. Gateway VMs are optional.

## Install and prepare SDN for AKS hybrid

The first step is to install SDN. To install SDN, we recommend [SDN Express][] or [Windows Admin Center][].

A reference configuration file that deploys all the needed SDN infrastructure components can be found here: [Software Load Balancer.psd1][].

Once the SDN Express deployment completes, there should be a screen that reports the status as healthy.

If anything went wrong or is being reported as unhealthy, see [Troubleshooting SDN][]. Feel free to reach out to aks-hci-sdn@microsoft.com for assistance.

It is important that SDN is healthy before proceeding. If you are deploying SDN in a new environment, we also recommend creating test VMs and verifying connectivity to the load balancer VIPs. See [how to create and attach VMs to an SDN virtual network][] using Windows Admin Center.

## Steps to install AKS-HCI

Initialize and prepare all the physical host machines for AKS hybrid. See [Deploy an AKS host](prestage-cluster-service-host-create.md) for the most up-to-date instructions.

### Install the AKS-HCI PowerShell module

See [Install the AksHci PowerShell module](kubernetes-walkthrough-powershell.md#install-the-akshci-powershell-module) for information about installing the AKS-HCI PowerShell module.

> [!NOTE]
> After completing this step, refresh or reload any opened PowerShell sessions to reload the modules.

### Register the resource provider to your subscription

For information about how to register the resource provider to your subscription, see [Install the AksHci PowerShell module](kubernetes-walkthrough-powershell.md#register-the-resource-provider-to-your-subscription).

### Prepare your machines for deployment

For information about how to prepare your machines for deployment, see [Prepare your machines for deployment](kubernetes-walkthrough-powershell.md#step-1-prepare-your-machines-for-deployment).

### Configure AKS-HCI for installation

Choose one of your Azure Stack HCI servers to drive the creation of AKS hybrid. There are three steps that need to be done prior to installation:

1. Configure the AKS hybrid network settings for SDN; for example, using:
   1. SDN Virtual network "10.20.0.0/24" (10.20.0.0 – 10.20.0.255). A virtualized network, and you can use any IP subnet. This subnet does not need to exist on your physical network.
   2. vSwitch name "External." The external vSwitch on the Azure Stack HCI servers. Ensure that you use the same vSwitch that was used for SDN deployment.
   3. Gateway "10.20.0.1." This address is the gateway for your virtual network.
   4. DNS Server "10.127.130.7." The DNS server for your virtual network.

   ```powershell
   $vnet = New-AksHciNetworkSetting –name "myvnet" –vswitchName "External" -k8sNodeIpPoolStart "10.20.0.2" -k8sNodeIpPoolEnd "10.20.0.255"
   -ipAddressPrefix "10.20.0.0/24" -gateway "10.20.0.1" -dnsServers "10.127.130.7"
   ```

   | Parameter                               | Description                                                                                    |
   |-----------------------------------------|------------------------------------------------------------------------------------------------|
   | `-name`                                   | Name of virtual network in AKS hybrid (must be lowercase).                                        |
   | `-vswitchName`                            | Name of external vSwitch on the Azure Stack HCI servers. Use same vSwitch that was used for SDN deployment. |
   | `-k8sNodeIpPoolStart` <br /> `-k8sNodeIpPoolEnd` | IP start/end range of SDN virtual network.                                                      |
   | `-ipAddressPrefix`                        | Virtual network subnet in CIDR notation.                                                        |
   | `-gateway` <br /> `-dnsServers`                  | Gateway and DNS server of the SDN virtual network.                                              |

   For more information about these parameters, see [New-AksHciNetworkSetting][].

2. In the same PowerShell window you used in Step 1, create a VIP pool to inform AKS of our IPs that can be used from our SDN Load Balancing Logical Network:

   ```powershell
   $VipPool = New-AksHciVipPoolSetting -name "publicvip" -vipPoolStart "10.127.132.16" -vipPoolEnd "10.127.132.23
   ```

   | Parameter     | Description                                                                                                                                      |
   |---------------|--------------------------------------------------------------------------------------------------------------------------------------------------|
   | `-name`         | The "PublicVIP" logical network that you provided when configuring SDN load balancers. Within the cmdlet, this name must be lowercase.                                                    |
   | `-vipPoolStart` | IP start range of logical network used for public load balancer VIP pool. You must use an address range from the "PublicVIP" SDN logical network. |
   | `-vipPoolEnd`   | IP end range of logical network used for public load balancer VIP pool. You must use an address range from the "PublicVIP" SDN logical network.   |

3. In the same PowerShell window used in Step 2, create the AKS configuration for SDN by providing references to the targeted SDN networks, and supply the network settings ($vnet, $vipPool) that we previously defined:

   ```powershell
   Set-AksHciConfig 
   –imageDir "C:\ClusterStorage\Volume1\ImageStore" 
   –workingDir "C:\ClusterStorage\Volume1\WorkDir"
   –cloudConfigLocation "C:\ClusterStorage\Volume1\Config" 
   –vnet $vnet –useNetworkController
   –NetworkControllerFqdnOrIpAddress "nc.contoso.com" 
   –networkControllerLbSubnetRef "/logicalnetworks/PublicVIP/subnets/my_vip_subnet" 
   –networkControllerLnetRef "/logicalnetworks/HNVPA" 
   -vipPool $vipPool
   ```

   The HNVPA logical network is used as the underlying provider for the AKS hybrid virtual network.

   If you are using static IP address assignment for your Azure Stack HCI cluster nodes, you must also provide the CloudServiceCidr parameter. This parameter is the IP address of the MOC cloud service, and must be in the same subnet as Azure Stack HCI cluster nodes. For more information, see [Microsoft On-premises Cloud service](concepts-node-networking.md#microsoft-on-premises-cloud-service).

      | Parameter                         | Description                                                                                                                                                                                                                                                                                                                                                             |
      |-----------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
      | `–imageDir`                         | The path to where AKS hybrid stores its VHD images. This path must be a shared storage path, or an SMB share.                                                                                                                                                                                                                                                                      |
      | `–workingDir`                       | The path to where small files for the module are stored. This path must be a shared storage path, or an SMB share.                                                                                                                                                                                                                                                              |
      | `-cloudConfigLocation`              | The path to the directory where cloud agent configuration is stored. This path must be a shared storage path, or an SMB share.                                                                                                                                                                                                                                               |
      | `-vnet`                             | Name of `AksHciNetworkSetting` variable created in the previous step                                                                                                                                                                                                                                                                                                      |
      | `-useNetworkController`             | Enable integration with SDN.                                                                                                                                                                                                                                                                                                                                             |
      | `-networkControllerFqdnOrIpAddress` | Network controller FQDN. You can get the FQDN by executing `Get-NetworkController` on the Network Controller VM and using the `RestName` parameter.                                                                                                                                                                                                                         |
      | `-networkControllerLbSubnetRef`     | Reference to the public VIP logical network subnet configured in Network Controller. You can get this subnet by executing the `Get-NetworkControllerLogicalSubnet` cmdlet. When using this cmdlet, use `PublicVIP` as the `LogicalNetworkId`. The `VipPoolStart` and `vipPoolEnd` parameters in the `New-AksHciVipPoolSetting` cmdlet must be part of the subnet referenced here. |
      | `-networkControllerLnetRef`         | Normally, this value is "/logicalnetworks/HNVPA."                                                                                                                                                                                                                                                                                                                        |
      | `-vipPool`                          | VIP pool used as the front end IPs for load balancing.                                                                                                                                                                                                                                                                                                                   |

      For more information about these parameters, see [Set-AksHciConfig][].

### Sign in to Azure and configure registration settings

Follow [the instructions here](kubernetes-walkthrough-powershell.md#step-4-log-in-to-azure-and-configure-registration-settings) to configure registration settings.

> [!NOTE]
> If you don't have owner permissions, it's recommended that you use an [Azure service principal][].

### Install AKS-HCI

Once the AKS configuration completes, you are ready to install AKS on Azure Stack HCI.

```powershell
Install-AksHci
```

Once the installation succeeds, a control plane VM (management cluster) is created, and its VmNIC is attached to your SDN network.

### Collect logs from an SDN and AKSHCI environment

With SDN and AKSHCI, we gain isolation of the AKS nodes on Virtual Networks. Since they are isolated, we must import a new SDN AKSHCI log collection script and run a modified command that uses the load balancer to retrieve logs from the nodes.

```powershell
Install-Module -Name AksHciSdnLogCollector -Repository PSGallery
Get-AksHciLogsSdn
```

### Feedback/issues

If you encounter any issues with the instructions or would simply like to provide feedback, reach out to us at
<aks-hci-sdn@microsoft.com>. There are also some self-help resources that [can be found here][Troubleshooting SDN] for SDN
[and here](known-issues.yml) for AKS-HCI.

## Next steps

Next, you can create [workload clusters][] and [deploy your applications][]. All AKS VM NICs in AKS hybrid are seamlessly attached to the
SDN virtual network that was provided during installation. The SDN Software load balancer is also used as the external load balancer
for all Kubernetes services, and acts as the load balancer for the API server on Kubernetes control-plane(s).

[Software Load Balancer]: /azure-stack/hci/concepts/software-load-balancer
[AKS hybrid requirements]: system-requirements.md
[Plan a Software Defined Network infrastructure]: /azure-stack/hci/concepts/plan-software-defined-networking-infrastructure
[SDN Express]: /azure-stack/hci/manage/sdn-express
[Windows Admin Center]: /azure-stack/hci/deploy/sdn-wizard
[Software Load Balancer.psd1]: https://github.com/microsoft/SDN/blob/master/SDNExpress/scripts/Sample%20-%20Software%20Load%20Balancer.psd1
[Troubleshooting SDN]: /windows-server/networking/sdn/troubleshoot/troubleshoot-software-defined-networking
[how to create and attach VMs to an SDN virtual network]: /azure-stack/hci/manage/vm
[New-AksHciNetworkSetting]: reference/ps/new-akshcinetworksetting.md
[Set-AksHciConfig]: reference/ps/set-akshciconfig.md
[Azure service principal]: reference/ps/set-akshciregistration.md#register-aks-hybrid-using-a-service-principal
[workload clusters]: kubernetes-walkthrough-powershell.md#step-6-create-a-kubernetes-cluster
[Deploy your applications]: deploy-windows-application.md
