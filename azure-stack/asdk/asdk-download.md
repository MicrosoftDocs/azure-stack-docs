---
title: Download and extract the ASDK | Microsoft Docs
description: Learn how to download and extract the Azure Stack Development Kit (ASDK).
author: justinha

ms.service: azure-stack
ms.topic: article
ms.date: 05/06/2019
ms.author: justinha
ms.reviewer: misainat
ms.lastreviewed: 08/10/2018


---

# Download and extract the ASDK
After ensuring that your development kit host computer meets the basic requirements for installing the Azure Stack Development Kit (ASDK), the next step is to download and extract the ASDK deployment package to get the Cloudbuilder.vhdx.

## Download the ASDK
1. Before you start the download, make sure that your computer meets the following prerequisites:

   - Your computer must have at least 60 GB of free disk space available on four separate and identical logical hard drives in addition to the operating system disk.
   - [.NET Framework 4.6 (or a later version)](https://dotnet.microsoft.com/download/dotnet-framework-runtime/net46) must be installed.

2. [Go to the Get Started page](https://azure.microsoft.com/overview/azure-stack/try/?v=try) where you can download the ASDK, provide your details, and then click **Submit**.
3. Download and run the [Deployment Checker for ASDK](https://go.microsoft.com/fwlink/?LinkId=828735&clcid=0x409) prerequisite checker script. This standalone script goes through the prerequisite checks done by the setup for ASDK. It provides a way to confirm you're meeting the hardware and software requirements before downloading the larger package for ASDK.
4. Under **Download the software**, click **Azure Stack Development Kit**.

   > [!NOTE]
   > The ASDK download (AzureStackDevelopmentKit.exe) is approximately 10GB.

## Extract the ASDK
1. After the download completes, click **Run** to launch the ASDK self-extractor (AzureStackDevelopmentKit.exe).
2. Review and accept the displayed license agreement from the **License Agreement** page of the Self-Extractor Wizard and then click **Next**.
3. Review the privacy statement info displayed on the **Important Notice** page of the Self-Extractor Wizard and then click **Next**.
4. Select the location for Azure Stack setup files to be extracted to on the **Select Destination Location** page of the Self-Extractor Wizard and then click **Next**. The default location is *current folder*\Azure Stack Development Kit. 
5. Review the destination location summary on the **Ready to Extract** page of the Self-Extractor Wizard, and then click **Extract** to extract the CloudBuilder.vhdx (approximately 28GB) and ThirdPartyLicenses.rtf files. This process takes some time to complete.
6. Copy or move the CloudBuilder.vhdx file to the root of the C:\ drive (`C:\CloudBuilder.vhdx`) on the ASDK host computer.

> [!NOTE]
> After you extract the files, you can delete the .EXE and .BIN files to recover hard disk space. Or, you can back up these files so that you don't need to download the files again if you need to redeploy the ASDK.


## Next steps
[Prepare the ASDK host computer](asdk-prepare-host.md)