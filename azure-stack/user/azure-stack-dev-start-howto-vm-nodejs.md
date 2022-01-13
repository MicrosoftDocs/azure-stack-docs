---
title: Deploy Node.js app to VM in Azure Stack Hub 
description: Deploy an Node.js app to Azure Stack Hub.
author: BryanLa

ms.topic: how-to
ms.date: 8/20/2021
ms.author: bryanla
ms.reviewer: raymondl
ms.lastreviewed: 8/20/2021
ms.custom: contperf-fy22q1

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---



# Deploy a Node.js web app to a VM in Azure Stack Hub

You can create a virtual machine (VM) to host a Node.js web app in Azure Stack Hub. In this article, set up a server, configure the server to host your Node.js web app, and then deploy the app to Azure Stack Hub.

If you are looking for general information about global Azure, see [Azure for JavaScript & Node.js developers](/azure/developer/javascript/). This article is for using Azure Stack Hub, an on-premises version of Azure.

## Create a VM

1. Set up your VM in Azure Stack Hub by following the instructions in [Deploy a Linux VM to host a web app in Azure Stack Hub](azure-stack-dev-start-howto-deploy-linux.md).

2. In the VM network pane, make sure that the following ports are accessible:

    | Port | Protocol | Description |
    | --- | --- | --- |
    | 80 | HTTP | Hypertext Transfer Protocol (HTTP) is the protocol that's used to deliver webpages from servers. Clients connect via HTTP with a DNS name or IP address. |
    | 443 | HTTPS | Hypertext Transfer Protocol Secure (HTTPS) is a secure version of HTTP that requires a security certificate and allows for the encrypted transmission of information. |
    | 22 | SSH | Secure Shell (SSH) is an encrypted network protocol for secure communications. You use this connection with an SSH client to configure the VM and deploy the app. |
    | 3389 | RDP | Optional. The Remote Desktop Protocol (RDP) allows a remote desktop connection to use a graphic user interface on your machine.   |
    | 3000 | Custom | The port that's used by the Node.js Express framework. For a production server, you route your traffic through 80 and 443. |

## Install Node

1. Connect to your VM by using your SSH client. For instructions, see [Connect via SSH with PuTTY](azure-stack-dev-start-howto-ssh-public-key.md#connect-with-ssh-by-using-putty).

2. At the bash prompt on your VM, enter the following command:

    ```bash  
      sudo apt-get update
      sudo apt-get install nodejs
      sudo apt-get install npm
    ```

    This also installs [NPM](https://www.npmjs.com/), a package manager for Node.js packages, or modules. 

3. Validate your installation. While you're still connected to your VM in your SSH session, enter the following command:

    ```bash  
       node --version
    ```

## Scaffold a new application with the Express Generator

[Express](https://www.expressjs.com/) is a popular framework for building and running Node.js applications. You can scaffold (create) a new Express application using the [Express Generator tool](https://expressjs.com/en/starter/generator.html). The Express Generator is shipped as an **npm** module and can be run directly (without installation) by using the npm command-line tool `npx`.

```bash  
 npx express-generator myExpressApp --view pug --git
```

The ` --view pug --git` parameters tell the generator to use the pug template engine (formerly known as `jade`) and to create a `.gitignore` file.

To install all of the application's dependencies, go to the new folder and run npm install.

```bash  
cd myExpressApp
npm install
```

Run the application. From the terminal, start the application using the `npm start` command to start the server.

Go to your new server in a Web browser. You should see your running web application. You can find the URL for your Linux VM in the Azure Stack Hub user portal labeled **DNS name**.

```HTTP  
http://yourhostname.contoso.com:3000
```

## Next steps

- Learn more about how to [develop for Azure Stack Hub](azure-stack-dev-start.md).
- Learn about [common deployments for Azure Stack Hub as IaaS](azure-stack-dev-start-deploy-app.md).
- To learn more about using Node.js with Azure, see [Azure for JavaScript & Node.js developers](/azure/developer/javascript/)
