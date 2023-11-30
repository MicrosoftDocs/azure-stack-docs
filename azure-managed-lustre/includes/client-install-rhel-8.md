---
author: pauljewellmsft
ms.author: pauljewell
ms.service: azure-stack
ms.topic: include
ms.date: 02/19/2023
ms.reviewer: dsundarraj
ms.lastreviewed: 02/19/2023

---

1. Install and configure the Azure Managed Lustre repository for the DNF package manager. Create the following script and name it `repo.bash`:

   ```bash
   #!/bin/bash
   set -ex
   
   rpm --import https://packages.microsoft.com/keys/microsoft.asc
   
   DISTRIB_CODENAME=el8
   
   REPO_PATH=/etc/yum.repos.d/amlfs.repo
   echo -e "[amlfs]" > ${REPO_PATH}
   echo -e "name=Azure Lustre Packages" >> ${REPO_PATH}
   echo -e "baseurl=https://packages.microsoft.com/yumrepos/amlfs-${DISTRIB_CODENAME}" >> ${REPO_PATH}
   echo -e "enabled=1" >> ${REPO_PATH}
   echo -e "gpgcheck=1" >> ${REPO_PATH}
   echo -e "gpgkey=https://packages.microsoft.com/keys/microsoft.asc" >> ${REPO_PATH}
   ```

1. Execute script as super-user:

   ```bash
   sudo bash repo.bash
   ```

1. Install the metapackage that matches your running kernel:

   ```bash
   sudo dnf install amlfs-lustre-client-2.15.1_33_g0168b83-$(uname -r | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
   ```

   > [!NOTE]
   > The metapackage version does not always align with the kernel version. Use the install command above to install the proper metapackage.

   If you want to upgrade only the kernel (and not all packages), you must, at minimum, also upgrade the amlfs-lustre-client metapackage in order for the Lustre client to continue to work after the reboot. You must run something similar to this:

   ```bash
   export NEWKERNELVERSION=6.7.8
   sudo dnf upgrade kernel-$NEWKERNELVERSION amlfs-lustre-client-2.15.1_33_g0168b83-$(echo $NEWKERNELVERSION | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
   ```

