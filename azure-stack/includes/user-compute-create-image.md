---
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: include
ms.date: 08/04/2020
ms.reviewer: thoroet
ms.lastreviewed: 08/04/2020
---

1. Open the **Azure Stack User Portal** link  and sign in using the **aadUserName** user

2. select the storage account used to host the VM image copied above and select the container which includes that VHD.

3. Set the container access level to public

    > [!Note]  
    > This is only for simplifying the exercise.

4. select the container and on the VHD copied - save the **URL** to the VHD

    > [!Note]  
    > This will be used later in the exercise

5. Open the **Azure Stack Admin Portal** link  and sign in using the **aadUserName** user

6. select **Region Management**, select **Compute**, select **VM Images**, and select **Add**

7. Complete the required fields with any values you wish and specify the OS data disk URI as the path to the VHD image copied earlier


8. The image will be creating which includes the copy of the VHD

    > [!Note]  
    > This might take a few minutes - make sure the image has a "succeeded" status before creating the VM (you can continue with the next steps to create the template, just don't start the VM creation before the VM image has a "succeeded" status)

9. Open the Azure Stack User Portal link  and sign in.

10. select **Create a resource** and select **Template deployment**

11. select **Template**, select **Quickstart templates**, and select the "101-vm-windows-create" template

12. Edit the template to use the **Publisher**, **Offer**, and **SKU** used to create the VM image earlier in the exercise

13. Complete the required Parameters - make sure the **WindowsVersion** corresponds to the **SKU** value defined above

    > [!Note]  The "windowsversion" parameter is used in the template itself. This could be changed to any other name for that parameter.

14. After the VM is provisioned browse to the VM resource and notice the size of the Disk and how it's configured

    > [!Note]  Also notice how the VM uses a nonmanaged disk (as opposed to creating the VM from the

    > [!Tip]  use a different template (which uses a windows image) to deploy different resources, using the same image.
