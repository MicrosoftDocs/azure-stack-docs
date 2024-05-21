---
author: ronmiab
ms.author: robess
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 05/15/2024
---

Follow these steps on your Azure Stack HCI cluster to create the VM image from the VHDX that you created earlier.

Use Azure CLI to create the VM image:

1. Run PowerShell as an administrator.

2. Sign in. Run the following cmdlet:

    ```azurecli
    az login
    ```

3. Set your subscription. Run the following cmdlet:

    ```azurecli
    az account set --subscription <Subscription ID>
    ```

4. Set parameters for your subscription, resource group, custom location, location, OS type for the image, name of the image, and the path where the image is located. Replace the parameters in `< >` with the appropriate values.

    ```azurecli
    $Subscription = "<Subscription ID>"
    $Resource_Group = "<Resource group>"
    $CustomLocation = "<Custom location>"
    $Location = "<Location for your Azure Stack HCI cluster>"
    $OsType = "<OS of source image>"
    ```

    Parameters are described in the following table:

    | Parameter      | Description                                                                                |
    |----------------|--------------------------------------------------------------------------------------------|
    | `Subscription`   | Subscription associated with your Azure Stack HCI cluster.        |
    | `Resource_Group` | Resource group for Azure Stack HCI cluster that you associate with this image.        |
    | `Location`       | Location for your Azure Stack HCI cluster. For example, this could be `eastus`, `westreurope`. |
    | `OsType`         | Operating system associated with the source image. This can be Windows or Linux.           |

5. Use the VHDX of the VM to create a gallery image. Use this VM image to create Arc virtual machines on your Azure Stack HCI.

    Make sure to copy the VHDX in user storage in the cluster shared volume of your Azure Stack HCI. For example, the path could look like: `C:\ClusterStorage\UserStorage_1\linuxvhdx`.

    ```powershell
    $ImagePath = "Path to user storage in CSV" 

    $ImageName = "mylinuxvmimg" 

    az stack-hci-vm image create --subscription $subscription -g $resource_group --custom-location $CustomLocation --location $location --image-path $ImagePath --name $ImageName --debug --os-type 'Linux' 
    ```

6. Verify that the image is created.
