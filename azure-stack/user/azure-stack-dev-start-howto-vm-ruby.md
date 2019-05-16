---
title: Deploy an Ruby app to a virtual machine in Azure Stack | Microsoft Docs
description: Deploy an Ruby app to a virtual machine in Azure Stack.
services: azure-stack
author: mattbriggs

ms.service: azure-stack
ms.topic: overview
ms.date: 04/24/2019
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 04/24/2019

# keywords:  Deploy an app to Azure Stack
# Intent: I am developer using Windows 10 or Linux Ubuntu who would like to deploy an app for Azure Stack.
---

# How to deploy a Ruby web app to a VM in Azure Stack

You can create a VM to host your Ruby Web app in Azure Stack. This article looks at the steps you will follow in setting up server, configuring the server to host your Ruby web app, and then deploying your app.



This article will use Ruby and a Ruby on Rails web framework.

## Create a VM

1. Set up your VM set up in Azure Stack. Follow the steps in [Deploy a Linux VM to host a web app in Azure Stack](azure-stack-dev-start-howto-deploy-linux.md).

2. In the VM network blade, make sure the following ports are accessible:

    | Port | Protocol | Description |
    | --- | --- | --- |
    | 80 | HTTP | Hypertext Transfer Protocol (HTTP) is the protocol used to deliver web pages from servers. Clients connect via HTTP with a DNS name or IP address. |
    | 443 | HTTPS | Hypertext Transfer Protocol Secure (HTTPS) is a secure version of HTTP that requires a security certificate and allows for the encrypted transmission of information.  |
    | 22 | SSH | Secure Shell (SSH) is an encrypted network protocol for secure communications. You will use this connection with an SSH client to configure the VM and deploy the app. |
    | 3389 | RDP | Optional. The Remote Desktop Protocol allows for a remote desktop connection to use a graphic user interface your machine.   |
    | 3000 | Custom | Port 3000 is used by the Ruby-on-rails web framework in development. For a production server, you will want to route your traffic through 80 and 443. |

## Install Ruby

1. Connect to your VM using your SSH client. For instructions, see [Connect via SSH with PuTTy](azure-stack-dev-start-howto-ssh-public-key.md#connect-via-ssh-with-putty).
1. Install the PPA repository. At your bash prompt on your VM, type the following commands:

    ```bash  
    sudo apt -y install software-properties-common
    sudo apt-add-repository ppa:brightbox/ruby-ng

    sudo apt update
    ```

2. Install Ruby and Ruby rails on your VM. Still connected to your VM in your SSH session, type the following commands:

    ```bash  
    sudo apt install ruby
    gem install rails -v 4.2.6
    ```

3. Install Ruby rails dependencies. Still connected to your VM in your SSH session, type the following commands:

    ```bash  
    sudo apt-get install make
    sudo apt-get install gcc
    sudo apt-get install sqlite3
    sudo apt-get install nodejs
    sudo gem install sqlite
    sudo gem install bundler
    ```

    > [!Note]  
    > In installing, you may need to repeatedly run `sudo gem install bundler`. If dependencies attempt to install and fail, review the error logs and resolve the issues.

4. Validate your installation. Still connected to your VM in your SSH session, type the following commands:

    ```bash  
        ruby -v
    ```

3. Install Git. [Git](https://git-scm.com) is a widely distributed revision control and source code management (SCM) system. Still connected to your VM in your SSH session, type the following commands:

    ```bash  
       sudo apt-get -y install git
    ```

## Create and run an app

1. Still connected to your VM in your SSH session, type the following commands:

    ```bash
        rails new myapp
        cd myapp
        rails server -b 0.0.0.0 -p 3000
    ```

2.  Now navigate to your new server and you should see your running web application.

    ```HTTP  
       http://yourhostname.cloudapp.net:3000
    ```

## Next steps

- Learn more about how to [Develop for Azure Stack](azure-stack-dev-start.md)
- Learn about [common deployments for Azure Stack as IaaS](azure-stack-dev-start-deploy-app.md).
- To learn the Ruby programming language and find additional resources for Python, see [Ruby-lang.org](https://www.ruby-lang.org).