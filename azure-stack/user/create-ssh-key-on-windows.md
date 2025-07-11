---
title: Create an SSH key for Linux on Azure Stack Hub  
description: Learn how to create an SSH key for Linux on Azure Stack Hub
author: sethmanheim

ms.topic: how-to
ms.custom: linux-related-content
ms.date: 12/2/2020
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 12/2/2020

# Intent: As an Azure Stack Hub user, I would like to create a public/private ssh key pair to use when creating Linux VMs.
# Keywords: create SSH key
---

# Create an SSH key for Linux on Azure Stack Hub

You can create an SSH (secure shell) key for your Linux machine on a Windows machine. Use the public key generated by the steps in this article for SSH authentication with VMs. If you are using a Windows machine install Ubuntu on Windows to get a terminal with utilities such as bash, ssh, git, apt, and many more. Run the **ssh-keygen** to create your key.

## Open bash on Windows

1. If you do not have the Windows Subsystem for Linux installed on your machine, install "[Ubuntu on Windows](https://www.microsoft.com/en-us/p/ubuntu/9nblggh4msv6?activetab=pivot:overviewtab).  
    For more information about using the Windows Subsystem for Linux, see [Windows Subsystem for Linux Documentation](/windows/wsl/about).

2. Type **Ubuntu** in your toolbar and select **Open**.

## Create a key with ssh-keygen

1. Type the following command from your bash prompt:

    ```bash  
    ssh-keygen -t rsa
    ```

    Bash displays the following prompt:

    ```bash
    Generating public/private rsa key pair.
    Enter file in which to save the key (/home/username/.ssh/id_rsa):
    ```

2. Type the filename and passphrase. Type the passphrase again.

    Bash displays the following:

    ```bash
    Generating public/private rsa key pair.
    Enter file in which to save the key (/home/user/.ssh/id_rsa): key.txt
    Enter passphrase (empty for no passphrase):
    Enter same passphrase again:
    Your identification has been saved in key.txt.
    Your public key has been saved in key.txt.pub.
    The key fingerprint is:
    SHA256:xanotrealoN6z1/KChqeah0CYVeyhL50/0rq37qgy6Ik username@machine
    The key's randomart image is:
    +---[RSA 2048]----+
    |   o.     .      |
    |  . o.   +       |
    | + o .+ o o      |
    |o o .  O +       |
    | . o .o S .      |
    |  o +. .         |
    |.  o +..o. .     |
    |= . ooB +o+ .    |
    |E=..*X=*.. +.    |
    +----[SHA256]-----+
    ```

3. To view and the public ssh key:

    ```bash
    cat /home/<username>/<filename>
    ```

    Bash displays something like the following:

    ```bash
    ssh-rsa AAAAB3NzaC1ycTHISISANEXAMPLEDITqEJRNrf6tXy9c0vKnMhiol1BFzHFV3
    +suXk6NDeFcA9uI58VdD/CuvG826R+3OPnXutDdl2MLyH3DGG1fJAHObUWQxmDWluhSGb
    JMHiw2L9Wnf9klG6+qWLuZgjB3TQdus8sZI8YdB4EOIuftpMQ1zkAJRAilY0p4QxHhKbU
    IkvWqBNR+rd5FcQx33apIrB4LMkjd+RpDKOTuSL2qIM2+szhdL5Vp5Y6Z1Ut1EpOrkbg1
    cVw7oW0eP3ROPdyNqnbi9m1UVzB99aoNXaepmYviwJGMzXsTkiMmi8Qq+F8/qy7i4Jxl0
    aignia880qOtQrvNEvyhgZOM5oDhgE3IJ username@machine
    ```

4. Copy the text `ssh-rsa [...]` up to `username@machinename`. Make sure the text doesn't include any carriage returns. You can use this text when creating your VM or Kubernetes cluster using the AKS engine.

5. If you are on a Windows machine, you can access your Linux files using **\\\\wsl$**.

    1. Type `\\wsl$` in your toolbar. The default window your distribution open.

    2. Navigate to: `\\wsl$\Ubuntu\home\<username>` and find the public and private key and save to a secure location.

## Next steps

- [Deploy a Kubernetes cluster with the AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-deploy-cluster.md)
- [Quickstart: Create a Linux server VM by using the Azure Stack Hub portal](azure-stack-quick-linux-portal.md)
