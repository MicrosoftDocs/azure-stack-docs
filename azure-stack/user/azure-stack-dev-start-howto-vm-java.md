---
title: Deploy an Java WAR to a virtual machine in Azure Stack | Microsoft Docs
description:  Deploy an Java WAR to a virtual machine in Azure Stack.
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


# How to deploy a Java web app to a VM in Azure Stack

You can create a VM to host your Python Web app in Azure Stack. This article looks at the steps you will follow in setting up server, configuring the server to host your Python web app, and then deploying your app.

Java is a general-purpose computer-programming language that is concurrent, class-based, object-oriented, and designed to have as few implementation dependencies as possible. It is intended to let application developers "write once, run anywhere", meaning that compiled Java code can run on all platforms that support Java without the need for recompilation. To learn the Java programming language and find additional resources for Java, see [Java.com](https://www.java.com).

This article will walk through installing and configuring an Apache Tomcat server on a Linux VM in Azure Stack, and then loading a Java Web application Resource (WAR) file into the server. A WAR file is used to distribute a collection of JAR-files, JavaServer Pages, Java Servlets, Java classes, XML files, tag libraries, static web pages (HTML and related files) and other resources that together constitute a web application.

Apache Tomcat, often referred to as Tomcat Server, is an open-source Java Servlet Container developed by the Apache Software Foundation. Tomcat implements several Java EE specifications including Java Servlet, JavaServer Pages, Java EL, and WebSocket, and provides a "pure Java" HTTP web server environment in which Java code can run.

## Create a VM

1. Set up your VM set up in Azure Stack. Follow the steps in [Deploy a Linux VM to host a web app in Azure Stack](azure-stack-dev-start-howto-deploy-linux.md).

2. In the VM network blade, make sure the following ports are accessible:

    | Port | Protocol | Description |
    | --- | --- | --- |
    | 80 | HTTP | Hypertext Transfer Protocol (HTTP) is an application protocol for distributed, collaborative, hypermedia information systems. Clients will connect to your web app with either the public IP or DNS name of your VM. |
    | 443 | HTTPS | Hypertext Transfer Protocol Secure (HTTPS) is an extension of the Hypertext Transfer Protocol (HTTP). It is used for secure communication over a computer network. Clients will connect to your web app with the either the public IP or DNS name of your VM. |
    | 22 | SSH | Secure Shell (SSH) is a cryptographic network protocol for operating network services securely over an unsecured network. You will use this connection with an SSH client to configure the VM and deploy the app. |
    | 3389 | RDP | Optional. The Remote Desktop Protocol allows for a remote desktop connection to use a graphic user interface your machine.   |
    | 8080 | Custom | The default port for the Apache Tomcat service is 8080. For a production server, you will want to route your traffic through 80 and 443. |

## Install Java

1. Connect to your VM using your SSH client. For instructions, see [Connect via SSH with PuTTy](azure-stack-dev-start-howto-ssh-public-key.md#connect-via-ssh-with-putty).
2. At your bash prompt on your VM, type the following commands:

    ```bash  
        sudo apt-get install default-jdk
    ```

3. Validate your installation. Still connected to your VM in your SSH session, type the following commands:

    ```bash  
        java -version
    ```

## Install and configure Tomcat

1. Connect to your VM using your SSH client. For instructions, see [Connect via SSH with PuTTy](azure-stack-dev-start-howto-ssh-public-key.md#connect-via-ssh-with-putty).

2. Create Tomcat user.
    - First, create a new Tomcat group:
        ```bash  
            sudo groupadd tomcat
        ```
     
    - Second, create a new Tomcat user and make this user a member of the tomcat group with a home directory of `/opt/tomcat`, which is where you will install Tomcat, and with a shell of `/bin/false` (so nobody can log into the account):
        ```bash  
            sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
        ```

3. Install Tomcat.
    - First, get the URL for the tar for the latest version of Tomcat 8 from the Tomcat 8 download page at:  [http://tomcat.apache.org/download-80.cgi](http://tomcat.apache.org/download-80.cgi)
    - Second, user curl to download the latest version using the link.

        ```bash  
            cd /tmp 
            curl -O <URL for the tar for the latest version of Tomcat 8>
        ```

    - Third, install Tomcat to the `/opt/tomcat` directory. Create the directory, then extract the archive using the following commands:

        ```bash  
            sudo mkdir /opt/tomcat
            sudo tar xzvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1
            sudo chown -R tomcat webapps/ work/ temp/ logs/
        ```

4. Update the permissions for Tomcat.

    ```bash  
        sudo chgrp -R tomcat /opt/tomcat
        sudo chmod -R g+r conf
        sudo chmod g+x conf
    ```

5. Create a `systemd` service file. so that you can run Tomcat as a service.

    - Tomcat needs to know where Java is installed. This path is commonly referred to as **JAVA_HOME**. Find the location by running:

        ```bash  
            sudo update-java-alternatives -l
        ```

        This will produce something like the following:

        ```Text  
            Output
            java-1.8.0-openjdk-amd64       1081       /usr/lib/jvm/java-1.8.0-openjdk-amd64
        ```

        The **JAVA_HOME** variable value can be constructed by taking the path from the output and adding `/jre`. For example, using the above example: `/usr/lib/jvm/java-1.8.0-openjdk-amd64/jre`

    - Use the value from your server to create the systemd service file.

        ```bash  
            sudo nano /etc/systemd/system/tomcat.service
        ```

    - Paste the following contents into your service file. Modify the value of **JAVA_HOME** if necessary to match the value you found on your system. You may also want to modify the memory allocation settings that are specified in CATALINA_OPTS:

        ```Text  
            [Unit]
            Description=Apache Tomcat Web Application Container
            After=network.target
            
            [Service]
            Type=forking
            
            Environment=JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/jre
            Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
            Environment=CATALINA_HOME=/opt/tomcat
            Environment=CATALINA_BASE=/opt/tomcat
            Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
            Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'
            
            ExecStart=/opt/tomcat/bin/startup.sh
            ExecStop=/opt/tomcat/bin/shutdown.sh
        
            User=tomcat
            Group=tomcat
            UMask=0007
            RestartSec=10
            Restart=always
            
            [Install]
            WantedBy=multi-user.target
        ```

    - Save and close the file.
    - Reload the systemd daemon so that it knows about your service file:

        ```bash  
            sudo systemctl daemon-reload
        ```

    - Start the Tomcat service 

        ```bash  
            sudo systemctl start tomcat
        ```

    - Verify that it started without errors by typing:

        ```bash  
            ssudo systemctl status tomcat
        ```

6. Verify the Tomcat server. Tomcat uses port 8080 to accept conventional requests. Allow traffic to that port by running the following command:

    ```bash  
        sudo ufw allow 8080
    ```

    If you haven't added the **Inbound port rules** for your Azure Stack VM, then add those now. For more information, see [Create a VM](#create-a-vm).

7. Open a browser in the same network as your Azure Stack and open your server: `yourmachine.local.cloudapp.azurestack.external:8080`

    ![Apache Tomcat on an Azure Stack VM](media/azure-stack-dev-start-howto-vm-java/apache-tomcat.png)

    The Apache Tomcat page on your server loads. Next, you will configure the server to allow you to access the Server Status, Manager App, and Host Manager.

8. Enable the service file so that Tomcat automatically starts when you reboot your server:

    ```bash  
        sudo systemctl enable tomcat
    ```

9. Configure Tomcat server to allow you to access to the web management interface. Edit the `tomcat-users.xml` and define a role and user so that you can sign in. Define the user to access the `manager-gui` and `admin-gui`.

    ```bash  
        sudo nano /opt/tomcat/conf/tomcat-users.xml
    ```

    - Add the following elements into the `<tomcat-users>` section:

    ```XML  
        <role rolename="tomcat"/>
        <user username="<username>" password="<password>" roles="tomcat,manager-gui,admin-gui"/>
    ```

    - For example, your final file may look something like:

    ```XML  
        <tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
         <role rolename="tomcat"/>
        <user username="tomcatuser" password="changemepassword" roles="tomcat,manager-gui,admin-gui"/>
        </tomcat-users>
    ```

    - Save and close the file.


10. Tomcat restricts access to the **Manager** and **Host Manager** apps to connections coming from the server. Since you are installing Tomcat on a VM in Azure Stack, you will want to remove this restriction. Change the IP address restrictions on these apps, by editing the appropriate `context.xml` files.

    - Update  `context.xml` the Manager app:

        ```bash  
            sudo nano /opt/tomcat/webapps/manager/META-INF/context.xml
        ```

    - Comment out the IP address restriction to allow connections from anywhere, or add the IP address of the machine you are using to connect to Tomcat.

        ```XML  
        <Context antiResourceLocking="false" privileged="true" >
          <!--<Valve className="org.apache.catalina.valves.RemoteAddrValve"
                 allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />-->
        </Context>
        ```

    - Save and close the file.

    - Update  `context.xml` the Host Manager app with a similar update:

        ```bash  
            sudo nano /opt/tomcat/webapps/host-manager/META-INF/context.xml
        ```

    - Save and close the file.

11. Restart the Tomcat service to update the server with the changes:

    ```bash  
        sudo systemctl restart tomcat
    ```

12. Open a browser in the same network as your Azure Stack and open your server: `yourmachine.local.cloudapp.azurestack.external:8080`.

    - Select Server Status to review the status of the Tomcat server and verify you have access.
    - Sign in with your Tomcat credentials.

![Apache Tomcat on an Azure Stack VM](media/azure-stack-dev-start-howto-vm-java/apache-tomcat-management-app.png)

## Create an app

You will need to create a WAR to deploy to Tomcat. If you would just like to check your environment, you can find an example War at the Apache TomCat site: [sample app](https://tomcat.apache.org/tomcat-6.0-doc/appdev/sample/).

For guidance about developing Java apps in Azure, see [Build and deploy Java apps on Azure](https://azure.microsoft.com/develop/java/).

## Deploy and run the app

1. Connect to your VM using your SSH client. For instructions, see [Connect via SSH with PuTTy](azure-stack-dev-start-howto-ssh-public-key.md#connect-via-ssh-with-putty).
1. Stop the Tomcat service to update the server with your app package:

    ```bash  
        sudo systemctl stop tomcat
    ```

2.  Add your FTP user to the tomcat group so that you can write to the webapps folder. Your FTP user is the user your define when creating your VM in Azure Stack.

    ```bash  
        sudo usermod -a -G tomcat <VM-user>
    ```

3. Connect to your VM with FileZilla to clear the webapps folder and then load your new or updated WAR. For instructions on using FileZila, see [Connect with SFTP with FileZilla](azure-stack-dev-start-howto-ssh-public-key.md#connect-with-sftp-with-filezilla).
    - Clear `TOMCAT_HOME/webapps`.
    - Add your WAR to ` TOMCAT_HOME/webapps`, for example  `/opt/tomcat/webapps/`.

4.  Tomcat automatically expands and deploys the application. You can view it with the DNS name you created earlier. For example:

    ```HTTP  
       http://yourmachine.local.cloudapp.azurestack.external:8080/sample

## Next steps

- Learn more about how to [Develop for Azure Stack](azure-stack-dev-start.md)
- Learn about [common deployments for Azure Stack as IaaS](azure-stack-dev-start-deploy-app.md).