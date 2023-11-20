---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 11/20/2023
---

1. [Connect to a server](../hci/manage/azure-arc-vm-management-prerequisites.md#connect-to-the-cluster-directly) on your Azure Stack HCI system. 


1. Sign in. Type:

    ```azurecli
    az login --use-device-code
    ```

1. Set your subscription.

    ```azurecli
    az account set --subscription <Subscription ID>
    ```
