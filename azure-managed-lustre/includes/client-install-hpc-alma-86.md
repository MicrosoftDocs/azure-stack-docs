---
author: mayabishop
ms.author: mvbishop
ms.service: azure-stack
ms.topic: include
ms.date: 04/28/2023
ms.reviewer: dsundarraj
ms.lastreviewed: 04/28/2023

---
 > [!WARNING]
 > These instructions apply **ONLY** to the AlmaLinux 8.6 HPC marketplace images. For all other AlmaLinux 8 installs, including HPC and general marketplace, refer to [Red Hat 8 instructions](../install-rhel-8.md).

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
   sudo dnf install --disableexcludes=main --refresh [!INCLUDE [client-kernel-version-rhel](client-kernel-version-rhel.md)]-$(uname -r | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
   ```
        

   > [!NOTE]
   > The metapackage version does not always align with the kernel version. Please use the install command above to install the proper metapackage.

   If you want to upgrade only the kernel (and not all packages), you must, at minimum, also upgrade the amlfs-lustre-client metapackage in order for the Lustre client to continue to work after the reboot. You must run something similar to this:

   ```bash
   export NEWKERNELVERSION=6.7.8
   sudo dnf upgrade kernel-$NEWKERNELVERSION [!INCLUDE [client-kernel-version-rhel](client-kernel-version-rhel.md)]-$(echo $NEWKERNELVERSION | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
   ```

