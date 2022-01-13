---
title: Deploy Python web app to VM in Azure Stack Hub 
description: Deploy a Python web app to a virtual machine in Azure Stack Hub.
author: BryanLa

ms.topic: how-to
ms.date: 9/29/2021
ms.author: bryanla
ms.reviewer: raymondl
ms.lastreviewed: 9/29/2021
ms.custom: contperf-fy22q1

# Intent: As an Azure Stack Hub user, I want to deploy a Python web app to a virtual machine in Azure Stack Hub.
# Keyword: deploy python webapp VM azure stack hub

---

# Deploy a Python web app to a VM in Azure Stack Hub

You can create a VM to host your Python web app in Azure Stack Hub. In this article, you set up a server, configure the server to host your Python web app, and then deploy the app to Azure Stack Hub.

This article uses Python 3.x running Flask in a virtual environment on an Nginx server. Use **Ubuntu Server 18.04 LTS** from the Azure Stack Hub Marketplace.
## Create a VM

1. Set up your VM in Azure Stack Hub by following the instructions in [Deploy a Linux VM to host a web app in Azure Stack Hub](azure-stack-dev-start-howto-deploy-linux.md). Use **Ubuntu Server 18.04 LTS** from the Azure Stack Hub Marketplace.

2. In the VM network pane, make sure that the following ports are accessible:

    | Port | Protocol | Description |
    | --- | --- | --- |
    | 80 | HTTP | Hypertext Transfer Protocol (HTTP) is the protocol that's used to deliver webpages from servers. Clients connect via HTTP with a DNS name or IP address. |
    | 443 | HTTPS | Hypertext Transfer Protocol Secure (HTTPS) is a secure version of HTTP that requires a security certificate and allows for the encrypted transmission of information. |
    | 22 | SSH | Secure Shell (SSH) is an encrypted network protocol for secure communications. You use this connection with an SSH client to configure the VM and deploy the app. |
    | 3389 | RDP | Optional. The Remote Desktop Protocol (RDP) allows a remote desktop connection to use a graphic user interface on your machine.   |
    | 5000, 8000 | Custom | The ports that are used by the Flask web framework in development. For a production server, you route your traffic through 80 and 443. |

3. In the **Overview** pane, select **configure** under DNS name.

4. Select **static** and then name the machine so that you have a DNS name such as: `<yourmachine>.<local>.cloudapp.azurestack.contoso.com`.

## Install Python

1. Connect to your VM by using your SSH client. For instructions, see [Connect via SSH with PuTTy](azure-stack-dev-start-howto-ssh-public-key.md#connect-with-ssh-by-using-putty).
2. At your bash prompt on your VM, enter the following command:

    ```bash  
    sudo apt-get update
    sudo apt-get -y install python3 python3-dev
    sudo apt install python3-pip
    ```

3. Validate your installation. While you're still connected to your VM in your SSH session, enter the following command to open Python and note the version number. Then type `quit()` to exit the Python REPL.

    ```bash  
    python3
    quit()
    ```

3. [Install Nginx](https://www.nginx.com/resources/wiki/), a lightweight web server. While you're still connected to your VM in your SSH session, enter the following command:

    ```bash  
    sudo apt-get -y install nginx
    ```

4. [Install Git](https://git-scm.com), a widely distributed version control and source code management (SCM) system. While you're still connected to your VM in your SSH session, enter the following command:

    ```bash  
    sudo apt-get -y install git
    ```

## Deploy and run the app

1. Set up your Git repository on the VM. While you're still connected to your VM in your SSH session, enter the following commands:

    ```bash  
       git clone https://github.com/Azure-Samples/azure-stack-hub-flask-hello-world.git
    
       cd azure-stack-hub-flask-hello-world
    ```

2. While you're still connected to your VM in your SSH session, enter the following commands to install the dependencies. Install Flask using apt, and then pip to load the modules from `requirements.txt`.

    ```bash  
    sudo apt install python3-flask
    pip3 install -r requirements.txt

    export FLASK_APP=application.py
    flask run -h 0.0.0.0
    ```

3. Go to your new server. You should see your running web application.

    ```HTTP  
    <yourmachine>.<local>.cloudapp.azurestack.contoso.com:5000
    ```

## Update your server

1. Connect to your VM in your SSH session. Stop the server by typing Ctrl+C.

2. Enter the following commands:

    ```bash  
    cd azure-stack-hub-flask-hello-world
    git pull
    ```

3. Activate the virtual environment and start the app:

    ```bash  
    export FLASK_APP=application.py
    flask run -h 0.0.0.0
    ```

## Next steps

- Learn more about how to [develop for Azure Stack Hub](azure-stack-dev-start.md).
- Learn about [common deployments for Azure Stack Hub as IaaS](azure-stack-dev-start-deploy-app.md).
- To learn the Python programming language and find additional resources for Python, see [Python.org](https://www.python.org).
