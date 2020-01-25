---
title: Deploy a Node.js app to a virtual machine in Azure Stack Hub | Microsoft Docs
description: Deploy an Node.js app to Azure Stack Hub.
author: mattbriggs

ms.topic: overview
ms.date: 1/22/2020
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 10/02/2019

# keywords:  Deploy an app to Azure Stack Hub
# Intent: I am a developer using Windows 10 or Linux Ubuntu who would like to deploy an app for Azure Stack Hub.
---


# Deploy a Node.js web app to a VM in Azure Stack Hub

You can create a virtual machine (VM) to host a Node.js web app in Azure Stack Hub. In this article, you set up a server, configure the server to host your Node.js web app, and then deploy the app to Azure Stack Hub.

## Create a VM

1. Set up your VM in Azure Stack Hub by following the instructions in [Deploy a Linux VM to host a web app in Azure Stack Hub](azure-stack-dev-start-howto-deploy-linux.md).

2. In the VM network pane, make sure that the following ports are accessible:

    | Port | Protocol | Description |
    | --- | --- | --- |
    | 80 | HTTP | Hypertext Transfer Protocol (HTTP) is the protocol that's used to deliver webpages from servers. Clients connect via HTTP with a DNS name or IP address. |
    | 443 | HTTPS | Hypertext Transfer Protocol Secure (HTTPS) is a secure version of HTTP that requires a security certificate and allows for the encrypted transmission of information. |
    | 22 | SSH | Secure Shell (SSH) is an encrypted network protocol for secure communications. You use this connection with an SSH client to configure the VM and deploy the app. |
    | 3389 | RDP | Optional. The Remote Desktop Protocol (RDP) allows a remote desktop connection to use a graphic user interface on your machine.   |
    | 1337 | Custom | The port that's used by Node.js. For a production server, you route your traffic through 80 and 443. |

## Install Node

1. Connect to your VM by using your SSH client. For instructions, see [Connect via SSH with PuTTY](azure-stack-dev-start-howto-ssh-public-key.md#connect-with-ssh-by-using-putty).

1. At the bash prompt on your VM, enter the following command:

    ```bash  
      sudo apt install nodejs-legacy
    ```

2. [Install NPM](https://www.npmjs.com/), a package manager for Node.js packages, or modules. Still connected to your VM in your SSH session, enter the following command:

    ```bash  
       node --version
    ```

3. [Install Git](https://git-scm.com), a widely distributed version-control and source code management (SCM) system. While you're still connected to your VM in your SSH session, enter the following command:

    ```bash  
       sudo apt-get -y install git
    ```

3. Validate your installation. While you're still connected to your VM in your SSH session, enter the following command:

    ```bash  
       node -v
    ```

## Deploy and run the app

1. Set up your Git repository on the VM. While you're still connected to your VM in your SSH session, enter the following commands:

    ```bash  
       git clone https://github.com/Azure-Samples/nodejs-docs-hello-world.git
    
       cd nodejs-docs-hello-world
        npm start
    ```

2. Start the app. While you're still connected to your VM in your SSH session, enter the following command:

    ```bash  
       sudo node app.js
    ```

3. Go to your new server. You should see your running web application.

    ```HTTP  
       http://yourhostname.cloudapp.net:1337
    ```

## Next steps

- Learn more about how to [develop for Azure Stack Hub](azure-stack-dev-start.md).
- Learn about [common deployments for Azure Stack Hub as IaaS](azure-stack-dev-start-deploy-app.md).
- To learn the Node programming language and find additional resources for Node, see [Nodejs.org](https://nodejs.org).
