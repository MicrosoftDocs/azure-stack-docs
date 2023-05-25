---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 05/25/2023
---


## Download the VHDX file

SDN uses a VHDX file containing either the Azure Stack HCI or Windows Server operating system (OS) as a source for creating the SDN virtual machines (VMs). The version of the OS in your VHDX must match the version used by the Azure Stack HCI Hyper-V hosts. This VHDX file is used by all SDN infrastructure components.

You can download the Azure Stack HCI VHDX file from the [Azure Stack HCI software download site](https://azure.microsoft.com/contact/azure-stack-hci/). Complete the download form and select **Submit** to display the **Azure Stack HCI software download** page. To download the VHDX file, under **Azure Stack HCI**, select **English – VHDX** from the **Choose language** dropdown menu, and then select **Download Azure Stack HCI**.

:::image type="content" source="./media/sdn/download-vhdx.png" alt-text="Screenshot of the Azure Stack HCI software download page showing the option to download the VHDX file." lightbox="./media/sdn/download-vhdx.png":::

Currently, non-English VHDX file is not available for download. If you require a non-English version, download the corresponding ISO file and convert it into VHDX using the `Convert-WindowsImage` cmdlet. The following is an example of using `Convert-WindowsImage`:

```powershell
Install-Module -Name Convert-WindowsImage
Import-Module Convert-WindowsImage

$wimpath = "E:\sources\install.wim"
$vhdpath = "D:\temp\AzureStackHCI.vhdx"
$edition=1
Convert-WindowsImage -SourcePath $wimpath -Edition $edition -VHDPath $vhdpath -SizeBytes 500GB -DiskLayout UEFI
```

> [!NOTE]
> You must run this script from a Windows client computer. You will probably need to run this as Administrator and to modify the execution policy for scripts using the Set-ExecutionPolicy command.