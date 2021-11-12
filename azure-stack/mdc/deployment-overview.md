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
ms.date: 02/17/2021
ms.author: patricka
ms.reviewer: asganesh
ms.lastreviewed: 02/17/2021
---
 
# MDC requirements overview

This guide describes the requirements needed to install and configure a Modular Data Center (MDC). 

The objectives of this guide include:

- Provide a pre-deployment checklist to verify that all prerequisites have been met before installation of the components.
- Introduce the key components of a MDC.
- Validate the customer deployment.

Technical experience with virtualization, servers, operating systems, networking, and storage solutions is required to fully understand the content of this guide. 

This guide focuses on deployment of core components of Microsoft Azure Stack Hub, and the specifics of the MDC solution. 
The guide does not explain the operating procedures of Azure Stack Hub and does not cover all the features available in Azure Stack Hub. 

## Introduction

The MDC is an integrated offering for Azure Stack Hub packaged in a standard 40-foot metal shipping container. 
The container includes a climate control unit, lighting and alerting system. 
The core Azure Stack Hub components are installed as pods.

## Terminology

The following table lists some of the terms used in this guide.

|Term    |Definition |
|-------|-----------|
|Hardware Lifecycle Host (HLH)|    HLH is the physical server that is used for initial deployment bootstrap as well as ongoing hardware management, support, and backup of Azure Stack Hub infrastructure. HLH runs Windows Server 2019 with Desktop Experience and Hyper-V role. The server is used to host hardware management tools, switch management tools, Azure Stack Hub Partner Toolkit, and the deployment virtual machine. |
|Deployment virtual machine (DVM)|    DVM is a virtual machine that is created on the HLH for the duration of Azure Stack Hub software deployment. The DVM runs Azure Stack Hub software orchestration engine called the Enterprise Cloud Engine (ECE) to install and configure Azure Stack Hub fabric infrastructure software on all Azure Stack Hub scale unit servers over the network.|
|Azure Stack Hub Partner Toolkit|    A collection of software tools used to capture customer-specific input parameters and initiate installation and configuration of Azure Stack Hub. It includes the deployment worksheet, which is a Graphical User Interface (GUI) tool used for capturing and storing configurable parameters for Azure Stack Hub installation. It also includes the network configuration generator tool that uses deployment worksheet inputs to produce network configuration files for all physical network devices in the solution.|
|OEM Extension Package    |A package of firmware, device drivers, and hardware management tools in a specialized format used by Azure Stack Hub during initial deployment and update.|
|Serial port concentrator    |A physical device installed in each pod that provides network access to serial ports of network switches for deployment and management purposes.|
|Scale unit    |A core component of Azure Stack Hub that provides compute and storage resources to Azure Stack Hub fabric infrastructure and workloads.|
|Isilon storage |    An Azure Stack Hub component that is specific to the MDC solution. Isilon provides additional blob and file storage for Azure Stack Hub workloads. |
|Pod    |In the context of MDC, a pod is an independent logical unit consisting of two interconnected physical racks.|

## Deployment workflow

At a high level, the MDC deployment process consists of the following phases:

### Planning phase
1. Planning for datacenter power.
1. Planning for logical network configuration of Azure Stack Hub.
1. Planning for [datacenter network integration](../operator/azure-stack-network.md).
1. Planning for [identity](../operator/azure-stack-identity-overview.md) integration.
1. Planning for [security](../operator/azure-stack-security-foundations.md) integration.
1. Planning for [PKI certificates](../operator/azure-stack-pki-certs.md).

### Preparation phase
1. Collecting inventory.
1. Connecting power and powering on the solution.
1. Validating HVAC system health.
1. Validating fire monitoring and alerting system health.
1. Validating physical hardware health.

### Execution phase – separately for each of the three pods
1. Configuring the hardware lifecycle host.
1. Configuring network switches.
1. Datacenter network integration.
1. Configuring physical hardware settings.
1. Configuring Isilon storage.
1. Deploying Azure Stack Hub fabric infrastructure.
1. Datacenter identity integration.
1. Installing add-ons for extended functionality.

### Validation phase – separately for each of the three pods
1. Post-deployment health validation.
1. Registering Azure Stack Hub with Microsoft.
1. Azure Stack Hub customer hand-off.
