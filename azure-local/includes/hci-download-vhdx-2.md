---
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.topic: include
ms.date: 05/29/2025
---

SDN uses a VHDX file containing either the Azure Stack HCI or Windows Server operating system (OS) as a source for creating the SDN virtual machines (VMs).

> [!NOTE]
> The version of the OS in your VHDX must match the version used by the Azure Local Hyper-V machines. This VHDX file is used by all SDN infrastructure components.

[Download an English-language version of the VHDX file](https://aka.ms/PVvxVBVCVVC).

Currently, a non-English VHDX file isn't available for download. If you require a non-English version, [download the corresponding ISO file](../deploy/download-23h2-software.md) and convert it to VHDX using the `Convert-WindowsImage` cmdlet. You must run this script from a Windows client computer. You'll probably need to run this script as Administrator and modify the execution policy for scripts using the `Set-ExecutionPolicy` command.

The following syntax shows an example of using `Convert-WindowsImage`:

```powershell
Install-Module -Name Convert-WindowsImage
Import-Module Convert-WindowsImage

$wimpath = "E:\sources\install.wim"
$vhdpath = "D:\temp\AzureStackHCI.vhdx"
$edition=1
Convert-WindowsImage -SourcePath $wimpath -Edition $edition -VHDPath $vhdpath -SizeBytes 500GB -DiskLayout UEFI
```
