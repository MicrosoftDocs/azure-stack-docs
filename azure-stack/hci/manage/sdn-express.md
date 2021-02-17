--- 
title: Deploy an SDN infrastructure using SDN Express
description: Learn to deploy an SDN infrastructure using SDN Express
author: v-dasis 
ms.topic: how-to 
ms.date: 02/17/2021
ms.author: v-dasis 
ms.reviewer: JasonGerend 
---

# Deploy an SDN infrastructure using SDN Express

> Applies to Azure Stack HCI, version 20H2

In this topic, you deploy an end-to-end Software Defined Network (SDN) infrastructure using SDN Express PowerShell scripts. The infrastructure may include a highly available (HA) Network Controller (NC), a highly available Software Load Balancer (SLB), and a highly available Gateway (GW).  The scripts support a phased deployment, where you can deploy just the Network Controller component to achieve a core set of functionality with minimal network requirements.

You can also deploy an SDN infrastructure using System Center Virtual Machine Manager (VMM). For more information, see [Manage SDN resources in the VMM fabric](/system-center/vmm/network-sdn).

## Before you begin

Before you begin an SDN deployment, plan out and configure your physical and host network infrastructure. Reference the following articles:

- [Physical network requirements](../concepts/physical-network-requirements.md)
- [Host network requirements](../concepts/host-network-requirements.md)
- [Create a cluster using Windows Admin Center](../deploy/create-cluster.md)
- [Create a cluster using Windows PowerShell](../deploy/create-cluster-powershell.md)
- [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure.md)

