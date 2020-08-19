---
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: include
ms.date: 08/04/2020
ms.reviewer: thoroet
ms.lastreviewed: 08/04/2020
---

For this next step, you will need a VHD which is sysprep'ed and prepared to be used as an image on Azure Stack. [There are multiple ways of creating this image](https://docs.microsoft.com/azure-stack/operator/azure-stack-add-vm-image), including using Azure VMs. If you are using Azure VMs, you can upload the syspreped VHD in a storage account and use it as below (if you are not, consider uploading the vhd on the ASDK on a storage account)

The following steps assume you have used an Azure VM and uploaded the prepared VHD in a public storage account name "storageaccount", using a container named "vhdimages"

In the ASDK, using AzCopy in a PowerShell window, download the image.

> [!Note]  
> If the vhd doesn't contain the MD5 data and if you run azcopy without the "--check-md5=NoCheck" option, it'll fail because the hash will not match.

```powershell  
.\\azcopy.exe copy "https://storageaccount.blob.core.windows.net/vdhimages/WS201920191230155433.vhd" "C:\\r" --check-md5=NoCheck
```

Create an image used in a single subscription:

1. Open the **Azure Stack User Portal** link  and sign in using the **aadUserName** user

2. Create a new **Storage Account** and a new **Container**

3. Create a new SAS token for this storage account and note it down

      > [!Note] For simplicity, leave all the permissions selected

4. Using AzCopy, upload the downloaded VHD into the new Container in the Storage Account

    > [!Note] Make sure to run:

    ```powershell
      $env:AZCOPY_DEFAULT_SERVICE_API_VERSION="2017-11-09"
    ```
      
      In the PowerShell window in order to enable azcopy to upload the file to AzStackHub
      
      Also make sure to add the "container" name in the SAS key created above (highlighted in the example on the right)

5. Click on **All Services**, **Images**, and create a new **Image**

6. Complete the required fields and select the vhd uploaded above

7. Once the image is created, use it to create a new VM (complete all the required fields as needed)

> [!Note]  
> After the VM is provisioned, notice the VHD size and how the image was created.