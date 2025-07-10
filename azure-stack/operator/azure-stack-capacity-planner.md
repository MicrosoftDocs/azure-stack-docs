---
title: Azure Stack Hub Capacity Planner 
description: Learn how to use the Azure Stack Hub Capacity Planner spreadsheet for deployments.
author: sethmanheim
ms.topic: how-to
ms.date: 01/16/2025
ms.author: sethm
ms.lastreviewed: 03/08/2021

# Intent: As an Azure Stack Hub operator, I want to learn how to use the Capacity Planner spreadsheet for deployments.
# Keyword: azure stack hub capacity planner spreadsheet

---


# Azure Stack Hub Capacity Planner

The Azure Stack Hub Capacity Planner is a spreadsheet that shows how different allocations of computing resources fit across a selection of hardware offerings.

## Worksheet descriptions

The following table describes each worksheet in the Azure Stack Hub Capacity Planner, which you can download from [https://aka.ms/azstackcapacityplanner](https://aka.ms/azstackcapacityplanner).

|Worksheet name|Description|
|-----|-----|
|Version-Disclaimer|Purpose of the calculator, version number, and release date.|
|Instructions|Step-by-step instructions to model capacity planning for a collection of virtual machines (VMs).|
|DefinedSolutionSKUs|Table with up to five hardware definitions. The entries are examples. Change the details to match system configurations under consideration.|
|DefineByVMFootprint|Find the appropriate hardware SKU by comparing configurations with different sizes and quantities of VMs.|
|DefineByWorkloadFootprint|Find the appropriate hardware SKU by creating a collection of Azure Stack Hub workloads.|

## DefinedSolutionSKUs instructions

This worksheet has up to six hardware definition examples. Change the details to match your system configurations.

### Hardware selections provided by authorized hardware partners

Azure Stack Hub is delivered as an integrated system with software installed by solution partners. Solution partners provide their own authoritative versions of Azure Stack Hub capacity planning tools. Use those tools for final discussions of solution capacity.

### Multiple ways to model computing resources

Resource modeling within the Azure Stack Hub Capacity Planner depends upon the various sizes of Azure Stack Hub VMs. VMs range in size from the smallest, **Basic 0**, up to the largest, **Standard_Fsv2**. You can also choose from three GPU models that are available in NVIDIA V100, NVIDIA T4 and AMD MI25 GPUs. You can model computing resource allocations in two different ways:

- Select a specific hardware offering and see which combinations of different resources fit.
- Create a specific combination of VM allocations and let Azure Resource Calculator show which available hardware SKUs can support this VM configuration.

This tool provides two methods for allocating VM resources: either as one single collection of VM resource allocations, or as a collection of up to six different workload configurations. Each workload configuration can contain a different allocation of available VM resources. The next sections have step-by-step instructions to create and use each of these allocation models. Only values contained in non-background shaded cells or within SKU pull-down lists on this worksheet should be modified. Changes made within shaded cells might break resource calculations.

## DefineByVMFootprint instructions

To create a model by using a single collection of various sizes and quantities of VMs, select the **DefineByVMFootprint** tab and follow these steps:

1. In the upper right corner of this worksheet, use the provided pull-down list box controls to select an initial number of servers (between 4 and 16) that you want installed in each hardware system (SKU). This number of servers can be modified at any time during the modeling process to see how this affects overall available resources for your resource allocation model.
1. If you want to model various VM resource allocations against one specific hardware configuration, find the blue pull-down list box directly below the **Current SKU** label in the upper right corner of the page. Pull down this list box and select your desired hardware SKU.
1. You're now ready to begin adding variously sized VMs to your model. To include a particular VM type, enter a quantity value into the blue outlined box to the left of that VM entry.

   > [!NOTE]
   > Total VM Storage refers to the total capacity of the data disk of the VM (the number of supported disks multiplied by the maximum capacity of a single disk [1 TB]). Based on the configuration indicators, we've populated the Available Storage Configurations table so you can choose your desired level of storage resource for each Azure Stack Hub VM. However, it's important to note that you can add or change the Available Storage Configurations table as necessary. <br><br>Each VM starts with an initially assigned local temp storage. To reflect the thin provisioning of temp storage, you can change the local-temp number to anything in the drop-down menu, including the maximum allowable temp storage amount.

1. As you add VMs, you see the charts that show available SKU resources changing. These charts allow you to see the effects of adding various sizes and quantities of VMs during the modeling process. Another way to view the effect of changes is to watch the **Consumed** and **Still Available** numbers, listed directly below the list of available VMs. These numbers reflect estimated values based on the currently selected hardware SKU.
1. If GPU VMs were selected in the DefinedSolutionSKUs tab then the selected GPU type will be available to enter quantity. Please note: ONLY GPU type selected in the DefinedSolutionSKUs tab will be available for capacity planning, any other GPU choices made will be ignored.    
1. When you've created your set of VMs, you can find the suggested hardware SKU by selecting **Suggested SKU**. This button is located in the upper right corner of the page, directly below the **Current SKU** label. Using this button, you can then modify your VM configurations and see which hardware supports each configuration.

## DefineByWorkloadFootprint instructions

To create a model by using a collection of Azure Stack Hub workloads, select the **DefineByWorkloadFootprint** tab and follow this sequence of steps. You create Azure Stack Hub workloads by using available VM resources.

> [!TIP]
> To change the provided storage size for an Azure Stack Hub VM, see the note from step 3 in the preceding section.

1. In the upper right corner of this worksheet, use the provided pull-down list box controls to select an initial number of servers (between 4 and 16) that you want installed in each hardware system (SKU).
1. If you want to model various VM resource allocations against one specific hardware configuration, find the blue pull-down list box directly below the **Current SKU** label in the upper right corner of the page. Pull down this list box and select your desired hardware SKU.
1. Select the appropriate storage size for each of your desired Azure Stack Hub VMs on the **DefineByVMFootprint** page. This process is described in step three of the previous section. The storage size per VM is defined in the DefineByVMFootprint sheet.
1. Starting on the upper left of the **DefineByWorkloadFootprint** page, create configurations for up to six different workload types. Enter the quantity of each VM type contained within that workload. You do this by placing numeric values into the column directly below that workload's name. You can modify workload names to reflect the type of workloads that will be supported by this particular configuration.
1. If you want to add GPU workloads here, add them to the Custom Workloads. Please note: ONLY GPU type selected in the DefinedSolutionSKUs tab will be available for capacity planning, any other GPU choices entered will be ignored.
1. You can include a particular quantity of each workload type by entering a value at the bottom of that column, directly below the **Quantity** label.
1. When you've created workload types and quantities, select **Suggested SKU** in the upper right corner of the page, directly below the **Current SKU** label. The smallest SKU with enough resources to support this overall configuration of workloads will display.
1. You can accomplish further modeling by modifying the number of servers selected for a hardware SKU or by changing the VM allocations or quantities within your workload configurations. The associated graphs display immediate feedback, showing how your changes affect the overall resource consumption.
1. When you're satisfied with your changes, select **Suggested SKU** again to display the SKU suggested for your new configuration. You can also select the drop-down menu to select your desired SKU.

## Next steps

Learn about [datacenter integration considerations for Azure Stack Hub](azure-stack-datacenter-integration.md).
