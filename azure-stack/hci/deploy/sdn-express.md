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

The scripts also support a phased deployment, where you deploy just the network controller to achieve a core set of functionality with minimal network requirements.

You can also deploy an SDN infrastructure using System Center Virtual Machine Manager (VMM). For more information, see [Manage SDN resources in the VMM fabric](https://docs.microsoft.com/system-center/vmm/network-sdn).

## Before you begin

Before you begin SDN deployment, plan out and configure your physical and host network infrastructure. Reference the following articles:

- [Physical network requirements](../concepts/physical-network-requirements.md)
- [Host network requirements](../concepts/host-network-requirements.md)
- [Create a cluster using Windows Admin Center](create-cluster.md)
- [Create a cluster using Windows PowerShell](create-cluster-powershell.md)
- [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure.md)

You do not have to deploy all SDN components. See the [Phased deployment](../concepts/plan-software-defined-networking-infrastructure.md#phased-deployment) section of [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure.md) to determine which infrastructure components you need, and then run the scripts accordingly.

Make sure all host servers have the Azure Stack HCI operating system installed. See [Deploy the Azure Stack HCI operating system](operating-system.md) on how to do this.

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

1. After the network controller VMs are created, configure dynamic DNS updates for the Network Controller cluster name on the DNS server. For more information, see Step 3 of [Requirements for Deploying Network Controller](https://docs.microsoft.com/windows-server/networking/sdn/plan/installation-and-preparation-requirements-for-deploying-network-controller#step-3-configure-dynamic-dns-registration-for-network-controller).

## Next steps

Manage your VMs. For more information, see [Manage VMs](../manage/vm.md)