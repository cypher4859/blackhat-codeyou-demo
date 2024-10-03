# BlackHat Hacking: A Demo
## Docs - Table of Contents
0. [Architecture](./docs/Architecture.md)
0. [Walkthrough](./docs/Walkthrough.md)
0. [Network Infra](#network-infrastructure)
0. [Compute Infra](#compute-infrastructure)
0. [Deployment](#deployment)
0. [FAQ](#faq)


Pulled from [Architecture Documentation](./docs/Architecture.md)

## Network Infrastructure
This system is meant to be deployed to AWS to a particular region. I used `us-east-2`. The public Security Group protects the Public Subnet. All HTTP requests from the various machines are transmitted through the VPC Internet Gateway at the boundary edge. The only open receiving entrance to the internet is on port 8080 through the Application Load Balancer which will direct those transmissions to the CowabungaPizza frontend dotnet app.

Additionally there is a private subnet meant to contain the secret database and a VM that can be used a jumphost but that's still in the works.

## Compute Infrastructure
All of the Compute Infrastructure involves docker containers running services on EC2 infrastructure. Had to use `t3.medium`s to be able to host 2 containers each. All containers + virtual-machines are stood up using AutoScaling group that references a launch template for EC2 provisioning and Task Definitions for container provisioning. All of this is managed by Amazon ECS which manages the up/down scaling of resources, the specs of each, volumes, ebs storage, etc.

The Kali host and the VulnHub instance in the private subnet are not managed by AutoScaling group and are stood up by itself

## Deployment
### Pre-Requisites
1. Install the [AWS CLI](https://docs.aws.amazon.com/cli/v1/userguide/cli-chap-install.html)
1. Use AWS CLI to create the Credentials file and config file. You should have both at `~/.aws/config` and `~/.aws/credentials`. You can find [details on how to set these up here](https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-files.html). An example of what this looks like for [is below](#example-of-credentials-and-config-file).
1. Install `terraform` using [their website](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
2. `cd terraform`
2. In the `terraform/main.tf` file there is a `backend "s3" { ... }` resource. You can either delete this block or change the `bucket` value to the name of an S3 bucket that you own (you'll also need to make sure you have the right region as well). This backend block just determines where your terraform state file will be put, not necessary for one-off deployments.

### Actually Deploying
1. From the `terraform/` directory you can run `terraform apply` and be sure to type `yes` when prompted if you actually want to apply changes. Any other answer will stop the process
2. Go get a coffee :) Build time is around ~8minutes, should never be more than 30minutes or something is wrong :shrug:


### Destroying
1. When you're tired of this then from the `terraform/` directory run `terraform destroy`. This will prompt yo, say `yes`. 
2. *__Troubleshooting__*: There's a chance it'll fail to destroy some resources because of chicken-n-egg problems so if it fails then you can go to the AWS Console on their website and manually delete that failed resource. Sometimes terraform fights with the AutoScaling Group (ASG) and the ECS Capacity Provider; In that case I deleted the ASG and then deleted the ECS Capacity Provider and then ran the `terraform destroy` again to make sure it was cleaned up.

### Connecting to the Kali instance
You can go to your instance in the AWS Console, click on the instance, click `Connect` and it'll give you some options. Generally you'll need to grab the SSH KeyPair that is used with the Kali instance, download it from the `Key pairs` tab in the `EC2` Service. *_Make sure to login with user `kali` and not root_*
```sh
ssh -i "blackhat_codeyou_demo_keypair.pem" kali@<Public IPv4 DNS>
```

![Architecture Diagram](./assets/BlackHat_AWS-Architecture.png)


### FAQ
#### Example of credentials and config file
```
# Credentials file
[blackhat-user]
aws_access_key_id = <YOUR ACCESS KEY>
aws_secret_access_key = <YOUR SECRET KEY>

# Config file
[profile blackhat-user]
region=us-east-2
output = json
```

#### How Do I Setup VulnHub hosts?
Source: https://docs.aws.amazon.com/vm-import/latest/userguide/import-vm-image.html
1. Go download the vulhub OVA file from vulhub
2. Upload to S3 bucket in the account
3. Make a containers.json (should be one in the `VulHub/` path of this repo)
4. `aws ec2 import-image --description "<some kind of description>" --disk-containers "file://<PathToVulnHubDirectory>/containers.json"`

#### Once Kali is setup what do I do?
- Once logged in then we need to do a:
```sh
# login as kali
sudo apt update
sudo apt full-upgrade -y
echo "[i] Installing Xfce4 & xrdp (this will take a while as well)"
sudo apt-get install -y kali-desktop-xfce xorg xrdp

echo "[i] Configuring xrdp to listen to port 3390 (but not starting the service)"
sudo sed -i 's/port=3389/port=3390/g' /etc/xrdp/xrdp.ini

wget https://gitlab.com/kalilinux/recipes/kali-scripts/-/raw/main/xfce4.sh
chmod +x xfce4.sh
sudo ./xfce4.sh

# In the case of AWS
echo kali:kali | sudo chpasswd
```
