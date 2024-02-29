# Module 1 - Getting Started

## Prerequisites

## Set up and configure your environment to work with AWS resources.

>At the instructor-led workshop this module can be skipped as a workspace environment will be provided.

1. Go to the [provided link](https://dashboard.eventengine.run/) to get access to your AWS environment.
2. Enter the event hash as provided by the instructor, accept the terms and login.
   <img width="1412" alt="Screen Shot 2023-07-20 at 10 56 13 AM" src="https://github.com/tigera-solutions/cc-eks-shift-left/assets/117195889/1df789b2-078f-4102-80b4-228ea8bfaadc">
3. Follow the instructions to login to the lab env
   ![Screen Shot 2023-07-20 at 12 46 46 PM](https://github.com/tigera-solutions/cc-eks-shift-left/assets/117195889/c837711e-4c71-4738-9745-90860d24a501)
   ![Screen Shot 2023-07-20 at 12 47 46 PM](https://github.com/tigera-solutions/cc-eks-shift-left/assets/117195889/18b01a46-2cd3-4c31-b426-86d29b554679)
4. Click on AWS Console Login to get your access and secret keys and setup your AWS credentials, along with default region as us-east-2 in your Cloud9 console or local terminal of choice
   ![Screen Shot 2023-07-20 at 12 48 34 PM](https://github.com/tigera-solutions/cc-eks-shift-left/assets/117195889/bdeaada6-defb-4b14-afbf-5f2e19a73d8d)


## (Optional) Choose between local environment and Cloud9 instance

The simplest ways to configure your workspace environment is to either use your local environment, i.e. laptop, desktop computer, etc., or create an [AWS Cloud9 environment](https://docs.aws.amazon.com/cloud9/latest/user-guide/tutorial.html) from which you can run all necessary commands in this workshop. If you're familiar with tools like `ssh client`, `git`, `jq`, `Ncat` and feel comfortable using your local shell, then go to `step 2` in the next section.

## Steps

1. Create Cloud9 workspace environment.

    To configure a Cloud9 instance, open AWS Console and navigate to `Services` > `Developer Tools` > `Cloud9` or just search for `Cloud9`. Create an environment in the desired region. You can use all the default settings when creating the environment, but consider using `t3.small` instance instead of the default `t2.micro` instance as that could be a bit slow. You can name it as `tigera-workspace` to quickly find it in case you have many `Cloud9` instances. It usually takes only a few minutes to get the Cloud9 instance running.

2. Ensure your environment has these tools:

   - AWS CLI upgrade to v2

     [Installation instructions](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

     Linux installation:

     ```bash
     curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
     unzip awscliv2.zip
     sudo ./aws/install
     . ~/.bashrc
     aws --version
     ``` 

   - eksctl

     [Installation instructions](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)

     Linux installation

     ```bash
     curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
     sudo mv /tmp/eksctl /usr/local/bin
     eksctl version
     ```

   - EKS kubectl

     [Installation instructions](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)

     Linux installation:

     ```bash
     curl https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.1/2023-04-19/bin/linux/amd64/kubectl -o /tmp/kubectl
     sudo chmod +x /tmp/kubectl
     sudo mv /tmp/kubectl /usr/local/bin
     kubectl version --short --client
     ```

   - git and Ncat

     [Installation instructions - git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
     [Installation instructions - Ncat](https://nmap.org/ncat/)
     Linux Amazon/Centos:

     ```bash
     sudo yum install git-all nc -y
     git --version
     nc --version
     ```

     >For convenience consider configuring [autocompletion for kubectl](https://kubernetes.io/docs/tasks/tools/included/optional-kubectl-configs-bash-linux/#enable-kubectl-autocompletion).

     ```bash
     # this is optional kubectl autocomplete configuration
     echo 'source <(kubectl completion bash)' >>~/.bashrc
     echo 'alias k=kubectl' >>~/.bashrc
     echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
     source ~/.bashrc
     ```

   - K9s installation (optional)

     Download the k9s_Linux_x68_64.tar.gz file from the k9s github repo

     ```bash
     curl --silent --location "https://github.com/derailed/k9s/releases/download/v0.27.4/k9s_Linux_amd64.tar.gz" | tar xz -C /tmp
     sudo mv /tmp/k9s /usr/local/bin
     k9s version
     ```

3. Clone this repository

   ```bash
   git clone https://github.com/tigera-solutions/cc-eks-blueprint-secpos-workshop.git && cd cc-eks-blueprint-secpos-workshop
   ```

4. Configure AMI role for Cloud9 workspace.

   >This is necessary when using Cloud9 environment which has an IAM role automatically associated with it. You need to replace this role with a custom IAM role that provides necessary permissions to build EKS cluster so that you can work with the cluster using `kubectl` CLI.

   a. When using Cloud9 instance, by default the instance has AWS managed temporary credentials that provide limited permissions to AWS resources. In order to manage IAM resources from the Cloud9 workspace, export your user's [AWS Access Key/ID](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) via environment variables. If you already have them under your `~/.aws/credentials` then you can skip this step.

   >It is recommended to use your personal AWS account which would have full access to AWS resources. If using a corporate AWS account, make sure to check with account administrators to provide you with sufficient permissions to create and manage EKS clusters and Load Balancer resources.

   ```bash
   export AWS_ACCESS_KEY_ID='<your_accesskey_id>'
   export AWS_SECRET_ACCESS_KEY='<your_secretkey>'
   ```

   b. Create IAM role.

   ```bash
   IAM_ROLE='tigera-workshop-admin'
   # assign AdministratorAccess default policy. You can use a custom policy if required.
   ADMIN_POLICY_ARN=$(aws iam list-policies --query 'Policies[?PolicyName==`AdministratorAccess`].Arn' --output text)
   # create IAM role
   aws iam create-role --role-name $IAM_ROLE --assume-role-policy-document file://configs/trust-policy.json
   aws iam attach-role-policy --role-name $IAM_ROLE --policy-arn $ADMIN_POLICY_ARN
   # tag role
   aws iam tag-role --role-name $IAM_ROLE --tags '{"Key": "purpose", "Value": "tigera-eks-workshop"}'
   # create instance profile
   aws iam create-instance-profile --instance-profile-name $IAM_ROLE
   # add IAM role to instance profile
   aws iam add-role-to-instance-profile --role-name $IAM_ROLE --instance-profile-name $IAM_ROLE
   ```

   c. Assign the IAM role to Cloud9 workspace.

   - Click the grey circle button (in top right corner) and select `Manage EC2 Instance`.

   ![Cloud9 manage EC2](https://user-images.githubusercontent.com/104035488/207369343-2af69bbb-bbca-424b-96ae-154b7b2c1a90.png)

   - Select the instance, then choose `Actions` > `Security` > `Modify IAM Role` and assign the IAM role you created in previous step, i.e. `tigera-workshop-admin`.  

   <p><img width="600" alt="modify-iam-role" src="https://user-images.githubusercontent.com/104035488/207369432-c5f77cb3-19ab-41f8-940f-11677a36acf4.png"></p>

   d. Update IAM settings for your workspace.

   - Return to your Cloud9 workspace and click the gear icon (in top right corner)
   - Select AWS SETTINGS
   - Turn off AWS managed temporary credentials
   - Close the Preferences tab

   ![Cloud9 AWS settings](https://user-images.githubusercontent.com/104035488/207369474-26386f6b-e67f-4d32-9b68-62f13dbcc118.png)

   - Remove locally stored `~/.aws/credentials`

     ```bash
     rm -vf ~/.aws/credentials
     ```

   e. Unset `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` to allow Cloud9 instance to use the configured IAM role.

   ```bash
   unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
    ```

 ---

[:arrow_right: Module 2 - Deploy an EKS cluster](module-2-deploy-eks.md) <br>

[:leftwards_arrow_with_hook: Back to Main](../README.md)
