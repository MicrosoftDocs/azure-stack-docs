---
author: csmuell
ms.author: chmuell
ms.service: azure-stack
ms.topic: include
ms.date: 02/19/2026
ms.reviewer:
ms.lastreviewed:
---

```bash
sudo tdnf install -y amlfs-lustre-client-2.16.1_21_g153e389-$(uname -r | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
```

> [!NOTE]
> Running `tdnf search amlfs-lustre-client` doesn't show all available packages for your distribution. To see all available `amlfs-lustre-client` packages, run `tdnf list "amlfs-lustre-client*"`.

If you want to upgrade the kernel, you must first remove the existing Lustre packages, upgrade the kernel, set the new kernel as default, reboot, and then install the Lustre client for the new kernel:

```bash
# Remove existing Lustre packages
sudo lustre_rmmod
sudo tdnf remove '*lustre*' -y

# Upgrade kernel
sudo tdnf upgrade kernel -y

# Set newest kernel as default and reboot
sudo sed -i 's/^GRUB_DEFAULT=.*/GRUB_DEFAULT=0/' /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo reboot
```

After the reboot, install the Lustre client for your new kernel:

```bash
sudo tdnf install -y amlfs-lustre-client-2.16.1_21_g153e389-$(uname -r | sed -e "s/\.$(uname -p)$//" | sed -re 's/[-_]/\./g')-1
```
