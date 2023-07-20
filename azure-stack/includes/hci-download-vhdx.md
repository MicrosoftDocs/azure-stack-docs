---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 07/20/2023
---


SDN uses a VHDX file containing either the Azure Stack HCI or Windows Server operating system (OS) as a source for creating the SDN virtual machines (VMs).

> [!NOTE]
> The version of the OS in your VHDX must match the version used by the Azure Stack HCI Hyper-V hosts. This VHDX file is used by all SDN infrastructure components.

Follow these steps to download an English version of the VHDX file:

1. [Download the Azure Stack HCI operating system from the Azure portal](../deploy/download-operating-system.md). Make sure to select **English - VHDX** from the **Choose language** dropdown list.

Currently, a non-English VHDX file is not available for download. If you require a non-English version, download the corresponding ISO file and convert it to VHDX using the `Convert-WindowsImage` cmdlet. You must run this script from a Windows client computer. You will probably need to run this as Administrator and modify the execution policy for scripts using the `Set-ExecutionPolicy` command.

The following is an example of using `Convert-WindowsImage`:

```powershell
Install-Module -Name Convert-WindowsImage
Import-Module Convert-WindowsImage

$wimpath = "E:\sources\install.wim"
$vhdpath = "D:\temp\AzureStackHCI.vhdx"
$edition=1
Convert-WindowsImage -SourcePath $wimpath -Edition $edition -VHDPath $vhdpath -SizeBytes 500GB -DiskLayout UEFI
```