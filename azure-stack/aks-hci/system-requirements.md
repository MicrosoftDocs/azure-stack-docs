---
title: System requirements
description: The prerequisites for using Azure Kubernetes Service on Azure Stack HCI.
author: davannaw-msft
ms.topic: article
ms.date: 09/01/2020
ms.author: dawhite
---

# System Requirements

Before you begin setting up Azure Kubernetes Service for Azure Stack HCI, make sure your system meets the prerequisites for your desired cluster creation method.

## PowerShell
Insert text here.

## Windows Admin Center
Windows Admin Center is the user interface for creating and managing Azure Kubernetes Service on Azure Stack HCI. To use Windows Admin Center with Azure Kubernetes Service on Azure Stack HCI, you must meet all the criteria in the list below.

### On your Windows Admin Center system
The machine running the Windows Admin Center gateway must:
* Have 40 GB of free space to store downloaded packages
* [Be registered with Azure](https://docs.microsoft.com/windows-server/manage/windows-admin-center/azure/azure-integration)

### On your network
For public preview, it is recommended that your Windows Admin Center system and your target machines are in the same domain. 

If you plan on deploying Azure Kubernetes Service on Azure Stack HCI on a single node, you will need to provide your own server and have it configured in Windows Admin Center prior to cluster creation. Similarly, if you are planning on deploying your Azure Kubernetes Service for Azure Stack HCI cluster on top of an existing cluster, it must already be configured through Windows Admin Center before starting the cluster creation wizard. 

## Next steps
After you have satisfied all of the prerequisites above, you can set up Azure Kubernetes Service on Azure Stack HCI using [PowerShell](\quickstart-setup-ps) or [Windows Admin Center](\quickstart-setup-wac). 