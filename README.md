# Register APIs in Axway API Manager

This project enables you to quickly deploy/register APIs of your choice to Axway API Manager and mock their output by using [Stoplight Prizm server](https://stoplight.io/open-source/prism). The APIs must be provided in the *./APIs* folder as OAS specifications in JSON format.

## Requirements

These are the requirements to successfully use this project:

- Linux machine with Axway API Management installed
- API Manager URL has to be accessible from Internet
- Docker installed (Docker version 20.10.17 was tested)
- Git installed

## Running this project

Follow these steps to use this project:

1. Fork this project to your GitHub account

2. Clone it to your machine where you run Axway API Management. FYI, for our testing we've used CentOS 7 machine with Axway API Management v.7.7.20220530 installed. 

3. Add your API specs in JSON format to the *./APIs* folder

4. Modify the *`./config/script-config.json`* file with API Manager URL and user ID that has permissions to register APIs

5. Modify **organization** value in the `./config/API-config.json` file if needed. The default organization where the APIs will be installed is *API Development*.

6. Push these updates to your repo

7. Access your project in github.com and add a password variable **APIADMIN_PWD** (it must be this name) to your project (*Settings -> Secrets -> Actions*). This is a safe way for providing sensitive information for using in GitHub Actions.

   

   <img src="images/action-secret.png" style="zoom: 50%;" />

   

8. Click the **Action** tab and select **Deploy to APIM**. Click **Run workflow**. The action will prompt you for two input parameters: git branch and version of the Axway apim-cli. You can accept the default values. 

   

   <img src="images/run-action.png" style="zoom:50%;" />

   
   

   

9. GitHub executes this action in a container on its cloud. It will take a minute or so to complete. Come back to this page later and check the status. If the action is successful, you should see a green checkmark (like in the image above).

10. Connect to your API Manager to confirm that APIs are regisetered.

11. Now, go back to your Linux machine where you've installed Axway API Management and switch to your git repo folder.

12. Execute the following command from within this folder

    ```bash
    $ ./post-run-task.sh
    ```

    

13. This script will deploy multiple containers of Prizm mocking server on your machine: one per API spec in the *./APIs* folder. 

    **Note**: make sure that you have enough resources to run Axway APIM and multiple docker containers

14. 