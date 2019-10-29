---
title: Deploy a Ruby app to a virtual machine in Azure Stack | Microsoft Docs
description: Deploy a Ruby app to a virtual machine in Azure Stack.
services: azure-stack
author: mattbriggs

ms.service: azure-stack
ms.topic: overview
ms.date: 10/02/2019
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 10/02/2019

# keywords:  Deploy an app to Azure Stack
# Intent: I am a developer using Windows 10 or Linux Ubuntu who would like to deploy an app for Azure Stack.
---

# Deploy a Ruby web app to a VM in Azure Stack

You can create a VM to host your Ruby web app in Azure Stack. In this article, you set up a server, configure the server to host your Ruby web app, and then deploy the app to Azure Stack.

This article uses Ruby and a Ruby on Rails web framework.

## Create a VM

1. Set up your VM in Azure Stack. For instructions, see [Deploy a Linux VM to host a web app in Azure Stack](azure-stack-dev-start-howto-deploy-linux.md).

2. In the VM network pane, make sure the following ports are accessible:

    | Port | Protocol | Description |
    | --- | --- | --- |
    | 80 | HTTP | Hypertext Transfer Protocol (HTTP) is the protocol that's used to deliver webpages from servers. Clients connect via HTTP with a DNS name or IP address. |
    | 443 | HTTPS | Hypertext Transfer Protocol Secure (HTTPS) is a secure version of HTTP that requires a security certificate and allows for the encrypted transmission of information. |
    | 22 | SSH | Secure Shell (SSH) is an encrypted network protocol for secure communications. You use this connection with an SSH client to configure the VM and deploy the app. |
    | 3389 | RDP | Optional. The Remote Desktop Protocol (RDP) allows a remote desktop connection to use a graphic user interface on your machine.   |
    | 3000 | Custom | The port that's used by the Ruby on Rails web framework in development. For a production server, you route your traffic through 80 and 443. |

## Install Ruby

1. Connect to your VM by using your SSH client. For instructions, see [Connect via SSH with PuTTy](azure-stack-dev-start-howto-ssh-public-key.md#connect-with-ssh-by-using-putty).

1. Install the PPA repository. At the bash prompt on your VM, enter the following commands:

    ```bash  
    sudo apt -y install software-properties-common
    sudo apt-add-repository ppa:brightbox/ruby-ng

    sudo apt update
    ```

2. Install Ruby and Ruby on Rails on your VM. While you're still connected to your VM in your SSH session, enter the following commands:

    ```bash  
    sudo apt install ruby
    gem install rails -v 4.2.6
    ```

3. Install Ruby on Rails dependencies. While you're still connected to your VM in your SSH session, enter the following commands:

    ```bash  
    sudo apt-get install make
    sudo apt-get install gcc
    sudo apt-get install sqlite3
    sudo apt-get install nodejs
    sudo gem install sqlite
    sudo gem install bundler
    ```

    > [!Note]  
    > While you're installing Ruby on Rails dependencies, you might need to repeatedly run `sudo gem install bundler`. If the installation fails, review the error logs and resolve the issues.

4. Validate your installation. While you're still connected to your VM in your SSH session, enter the following command:

    ```bash  
        ruby -v
    ```

3. [Install Git](https://git-scm.com), a widely distributed version control and source code management (SCM) system. While you're still connected to your VM in your SSH session, enter the following command:

    ```bash  
       sudo apt-get -y install git
    ```

## Create and run an app

1. While you're still connected to your VM in your SSH session, enter the following commands:

    ```bash
        rails new myapp
        cd myapp
        rails server -b 0.0.0.0 -p 3000
    ```

2. Go to your new server. You should see your running web application.

    ```HTTP  
       http://yourhostname.cloudapp.net:3000
    ```

## Next steps

- Learn more about how to [develop for Azure Stack](azure-stack-dev-start.md).
- Learn about [common deployments for Azure Stack as IaaS](azure-stack-dev-start-deploy-app.md).
- To learn the Ruby programming language and find additional resources for Ruby, see [Ruby-lang.org](https://www.ruby-lang.org).
