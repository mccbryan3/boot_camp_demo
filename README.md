# Configure Github Pipeline for Azure

## Process

1. Create a service account with the ability to `create_scans:security`
2. <b>Fork</b> this gthub repo
   * If you do not know how to for.. ask
3. Check that you have an ssh public key `cat ~/.ssh/id_rsa.pub`<br>
    * If there is no file then run `ssh-keygen` to generate one<br>
4. Create SPN and application for Azure using the script `spn_bucket_create.sh`
6. (optional) Run `curl ifconfig.me` and record your ip<br>
7. Create a new branch in the local repo `git branch azure_pipelines_test_1`
8. Switch to the new branch `git checkout azure_pipelines_test_1`
7. (optional) Overwrite the `my_ip` variable in `demo.tfvars`<br>
7. Overwrite the `subscription_id` variable in the `backend.tf` file<br>
8. Add the creds to Github repo actions secrets including the ssh public key
![](./images/github_secrets_ssh.png)
9. Push the repo to git hub

# Jenkins Demo Setup

## Process

1. Record the public ip frm the pipeline output<br>
    * If there is no output then run re-run the pipeline<br>
    * NOTE: THIS SEEMS TO BE REQUIRED CURRENTLY<br>

2. Log into the instance with `ssh azureuser@<public_ip_address_here>`<br>
    * NOTE: If you recieve access denied.. Go get coffee and try again :-)

3. run `sudo tail -f /var/log/cloud-init-output.log`<br>

. Stretch<br>

5. Once the log finishes record the GUID for the Jenkins admin initial password<br>
![](./images/cloud_init_complete.png)<br>

6. Go to `http://<public_ip_address_here>:8080`<br>

7. Unlock Jenkins with GUID<br>
![](./images/unlock_jenkins.png)<br>

8. Install suggested plugins<br>
![](./images/install_plugins.png)<br>

9. Get coffee<br>

10. Skip user creation and continue as admin<br>

11. Select `Not now` for instance configuration<br>

12. Start using Jenkins<br>
![](./images/start_using_jenkins.png)<br>

13. Restart jenkins from the instance `sudo systemctl restart jenkins`<br>

1. Log back into Jenkins with admin and the initial password

15. Add the credentials to Jenkins<br>
    a. Manage Jenkins<br>
    ![](./images/manage_jenkins.png)<br>
    b. Manage Credentials<br>
    ![](./images/manage_creds.png)<br>
    c. System<br>
    ![](./images/system_credentials.png)<br>
    d. Global Credentials<br>
    ![](./images/global_creds.png)<br>
    e. Add Credentials<br>
    ![](./images/add_creds.png)<br>
    f. Add `username and password` credentials as shown below.<br>
        * NOTE: Be sure to give them the id of `wiz-cli`<br>
    ![](./images/create_password.png)<br>

16. Go back to the Jenkins Dashboard<br>

17. New Item<br>
![](./images/new_item.png)<br>

18. Add pipeline project with name `wiz-demo-pipeline`<br>
![](./images/pipeline_project.png)<br>

19. Add the pipeline file data [jenkins_pipeline](./jenkins_pipeline) to the pipeline steps<br>

20. Run the pipeline<br>
    * If you recieve `Got permission denied while trying to connect to the Docker daemon socket` restart jenkins as shown above

21. Review output<br>

22. Add Wiz CICD Policies to the pipeline scans to make the pipeline fail for vulns.. then iac<br>

23. Extra credit.. Figure out how to run pipeline steps on previous step failre (step conditons)
