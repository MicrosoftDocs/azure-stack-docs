---
title: Add Linux images to the Azure Stack Hub Marketplace 
description: Learn how to add Linux images to the Azure Stack Hub Marketplace.
author: sethmanheim
ms.topic: article
ms.date: 01/23/2020
ms.author: sethm
ms.reviewer: unknown
ms.lastreviewed: 11/16/2019

# Intent: As an Azure Stack operator, I want to add Linux images to Azure Stack so my users can deploy Linux VMs.
# Keyword: azure stack add linux image marketplace

---


# Add Linux images to the Azure Stack Hub Marketplace

You can deploy Linux virtual machines (VMs) on Azure Stack Hub by adding a Linux-based image into Azure Stack Hub Marketplace. The easiest way to add a Linux image to Azure Stack Hub is through Marketplace Management. These images have been prepared and tested for compatibility with Azure Stack Hub.

## Marketplace Management

To download Linux images from Azure Marketplace, see [Download marketplace items from Azure to Azure Stack Hub](azure-stack-download-azure-marketplace-item.md). Select the Linux images that you want to offer users on your Azure Stack Hub.

There are frequent updates to these images, so check Marketplace Management often to keep up-to-date.

## Prepare your own image

Wherever possible, download the images available through Marketplace Management. These images have been prepared and tested for Azure Stack Hub.

### Azure Linux Agent

The Azure Linux Agent (typically called **WALinuxAgent** or **walinuxagent**) is required, and not all versions of the agent work on Azure Stack Hub. Versions between 2.2.21 and 2.2.34 (inclusive) are not supported on Azure Stack Hub. To use the latest agent versions above 2.2.35, apply the 1901 hotfix/1902 hotfix, or update your Azure Stack Hub to the 1903 release (or above). Note that [cloud-init](https://cloud-init.io/) is supported on Azure Stack Hub releases beyond 1910.

| Azure Stack Hub build | Azure Linux Agent build |
| ------------- | ------------- |
| 1.1901.0.99 or earlier | 2.2.20 |
| 1.1902.0.69  | 2.2.20  |
|  1.1901.3.105   | 2.2.35 or newer |
| 1.1902.2.73  | 2.2.35 or newer |
| 1.1903.0.35  | 2.2.35 or newer |
| Builds after 1903 | 2.2.35 or newer |
| Not supported | 2.2.21-2.2.34 |
| Builds after 1910 | All Azure WALA agent versions|

You can prepare your own Linux image using the following instructions:

* [CentOS-based Distributions](/azure/virtual-machines/linux/create-upload-centos?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
* [Debian Linux](/azure/virtual-machines/linux/debian-create-upload-vhd?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
* [Red Hat Enterprise Linux](azure-stack-redhat-create-upload-vhd.md)
* [SLES & openSUSE](/azure/virtual-machines/linux/suse-create-upload-vhd?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
* [Ubuntu Server](/azure/virtual-machines/linux/create-upload-ubuntu?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)

## Cloud-init

[Cloud-init](https://cloud-init.io/) is supported on Azure Stack Hub releases beyond 1910. To use cloud-init to customize your Linux VM, you can use the following PowerShell instructions.

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
  
### Step 2: Reference the cloud-init.txt during the Linux VM deployment

Upload the file to an Azure storage account, Azure Stack Hub storage account, or GitHub repository reachable by your Azure Stack Hub Linux VM.
Currently, using cloud-init for VM deployment is only supported on REST, Powershell, and CLI, and doesn't have an associated portal UI on Azure Stack Hub.

You can follow [these](../user/azure-stack-quick-create-vm-linux-powershell.md) instructions to create the Linux VM using powershell, but make sure to reference the cloud-init.txt as a part of the `-CustomData` flag:

```powershell
$VirtualMachine =Set-AzureRmVMOperatingSystem -VM $VirtualMachine `
  -Linux `
  -ComputerName "MainComputer" `
  -Credential $cred -CustomData "#include https://cloudinitstrg.blob.core.windows.net/strg/cloud-init.txt"
```

## Add your image to Marketplace

Follow [Add the image to the Marketplace](azure-stack-add-vm-image.md). Make sure that the `OSType` parameter is set to `Linux`.

After you've added the image to the Marketplace, a Marketplace item is created and users can deploy a Linux VM.

## Next steps

* [Download marketplace items from Azure to Azure Stack Hub](azure-stack-download-azure-marketplace-item.md)
* [Azure Stack Hub Marketplace overview](azure-stack-marketplace.md)
