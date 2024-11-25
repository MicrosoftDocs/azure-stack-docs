---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.topic: include
ms.date: 10/25/2022
ms.reviewer: alkohli
---




1. Under **Tools**, scroll down to the **Networking** area, and select **Virtual machines**

1. Select the **Inventory** tab, select the VM, and then select **Settings**.

1. On the **Settings** page, select **Networks**.

1. For Isolation Mode, select **Logical Network**.

1. Select the **Logical network** and **Logical subnet** that you created earlier.

    1. For **Security level**, you have two options:
    
       1. **No Protection**: Choose this if you don't want any network access policies for your VMs.
       1. **Use existing NSG**: Choose this if you want to apply network access policies for your VMs. You can either create a new NSG and attach it to the VM or you can attach any existing NSG to the VM.