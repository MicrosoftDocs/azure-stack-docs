--- 
title: Deploy an SDN infrastructure using SDN Express
description: Learn to deploy an SDN infrastructure using SDN Express
author: v-dasis 
ms.topic: how-to 
ms.date: 12/16/2020 
ms.author: v-dasis 
ms.reviewer: JasonGerend 
---

# Deploy an SDN infrastructure using SDN Express

> Applies to Azure Stack HCI, version 20H2

In this topic, you deploy an end-to-end Software Defined Network (SDN) infrastructure using SDN Express PowerShell scripts. The infrastructure includes a highly available (HA) network controller, a highly available Software Load Balancer (SLB) and a highly available gateway.  

You can also do a phased deployment starting with just the network controller to achieve a core set of functionality with minimal network requirements. For more information, see section [Step 5: SDN](create-cluster.md#step-5-sdn-optional) of [Create a cluster using Windows Admin Center](create-cluster.md).

You can also deploy an SDN infrastructure using System Center Virtual Machine Manager (VMM). For more information, see [Manage SDN resources in the VMM fabric](https://docs.microsoft.com/system-center/vmm/network-sdn).

## Before you begin

Before you begin SDN deployment, plan out and configure your hosts and physical network infrastructure. For information on how to do this, see [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure.md). You do not have to deploy all SDN components described. See the [Phased deployment](../concepts/plan-software-defined-networking-infrastructure.md#phased-deployment) section to determine which infrastructure components you need, and then run the scripts accordingly.

Make sure all host servers have the Azure Stack HCI operating system installed. See [Deploy the Azure Stack HCI operating system](operating-system.md) on how to do this.

## Install host networking

If you created your Azure Stack HCI cluster using Windows Admin Center, you can skip this section and proceed to the [Validate host networking](#validate-host-networking) section.

See [Plan a Software Defined Network infrastructure](https://docs.microsoft.com/azure-stack/hci/concepts/plan-software-defined-networking-infrastructure) on how to obtain VLAN IDs and assign IP addresses as needed for steps 4 and 5.

1. Install the latest network drivers available for your network adapters.

1. Install the Hyper-V role on all hosts using the following Windows PowerShell command:

    ```powershell
    Install-WindowsFeature -Name Hyper-V -ComputerName <server_name> -IncludeManagementTools -Restart
    ```

1. Create the Hyper-V virtual switch. Use the same switch name for all hosts. Configure at least one network adapter or, if using two or more adapters use Switch Embedded Teaming (SET). For more information, see the blog post [Teaming in Azure Stack HCI](https://techcommunity.microsoft.com/t5/networking-blog/teaming-in-azure-stack-hci/ba-p/1070642). Maximum inbound spreading occurs when using two adapters.

    Here is an example command:

    ```powershell
    New-VMSwitch "<switch name>" -NetAdapterName "<NetAdapter1>" [, "<NetAdapter2>" -EnableEmbeddedTeaming $True] -AllowManagementOS $True
    ```

    > [!TIP]
    > You can skip steps 4 and 5 if you use separate network adapters for management.

1. If your deployment uses VLAN IDs, obtain the VLAN ID of the management adapter.  This step can be omitted if your environment does not use VLAN IDs.

    Attach the management virtual adapter of the newly created virtual switch to the management VLAN as follows:

    ```powershell
    Set-VMNetworkAdapterIsolation -ManagementOS -IsolationMode Vlan -DefaultIsolationID <Management VLAN> -AllowUntaggedTraffic $True
    ```

1. Assign an IP address (either static or dynamic) to the management virtual adapter of the newly created virtual switch. 
    The following example shows how to create a static IP address and assign it to the management virtual adapter of your virtual switch:

    ```powershell
    New-NetIPAddress -InterfaceAlias "vEthernet (<switch_name>)" -IPAddress <IP> -DefaultGateway <Gateway IP> -AddressFamily IPv4 -PrefixLength <Length of Subnet Mask - for example: 24>
    ```

1. **(Optional)** Deploy a virtual machine (VM) to host Active Directory Domain Services (Level 100) and DNS services. Connect this VM to the management VLAN:

    ```powershell
    - Set-VMNetworkAdapterIsolation -VMName "<VM Name>" -Access -VlanId <Management VLAN> -AllowUntaggedTraffic $True
    ```

    Then, install Active Directory Domain Services and DNS.

1. Join all Hyper-V hosts to the domain. Make that sure the DNS server entry for the network adapter has an IP address assigned to the management network that points to a DNS server that can resolve the domain name:

    ```powershell
    Set-DnsClientServerAddress -InterfaceAlias "vEthernet (<switch_name>)" -ServerAddresses <DNS_Server_IP_address>
    ```

## Validate host networking

Use the following steps to validate that host networking is setup correctly.

1. Ensure the VM switch was created successfully:

    ```powershell
    Get-VMSwitch "<switch name>"
    ```

1. Verify that the management vNIC on the VM Switch is connected to the management VLAN:

    > [!NOTE]
    > This is relevant only if management and tenant traffic share the same NIC.

    ```powershell
    Get-VMNetworkAdapterIsolation -ManagementOS
    ```

1. Validate all Hyper-V hosts and external management resources, such as DNS servers for example.

1. Ensure they are accessible via `ping` using their management IP address or fully qualified domain name (FQDN): `ping <Hyper-V Host IP> ping <Hyper-V Host FQDN>`.

1. Run the following command on the deployment host and specify the FQDN of each Hyper-V host to ensure the Kerberos credentials used provides access to all the servers: `winrm id -r:<Hyper-V Host FQDN>`

## Run the SDN Express scripts

1. Go to the [SDN Express](https://github.com/microsoft/SDN) GitHub repository.

1. Download the files from the repository to your designated deployment computer. Select **Clone** or **Download ZIP**.

    > [!NOTE]
    > The designated deployment computer must be running Windows Server 2016 or later.

1. Extract the ZIP file and copy the `SDNExpress` folder to your deployment computer's `C:\` folder.

1. Navigate to the `C:\SDNExpress\scripts` folder.

1. Run the `SDNExpress.ps1` script file. This script uses a PowerShell deployment (PSD) file as input for the various configuration settings. See the `README.md` file for instructions on how to run the script.  

1. Use a VHDX containing the Azure Stack HCI OS as a source for creating the SDN VMs. If you've downloaded and installed the Azure Stack HCI OS from an ISO, you can create this VHDX using the `convert-windowsimage` utility as described in the documentation.

1. Customize the `SDNExpress\scripts\MultiNodeSampleConfig.psd1` file by changing the specific values to fit your infrastructure including host names, domain names, usernames and passwords, and network information for the networks listed as discussed in the [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure.md) topic. This file has specific information about what needs to be filled out based on whether you are deploying only the network controller component, or the software load balancer and gateway components as well.

1. Run the following script from a user account with Administrator credentials on the Hyper-V hosts:

    ```powershell
    SDNExpress\scripts\SDNExpress.ps1 -ConfigurationDataFile MultiNodeSampleConfig.psd1 -Verbose
    ```

1. After the network controller VMs are created, configure dynamic DNS updates for the Network Controller cluster name on the DNS server. Follow the instructions here to complete this process.

## Next steps

Use SC VMM to deploy a SDN infrastructure. See [Manage SDN resources in the VMM fabric](https://docs.microsoft.com/system-center/vmm/network-sdn).