---
title: Deploy an Azure Stack HCI system using the Azure portal
description: Learn how to deploy an Azure Stack HCI system from the Azure portal
author: JasonGerend
ms.topic: how-to
ms.date: 11/11/2023
ms.author: jgerend
#CustomerIntent: As an IT Pro, I want to deploy an Azure Stack HCI system of 1-16 nodes via the Azure portal so that I can host VM and container-based workloads on it.
---

# Deploy an Azure Stack HCI, version 23H2 Preview system using the Azure portal

This article helps you deploy an Azure Stack HCI, version 23H2 Preview system using the Azure portal, assuming that you've already connected each server to Azure Arc.

To instead deploy Azure Stack HCI, version 22H2, see [Create an Azure Stack HCI cluster using Windows Admin Center](create-cluster.md).

## Prerequisites

* Azure account with an active subscription. Use the link [Create an account for free](https://azure.microsoft.com/free/?WT.mc_id=A261C142F).
* Completion of [Connect servers to Arc](connect-to-arc.md)

## Start the wizard and fill out the basics

First you must 

1. Open the Azure portal and navigate to the Azure Stack HCI service and then select **Deploy**.

   The Azure search box is an easy way to find the service.
2. Enter the subscription and resource group in which to store this system's resources.

   All resources in the Azure subscription are billed together.
3. Enter the cluster name used for this Azure Stack HCI system when Active Directory Domain Services (AD DS) was prepared for this deployment.
4. Select the Azure region to store this system's Azure resources—in this preview you must use either **EastUS** or **Western Europe**.

   We don't transfer a lot of data so it's OK if the region isn't very close.
5. Select or create an empty key vault to securely store secrets for this system, such as cryptographic keys, local admin credentials, and BitLocker recovery keys.
6. Select the server or servers you want to deploy.

## Specify the deployment settings

## Specify network settings

## Specify management settings

## Set the security level

## Optionally change advanced settings and apply tags

Tags are name/value pairs you can use to categorize resources. You can then view consolidated billing for all resources with a given tag. Learn more

Note that if you create tags and then change resource settings on other tabs, your tags are automatically updated.


## Validate and deploy the system

## Next stp

> [!div class="nextstepaction"]
> [Validate your system](foo.md)