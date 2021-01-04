---
title: Azure Stack Hub ruggedized deployment and set up for the Azure Stack Hub Hardware Lifecycle Host (HLH) management server | Microsoft Docs
description: Learn what to expect for a successful on-site deployment of a Azure Stack Hub ruggedized, from planning to post-deployment.
services: azure-stack
documentationcenter: ''
author: ashika789
manager: femila
editor: ''

ms.assetid: 
ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 10/14/2020
ms.author: patricka
ms.reviewer: asganesh
ms.lastreviewed: 10/14/2020
---
 
# Azure Stack Hub ruggedized deployment overview

This deployment guide describes the steps to install and configure Azure Stack Hub ruggedized. 

The objectives of this guide include:

- Provide a pre-deployment checklist to verify that all prerequisites have been met before installation of the components.
- Introduce the key components of Azure Stack Hub ruggedized.
- Describe how to install and configure the key components.
- Validate the customer deployment.

This deployment guide is intended for the Microsoft field professional team that is responsible for deployment of Azure Stack Hub ruggedized at a customer site.

Technical experience with virtualization, servers, operating systems, networking, and storage solutions is required to fully understand the content of this guide. 
The Deployment Engineer must have knowledge of Microsoft Windows Server 2019 with Hyper-V, Azure Stack Hub, Azure, and Microsoft PowerShell.

This guide focuses on deployment of core components of Microsoft Azure Stack Hub, and the specifics of the Azure Stack Hub ruggedized solution. 
The guide does not explain the operating procedures of Azure Stack Hub and does not cover all the features available in Azure Stack Hub. 
For more information, see [Azure Stack Hub Operator Guide](https://docs.microsoft.com/azure-stack/operator/).

## Introduction

Azure Stack Hub ruggedized is a ruggedized and field-deployable offering for Microsoft Azure Stack Hub. 
The core components, such as servers and switches, are contained in transit cases called pods.

A pod is a 4U rack container that has smaller dimensions than a regular 4U rack. 
There is one management pod and two scale unit (SU) pods. 
The management pod includes the hardware lifecycle host (HLH), two 25 GbE top-of-rack (ToR) switches, and a baseboard management controller (BMC) switch.

Each SU pod holds two Azure Stack Hub ruggedized R640 SU servers. 
One R640 server occupies a 2U rack space in the pod. 
During deployment, the servers in the SU pods are connected to BMC and ToR switches in the management pod.

## Terminology

The following table lists some of the terms used in this guide.

|Term	| Definition |
|-------|------------|
|Hardware Lifecycle Host (HLH)|	HLH is the physical server that is used for initial deployment bootstrap as well as ongoing hardware management, support, and backup of Azure Stack Hub infrastructure. HLH runs Windows Server 2019 with Desktop Experience and Hyper-V role. The server is used to host hardware management tools, switch management tools, Azure Stack Hub Partner Toolkit, and the deployment virtual machine. |
|Deployment virtual machine (DVM)|	DVM is a virtual machine that is created on the HLH for the duration of Azure Stack Hub software deployment. The DVM runs Azure Stack Hub software orchestration engine called the Enterprise Cloud Engine (ECE) to install and configure Azure Stack Hub fabric infrastructure software on all Azure Stack Hub scale unit servers over the network.|
|Azure Stack Hub Partner Toolkit|	A collection of software tools used to capture customer-specific input parameters and initiate installation and configuration of Azure Stack Hub. It includes the deployment worksheet, which is a Graphical User Interface (GUI) tool used for capturing and storing configurable parameters for Azure Stack Hub installation. It also includes the network configuration generator tool that uses deployment worksheet inputs to produce network configuration files for all physical network devices in the solution.|
|OEM Extension Package	|A package of firmware, device drivers, and hardware management tools in a specialized format used by Azure Stack Hub during initial deployment and update.|
|Integrated Dell Remote Access Controller (iDRAC)|	An iDRAC with Lifecycle Controller is a baseboard management controller embedded in every Azure Stack Hub ruggedized R640 server. iDRAC provides out-of-band management functionality to help deploy, update, monitor, and maintain Azure Stack Hub servers.|
|Scale unit	|A core component of Azure Stack Hub that provides compute and storage resources to Azure Stack Hub fabric infrastructure and workloads. Consists of four Azure Stack Hub ruggedized R640 servers (also called nodes) and can be dynamically scaled to up to 16 nodes.|
|Pod	|In context of Azure Stack Hub ruggedized, a pod is a physical rugged container designed to be carried by two people that contains rack mounting brackets and shock absorbers to protect Azure Stack Hub ruggedized hardware from environmental physical stress. Includes front and back transit case covers that can be installed and sealed for transporting the hardware. A complete solution in minimum configuration includes three pods.|


## Deployment overflow

At a high level, the Azure Stack Hub ruggedized deployment process consists of the following steps.

1. Planning phase:
   1. Planning for datacenter power and cooling.
   1. Planning for logical network configuration of Azure Stack Hub.
   1. Planning for datacenter network integration.
   1. Planning for identity and security integration.
   1. Planning for PKI certificates.
1. Preparation phase:
   1. Unboxing and collecting inventory.
   1. Connecting power and powering on the solution.
   1. Validating physical hardware health.
1. Execution phase:
   1. Configuring the hardware lifecycle host.
   1. Configuring network switches.
   1. Datacenter network integration.
   1. Configuring physical hardware settings.
   1. Deploying Azure Stack Hub fabric infrastructure.
   1. Datacenter identity integration.
   1. Installing add-ons for extended functionality.
1. Validation phase:
   1. Post-deployment health validation.
   1. Registering Azure Stack Hub with Microsoft.
   1. Azure Stack Hub operator hand-off.
   
Each of the above topics is explained in detail further in this guide.
