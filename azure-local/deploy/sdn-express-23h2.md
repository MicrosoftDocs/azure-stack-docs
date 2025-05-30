--- 
title: Deploy an SDN infrastructure using SDN Express for Azure Local, version 23H2
description: Learn to deploy an SDN infrastructure using SDN Express for Azure Local, version 23h2.
author: alkohli 
ms.topic: how-to 
ms.date: 05/29/2025
ms.author: alkohli 
ms.reviewer: anirbanpaul 
---

# Deploy an SDN infrastructure using SDN Express for Azure Local

> Applies to: Azure Local 2311.2 and later; Windows Server 2022, Windows Server 2019, Windows Server 2016

In this article, you deploy an end-to-end Software Defined Network (SDN) infrastructure for Azure Local using SDN Express PowerShell scripts. The infrastructure includes a highly available (HA) Network Controller (NC), and optionally, a highly available Software Load Balancer (SLB), and a highly available Gateway (GW).  The scripts support a phased deployment, where you can deploy just the Network Controller component to achieve a core set of functionality with minimal network requirements.

You can also deploy an SDN infrastructure System Center Virtual Machine Manager (VMM). For more information, [Manage SDN resources in the VMM fabric](/system-center/vmm/network-sdn).

> [!IMPORTANT]
> If you're deploying SDN on Azure Local, ensure that all the applicable SDN infrastructure VMs (Network Controller, Software Load Balancers, Gateways) are on the latest Windows Update patch. You can initiate the update from the SConfig UI on the machines. Without the latest patches, connectivity issues may arise. For more information about updating the SDN infrastructure, see [Update SDN infrastructure for Azure Local](../manage/update-sdn.md).

## Before you begin

Before you begin an SDN deployment, plan out and configure your physical and host network infrastructure. Reference the following articles:

- [Physical network requirements](../concepts/physical-network-requirements.md)
- [Host network requirements](../concepts/host-network-requirements.md)
- [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure.md)

You don't have to deploy all SDN components. See the [Phased deployment](../concepts/plan-software-defined-networking-infrastructure.md#phased-deployment) section of [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure.md) to determine which infrastructure components you need, and then run the scripts accordingly.

Make sure all host machines have the Azure Stack HCI operating system installed. See [Deploy the Azure Stack HCI operating system](../deploy/deployment-install-os.md) on how to do this.

## Requirements

The following requirements must be met for a successful SDN deployment:

- All host machines must have Hyper-V enabled.
- All host machines must be joined to Active Directory.
- Active Directory must be prepared. For more information, see [Prepare Active Directory](../deploy/deployment-prep-active-directory.md).
- A [virtual switch](../manage/create-logical-networks.md) must be created. You can use the default switch created for Azure Local. You may need to create separate switches for compute traffic and management traffic, for example.
- The physical network must be configured for the subnets and VLANs defined in the configuration file.
- The SDN Express script needs to be run from a Windows Server 2016 or later computer.
- The VHDX file specified in the configuration file must be reachable from the computer where the SDN Express script is run.

## Download the VHDX file

[!INCLUDE [download-vhdx](../includes/hci-download-vhdx-2.md)]

## Install the SDN Express PowerShell module

Run the following command to install the latest version of the SDN Express PowerShell module on the machine where you want to run the SDN installation:

```powershell
Install-Module -Name SDNExpress
```

