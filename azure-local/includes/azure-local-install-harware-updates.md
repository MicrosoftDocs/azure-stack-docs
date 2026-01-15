---
author: sipastak
ms.author: sipastak
ms.service: azure-local
ms.topic: include
ms.date: 06/06/2025
ms.reviewer: sipastak
---

There are several methods to install hardware updates for Azure Local depending on what your Azure Local instance supports.

- Solution Builder Extension
- Windows Admin Center
- Hardware vendor recommendation

### Solution Builder Extension

For systems that support Solution Builder Extensions:

- The appropriate Solution Builder Extension updates are automatically included when installing Azure Local Feature updates.
- The Solution Builder Extension updates can be installed separately (hardware updates can be installed without a combined Azure Local update).

### Windows Admin Center

If your hardware doesn't support the Solution Builder Extension update experience, the process for updating your hardware remains similar to the process used with Azure Local, version 22H2. This means that your hardware updates may be available using Windows Admin Center. For more information, see [Update Azure Local, version 22H2](/previous-versions/azure/azure-local/manage/update-cluster#install-operating-system-and-hardware-updates-using-windows-admin-center).

### Hardware vendor recommendation

Your firmware and driver updates may need to be performed separately, if your hardware doesn't support hardware updates using Solution Builder Extension packages or Windows Admin Center. Follow the recommendations of your hardware vendor.

To determine if your system supports solution builder extension and for details on installing hardware updates, see [About Solution Builder Extension software updates](../update/solution-builder-extension.md).