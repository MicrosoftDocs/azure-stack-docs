---
title: Known issues for Azure Stack HCI
description: This topic details known issues with Azure Stack HCI.
author: myoungerman
ms.author: v-myoung
ms.topic: troubleshooting
ms.date: 10/27/2020
---

# Known issues for Azure Stack HCI

>Applies to: Azure Stack HCI, version 20H2

This topic details known issues for Azure Stack HCI

- The October 20, 2020 Preview Update (KB4580388) may cause a Cluster Aware Updating (CAU) operation to fail if any of the virtual machines (VMs) are expected to perform Live Migration during CAU. To avoid this, change the default behavior temporarily so that CAU uses Quick Migration instead of Live Migration. See the [Release notes](release-notes.md#october-20-2020-preview-update-kb4580388) for more information.
- The connection between the on-premises cluster and the Azure Stack HCI cloud service doesn't yet support [Azure Private Link](https://azure.microsoft.com/services/private-link).
- The Azure Stack HCI cloud service is only available in select regions right now.
- When you log interactively into the operating system, the welcome screen that says “Welcome to Azure Stack HCI” is not yet localized in Czech, Hungarian, Nederland, Polish, Swedish and Turkish (locale codes cs-cz, hu-hu, nl-nl, pl-pl, pt-pt, sv-se, tr-tr). Furthermore, in all languages other than English, input prompts such as “[Y]es/[N]o” only accept values “Y” and “N”, even if the prompt itself misleadingly appears localized, such as [O]ui/[N]on in French or [J]a/[N]ein in German.
- If you evaluate Azure Stack HCI using nested virtualization, you may come across an error like “Hyper-V can't be installed because virtualization support isn't enabled” due to Azure Stack HCI’s dependency on virtualized-based security. There are two possible workarounds: (1) Use Hyper-V generation 1 VMs instead; or (2) inject the Hyper-V feature into the VM’s VHDX offline. From the host, run the following PowerShell command on each of the VMs that will act as Azure Stack HCI nodes while they're powered off: **Install-WindowsFeature -Vhd \<path> -Name Hyper-V, RSAT-Hyper-V-Tools, Hyper-V-Powershell**.
