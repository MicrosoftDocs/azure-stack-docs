---
title: Azure Kubernetes Service on Azure Stack HCI requirements
description: The prerequisites for using Azure Kubernetes Service on Azure Stack HCI.
author: davannaw-msft
ms.topic: article
ms.date: 09/01/2020
ms.author: dawhite
---

# Azure Kubernetes Service on Azure Stack HCI requirements

Before you begin setting up Azure Kubernetes Service on Azure Stack HCI, make sure your system meets the prerequisites for cluster creation.

## On your Windows Admin Center system
The machine running the Windows Admin Center gateway must:
* Have 40 GB of free space to store downloaded packages
* [Be registered with Azure](..\hci\manage\register-windows-admin-center.md)

## On your network
For public preview, we recommend that your Windows Admin Center system and your target machines are in the same domain. 

If you plan on deploying Azure Kubernetes Service on Azure Stack HCI on a single node, you will need to provide your own server and have it configured in Windows Admin Center prior to cluster creation. Similarly, if you are planning on deploying your Azure Kubernetes Service for Azure Stack HCI cluster on top of an existing cluster, it must already be configured through Windows Admin Center before starting the cluster creation wizard. 

## Next steps
After you have satisfied all of the prerequisites above, you can set up Azure Kubernetes Service on Azure Stack HCI using [PowerShell](\quickstart-setup-ps) or [Windows Admin Center](\quickstart-setup-wac). 