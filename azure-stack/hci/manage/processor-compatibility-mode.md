---
title: Processor compatibility mode in Azure Stack HCI
description: The processor compatibility mode in Azure Stack HCI has been updated to take advantage of new processor capabilities in a clustered environment.
author: khdownie
ms.author: v-kedow
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 05/11/2021
---

# Processor compatibility mode in Azure Stack HCI

> Applies to: Azure Stack HCI, version 20H2 **Alvin: Does this also apply to WS19? what about WS22/HCIv2?**

The processor compatibility mode in Azure Stack HCI has been updated to take advantage of new processor capabilities in a clustered environment. Processor compatibility works by determining the supported processor features for each individual node in the cluster and calculating the common denominator across all processors. Virtual machines (VMs) will be configured to use the maximum number of features available across all nodes. This improves performance compared to the previous version of processor compatibility that defaulted to a minimal, fixed set of processor capabilities.

   > [!IMPORTANT]
   > Only Hyper-V VMs with the latest configuration version (10.0) will benefit from the dynamic configuration. VMs with older versions won't benefit from the dynamic configuration and will continue to use fixed processor capabilities from the previous version.

## When to use processor compatibility mode

Processor compatibility mode allows for moving a live VM (live migrating) or moving a VM that is saved between nodes with different process capability sets. Even when processor compatibility is enabled, you won't be able to move VMs between processor manufacturers. For example, you can't move running VMs or saved state VMs from a host with Intel processors to a host with AMD processors. If you must move a VM in this manner, shut the VM down first, then restart it on the new host.

We recommended that you enable processor compatibility mode for VMs running on Azure Stack HCI. This will provide the highest level of capabilities, and when it's time to migrate to other types of hardware, moving the VMs will not require downtime.

   > [!NOTE]
   > Processor compatibility mode isn't needed if you plan to stop and restart the VMs anyway.

## Why processor compatibility mode is needed

Processor manufacturers often introduce optimizations and capabilities in their processors. These capabilities often improve performance or security by using specialized hardware for a particular task. For example, many media applications use processor capabilities to speed up vector calculations. These features are rarely required for applications to run; they simply boost performance. 

The capability set that's available on a processor varies depending on its make, model, and age. Operating systems and application software typically enumerate the system’s processor capability set when they are first launched. Software does not expect the available processor capabilities to change during their lifetime, and of course, this could never happen when running on a physical computer because processor capabilities are static unless the processor is upgraded.

However, VM mobility features allow a running VM to be migrated to a new virtualization host. If software in the VM has detected and started using a particular processor capability, and the VM gets moved to a new virtualization host that lacks that capability, the software is likely to fail. This could result in the application or VM crashing.

To avoid failures, Hyper-V performs “pre-flight” checks whenever a VM live migration or save/restore operation is initiated. These checks compare the set of processor features that are available to the VM on the source host against the set of features that are available on the target host. If these feature sets don't match, the migration or restore operation is cancelled.

## What's new in processor capability mode

In the past, all new processor instructions sets were hidden, meaning that the guest operating system and application software could not take advantage of new processor instruction set enhancements.

To overcome this limitation, processor compatibility mode has been updated to provide enhanced capabilities on processors capable of second-level address translation (SLAT). In Azure Stack HCI environments, the new processor compatibility mode ensures that the set of processor features available to VMs across virtualization hosts will match by presenting a common capability set across all servers in the cluster. Each VM receives the maximum number of processor instruction sets that are present across all nodes. This process occurs automatically and is always enabled and replicated across the cluster, helping applications and VMs stay performant.

## How to use processor compatibility mode

Processor compatibility calculations occur automatically across all servers in the cluster, so there's no command to enable or disable the process.

## Minimum fixed CPU capabilities

The minimum fixed CPU capabilities are as follows: **Alvin: Is this supposed to be a table with corresponding values? Can/should we describe each one?**

- SSE3
- LAHF_SAHF
- SSSE3
- SSE4_1
- SSE4_2
- POPCNT
- CMPXCHG16B
- MMX_EXT
- RDTSCP
- IBRS
- IBPB
- MDD
- ALTMOVCR8
- NPIEP1
- VIRT_SPEC_CTRL 

## Using processor compatibility mode

There are a number of important concepts to understand when using processor compatibility mode with Hyper-V in Azure Stack HCI.

### When processor compatibility mode isn't needed

Processor compatibility mode isn't needed for clusters with the same processor. 


## Next steps

For more information, see also:

- ?
- ?