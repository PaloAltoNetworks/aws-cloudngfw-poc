# AWS CloudNGFW Blueprints for PoCs
This repository contains the blueprints and modules required for deploying a Proof-of-Concept architecture with AWS CloudNGFW.

## Prerequisites
### AWS
- A working AWS account
- The Access key and Secret key credentials for your AWS account. This is required if you would like to deploy this from your own system.
- IAM permissions for:
    - Subscribing to the CloudNGFW service on the AWS Marketplace.
    - AWS CloudShell, if you do not have the Access key and Secret key credentials for your AWS account.
    - Deploying the below resources:
        - VPCs
        - Subnets
        - EC2 instances
        - VPC Routes
        - Route tables
        - Route table associations
        - Internet Gateways
        - Network Interfaces
        - SSH Key-Pairs
        - Elastic IPs
        - Security Groups
        - CloudWatch Log Groups
- Integrate your vendor account with CloudNGFW. More details on this in the next section.

__Note:__ You may need further IAM permissions for resources specific to each blueprint. Those will be covered in their respective blueprints.

### Terraform
- You will need to install _Terraform_ on the system from which you intend to deploy the terraform code. For this code-base, you need a minimum version of v1.0.
- Obviously, you will need _git_ to clone this repo on to your system.

### Logging
- Create a Log Group called __PaloAltoCloudNGFW__ in AWS CloudWatch.

## CloudNGFW Resources

### Subscribing and Onboarding the vendor account to AWS CloudNGFW

[![Subscribing to AWS CloudNGFW](https://img.youtube.com/vi/qeyODhEBpj8/hqdefault.jpg)](https://www.youtube.com/watch?v=qeyODhEBpj8)

### Creating a Rulestack and Security Profiles

[![AWS CloudNGFW Rulestacks](https://img.youtube.com/vi/IKICc6N5CY4/hqdefault.jpg)](https://www.youtube.com/watch?v=IKICc6N5CY4)

### Creating the AWS Cloud NGFW resource

[![AWS CloudNGFW NGFWs](https://img.youtube.com/vi/oT5FvwkN3Nk/hqdefault.jpg)](https://www.youtube.com/watch?v=oT5FvwkN3Nk)