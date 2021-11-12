---
title: Add Linux images to the Azure Stack Hub Marketplace 
description: Learn how to add Linux images to the Azure Stack Hub Marketplace.
author: sethmanheim
ms.topic: article
ms.date: 9/9/2021
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 9/9/2021

# Intent: As an Azure Stack operator, I want to add Linux images to Azure Stack so my users can deploy Linux VMs.
# Keyword: azure stack add linux image marketplace

---

# Add Linux images to the Azure Stack Hub Marketplace

You can deploy Linux virtual machines (VMs) on Azure Stack Hub by adding a Linux-based image to the Azure Stack Hub Marketplace. The easiest way to add a Linux image to Azure Stack Hub is through marketplace management. These images have been prepared and tested for compatibility with Azure Stack Hub.

## Marketplace management

To download Linux images from Azure Marketplace, see [Download marketplace items from Azure to Azure Stack Hub](azure-stack-download-azure-marketplace-item.md). Select the Linux images that you want to offer users on your Azure Stack Hub.

There are frequent updates to these images, so check back often to keep up to date.

## Prepare your own image

Wherever possible, download the images available through marketplace management. These images have been prepared and tested with Azure Stack Hub.

### Minimum supported Azure Linux Agent

To get support for the Azure Linux Agent and extensions in Azure Stack Hub, the [Linux Agent](https://github.com/Azure/WALinuxAgent) version on the Linux virtual machine (VM) must be later than or equal to version 2.2.10 and Azure Stack Hub must run a build that is within two releases of the current release. For information about Azure Stack Hub updates, see [Azure Stack Hub release notes](./release-notes.md).

As of July 2020, the minimum supported version is 2.2.41 for the Linux Agent. If the Linux Agent version is earlier than version 2.2.10, you must update the VM by using the distribution package manager and by enabling auto-update.
 - If the distribution vendor doesn't have the minimum Linux Agent version in the package repositories, the system is still in support. If the Linux Agent version is later than version 2.1.7, you must enable the Agent auto-update feature. It will retrieve the latest version of code for extension handling.
 - If the Linux Agent version is earlier than version 2.2.10, or if the Linux system is out-of-support, we may require you to update the agent before getting support.
 - If the Linux Agent version is customized by a publisher, Microsoft may direct you to the publisher for support agent or extension-specific support because of the customization. To upgrade the Linux Agent, see [How to update the Azure Linux Agent on a VM](/azure/virtual-machines/extensions/update-linux-agent).

###  Check your Linux Agent Version

To check your Linux Agent Version, run:

```bash
waagent --version
```

For example, if you are running this command on Ubuntu 18.04, you'll see the output:

```bash  
WALinuxAgent - 2.2.45
Python - 3.6.9
Goal State Agent - 2.2.48.1
```

For more information about the agent, see the [FAQ for WALinuxAgent](https://github.com/Azure/WALinuxAgent/wiki/FAQ).
#### Prepare your own Linux image

You can prepare your own Linux image using the following instructions:

* [CentOS-based Distributions](/azure/virtual-machines/linux/create-upload-centos?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
* [Debian Linux](/azure/virtual-machines/linux/debian-create-upload-vhd?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
* [Red Hat Enterprise Linux](azure-stack-redhat-create-upload-vhd.md)
* [SLES & openSUSE](/azure/virtual-machines/linux/suse-create-upload-vhd?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
* [Ubuntu Server](/azure/virtual-machines/linux/create-upload-ubuntu?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)

## Cloud-init

You can use [Cloud-init](https://cloud-init.io/)  to customize your Linux VM, you can use the following PowerShell instructions.

### Step 1: Create a cloud-init.txt file with your cloud-config

Create a file named cloud-init.txt and paste the following cloud configuration:

```yaml
#cloud-config
package_upgrade: true
packages:
  - nginx
  - nodejs
  - npm
write_files:
  - owner: www-data:www-data
    path: /etc/nginx/sites-available/default
    content: |
      server {
        listen 80;
        location / {
          proxy_pass http://localhost:3000;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection keep-alive;
          proxy_set_header Host $host;
          proxy_cache_bypass $http_upgrade;
        }
      }
  - owner: azureuser:azureuser
    path: /home/azureuser/myapp/index.js
    content: |
      var express = require('express')
      var app = express()
      var os = require('os');
      app.get('/', function (req, res) {
        res.send('Hello World from host ' + os.hostname() + '!')
      })
      app.listen(3000, function () {
        console.log('Hello world app listening on port 3000!')
      })
runcmd:
  - service nginx restart
  - cd "/home/azureuser/myapp"
  - npm init
  - npm install express -y
  - nodejs index.js
  ```
  
### Step 2: Reference cloud-init.txt during the Linux VM deployment

Upload the file to an Azure storage account, Azure Stack Hub storage account, or GitHub repository reachable by your Azure Stack Hub Linux VM.

Currently, using cloud-init for VM deployment is only supported on REST, PowerShell, and Azure CLI, and does not have an associated portal UI on Azure Stack Hub.

You can follow the [Quickstart: Create a Linux server VM by using PowerShell in Azure Stack Hub](../user/azure-stack-quick-create-vm-linux-powershell.md) to create the Linux VM using PowerShell. Make sure to reference the `cloud-init.txt` as a part of the `-CustomData` flag:

### [Az modules](#tab/az)

```powershell
$VirtualMachine =Set-AzVMOperatingSystem -VM $VirtualMachine `
  -Linux `
  -ComputerName "MainComputer" `
  -Credential $cred -CustomData "#include https://cloudinitstrg.blob.core.windows.net/strg/cloud-init.txt"
```

### [AzureRM modules](#tab/azurerm)

```powershell
$VirtualMachine =Set-AzureRMVMOperatingSystem -VM $VirtualMachine `
  -Linux `
  -ComputerName "MainComputer" `
  -Credential $cred -CustomData "#include https://cloudinitstrg.blob.core.windows.net/strg/cloud-init.txt"
```

---

## Add your image to Marketplace

Follow [Add the image to the Marketplace](azure-stack-add-vm-image.md). Make sure that the `OSType` parameter is set to `Linux`.

After you've added the image to the Marketplace, a Marketplace item is created and users can deploy a Linux VM.

## Next steps

* [Download marketplace items from Azure to Azure Stack Hub](azure-stack-download-azure-marketplace-item.md)
* [Azure Stack Hub Marketplace overview](azure-stack-marketplace.md)
