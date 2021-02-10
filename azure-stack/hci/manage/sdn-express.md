--- 
title: Deploy an SDN infrastructure using SDN Express
description: Learn to deploy an SDN infrastructure using SDN Express
author: v-dasis 
ms.topic: how-to 
ms.date: 02/01/2021
ms.author: v-dasis 
ms.reviewer: JasonGerend 
---

# Deploy an SDN infrastructure using SDN Express

> Applies to Azure Stack HCI, version 20H2

In this topic, you deploy an end-to-end Software Defined Network (SDN) infrastructure using SDN Express PowerShell scripts. The infrastructure may include a highly available (HA) network controller (NC), a highly available Software Load Balancer (SLB), and a highly available gateway.  The scripts support a phased deployment, where you can deploy just the Network Controller to achieve a core set of functionality with minimal network requirements. 

You can also deploy an SDN infrastructure using System Center Virtual Machine Manager (VMM). For more information, see [Manage SDN resources in the VMM fabric](/system-center/vmm/network-sdn).

## Before you begin

Before you begin SDN deployment, plan out and configure your physical and host network infrastructure. Reference the following articles:

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

SDN uses a VHDX file containing the Azure Stack HCI OS as a source for creating the SDN virtual machines (VMs). The version of the OS in your VHDX must match the version used by the Hyper-V hosts.

If you've downloaded and installed the Azure Stack HCI OS from an ISO, you can create this VHDX using the `Convert-WindowsImage` utility as described in the [Script Center](https://gallery.technet.microsoft.com/scriptcenter/Convert-WindowsImageps1-0fe23a8f).

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

1. Go to the [SDN Express](https://github.com/microsoft/SDN) GitHub repository.

1. Download the files from the repository to your designated deployment computer. Select **Clone** or **Download ZIP**.

    > [!NOTE]
    > The designated deployment computer must be running Windows Server 2016 or later.

1. Extract the ZIP file and copy the `SDNExpress` folder to your deployment computer's `C:\` folder.

## Edit the configuration file

The PowerShell `MultiNodeSampleConfig.psd1` configuration data file contains all the parameters and settings that are needed for the SDN Express script as input for the various parameters and configuration settings. This file has specific information about what needs to be filled out based on whether you are deploying only the network controller component, or the software load balancer and gateway components as well.

For detailed information, see [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure.md) topic.

Let's begin:

1. Navigate to the `C:\SDNExpress\scripts` folder.

1. Open the `MultiNodeSampleConfig.psd1` file in your favorite text editor.

1. Change specific parameter values to fit your infrastructure.

## Run the deployment script

The SDN Express script deploys your SDN infrastructure. When the script is complete, your infrastructure is ready to be used for workload deployments.

1. Review the `README.md` file for late-breaking information on how to run the deployment script.  

1. Run the following command from a user account with administrative credentials for the cluster host servers:

    ```powershell
    SDNExpress\scripts\SDNExpress.ps1 -ConfigurationDataFile MultiNodeSampleConfig.psd1 -Verbose
    ```

1. After the network controller VMs are created, configure dynamic DNS updates for the Network Controller cluster name on the DNS server. For more information, see Step 3 of [Requirements for Deploying Network Controller](/windows-server/networking/sdn/plan/installation-and-preparation-requirements-for-deploying-network-controller#step-3-configure-dynamic-dns-registration-for-network-controller).

## Next steps

Manage your VMs. For more information, see [Manage VMs](../manage/vm.md)