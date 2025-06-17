---
title:  Azure Local security book trusted launch
description: Trusted launch for the Azure Local security book.
author: alkohli
ms.topic: conceptual
ms.date: 06/16/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Trusted launch for Azure Local VMs enabled by Azure Arc

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

Trusted launch for Azure Local VMs enabled by Azure Arc supports secure boot, virtual Trusted Platform Module (vTPM), and vTPM state transfer when a VM migrates or fails over within a system. You can choose Trusted launch as a security type when creating Azure Local VMs via Azure portal or Azure CLI. For more information, see [Trusted launch for Azure Local VMs enabled by Azure Arc](../manage/trusted-launch-vm-overview.md).
 
With standard VMs, vTPM state is not preserved when a VM migrates or fails over to another machine. This limits functionality and availability of applications that rely on the vTPM and its state. With Trusted launch, vTPM state is automatically moved along with the VM, when a VM migrates or fails over to another machine within a system. This allows applications that rely on the vTPM state to continue to function normally even as the VM migrates or fails over. Applications use TPM in a variety of ways. In general, any application that relies on the TPM will benefit from Trusted launch capabilities. For more information, read the blog post [Trusted launch for Azure Local VMs](https://techcommunity.microsoft.com/blog/microsoft-security-blog/trusted-launch-for-azure-arc-vms-on-azure-stack-hci/3978051). 


## Related content

- Continuous monitoring
