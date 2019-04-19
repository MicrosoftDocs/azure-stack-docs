---
title: Deploy an Node.js app to Azure Stack | Microsoft Docs
description: Deploy an Node.js app to Azure Stack.
services: azure-stack
author: mattbriggs

ms.service: azure-stack
ms.topic: overview
ms.date: 03/11/2019
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 03/11/2019

# keywords:  Deploy an app to Azure Stack
# Intent: I am developer using Windows 10 or Linux Ubuntu who would like to deploy an app for Azure Stack.
---


# How to deploy a Node.js web app to a VM in Azure Stack

You can create a VM to host your Node.js  Web app in Azure Stack. This article looks at the steps you will follow in setting up server, configuring the server to host your Node web app, and then deploying your app.

Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine. As an asynchronous event driven JavaScript runtime, Node is designed to build scalable network applications. To learn the Node programming language and find additional resources for Node, see [Nodejs.org](https://nodejs.org).

## Create a VM

1. Set up your VM set up in Azure Stack. Follow the steps in [Deploy a Linux VM to host a web app in Azure Stack](azure-stack-dev-start-howto-deploy-linux.md).

2. In the VM network blade, make sure the following ports are accessible:

    | Port | Protocol | Description |
    | --- | --- | --- |
    | 80 | HTTP | Hypertext Transfer Protocol (HTTP) is an application protocol for distributed, collaborative, hypermedia information systems. Clients will connect to your web app with either the public IP or DNS name of your VM. |
    | 443 | HTTPS | Hypertext Transfer Protocol Secure (HTTPS) is an extension of the Hypertext Transfer Protocol (HTTP). It is used for secure communication over a computer network. Clients will connect to your web app with the either the public IP or DNS name of your VM. |
    | 22 | SSH | Secure Shell (SSH) is a cryptographic network protocol for operating network services securely over an unsecured network. You will use this connection with an SSH client to configure the VM and deploy the app. |
    | 3389 | RDP | Optional. The Remote Desktop Protocol allows for a remote desktop connection to use a graphic user interface your machine.   |
    | 1337 | Custom | Port 1337 is used by the Node.js. For a production server, you will want to route your traffic through 80 and 443. |

## Install Node

1. Connect to your VM using your SSH client. For instructions, see [Connect via SSH with PuTTy](azure-stack-dev-start-howto-SSH-public-key.md#connect-via-ssh-with-putty).
1. At your bash prompt on your VM, type the following commands:

    ```bash  
      sudo apt install nodejs-legacy
    ```

2. Install NPM. [NPM](https://www.npmjs.com/) is a package manager for Node.js packages, or modules. Still connected to your VM in your SSH session, type the following commands:

    ```bash  
       go version
    ```

3. Install Git. [Git](https://git-scm.com) is a widely distributed revision control and source code management (SCM) system. Still connected to your VM in your SSH session, type the following commands:

    ```bash  
       sudo apt-get -y install git
    ```

3. Validate your installation. Still connected to your VM in your SSH session, type the following commands:

    ```bash  
       node -v
    ```

## Deploy and run the app

1. Set up your Git repository on the VM. Still connected to your VM in your SSH session, type the following commands:

    ```bash  
       git clone https://github.com/Azure-Samples/nodejs-docs-hello-world.git
    
       cd nodejs-docs-hello-world
        npm start
    ```

2. Start the app. Still connected to your VM in your SSH session, type the following command:

    ```bash  
       sudo node app.js
    ```

3.  Now navigate to your new server and you should see your running web application.

    ```HTTP  
       http://yourhostname.cloudapp.net:1337
    ```

## Next steps

- Learn more about how to [Develop for Azure Stack](azure-stack-dev-start.md)
- Learn about [common deployments for Azure Stack as IaaS](azure-stack-dev-start-deploy-app.md).