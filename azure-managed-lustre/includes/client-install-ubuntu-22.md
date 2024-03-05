---
author: pauljewellmsft
ms.author: pauljewell
ms.service: azure-stack
ms.topic: include
ms.date: 02/19/2023
ms.reviewer: dsundarraj
ms.lastreviewed: 02/19/2023

---

> [!IMPORTANT]
> The Azure Marketplace image for the Ubuntu 22.04 LTS release uses the Hardware Enablement (HWE) Kernel by default. However, these kernels are only supported for 6 month periods, and Lustre support for these kernels is often not available when they're released. Therefore, we recommend that you switch to the LTS kernel because it gives you more stability as well as maintains a kernel version that is supported with the Lustre Client.

1. Install the LTS Kernel Metapackage.

   ```bash
   sudo apt update && sudo apt install linux-image-azure-lts-22.04
   ```

1. Remove the HWE Kernel Metapackage.

   Remove the default (Hardware Enablement) Kernel metapackage. It will also ask to remove the linux-azure metapackage.  This is expected.

   ```bash
   sudo apt remove linux-image-azure
   ```

1. List installed kernels and see which one is supplied by the LTS metapackage.

   After the metadata package is removed, check to see what kernels are currently installed.  Newly provisioned hosts will have two kernels and older hosts might have more. Compare the version that the LTS metapackage provides against the other installed kernels.  Here you see that a 6.2 kernel is still installed previously from the linux-image-azure metapackage.

   ```bash
   apt list --installed linux-image*
   ```

1. Remove any kernels newer than the one mentioned in the LTS metapackage.

   Remove any kernels other than the one mentioned in the LTS kernel metapackage.  It will warn about removing the kernel and recommend aborting the process. If you're following these steps on a newly provisioned host, they work. But if you have concerns, consult Ubuntu documentation on configuring kernels to ensure it's able to boot after a reboot.

   ```bash
   sudo apt remove linux-image-5.15.0-1053-azure
   ```

1. Verify that you don't have kernels newer than the one mentioned in the LTS metapackage.

   ```bash
   apt list --installed linux-image*
   ```

1. Reboot to load the LTS kernel.

1. Install and configure the Azure Managed Lustre repository for the APT package manager. Create the following script and name it `repo.bash`:

   ```bash
   #!/bin/bash
   set -ex
   
   apt update && apt install -y ca-certificates curl apt-transport-https lsb-release gnupg
   source /etc/lsb-release
   echo "deb [arch=amd64] https://packages.microsoft.com/repos/amlfs-${DISTRIB_CODENAME}/ ${DISTRIB_CODENAME} main" | tee /etc/apt/sources.list.d/amlfs.list
   curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
   
   apt update
   ```

1. Execute script as a super-user:

   ```bash
   sudo bash repo.bash
   ```

1. Install the metapackage that matches your running kernel:

   ```bash
   sudo apt install amlfs-lustre-client-2.15.4-42-gd6d405d=$(uname -r)
   ```

   > [!NOTE]
   > This installs a metapackage that will keep the version of Lustre aligned with the installed kernel. In order for this to work, you must use `apt full-upgrade` instead of simply `apt upgrade` when updating your system.

   Optionally, if you want to upgrade ONLY the kernel (and not all packages), you must, at minimum, also upgrade the amlfs-lustre-client metapackage in order for the Lustre client to continue to work after the reboot. You must run something similar to this:

   ```bash
   apt upgrade linux-image-[new kernel version] amlfs-lustre-client-2.15.4-42-gd6d405d
   ```
