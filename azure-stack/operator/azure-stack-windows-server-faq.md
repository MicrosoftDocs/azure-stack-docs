---
title: Windows Server in Azure Stack Hub Marketplace FAQ
titleSuffix: Azure Stack Hub
description: List of Azure Stack Hub Marketplace FAQs for Windows Server.
author: sethmanheim
ms.topic: article
ms.date: 12/27/2019
ms.author: sethm
ms.reviewer: avishwan
ms.lastreviewed: 08/29/2019

---

# Windows Server in Azure Stack Hub Marketplace FAQ

This article answers some frequently asked questions about Windows Server images in the [Azure Stack Hub Marketplace](azure-stack-marketplace.md).

## Marketplace items

### How do I update to a newer Windows image?

First, determine if any Azure Resource Manager templates refer to specific versions. If so, update those templates, or keep older image versions. It's best to use **version: latest**.

Next, if any virtual machine scale sets refer to a specific version, you should think about whether these will be scaled later, and decide whether to keep older versions. If neither of these conditions apply, delete older images in Azure Stack Hub Marketplace before downloading newer ones. Use marketplace management to delete them if that's how the original was downloaded. Then download the newer version.

### What are the licensing options for Windows Server Marketplace images on Azure Stack Hub?

Microsoft offers two versions of Windows Server images through Azure Stack Hub Marketplace. Only one version of this image can be used in an Azure Stack Hub environment.  

- **Pay as you use**: These images run the full price Windows meters.
   Who should use this option: Enterprise Agreement (EA) customers who use the *Consumption billing model*; CSPs who don't want to use SPLA licensing.
- **Bring Your Own License (BYOL)**: These images run basic meters.
   Who should use this option: EA customers with a Windows Server license; CSPs who use SPLA licensing.

Azure Hybrid Use Benefit (AHUB) isn't supported on Azure Stack Hub. Customers who license through the "Capacity" model must use the BYOL image. If you're testing with the Azure Stack Development Kit (ASDK), you can use either of these options.

### What if I downloaded the wrong version to offer my tenants/users?

Delete the incorrect version first through marketplace management. Wait for it to complete (look at the notifications for completion, not the **Marketplace Management** blade). Then download the correct version.

If you download both versions of the image, only the latest version is visible to end customers in Azure Stack Hub Marketplace.

### What if my user incorrectly checked the "I have a license" box in previous Windows builds, and they don't have a license?

You can change the license model attribute to switch from bring your own license (BYOL) to the pay-as-you-go (PAYG) model by running the following script:

```powershell
$vm= Get-Azurermvm -ResourceGroup "<your RG>" -Name "<your VM>"
$vm.LicenseType = "None"
Update-AzureRmVM -ResourceGroupName "<your RG>" -VM $vm
```

You can check the license type of your VM by running the following commands. If the license model says **Windows_Server**, you'll be charged for the BYOL price, otherwise you'll be charged for the Windows meter per the PAYG model:

```powershell
$vm | ft Name, VmId,LicenseType,ProvisioningState
```

### What if I have an older image and my user forgot to check the "I have a license" box, or we use our own images and we do have Enterprise Agreement entitlement?

You can change the license model attribute to the bring your own license model by running the following commands:

```powershell
$vm= Get-Azurermvm -ResourceGroup "<your RG>" -Name "<your VM>"
$vm.LicenseType = "Windows_Server"
Update-AzureRmVM -ResourceGroupName "<your RG>" -VM $vm
```

### What about other VMs that use Windows Server, such as SQL or Machine Learning Server?

These images do apply the **licenseType** parameter, so they're pay as you use. You can set this parameter (see the previous FAQ answer). This only applies to the Windows Server software, not to layered products such as SQL, which require you to bring your own license. Pay as you use licensing doesn't apply to layered software products.

Note that you can only change the **licenseType** property for SQL Server images from Azure Stack Hub Marketplace if the version is XX.X.20190410 or higher. If you're running an older version of the SQL Server images from Azure Stack Hub Marketplace, you can't change the **licenseType** attribute and you must redeploy using the latest SQL Server images from Azure Stack Hub Marketplace.

### I have an Enterprise Agreement (EA) and will be using my EA Windows Server license; how do I make sure images are billed correctly?

You can add **licenseType: Windows_Server** in an Azure Resource Manager template. This setting must be added to each virtual machine (VM) resource block.

## Activation

To activate a Windows Server VM on Azure Stack Hub, the following conditions must be true:

- The OEM has set the appropriate BIOS marker on every host system in Azure Stack Hub.
- Windows Server 2012 R2 and Windows Server 2016 must use [Automatic VM Activation](/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn303421(v=ws.11)). Key Management Service (KMS) and other activation services aren't supported on Azure Stack Hub.

### How can I verify that my VM is activated?

Run the following command from an elevated command prompt:

```shell
slmgr /dlv
```

If it's correctly activated, you'll see this clearly indicated and the host name displayed in the `slmgr` output. Don't depend on watermarks on the display as they might not be up to date, or are showing from a different VM behind yours.

### My VM isn't set up to use AVMA, how can I fix it?

Run the following command from an elevated command prompt:

```shell
slmgr /ipk <AVMA key>
```

See the [Automatic VM Activation](/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn303421(v=ws.11)) article for the keys to use for your image.

### I create my own Windows Server images, how can I make sure they use AVMA?

It's recommended that you execute the `slmgr /ipk` command line with the appropriate key before you run the `sysprep` command. Or, include the AVMA key in any Unattend.exe setup file.

### I am trying to use my Windows Server 2016 image created on Azure and it's not activating or using KMS activation.

Run the `slmgr /ipk` command. Azure images may not correctly fall back to AVMA, but if they can reach the Azure KMS system, they will activate. It's recommended that you ensure these VMs are set to use AVMA.

### I have performed all of these steps but my VMs are still not activating.

Contact your hardware supplier to verify that the correct BIOS markers were installed.

### What about earlier versions of Windows Server?

[Automatic VM Activation](/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn303421(v=ws.11)) isn't supported in earlier versions of Windows Server. You must activate the VMs manually.

## Next steps

For more information, see the following articles:

- [The Azure Stack Hub Marketplace overview](azure-stack-marketplace.md)
- [Download marketplace items from Azure to Azure Stack Hub](azure-stack-download-azure-marketplace-item.md)
