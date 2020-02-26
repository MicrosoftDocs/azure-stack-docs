---
title: Deploy a Go web app to a virtual machine in Azure Stack Hub 
description: How to deploy a Go web app to a VM in Azure Stack Hub
author: mattbriggs

ms.topic: overview
ms.date: 1/22/2020
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 10/02/2019

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---


# Deploy a Go web app to a VM in Azure Stack Hub

You can create a virtual machine (VM) to host a Go web app in Azure Stack Hub. In this article, you set up a server, configure the server to host your Go web app, and then deploy the app to Azure Stack Hub.

## Create a VM

1. Set up your VM in Azure Stack Hub by following the instructions in [Deploy a Linux VM to host a web app in Azure Stack Hub](azure-stack-dev-start-howto-deploy-linux.md).

2. In the VM network pane, make sure that the following ports are accessible:

    | Port | Protocol | Description |
    | --- | --- | --- |
    | 80 | HTTP | Hypertext Transfer Protocol (HTTP) is the protocol that's used to deliver webpages from servers. Clients connect via HTTP with a DNS name or IP address. |
    | 443 | HTTPS | Hypertext Transfer Protocol Secure (HTTPS) is a secure version of HTTP that requires a security certificate and allows for the encrypted transmission of information. |
    | 22 | SSH | Secure Shell (SSH) is an encrypted network protocol for secure communications. You use this connection with an SSH client to configure the VM and deploy the app. |
    | 3389 | RDP | Optional. The Remote Desktop Protocol (RDP) allows a remote desktop connection to use a graphic user interface on your machine.   |
    | 3000 | Custom | Port 3000 is used by the Go web framework in development. For a production server, you route your traffic through 80 and 443. |

## Install Go

1. Connect to your VM by using your SSH client. For instructions, see [Connect via SSH with PuTTY ](azure-stack-dev-start-howto-ssh-public-key.md#connect-with-ssh-by-using-putty).

1. At the bash prompt on your VM, enter the following commands:

    ```bash  
    wget https://dl.google.com/go/go1.10.linux-amd64.tar.gz
    sudo tar -xvf go1.10.linux-amd64.tar.gz
    sudo mv go /usr/local
    ```

2. Set up the Go environment on your VM. While you're still connected to your VM in your SSH session, enter the following commands:

    ```bash  
    export GOROOT=/usr/local/go
    export GOPATH=$HOME/Projects/ADMFactory/Golang
    export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

    vi ~/.profile
    ```

3. Validate your installation. While you're still connected to your VM in your SSH session, enter the following command:

    ```bash  
        go version
    ```

3. [Install Git](https://git-scm.com), a widely distributed version control and source code management (SCM) system. While you're still connected to your VM in your SSH session, enter the following command:

    ```bash  
       sudo apt-get -y install git
    ```

## Deploy and run the app

1. Set up your Git repository on the VM. While you're still connected to your VM in your SSH session, enter the following commands:

    ```bash  
       git clone https://github.com/appleboy/go-hello
    
       cd go-hello
       go get -d
    ```

2. Start the app. While you're still connected to your VM in your SSH session, enter the following command:

    ```bash  
       go run hello-world.go
    ```

3. Go to your new server. You should see your running web application.

    ```HTTP  
       http://yourhostname.cloudapp.net:3000
    ```

## Next steps

- Learn more about how to [develop for Azure Stack Hub](azure-stack-dev-start.md).
- Learn about [common deployments for Azure Stack Hub as IaaS](azure-stack-dev-start-deploy-app.md).
- To learn the Go programming language and find additional resources for Go, see [Golang.org](https://golang.org).
