---
title: How to use an SSH public key | Microsoft Docs
description: How to use an SSH public key
services: azure-stack
author: mattbriggs

ms.service: azure-stack
ms.topic: overview
ms.date: 03/11/2019
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 03/11/2019

# keywords: Create an SSH key and connect to a VM.
---

# How to use an SSH public key

You may need to create an SSH public and private key pair to use an open SSH connection from your development machine and the server VM in Azure Stack hosting your web app. This article walks you through the steps of getting your keys and using the keys to connect to your server. You can use an SSH client to get a bash prompt on the Linux server, or an SFTP client to move files to and from the server.

## Create an SSH public key on Windows

In this section, you will use PuTTY's key generator to create a public SSH key and private key pair to use when creating a secure connection to Linux machines on your Azure Stack. PuTTY is a free implementation of SSH and Telnet for Windows and Unix platforms, along with an `xterm` terminal emulator.

1. [Download and install PuTTY for your machine.](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)
1. Open the PuTTY Key Generator.
1. Set the **Parameters** to **RSA**.
1. Set the number of bits in a generated key to `2048`.
    ![Use PuTTY to generate an SSH public key](media/azure-stack-dev-start-howto-SSH-public-key/001-puTTYkeygenstart.png)
1. Select **Generate**. In the **Key** area, generate some randomness by moving the cursor over the blank area.
1. Add a **Key passphrase** and confirm it in the **Confirm** box. Make note of your passphrase.
    ![Use PuTTY to generate an SSH public key](media/azure-stack-dev-start-howto-SSH-public-key/002-puTTYkeygenresult.png)
1. Select **Save the public key** and save to a location where you can access it.
1. Select **Save private key** to and save to a location where you can access it remember that is belongs with the public key.

Your public key is stored in the text file you saved. If you open it, it will contain text that looks like:

```text  
---- BEGIN SSH2 PUBLIC KEY ----
Comment: "rsa-key-20190330"
THISISANEXAMPLEDONOTUSE AAAAB3NzaC1yc2EAAAABJQAAAQEAthW2CinpqhXq
9uSa8/lSH7tLelMXnFljSrJIcpxp3MlHlYVbjHHoKfpvQek8DwKdOUcFIEzuStfT
Z8eUI1s5ZXkACudML68qQT8R0cmcFBGNY20K9ZMz/kZkCEbN80DJ+UnWgjdXKLvD
Dwl9aQwNc7W/WCuZtWPazee95PzAShPefGZ87Jp0OCxKaGYZ7UXMrCethwfVumvU
aj+aPsSThXncgVQUhSf/1IoRtnGOiZoktVvt0TIlhxDrHKHU/aZueaFXYqpxDLIs
BvpmONCSR3YnyUtgWV27N6zC7U1OBdmv7TN6M7g01uOYQKI/GQ==
---- END SSH2 PUBLIC KEY ----
```

When using the public key, you copy and paste the entire contexts of the text box as the value when an application asks for the key.

## Create an SSH public key on Linux

ToDo: I need to write this section.

## Connect with SSH using PuTTY

If you have installed PuTTY, you have both the key generator and an SSH client. Open the SSH client, PuTTY, configure your connection values and SSH key, and if you are on the same network as your Azure Stack, connect to your VM.

Before you connect, you will need:
- PuTTY
- The IP address and username for the Linux machine in your Azure Stack that uses an SSH Public key as the Authentication type.
- Port 22 needs to be open for the machine.
- The public SSH key that you used when creating the machine.
- Your client machine running PuTTY to be on the same network as your Azure Stack.

### Connect via SSH with PuTTy

1. Open Putty.

    ![Use PuTTY to connect](media/azure-stack-dev-start-howto-SSH-public-key/002-puTTYconnect.png)

2. Add the username and public IP address of the machine. For example, `username@192.XXX.XXX.XX` for the **Host Name**. 
3. Validate that **Port** `22` is set and **Connection type** is set to `SSH`.
4. Expand **SSH** > **Auth** in the **Category** tree.

    ![SSH private key](media/azure-stack-dev-start-howto-SSH-public-key/002-puTTYsetprivatekey.png)

5. Select **Browse** and find your private key file (filename.ppk) of your public and private key pair.
6. Select Session in the Category tree.

    ![SSH public key with private key](media/azure-stack-dev-start-howto-SSH-public-key/003-puTTYsavesession.png)

7. Type a name for the session under **Saved Sessions** and Select *Save*.
8. Select the name of the session and **Load**.
9. Select **Open**. The SSH session will open.

![Use SSH public key to connect via openSSH](media/azure-stack-dev-start-howto-SSH-public-key/004-openSSHSession.png)

## Connect with SFTP with FileZilla

You can use Filezilla as an FTP client that supports SFTP to move files to and from your Linux machine. FileZilla runs on Windows 10, Linux, and macOS. The FileZilla Client supports FTP, but also FTP over TLS (FTPS) and SFTP. It is open-source software distributed free of charge under the terms of the GNU General Public License.

### Set your connection

1. [Download and install FileZilla](https://filezilla-project.org/download.php).
1. Open FileZilla.
1. Select **File** > **Site Manager**.

    ![SSH public key with private key](media/azure-stack-dev-start-howto-SSH-public-key/005-FileZilla-Site-Manger.png)

1. Select **SFTP - SSH File Transfer Protocol** for **Protocol**.
1. Add the public IP address for your machine in the **Host** box.
1. Select **Normal** for **sign in Type**.
1. Add your user name and password.
1. Select **OK**.
1. Select **Edit** > **Settings**.

    ![SSH public key with private key](media/azure-stack-dev-start-howto-SSH-public-key/006-Filezilla-addprivatekey.png)

1. Expand **Connection** in the **Select page** tree. Select **SFTP**.
1. Select **Add key file** and add your private key file (filename.ppk).
1. Select **OK**.

### Open your connection

1. Open FileZilla.
1. Select **File** > **Site Manager**.
1. Select the name of your site, and select **Connect**.

## Next steps

Learn more about how to [Develop for Azure Stack](azure-stack-dev-start.md)