You do not have to deploy all SDN components. See the [Phased deployment](../concepts/plan-software-defined-networking-infrastructure.md#phased-deployment) section of [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure.md) to determine which infrastructure components you need, and then run the scripts accordingly.

Make sure all host servers have the Azure Stack HCI operating system installed. See [Deploy the Azure Stack HCI operating system](../deploy/operating-system.md) on how to do this.

## Requirements

The following requirements must be met for a successful SDN deployment:

- All host servers must have Hyper-V enabled
- All host servers must be joined to Active Directory
- A virtual switch must be created
- The physical network must be configured for the subnets and VLANs defined in the configuration file
- The VHDX file specified in the configuration file must be reachable from the deployment computer where the SDN Express script is run

## Create the VDX file

SDN uses a VHDX file containing the Azure Stack HCI operating system (OS) as a source for creating the SDN virtual machines (VMs). The version of the OS in your VHDX must match the version used by the Azure Stack HCI Hyper-V hosts. This VHDX file is used by all SDN infrastructure components.

If you've downloaded and installed the Azure Stack HCI OS from an ISO, you can create the VHDX file using the [Convert-WindowsImage ](https://www.powershellgallery.com/packages/Convert-WindowsImage/10.0) utility.

The following shows an example using `Convert-WindowsImage`:

 ```powershell
$wimpath = "d:\sources\install.wim"
$vhdpath = "c:\temp\WindowsServerDatacenter.vhdx"
$Edition = 4   # 4 = Full Desktop, 3 = Server Core

import-module ".\convert-windowsimage.ps1"

Convert-WindowsImage -SourcePath $wimpath -Edition $Edition -VHDPath $vhdpath -SizeBytes 500GB -DiskLayout UEFI
```

## Download the GitHub repository

The SDN Express script files live in GitHub. The first step is to get the necessary files and folders onto your deployment computer.

1. Go to the [Microsoft SDN Github](https://github.com/microsoft/SDN) repository.

1. In the repository, expand the **Code** drop-down list, and then choose either **Clone** or **Download ZIP** to download the SDN files to your designated deployment computer.

    > [!NOTE]
    > The designated deployment computer must be running Windows Server 2016 or later.

1. Extract the ZIP file and copy the `SDNExpress` folder to your deployment computer's `C:\` folder.

## Edit the configuration file

The PowerShell `MultiNodeSampleConfig.psd1` configuration data file contains all the parameters and settings that are needed for the SDN Express script as input for the various parameters and configuration settings. This file has specific information about what needs to be filled out based on whether you are deploying only the network controller component, or the software load balancer and gateway components as well. For detailed information, see [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure.md) topic.

Navigate to the `C:\SDNExpress\scripts` folder and open the `MultiNodeSampleConfig.psd1` file in your favorite text editor. Change specific parameter values to fit your infrastructure and deployment:

### General settings and parameters

The settings and parameters are used by SDN in general for all deployments:

- **VHDPath** - VHD file path used by all SDN infrastructure VMs (NC, SLB, GW)
- **VHDFile** - VHD file name used by all SDN infrastructure VMs
- **VMLocation** - file path to SDN infrastructure VMs
- **JoinDomain** - domain to which SDN infrastructure VMs are joined to
- **SDNMacPoolStart** - beginning MAC pool address for client workload VMs
- **SDNMacPoolEnd** -  end MAC pool address for client workload VMs
- **ManagementSubnet** - management network subnet used by NC to manage Hyper-V hosts, SLB, and GW components
- **ManagementGateway** - Gateway address for the management network
- **ManagementDNS** - DNS server for the management network
- **ManagementVLANID** - VLAN ID for the management network
- **DomainJoinUsername** - administrator user name
- **LocalAdminDomainUser** - administrator password
- **RestName** - DNS name used by management clients (such as Windows Admin Center) to communicate with NC
- **HyperVHosts** - host servers to be managed by Network Controller
- **NCUsername** - Network Controller account user name
- **ProductKey** - product key for SDN infrastructure VMs
- **SwitchName** - only required if more than one virtual switch exists on the Hyper-V hosts
- **VMMemory** - memory (in GB) assigned to infrastructure VMs. Default is 4 GB
- **VMProcessorCount** - number of processors assigned to infrastructure VMs. Default is 8
- **Locale** - if not specified, locale of deployment computer is used
- **TimeZone** - if not specified, local time zone of deployment computer is used

Passwords can be optionally included if stored encrypted as text-encoded secure strings.  Passwords will only be used if SDN Express scripts are run on the same computer where passwords were encrypted, otherwise it will prompt for these passwords:

- **DomainJoinSecurePassword** - for domain account
- **LocalAdminSecurePassword** - for local administrator account
- **NCSecurePassword** - for Network Controller account

> [!NOTE]
> The SDN Express script does not support DHCP addressing. Ensure that MAC addresses for all SDN infrastructure VMs are outside the `SDNMACPool` parameter range.

### Network Controller VM section

The `NCs = @()` section is used for the Network Controller VMs. Make sure that the MAC address of each NC VM is outside the `SDNMACPool` range listed in the General settings:

- **ComputerName** - name of NC VM
- **HostName** - host name of server where the NC VM is located
- **ManagementIP** - management network IP address for the NC VM
- **MACAddress** - MAC address for the NC VM

### Software Load Balancer VM section

The `Muxes = @()` section is used for the SLB VMs. Make sure that the MAC address of each SLB VM is outside the `SDNMACPool` range listed in the General settings. Leave this section empty (`Muxes = @()`) if not deploying the SLB component:

- **ComputerName** - name of SLB VM
- **HostName** - host name of server where the SLB VM is located
- **ManagementIP** - management network IP address for the SLB VM
- **MACAddress** - MAC address for the SLB VM
- **PAIPAddress** - Provider network IP address (PA) for the SLB VM
- **PAMACAddress** - Provider network IP address (PA) for the SLB VM

### Gateway VM section

The `Gateways = @()` section is used for the Gateway VMs. Make sure that the MAC address of each Gateway VM is outside the `SDNMACPool` range listed in the General settings. Leave this section empty (`Gateways = @()`) if not deploying the Gateway component:

- **ComputerName** - name of Gateway VM
- **HostName** - host name of server where the Gateway VM is located
- **ManagementIP** - management network IP address for the Gateway VM
- **MACAddress** - MAC address for the Gateway VM
- **FrontEndIp** - Provider Network front end IP address for the Gateway VM
- **FrontEndMac** - Provider network front end MAC address for the Gateway VM
- **BackEndMac** - Provider network back end MAC address for the Gateway VM

### Additional settings for SLB and Gateway

The following additional parameters are used by SLB and Gateway VMs. Leave these values blank if you are not deploying SLB or Gateway VMs:

- **SDNASN** - Autonomous System Number (ASN) used by SDN to peer with network switches
- **RouterASN** - Gateway router ASN
- **RouterIPAddress** - Gateway router IP address
- **PrivateVIPSubnet** -  virtual IP address (VIP) for the private subnet
- **PublicVIPSubnet** - virtual IP address for the public subnet

The following additional parameters are used by Gateway VMs only. Leave these values blank if you are not deploying Gateway VMs:

- **PoolName** - pool name used by all Gateway VMs
- **GRESubnet** - VIP subnet for GRE (if using GRE connections)
- **Capacity** - capacity in Kbps for each Gateway VM in the pool

### Settings for tenant overlay networks

The following parameters are used if you are deploying and managing overlay virtualized networks for tenants. If you are using Network Controller to manage traditional VLAN networks instead, these values can be left blank.

- **PASubnet** -  subnet for the Provider Address (PA) network
- **PAVLANID** - VLAN ID for the PA network
- **PAGateway** - IP address for the PA network Gateway
- **PAPoolStart** - beginning IP address for the PA network pool
- **PAPoolEnd** - end IP address for the PA network pool

## Run the deployment script

The SDN Express script deploys your specified SDN infrastructure. When the script is complete, your SDN infrastructure is ready to be used for VM workload deployments.

1. Review the `README.md` file for late-breaking information on how to run the deployment script.  

1. Run the following command from a user account with administrative credentials for the cluster host servers:

    ```powershell
    SDNExpress\scripts\SDNExpress.ps1 -ConfigurationDataFile MultiNodeSampleConfig.psd1 -Verbose
    ```

1. After the NC VMs are created, configure dynamic DNS updates for the Network Controller cluster name on the DNS server. For more information, see [How to configure DNS dynamic updates](https://docs.microsoft.com/troubleshoot/windows-server/networking/configure-dns-dynamic-updates-windows-server-2003).

## Next steps

Manage your VMs. For more information, see [Manage VMs](../manage/vm.md).