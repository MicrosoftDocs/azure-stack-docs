---
title: Changing languages in Azure Stack HCI
description: This topic provides guidance on how to change languages in the Azure Stack HCI operating system, Windows 10, Windows Admin Center, and Microsoft Edge.
author: JohnCobb1
ms.author: v-johcob
ms.topic: how-to
ms.date: 06/26/2020
---

# Changing languages in Azure Stack HCI

>Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

You can change your preferred language in Windows Admin Center, a management PC running Windows 10, Microsoft Edge, and the Azure Stack HCI operating system running on the servers that you manage. Windows Admin Center remains in your language of choice regardless of language changes in these other resources.

This article explains how to change the language in:

- Windows 10
- Windows Admin Center
- Microsoft Edge
- Server Core in the Azure Stack HCI operating system

## Change the language in the management PC running Windows 10
You can install a language pack to use for Windows 10, apps, and websites. You also can change your keyboard language, and set an input language in a language-preference order for websites and apps.

Changing either the language that you use in Windows 10 or the keyboard language does not affect the display language in Windows Admin Center.

   >[!IMPORTANT]
   > After changing your language in Windows 10, we recommend to set your preferred keyboard language as the default before signing out to avoid potential keyboard input issues.

To learn more, see [Manage the input and display language settings in Windows 10](https://support.microsoft.com/help/4496404/windows-10-manage-the-input-and-display-language).

## Change the language in Windows Admin Center
You can change the language in Windows Admin Center and the region format as needed according to your location. Changing either of these options in Windows Admin Center has no effect on the language setting of the management PC running Windows 10.

To change the language in Windows Admin Center:
1. On the **All connections** pane, select the **Settings** gear icon, and then under **Settings**, select **Language / Region**.
1. Expand the **Language** drop-down list to select your preferred language, and then expand the **Regional formate** drop-down list to select a different region if needed.
1. Select **Save and reload**.

    :::image type="content" source="media/language-region.png" alt-text="The Language / Region page in Windows Admin Center":::

To learn more, see [Windows Admin Center Settings](https://docs.microsoft.com/windows-server/manage/windows-admin-center/configure/settings).

## Change the language in Microsoft Edge
You can add supported languages to Microsoft Edge, and reorder your language preferences in the browser. You also can add a foreign language translator extension to the browser to get translations.

To learn more, see [Microsoft Edge language support](https://docs.microsoft.com/deployedge/microsoft-edge-supported-languages).

## Change the language in Server Core
There are a couple ways to change the language in Server Core of the Azure Stack HCI operating system. However, we recommend to change your language choice after clustering your servers. You can change the language and keyboard input method on a single server using the **Regional Settings** Control Panel tool. You can also change the language in Server Core using Windows PowerShell.

<!---Point to Dan's cluster creation topic using To learn more prompt here?.--->

To change the language in Windows Server Core:
1. Open an Administrator command prompt, type control `intl.cpl` and press Enter.

    The **Regional Settings** Control Panel tool displays.

1. Expand the **Format** tab drop-down list to change the Windows display language.

Select language preferences->Language->Add a language

To change the keyboard input method, Language->Spelling, typing & keyboard settings->under More keyboard settings->Advanced keyboard settings->can set Override for default input method->expand drop-down list to choose language.


To use Windows PowerShell to change the language in Windows Server Core:
1. 


<!---Example note format.--->
   >[!NOTE]
   > TBD.

## Next steps
For more information, see also:

<!---Confirm ToC location; currently from here to:--->

- [Add or remove servers for an Azure Stack HCI cluster](https://docs.microsoft.com/azure-stack/hci/manage/add-cluster)
