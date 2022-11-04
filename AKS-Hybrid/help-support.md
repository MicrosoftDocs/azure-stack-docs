---
title: Concepts - Get support for AKS hybrid
description: Learn about how to get support and open a support request for AKS hybrid.
ms.topic: conceptual
ms.date: 11/03/2022
ms.custom: fasttrack-edit
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: mikek
author: sethmanheim
# Intent: As an IT Pro, I want to find out what options are available to get help and support, such as creating a ticket.
# Keyword: AKS support AKS help support requests
---

# Get support for AKS hybrid

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

If you encounter an issue with AKS hybrid, this article describes how to open a support request.

[!INCLUDE [aks-hybrid-description](includes/aks-hybrid-description.md)]

## Go to Help + support in the Azure portal

1. Log into the [Azure portal](https://portal.azure.com).
2. Browse to the subscription you are using for Azure Kubernetes Services on Azure Stack HCI.
3. Under Azure services section, select the **Help + support** icon:

    ![Screenshot of the Azure portal Help and Support icon.](media/support/help-support-icon.png)

   Or, you can go to **Support + troubleshooting** from a resource menu in the left-hand pane:

    ![Screenshot of the Azure portal Help and Support sidebar.](media/support/new-support-request-sidebar.png)

4. Select the **New Support Request** option.
 
5. Add a short description of your issue in the **Summary** field, and under **Issue** type, select **Technical**:

    ![Screenshot showing how to add a description of a technical issue on the Basics tab of a support request.](media/support/basics-page.png)
 
6. Select the appropriate subscription from the dropdown menu, and then change the **Service** type to **All services**. Begin typing _Azure Kubernetes Service_ in the search box to locate the **Azure Kubernetes Service on Azure Stack HCI service**<!--Will this option label change for AKS hybrid?--> under **Compute**:

    ![Screenshot of the Basics pane for a support request with the AKS on Azure Stack HCI product selected.](media/support/basic-select-service.png)
 
7. Select the appropriate **Problem** type from the dropdown menu for your issue (for example, Kubernetes), and then select the **Next: Solutions** button at the bottom left of the screen:

    ![Screenshot showing how to select the Kubernetes problem type on the Basics tab for a support request.](media/support/basics-problem-type.png)

8. Review the provided **Recommended Article(s)** to determine if they address your issue. If not, select the **Next: Details** button at the bottom left of the screen. 

    ![Screenshot showing Recommended Articles on the Solutions tab for a support request.](media/support/solutions-page.png)

9. If the solutions are not applicable, complete the remainder of the information on the **Details** page.

    ![Screenshot showing the Details tab for a support request.](media/support/service-request-details.png)

    Then, select **Review + create** at the bottom of the support request to review and create the request for support:

    ![Screenshot showing the Support Method summary for a support request. The Review Plus Create button is highlighted.](media/support/service-request-support-method.png)

## Next steps

- [Review support policies for AKS hybrid](./support-policies.md).