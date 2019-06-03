---
title: Azure Stack Capacity Planner | Microsoft Docs
description: Learn about capacity planning for Azure Stack deployments.
services: azure-stack
documentationcenter: ''
author: prchint
manager: femila
editor: ''

ms.assetid:
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 05/31/2019
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 05/31/2019
---

# Azure Stack Capacity Planner

The Azure Stack Capacity Planner is a spreadsheet that shows how different allocations of computing resources would fit across a selection of hardware offerings. 

## Worksheet descriptions
The following table has a description for each worksheet in the Azure Stack Capacity Planner, which can be downloaded from [https://aka.ms/azstackcapacityplanner](https://aka.ms/azstackcapacityplanner). 

|Tab Name|Description|
|-----|-----|
|Version-Disclaimer|Purpose of the calculator, version number, and release date.|
|Instructions|Step-by-step instructions to model capacity planning for a collection of VMs.|
|DefinedSolutionSKUs|Table with up to five hardware definitions. The entries are examples. Change the details to match system configurations under consideration.|
|DefineByVMFootprint|Find the appropriate hardware SKU by comparing configurations with different sizes and quantities of VMs.|
|DefineByWorkloadFootprint|Find the appropriate hardware SKU by creating a collection of Azure Stack workloads.|
|  |  |

## DefinedSolutionSKUs instructions
This worksheet contains up to five hardware definition examples. Change details to match the system configurations under consideration.

### Hardware selections provided by Authorized Hardware Partners
Azure Stack is delivered as an integrated system with software installed by solution partners. Solution partners provide their own authoritative versions of Azure Stack capacity planning tools. Use those tools for final discussions of solution capacity.

### Multiple ways to model computing resources
Resource modeling within the Azure Stack planner depends upon the various sizes of Azure Stack VMs. VMs range in size from the smallest Basic 0 up to the largest Standard_Fsv2. You can model computing resource allocations in two different ways:

- Select a specific hardware offering and see which combinations of various resources fit. 

- Create a specific combination of VM allocations and let the Azure Resource Calculator show which available hardware SKUs are capable of supporting this VM configuration.

This tool provides two methods for allocating VM resources: either as one single collection of VM resource allocations or as a collection of up to six differing Workload configurations. Each Workload configuration can contain a different allocation of available VM resources. The next sections have step-by-step instructions to create and use each of these allocation models. Only values contained in non-background shaded cells, or within SKU pull-down lists on this worksheet should be modified. Changes made within shaded cells may break resource calculations.


## DefineByVMFootprint instructions
To create a model using a single collection of various sizes and quantities of VMs, select the "DefineByVMFootprint" Tab and follow these steps:

1. In the upper right corner of this worksheet, use the provided pull-down list box controls to select an initial number of servers (between 4 and 16) you want installed in each hardware system (SKU). This number of servers may be modified at any time during the modeling process to see how this affects overall available resources for your resource allocation model.
2. If you want to model various VM resource allocations against one specific hardware configuration, find the blue pull-down list box directly below the "Current SKU" label in the upper right-hand corner of the page. Pull down this list box and select your desired hardware SKU.
3. You are now ready to begin adding various sized VMs to your model. To include a particular VM type, enter a quantity value into the blue outlined box to the left of that VM entry.

   > [!NOTE]
   > Total VM Storage refers to the total capacity of the data disk of the VM (number of supported disks * the maximum capacity of a single disk (1 TB)). Based on the configuration indicators we have populated the Available Storage Configurations table, so that you may choose your desired level of storage resource for each Azure Stack VM. However, it is important to note that you may add or change the Available Storage Configurations table as necessary.<br><br>Each VM starts with an initially assigned local temp storage. To reflect the thin provisioning of temp storage the local-temp number can be changed to anything in the drop down menu including the maximum allowable temp storage amount.

4. As you add VMs, you will see the charts that show available SKU resources changing. This allows you to see the effects of adding various sizes and quantities of VMs during the modeling process. Another way to view the effect of changes is to watch the Consumed and Still Available numbers listed directly below the list of available VMs. These numbers reflect estimated values based on the currently selected hardware SKU.
5. Once you have created your set of VMs, you can find the suggested hardware SKU by clicking the "Suggested SKU" button found in the upper right corner of the page, directly below the "Current SKU" label. Using this button, you can then modify your VM configurations and see which hardware supports each configuration.


## DefineByWorkloadFootprint instructions
To create a model using a collection of Azure Stack Workloads, select the "DefineByWorkloadFootprint" Tab and follow this sequence of steps. Azure Stack Workloads are created using available VM resources.   

> [!TIP]
> To change the provided storage size for an Azure Stack VM, see the note from step three in the preceding section.

1. In the upper right corner of this page, use the provided pull-down list box controls to select an initial number of servers (between 4 and 16) you want installed in each hardware system (SKU).
2. If you want to model various VM resource allocations against one specific hardware configuration, find the blue pull-down list box directly below the "Current SKU" label in the upper right-hand corner of the page. Pull down this list box and select your desired hardware SKU.
3. Select the appropriate storage size for each of your desired Azure Stack VMs on the DefineByVMFootprint page as described above in step three of DefineByVMFootprint instructions. The storage size per VM is defined in the DefineByVMFootprint sheet.
4. Starting on the upper left of the DefineByWorkloadFootprint page, create configurations for up to six different Workload types by entering the quantity of each VM type contained within that Workload. This is done by placing numeric values into the column directly below that Workload's name. Workload names may be modified to reflect the type of workloads that will be supported by this particular configuration.
5. You may include a particular quantity of each Workload type by entering a value at the bottom of that column directly below the "Quantity" label.
6. Once Workload types and quantities have been created, clicking the "Suggested SKU" button found in the upper right corner of the page, directly below the "Current SKU" label, will cause the smallest SKU with sufficient resources to support this overall configuration of Workloads to be displayed.
7. Further modeling may be accomplished by modifying the number of servers selected for a hardware SKU, or changing the VM allocations or quantities within your Workload configurations. The associated graphs will display immediate feedback showing how your changes affect the overall resource consumption.
8. Once you are satisfied with your changes, clicking **Suggested SKU** again will display the SKU suggested for your new configuration. You can also click the drop-down menu to select your desired SKU.

## Next steps
Learn about the [datacenter integration considerations for Azure Stack](azure-stack-datacenter-integration.md)
