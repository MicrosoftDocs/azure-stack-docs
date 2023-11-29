---
author: pauljewellmsft
ms.author: pauljewell
ms.service: azure-stack
ms.topic: include
ms.date: 02/19/2023
ms.reviewer: dsundarraj
ms.lastreviewed: 02/19/2023

---

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
   sudo apt install amlfs-lustre-client-2.15.1-33-g0168b83=$(uname -r)
   ```

   > [!NOTE]
   > This installs a metapackage that will keep the version of Lustre aligned with the installed kernel. In order for this to work, you must use `apt full-upgrade` instead of simply `apt upgrade` when updating your system.

   Optionally, if you want to upgrade ONLY the kernel (and not all packages), you must, at minimum, also upgrade the amlfs-lustre-client metapackage in order for the Lustre client to continue to work after the reboot. You must run something similar to this:

   ```bash
   apt upgrade linux-image-[new kernel version] amlfs-lustre-client-2.15.1-33-g0168b83
   ```