The files automatically install in the default PowerShell module directory: `C:\Program Files\WindowsPowerShell\Modules\SdnExpress\`.

> [!NOTE]
> The SDN Express script files are no longer available on GitHub.

## Edit the configuration file

The PowerShell configuration data file (psd1 file) stores the input parameters and configuration settings that the SDN Express script requires to run. This file contains specific information about what needs to be configured, based on whether you're deploying just the Network Controller component or also the Software Load Balancer and Gateway components.

For more information, see [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure-23h2.md). For details about the relevant config file to be used, see [Configuration sample files](#configuration-sample-files).

Navigate to the `C:\Program Files\WindowsPowerShell\Modules\SdnExpress\` folder and open the relevant config file in your favorite text editor. Change specific parameter values to fit your infrastructure and deployment.

### General settings and parameters

The settings and parameters are used by SDN in general for all deployments. For specific recommendations, see [SDN infrastructure VM role requirements](../concepts/plan-software-defined-networking-infrastructure.md#sdn-infrastructure-vm-role-requirements).

- **VHDPath** - VHD file path used by all SDN infrastructure VMs (NC, SLB, GW)
- **VHDFile** - VHDX file name used by all SDN infrastructure VMs
- **VMLocation** - file path to SDN infrastructure VMs. Universal Naming Convention (UNC) paths aren't supported. For cluster storage-based paths, use a format like `C:\ClusterStorage\...`
- **JoinDomain** - domain to which SDN infrastructure VMs are joined
- **SDNMacPoolStart** - beginning MAC pool address for client workload VMs
- **SDNMacPoolEnd** -  end MAC pool address for client workload VMs
- **ManagementSubnet** - management network subnet used by NC to manage Hyper-V hosts, SLB, and GW components
- **ManagementGateway** - Gateway address for the management network
- **ManagementDNS** - DNS server for the management network
- **ManagementVLANID** - VLAN ID for the management network
- **DomainJoinUsername** - administrator username. The username should be in the following format: `domainname\username`. For example, if the domain is `contoso.com`, enter the username as `contoso\<username>`. Don't use formats like `contoso.com\<username>` or `username@contoso.com`
- **LocalAdminDomainUser** - local administrator username. The username should be in the following format: `domainname\username`. For example, if the domain is `contoso.com`, enter the username as `contoso\<username>`. Don't use formats like `contoso.com\<username>` or `username@contoso.com`
- **RestName** - DNS name used by management clients (such as Windows Admin Center) to communicate with NC
- **RestIpAddress** - Static IP address for your REST API, which is allocated from your management network. It can be used for DNS resolution or REST IP-based deployments
- **HyperVHosts** - host machines to be managed by Network Controller
- **NCUsername** - Network Controller account username
- **ProductKey** - product key for SDN infrastructure VMs
- **SwitchName** - only required if more than one virtual switch exists on the Hyper-V hosts
- **VMMemory** - memory (in GB) assigned to infrastructure VMs. Default is 4 GB
- **VMProcessorCount** - number of processors assigned to infrastructure VMs. Default is 8
- **Locale** - if not specified, locale of deployment computer is used
- **TimeZone** - if not specified, local time zone of deployment computer is used

Passwords can be optionally included if stored encrypted as text-encoded secure strings.  Passwords will only be used if SDN Express scripts are run on the same computer where passwords were encrypted, otherwise it prompts for these passwords:

- **DomainJoinSecurePassword** - for domain account
- **LocalAdminSecurePassword** - for local administrator account
- **NCSecurePassword** - for Network Controller account

### Network Controller VM section

A minimum of three Network Controller VMs are recommended for SDN.

The `NCs = @()` section is used for the Network Controller VMs. Make sure that the MAC address of each NC VM is outside the `SDNMACPool` range listed in the General settings.

- **ComputerName** - name of NC VM
- **HostName** - host name of server where the NC VM is located
- **ManagementIP** - management network IP address for the NC VM
- **MACAddress** - MAC address for the NC VM

### Software Load Balancer VM section

A minimum of two Software Load Balancer VMs are recommended for SDN.

The `Muxes = @()` section is used for the SLB VMs. Make sure that the `MACAddress` and `PAMACAddress` parameters of each SLB VM are outside the `SDNMACPool` range listed in the General settings. Ensure that you get the `PAIPAddress` parameter from outside the PA Pool specified in the configuration file, but part of the PASubnet specified in the configuration file.

Leave this section empty (`Muxes = @()`) if not deploying the SLB component:

- **ComputerName** - name of SLB VM
- **HostName** - host name of the machine where the SLB VM is located
- **ManagementIP** - management network IP address for the SLB VM
- **MACAddress** - MAC address for the SLB VM
- **PAIPAddress** - Provider network IP address (PA) for the SLB VM
- **PAMACAddress** - Provider network IP address (PA) for the SLB VM

### Gateway VM section

A minimum of two Gateway VMs (one active and one redundant) are recommended for SDN.

The `Gateways = @()` section is used for the Gateway VMs. Make sure that the `MACAddress` parameter of each Gateway VM is outside the `SDNMACPool` range listed in the General settings. The `FrontEndMac` and `BackendMac` must be from within the `SDNMACPool` range. Ensure that you get the `FrontEndMac` and the `BackendMac` parameters from the end of the `SDNMACPool` range.

Leave this section empty (`Gateways = @()`) if not deploying the Gateway component:

- **ComputerName** - name of Gateway VM
- **HostName** - host name of the machine where the Gateway VM is located
- **ManagementIP** - management network IP address for the Gateway VM
- **MACAddress** - MAC address for the Gateway VM
- **FrontEndMac** - Provider network front end MAC address for the Gateway VM
- **BackEndMac** - Provider network back end MAC address for the Gateway VM

### Additional settings for SLB and Gateway

The following other parameters are used by SLB and Gateway VMs. Leave these values blank if you aren't deploying SLB or Gateway VMs:

- **SDNASN** - Autonomous System Number (ASN) used by SDN to peer with network switches
- **RouterASN** - Gateway router ASN
- **RouterIPAddress** - Gateway router IP address
- **PrivateVIPSubnet** -  virtual IP address (VIP) for the private subnet
- **PublicVIPSubnet** - virtual IP address for the public subnet

The following other parameters are used by Gateway VMs only. Leave these values blank if you aren't deploying Gateway VMs:

- **PoolName** - pool name used by all Gateway VMs
- **GRESubnet** - VIP subnet for GRE (if using GRE connections)
- **Capacity** - capacity in Kbps for each Gateway VM in the pool
- **RedundantCount** - number of gateways in redundant mode. The default value is 1. Redundant gateways don't have any active connections. Once an active gateway goes down, the connections from that gateway move to the redundant gateway and the redundant gateway becomes active.

    > [!NOTE]
    > If you fill in a value for **RedundantCount**, ensure that the total number of gateway VMs is at least one more than the **RedundantCount**. By default, the **RedundantCount** is 1, so you must have at least 2 gateway VMs to ensure that there is at least 1 active gateway to host gateway connections.

### Settings for tenant overlay networks

The following parameters are used if you're deploying and managing overlay virtualized networks for tenants. If you're using Network Controller to manage traditional VLAN networks instead, these values can be left blank.

- **PASubnet** -  subnet for the Provider Address (PA) network
- **PAVLANID** - VLAN ID for the PA network
- **PAGateway** - IP address for the PA network Gateway
- **PAPoolStart** - beginning IP address for the PA network pool
- **PAPoolEnd** - end IP address for the PA network pool

Here's how Hyper-V Network Virtualization (HNV) Provider logical network allocates IP addresses. Use this to plan your address space for the HNV Provider network.

- Allocates two IP addresses to each physical machine
- Allocates one IP address to each SLB MUX VM
- Allocates one IP address to each gateway VM

## Run the deployment script

The SDN Express script deploys your specified SDN infrastructure. When the script is complete, your SDN infrastructure is ready to be used for VM workload deployments.

1. Review the `README.md` file for late-breaking information on how to run the deployment script.  

1. Run the following command from a user account with administrative credentials for the host machines:

    ```powershell
    .\SDNExpress.ps1 -ConfigurationDataFile “Traditional VLAN networks.psd1” -DomainJoinCredential $cred -NCCredential $cred -LocalAdminCredential $cred -Verbose
    ```

1. After the NC VMs are created, configure dynamic DNS updates for the Network Controller cluster name on the DNS server. For more information, see [Dynamic DNS updates](../concepts/network-controller.md#dynamic-dns-updates).

## Configuration sample files

The following configuration sample files for deploying SDN are available in the location where the PowerShell module is installed (`C:\Program Files\WindowsPowerShell\Modules\SdnExpress\`):

- **Traditional VLAN networks.psd1** - Deploy Network Controller for managing network policies like microsegmentation and Quality of Service on traditional VLAN Networks.

- **Virtualized networks.psd1** - Deploy Network Controller for managing virtual networks and network policies on virtual networks.

- **Software Load Balancer.psd1** - Deploy Network Controller and Software Load Balancer for load balancing on virtual networks.

- **SDN Gateways.psd1** - Deploy Network Controller, Software Load Balancer and Gateway for connectivity to external networks.

## Next steps

- [Manage VMs](../manage/vm.md)
