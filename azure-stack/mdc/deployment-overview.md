---
title: Modular Data Center (MDC) deployment overview and set up for the Azure Stack Hub Hardware Lifecycle Host (HLH) management server| Microsoft Docs
description: Learn what to expect for a successful on-site deployment of a Modular Data Center (MDC), from planning to post-deployment.
services: azure-stack
documentationcenter: ''
author: asganesh
manager: femila
editor: ''

ms.assetid: 
ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 10/20/2020
ms.author: justinha
ms.reviewer: asganesh
ms.lastreviewed: 10/20/2020
---
 
# MDC deployment overview

This deployment guide describes the steps to install and configure a Modular Data Center (MDC). 
This guide also describes the automated process for setting up the Azure Stack Hub Hardware Lifecycle Host (HLH) management server for the Azure Stack Hub deployment.

The objectives of this guide include:

- Provide a pre-deployment checklist to verify that all prerequisites have been met before installation of the components.
- Introduce the key components of a MDC.
- Describe how to install and configure the key components.
- Validate the customer deployment.

Technical experience with virtualization, servers, operating systems, networking, and storage solutions is required to fully understand the content of this guide. 
The Deployment Engineer must have knowledge of Microsoft Windows Server 2019 with Hyper-V, Azure Stack Hub, Azure, and Microsoft PowerShell.

This guide focuses on deployment of core components of Microsoft Azure Stack Hub, and the specifics of the MDC solution. 
The guide does not explain the operating procedures of Azure Stack Hub and does not cover all the features available in Azure Stack Hub. 
For more information, see [Azure Stack Hub Operator's Guide](https://docs.microsoft.com/azure-stack/operator/).

## Introduction

The MDC is an integrated offering for Azure Stack Hub packaged in a standard 40-foot metal shipping container. 
The container includes a climate control unit, lighting and alerting system. 
The core Azure Stack Hub components, such as servers and switches, are installed in six physical racks that are logically organized in three independent pods.

Each pod consists of two 42U racks. A pod includes the top-of-rack (ToR) switches, edge switches, and a baseboard management controller (BMC) switch. Additionally, each pod includes a hardware lifecycle host (HLH) and a serial port concentrator. 
Core compute and storage capacity is provided by Azure Stack Hub scale units (SU) consisting of eight Rugged Edge Appliance (REA) R840 servers. Additional storage capacity is provided by 48 Isilon storage nodes. Physical configuration of all pods is identical.

## Terminology

The following table lists some of the terms used in this guide.

|Term    |Definition |
|-------|-----------|
|Hardware Lifecycle Host (HLH)|    HLH is the physical server that is used for initial deployment bootstrap as well as ongoing hardware management, support, and backup of Azure Stack Hub infrastructure. HLH runs Windows Server 2019 with Desktop Experience and Hyper-V role. The server is used to host hardware management tools, switch management tools, Azure Stack Hub Partner Toolkit, and the deployment virtual machine. |
|Deployment virtual machine (DVM)|    DVM is a virtual machine that is created on the HLH for the duration of Azure Stack Hub software deployment. The DVM runs Azure Stack Hub software orchestration engine called the Enterprise Cloud Engine (ECE) to install and configure Azure Stack Hub fabric infrastructure software on all Azure Stack Hub scale unit servers over the network.|
|Azure Stack Hub Partner Toolkit|    A collection of software tools used to capture customer-specific input parameters and initiate installation and configuration of Azure Stack Hub. It includes the deployment worksheet, which is a Graphical User Interface (GUI) tool used for capturing and storing configurable parameters for Azure Stack Hub installation. It also includes the network configuration generator tool that uses deployment worksheet inputs to produce network configuration files for all physical network devices in the solution.|
|OEM Extension Package    |A package of firmware, device drivers, and hardware management tools in a specialized format used by Azure Stack Hub during initial deployment and update.|
|Serial port concentrator    |A physical device installed in each pod that provides network access to serial ports of network switches for deployment and management purposes.|
|Scale unit    |A core component of Azure Stack Hub that provides compute and storage resources to Azure Stack Hub fabric infrastructure and workloads. Each pod includes eight MDC R840 servers also called nodes.|
|Isilon storage |    An Azure Stack Hub component that is specific to the MDC solution. Isilon provides additional blob and file storage for Azure Stack Hub workloads. Each pod includes 48 Isilon storage nodes.|
|Pod    |In the context of MDC, a pod is an independent logical unit consisting of two interconnected physical racks. A complete solution includes three pods installed in a single container.|





## Deployment workflow

At a high level, the MDC deployment process consists of the following steps:

1. Planning phase:
   1. Planning for datacenter power.
   1. Planning for logical network configuration of Azure Stack Hub.
   1. Planning for datacenter network integration.
   1. Planning for identity and security integration.
   1. Planning for PKI certificates.
1. Preparation phase:
   1. Collecting inventory.
   1. Connecting power and powering on the solution.
   1. Validating HVAC system health.
   1. Validating fire monitoring and alerting system health.
   1. Validating physical hardware health.
1. Execution phase – separately for each of the three pods:
   1. Configuring the hardware lifecycle host.
   1. Configuring network switches.
   1. Datacenter network integration.
   1. Configuring physical hardware settings.
   1. Configuring Isilon storage.
   1. Deploying Azure Stack Hub fabric infrastructure.
   1. Datacenter identity integration.
   1. Installing add-ons for extended functionality.
1. Validation phase – separately for each of the three pods:
   1. Post-deployment health validation.
   1. Registering Azure Stack Hub with Microsoft.
   1. Azure Stack Hub operator hand-off.
  
Each of the above topics is explained in detail further in this guide.
