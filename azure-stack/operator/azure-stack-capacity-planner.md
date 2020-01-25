---
title: Azure Stack Hub Capacity Planner 
description: Learn about capacity planning for Azure Stack Hub deployments.
author: prchint

ms.topic: article
ms.date: 05/31/2019
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 05/31/2019
---

# Azure Stack Hub Capacity Planner

The Azure Stack Hub Capacity Planner is a spreadsheet that shows how different allocations of computing resources would fit across a selection of hardware offerings. 

## Worksheet descriptions
The following table describes each worksheet in the Azure Stack Hub Capacity Planner, which can be downloaded from [https://aka.ms/azstackcapacityplanner](https://aka.ms/azstackcapacityplanner). 

|Worksheet name|Description|
|-----|-----|
|Version-Disclaimer|Purpose of the calculator, version number, and release date.|
|Instructions|Step-by-step instructions to model capacity planning for a collection of virtual machines (VMs).|
|DefinedSolutionSKUs|Table with up to five hardware definitions. The entries are examples. Change the details to match system configurations under consideration.|
|DefineByVMFootprint|Find the appropriate hardware SKU by comparing configurations with different sizes and quantities of VMs.|
|DefineByWorkloadFootprint|Find the appropriate hardware SKU by creating a collection of Azure Stack Hub workloads.|
|  |  |

## DefinedSolutionSKUs instructions
This worksheet contains up to five hardware definition examples. Change details to match the system configurations under consideration.

### Hardware selections provided by authorized hardware partners
Azure Stack Hub is delivered as an integrated system with software installed by solution partners. Solution partners provide their own authoritative versions of Azure Stack Hub capacity planning tools. Use those tools for final discussions of solution capacity.

### Multiple ways to model computing resources
Resource modeling within the Azure Stack Hub Capacity Planner depends upon the various sizes of Azure Stack Hub VMs. VMs range in size from the smallest, Basic 0, up to the largest, Standard_Fsv2. You can model computing resource allocations in two different ways:

- Select a specific hardware offering, and see which combinations of various resources fit. 

- Create a specific combination of VM allocations, and let Azure Resource Calculator show which available hardware SKUs are capable of supporting this VM configuration.

This tool provides two methods for allocating VM resources: either as one single collection of VM resource allocations, or as a collection of up to six differing workload configurations. Each workload configuration can contain a different allocation of available VM resources. The next sections have step-by-step instructions to create and use each of these allocation models. Only values contained in non-background shaded cells, or within SKU pull-down lists on this worksheet, should be modified. Changes made within shaded cells might break resource calculations.


## DefineByVMFootprint instructions
To create a model by using a single collection of various sizes and quantities of VMs, select the **DefineByVMFootprint** tab, and follow these steps:

1. In the upper right corner of this worksheet, use the provided pull-down list box controls to select an initial number of servers (between 4 and 16) that you want installed in each hardware system (SKU). This number of servers can be modified at any time during the modeling process to see how this affects overall available resources for your resource allocation model.
2. If you want to model various VM resource allocations against one specific hardware configuration, find the blue pull-down list box directly below the **Current SKU** label in the upper right corner of the page. Pull down this list box, and select your desired hardware SKU.
3. You're now ready to begin adding various sized VMs to your model. To include a particular VM type, enter a quantity value into the blue outlined box to the left of that VM entry.

   > [!NOTE]
   > Total VM Storage refers to the total capacity of the data disk of the VM (the number of supported disks multiplied by the maximum capacity of a single disk [1 TB]). Based on the configuration indicators, we've populated the Available Storage Configurations table, so you can choose your desired level of storage resource for each Azure Stack Hub VM. However, it's important to note that you can add or change the Available Storage Configurations table as necessary.<br><br>Each VM starts with an initially assigned local temp storage. To reflect the thin provisioning of temp storage, you can change the local-temp number to anything in the drop-down menu, including the maximum allowable temp storage amount.

4. As you add VMs, you'll see the charts that show available SKU resources changing. This allows you to see the effects of adding various sizes and quantities of VMs during the modeling process. Another way to view the effect of changes is to watch the **Consumed** and **Still Available** numbers, listed directly below the list of available VMs. These numbers reflect estimated values based on the currently selected hardware SKU.
5. When you've created your set of VMs, you can find the suggested hardware SKU by selecting **Suggested SKU**, in the upper right corner of the page, directly below the **Current SKU** label. Using this button, you can then modify your VM configurations and see which hardware supports each configuration.


## DefineByWorkloadFootprint instructions
To create a model by using a collection of Azure Stack Hub workloads, select the **DefineByWorkloadFootprint** tab, and follow this sequence of steps. You create Azure Stack Hub workloads by using available VM resources.   

> [!TIP]
> To change the provided storage size for an Azure Stack Hub VM, see the note from step three in the preceding section.

1. In the upper right corner of this worksheet, use the provided pull-down list box controls to select an initial number of servers (between 4 and 16) that you want installed in each hardware system (SKU).
2. If you want to model various VM resource allocations against one specific hardware configuration, find the blue pull-down list box directly below the **Current SKU** label in the upper right corner of the page. Pull down this list box, and select your desired hardware SKU.
3. Select the appropriate storage size for each of your desired Azure Stack Hub VMs on the **DefineByVMFootprint** page, as described in step three of the previous section. The storage size per VM is defined in the DefineByVMFootprint sheet.
4. Starting on the upper left of the **DefineByWorkloadFootprint** page, create configurations for up to six different workload types. Enter the quantity of each VM type contained within that workload. You do this by placing numeric values into the column directly below that workload's name. You can modify workload names to reflect the type of workloads that will be supported by this particular configuration.
5. You can include a particular quantity of each workload type by entering a value at the bottom of that column, directly below the **Quantity** label.
6. When you've created workload types and quantities, select **Suggested SKU** in the upper right corner of the page, directly below the **Current SKU** label. This displays the smallest SKU with sufficient resources to support this overall configuration of workloads.
7. You can accomplish further modeling by modifying the number of servers selected for a hardware SKU, or changing the VM allocations or quantities within your workload configurations. The associated graphs display immediate feedback, showing how your changes affect the overall resource consumption.
8. When you're satisfied with your changes, select **Suggested SKU** again to display the SKU suggested for your new configuration. You can also select the drop-down menu to select your desired SKU.

## Next steps
Learn about [datacenter integration considerations for Azure Stack Hub](azure-stack-datacenter-integration.md).
