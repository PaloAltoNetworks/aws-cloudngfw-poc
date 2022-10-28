# Distributed Architecture - Multi AZ Deployment
This blueprint deploys the distributed design model of AWS CloudNGFW to secure Inbound and Outbound traffic for Web servers deployed in a Multi-AZ architecture behind an Application Load Balancer with Autoscaling.

## High-level topology

![high-level topo](/assets/distributed-2az-arch.png)

## Deploying the AWS resources
1. Make sure that you satisfy all the [prerequisites](https://github.com/PaloAltoNetworks/aws-cloudngfw-poc#prerequisites) for this blueprint deployment.
2. Download the GitHub repository
```
git clone https://github.com/PaloAltoNetworks/aws-cloudngfw-poc.git
```
3. Change the directory to single-vpc-basic.
```
cd ~/aws-cloudngfw-poc/blueprints/distributed-architecture/multi-az-with-alb/
```
4. Open the file named _vpc.auto.tfvars_ and update the following fields with the values corresponding to your AWS environment.
```
vi vpc.auto.tfvars
```

```
access-key      = ""
secret-key      = ""
region          = ""
ssh-key-name    = ""
```
5. Initialize Terraform
```
terraform init
```
6. View the Terraform Plan to be deployed. This command will also throw up any errors in the configuration without automatically deploying the resources.
```
terraform plan
```
7. Apply the Terraform plan.
```
terraform apply -auto-approve
```
8. Once the terraform apply operation is complete, you will see a message similar to the one shown below.

![terraform apply output](/assets/distributed-2az-hcl-out.png)

9. You can copy the value of __LOAD_BALANCER_DNS_ADDRESS__ and paste it on your browser. You should see the webpage as shown below.

![webpage screenshot](/assets/web-server-dns-screen.png)

10. Now that our AWS Cloud resources have been deployed. It is time to configure and deploy the AWS CloudNGFW resources. Make sure that you have subscribed and onboarding your vendor account to the AWS CloudNGFW portal.
11. Login to AWS CloudNGFW portal using the credentials used for the onboarding.
12. Navigate to the _Rulestacks_ option on the left-menu.
13. Create a new Rulestack _Rulestack1_.
14. Create a new Rule _Rule1_ to allow only web-traffic to and from the web-servers.
    - In the _Rule Priority_ field, enter 100.
    - In the _Applications_ field, select _Match_ and add _web-browsing_ to the selected applications.
    - In the _Action_ section, choose _Allow_.
    - Enable _Logging_.
    - You can leave everything else with the default values and Save.
15. Create a new Rule _explicit-deny_ to deny any other traffic to the web-servers.
    - In the _Rule Priority_ field, enter 200.
    - In the _Action_ section, choose _Deny_.
    - Enable _Logging_.
    - You can leave everything else with the default values and Save.
16. Commit the changes by clicking on _Deploy Configuration_.
17. Navigate to the _NGFWs_ option on the left menu.
18. Create a new firewall _Firewall1_.
    - Select the AWS Account associated with the vendor account.
    - Select the VPC that has the name _cloudngfw-vpc_.
    - Select the Rulestack _Rulestack1_ that we just created in the previou step.
    - Choose _Yes_ to let the firewall create the endpoints on your VPC subnets.
    - From the list, choose the following 4 subnets and Save.
        - _cloudngfw-vpc-fw-ingress-subnet-a_
        - _cloudngfw-vpc-fw-ingress-subnet-b_
        - _cloudngfw-vpc-fw-egress-subnet-a_
        - _cloudngfw-vpc-fw-egress-subnet-b_
19. Wait until you get the status of the firewall as CREATE_COMPLETE. This should take from 10-20 mins.
20. On the AWS CloudNGFW portal, select the NGFWs option from the left-menu and click on _Firewall1_.
21. Navigate to the _Log Settings_ tab.
    - For _Log Type_, choose _TRAFFIC_ and _THREAT_.
    - For _Log Destination Type_, choose _Cloudwatch Log Group_.
    - In the _Log Destination_ field, enter __PaloAltoCloudNGFW__.
    - Save.
22. Navigate to the VPC section on the AWS Console and select Route Tables from the left-menu.
23. Make the route changes as described in the table below.

| Route Table             | Action        | Destination | Target        | Resource                                                      |
|-------------------------|---------------|-------------|---------------|---------------------------------------------------------------|
| _cloudngfw-vpc-igw-rt_  | Add new route | 10.1.3.0/24 | GWLB Endpoint | GWLB Endpoint created in _cloudngfw-vpc-fw-ingress-subnet-a_  |
| _cloudngfw-vpc-igw-rt_  | Add new route | 10.1.4.0/24 | GWLB Endpoint | GWLB Endpoint created in _cloudngfw-vpc-fw-ingress-subnet-b_  |
| _cloudngfw-vpc-lb-rt-a_ | Modify route  | 0.0.0.0/0   | GWLB Endpoint | GWLB Endpoint created in  _cloudngfw-vpc-fw-ingress-subnet-a_ |
| _cloudngfw-vpc-lb-rt-b_ | Modify route  | 0.0.0.0/0   | GWLB Endpoint | GWLB Endpoint created in  _cloudngfw-vpc-fw-ingress-subnet-b_ |
| _cloudngfw-vpc-rt-a_    | Modify route  | 0.0.0.0/0   | GWLB Endpoint | GWLB Endpoint created in  _cloudngfw-vpc-fw-egress-subnet-a_  |
| _cloudngfw-vpc-rt-b_    | Modify route  | 0.0.0.0/0   | GWLB Endpoint | GWLB Endpoint created in  _cloudngfw-vpc-fw-egress-subnet-b_  |

24. Now, try to access the webpage as you did in Step 9. You should be able to see the same webpage as seen in Step 9. If the page does not load, review the changes in the route tables made in Step 
23 once again and ensure they are as per instructions.
25. If you are able to see the webpage, navigate to AWS Cloudwatch Log Groups and select __PaloAltoCloudNGFW__.
26. You should be able to see new logs listed as the one shown below.

![webpage screenshot](/assets/log-groups.png)

![webpage screenshot](/assets/logs.png)

27. Once done, make sure to __Unsubscribe__ from the CloudNGFW service on the AWS Marketplace. This is important otherwise you will probably run into issues when you attempt to set it all up the next time.

## Fin.