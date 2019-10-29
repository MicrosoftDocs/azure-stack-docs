---
title: Deploy a Python web app to a virtual machine in Azure Stack | Microsoft Docs
description: Deploy a Python web app to a virtual machine in Azure Stack.
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


# Deploy a Python web app to a VM in Azure Stack

You can create a VM to host your Python web app in Azure Stack. In this article, you set up a server, configure the server to host your Python web app, and then deploy the app to Azure Stack.

This article uses Python 3.x running Flask in a virtual environment on an Nginx server.

## Create a VM

1. Set up your VM in Azure Stack by following the instructions in [Deploy a Linux VM to host a web app in Azure Stack](azure-stack-dev-start-howto-deploy-linux.md).

2. In the VM network pane, make sure that the following ports are accessible:

    | Port | Protocol | Description |
    | --- | --- | --- |
    | 80 | HTTP | Hypertext Transfer Protocol (HTTP) is the protocol that's used to deliver webpages from servers. Clients connect via HTTP with a DNS name or IP address. |
    | 443 | HTTPS | Hypertext Transfer Protocol Secure (HTTPS) is a secure version of HTTP that requires a security certificate and allows for the encrypted transmission of information. |
    | 22 | SSH | Secure Shell (SSH) is an encrypted network protocol for secure communications. You use this connection with an SSH client to configure the VM and deploy the app. |
    | 3389 | RDP | Optional. The Remote Desktop Protocol (RDP) allows a remote desktop connection to use a graphic user interface on your machine.   |
    | 5000, 8000 | Custom | The ports that are used by the Flask web framework in development. For a production server, you route your traffic through 80 and 443. |

## Install Python

1. Connect to your VM by using your SSH client. For instructions, see [Connect via SSH with PuTTy](azure-stack-dev-start-howto-ssh-public-key.md#connect-with-ssh-by-using-putty).
2. At your bash prompt on your VM, enter the following command:

    ```bash  
    sudo apt-get -y install python3 python3-venv python3-dev
    ```

3. Validate your installation. While you're still connected to your VM in your SSH session, enter the following command:

    ```bash  
        python -version
    ```

3. [Install Nginx](https://www.nginx.com/resources/wiki/), a lightweight web server. While you're still connected to your VM in your SSH session, enter the following command:

    ```bash  
       sudo apt-get -y install nginx git
    ```

4. [Install Git](https://git-scm.com), a widely distributed version control and source code management (SCM) system. While you're still connected to your VM in your SSH session, enter the following command:

    ```bash  
       sudo apt-get -y install git
    ```

## Deploy and run the app

1. Set up your Git repository on the VM. While you're still connected to your VM in your SSH session, enter the following commands:

    ```bash  
       git clone https://github.com/mattbriggs/flask-hello-world.git
    
       cd flask-hello-world
    ```

2. Create a virtual environment, and populate it with all the package dependencies. While you're still connected to your VM in your SSH session, enter the following commands:

    ```bash  
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    
    export FLASK_APP=application.py
    # export FLASK_DEBUG=1 
    flask run -h 0.0.0.0
    ```

3. Go to your new server. You should see your running web application.

    ```HTTP  
       http://yourhostname.cloudapp.net:5000
    ```

## Update your server

1. Connect to your VM in your SSH session. Stop the server by typing Ctrl+C.

2. Enter the following commands:

    ```bash  
    deactivate
    open the git repo
    git pull
    ```

3. Activate the virtual environment and start the app:

    ```bash  
    source venv/bin/activate
    export FLASK_APP=application.py
    flask run -h 0.0.0.0
    ```

## Next steps

- Learn more about how to [develop for Azure Stack](azure-stack-dev-start.md).
- Learn about [common deployments for Azure Stack as IaaS](azure-stack-dev-start-deploy-app.md).
- To learn the Python programming language and find additional resources for Python, see [Python.org](https://www.python.org).
