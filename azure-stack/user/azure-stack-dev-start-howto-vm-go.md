---
title: How to deploy a GO web app to a VM in Azure Stack | Microsoft Docs
description: How to deploy a GO web app to a VM in Azure Stack
services: azure-stack
author: mattbriggs

ms.service: azure-stack
ms.topic: overview
ms.date: 03/11/2019
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 03/11/2019

# keywords:  Deploy an Go web app to Azure Stack
# Intent: I am developer using Windows 10 or Linux Ubuntu who would like to deploy an Go web app for Azure Stack.
---


# How to deploy a GO web app to a VM in Azure Stack

You can create a VM to host your Go Web app in Azure Stack. This article looks at the steps you will follow in setting up server, configuring the server to host your GO web app, and then deploying your app.

Go is expressive, concise, clean, and efficient. Its concurrency mechanisms make it easy to write programs that get the most out of multicore and networked machines, while its novel type system enables flexible and modular program construction. Go compiles quickly to machine code yet has the convenience of garbage collection and the power of run-time reflection. It's a fast, statically typed, compiled language that feels like a dynamically typed, interpreted language. To learn the Go programming language and find additional resources for GO, see [Golang.org](https://golang.org).

## Create a VM

1. Set up your VM set up in Azure Stack. Follow the steps in [Deploy a Linux VM to host a web app in Azure Stack](azure-stack-dev-start-howto-deploy-linux.md).

2. In the VM network blade, make sure the following ports are accessible:

    | Port | Protocol | Description |
    | --- | --- | --- |
    | 80 | HTTP | Hypertext Transfer Protocol (HTTP) is an application protocol for distributed, collaborative, hypermedia information systems. Clients will connect to your web app with either the public IP or DNS name of your VM. |
    | 443 | HTTPS | Hypertext Transfer Protocol Secure (HTTPS) is an extension of the Hypertext Transfer Protocol (HTTP). It is used for secure communication over a computer network. Clients will connect to your web app with the either the public IP or DNS name of your VM. |
    | 22 | SSH | Secure Shell (SSH) is a cryptographic network protocol for operating network services securely over an unsecured network. You will use this connection with an SSH client to configure the VM and deploy the app. |
    | 3389 | RDP | Optional. The Remote Desktop Protocol allows for a remote desktop connection to use a graphic user interface your machine.   |
    | 3000 | Custom | Port 3000 is used by the GO web framework in development. For a production server, you will want to route your traffic through 80 and 443. |

## Install GO

1. Connect to your VM using your SSH client. For instructions, see [Connect via SSH with PuTTy](azure-stack-dev-start-howto-SSH-public-key.md#connect-via-ssh-with-putty).
1. At your bash prompt on your VM, type the following commands:

    ```bash  
    wget https://dl.google.com/go/go1.10.linux-amd64.tar.gz
    sudo tar -xvf go1.10.linux-amd64.tar.gz
    sudo mv go /usr/local
    ```

2. Set up the GO environment on your VM. Still connected to your VM in your SSH session, type the following commands:

    ```bash  
    export GOROOT=/usr/local/go
    export GOPATH=$HOME/Projects/ADMFactory/Golang
    export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

    vi ~/.profile
    ```

3. Validate your installation. Still connected to your VM in your SSH session, type the following commands:

    ```bash  
        go version
    ```

3. Install Git. [Git](https://git-scm.com) is a widely distributed revision control and source code management (SCM) system. Still connected to your VM in your SSH session, type the following commands:

    ```bash  
       sudo apt-get -y install git
    ```

## Deploy and run the app

1. Set up your Git repository on the VM. Still connected to your VM in your SSH session, type the following commands:

    ```bash  
       git clone https://github.com/appleboy/go-hello
    
       cd go-hello
       go get -d
    ```

2. Start the app. Still connected to your VM in your SSH session, type the following command:

    ```bash  
       go run hello-world.go
    ```

3.  Now navigate to your new server and you should see your running web application.

    ```HTTP  
       http://yourhostname.cloudapp.net:3000
    ```

## Next steps

- Learn more about how to [Develop for Azure Stack](azure-stack-dev-start.md)
- Learn about [common deployments for Azure Stack as IaaS](azure-stack-dev-start-deploy-app.md).