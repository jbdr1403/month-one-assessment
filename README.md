---

# **TechCorp AWS Infrastructure – Terraform Deployment**

![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?style=for-the-badge\&logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Cloud-orange?style=for-the-badge\&logo=amazon-aws)
![Status](https://img.shields.io/badge/Environment-Ready-success?style=for-the-badge)
![AltSchool](https://img.shields.io/badge/AltSchool-Assesment-blue?style=for-the-badge)

---

This repository contains the complete **Infrastructure-as-Code** configuration for deploying TechCorp’s highly available, securely segmented, multi-tier application environment on AWS.
The goal is to demonstrate practical engineering ability in:

- VPC design & subnetting
- Multi-AZ resilience
- Secure access patterns
- Automated provisioning via Terraform
- EC2 bootstrapping using user-data
- Load balancing and service health-checking
- Infrastructure lifecycle management

The implementation strictly follows the assessment’s **business**, **technical**, and **security** requirements.

---

```
====================================================
   T E C H C O R P   C L O U D   A R C H I T E C T U R E
====================================================
```

---

## **📘 Table of Contents**

- [Architecture Overview](#architecture-overview)
- [Assessment Requirements Coverage](#assessment-requirements-coverage)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Configuration Variables](#configuration-variables)
- [Deployment Steps](#deployment-steps)
- [Testing the Infrastructure](#testing-the-infrastructure)
- [Cleanup / Destroying Resources](#cleanup--destroying-resources)
- [Evidence](#evidence)

---

## **🏗️ Architecture Overview**

The deployed infrastructure includes:

### **Network Layer**

- VPC: `10.0.0.0/16` with DNS hostnames enabled
- Public Subnets:

  - `10.0.1.0/24` (AZ1)
  - `10.0.2.0/24` (AZ2)

- Private Subnets:

  - `10.0.3.0/24` (AZ1)
  - `10.0.4.0/24` (AZ2)

- Internet Gateway for public outbound access
- Two **NAT Gateways** (one per public subnet) ensuring private workloads can reach the internet securely
- Public and private route tables
- NACLs providing stateless subnet-level control

### **Compute Layer**

- **Bastion Host** (public subnet) — SSH only from your IP
- **Two Web Servers** (private subnets):

  - Registered to ALB Target Group
  - Bootstrapped via user-data with Apache & instance-ID HTML

- **Database Server** (private subnet):

  - Bootstrapped via user-data with PostgreSQL installation
  - Restricted to only Web SG + Bastion SG

### **Application Load Balancer**

- ALB spanning both public subnets
- Listener on port 80
- Health checks enabling resilient traffic routing
- Target group attached to both web servers

### **Security Controls**

- Bastion SG: allows SSH only from your public IP
- Web SG:

  - Allows HTTP/HTTPS from anywhere (per requirement)
  - Allows SSH only from Bastion SG

- DB SG:

  - Allows Postgres (5432) only from Web SG
  - Allows SSH from Bastion SG

---

## **📋 Assessment Requirements Coverage**

| Requirement                         | Status                           |
| ----------------------------------- | -------------------------------- |
| Multi-AZ High Availability          | ✅ Implemented                   |
| Public & Private Subnets            | ✅ 4 Subnets Created             |
| VPC with DNS support                | ✅ Enabled                       |
| NAT Gateways in both AZs            | ✅ Implemented                   |
| Bastion Host for secure access      | ✅ Configured                    |
| Auto-install Apache on Web Tier     | ✅ user-data/web_server_setup.sh |
| Auto-install PostgreSQL on DB Tier  | ✅ user-data/db_server_setup.sh  |
| ALB distributing traffic            | ✅ Target group + health checks  |
| SSH via Bastion → Web/DB            | ✅ Verified                      |
| Connect to PostgreSQL               | ✅ Achieved (`postgres=#`)       |
| Evidence folder with screenshots    | ✅ Included                      |
| README with Deployment Instructions | ✅ This document                 |
| Project Structure per assessment    | ✅ Matches specification         |

---

```
====================================================
             P R E R E Q U I S I T E S
====================================================
```

---

## **🛠️ Prerequisites**

To deploy this infrastructure, ensure you have:

### **Local Requirements**

- Terraform ≥ 1.5
- AWS CLI configured with appropriate IAM permissions
- An existing AWS EC2 Key Pair
- A Unix-like terminal (Mac/Linux/WSL)
- Your public IP for secure Bastion access (e.g., `curl ifconfig.me`)

### **AWS Requirements**

The IAM user should have permissions for:

- VPC
- EC2
- ELB
- IAM Key Pair usage
- CloudWatch logs (optional)

---

## **📦 Project Structure**

```
terraform-assessment/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example
│
├── user_data/
│   ├── web_server_setup.sh
│   └── db_server_setup.sh
│
├── evidence/
│   ├── (screenshots)
│   └── README.md
│
└── README.md
```

---

## **📝 Configuration Variables**

Copy the example file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Modify:

```hcl
region        = "us-west-2"
key_pair_name = "mynew_instance"
my_ip         = "YOUR_PUBLIC_IP/32"

bastion_instance_type = "t3.micro"
web_instance_type     = "t3.micro"
db_instance_type      = "t3.small"

azs = ["us-west-2a", "us-west-2b"]
```

---

```
====================================================
             D E P L O Y M E N T   S T E P S
====================================================
```

---

## **🚀 Deployment Steps**

### **1. Initialize Terraform**

```bash
terraform init
```

### **2. Validate & Format**

```bash
terraform fmt
terraform validate
```

### **3. Review plan**

```bash
terraform plan
```

### **4. Apply infrastructure**

```bash
terraform apply
```

Confirm with **yes**.

Terraform will create:

- Networking
- EC2 instances
- ALB
- Security groups
- Bootstrapped services (Apache, PostgreSQL)

---

```
====================================================
           T E S T I N G   T H E   S T A C K
====================================================
```

---

## **🔍 Testing the Infrastructure**

### **1. SSH into Bastion**

```bash
ssh -i ~/.ssh/<your-key>.pem ec2-user@<bastion_public_ip>
```

### **2. Bastion → Web Servers**

```bash
ssh ec2-user@10.0.3.33
ssh ec2-user@10.0.4.250
```

Validate Apache:

```bash
curl localhost
```

### **3. Bastion → Database Server**

```bash
ssh ec2-user@<db_private_ip>
```

Validate PostgreSQL:

```bash
sudo systemctl status postgresql
psql --version
```

Connect:

```bash
sudo -u postgres psql
```

You should see:

```
postgres=#
```

### **4. Test Load Balancer**

Open:

```
http://<alb_dns_name>
```

Expect alternating responses between Web Server 1 & Web Server 2.

---

```
====================================================
                   C L E A N U P
====================================================
```

---

## **🧹 Destroying the Infrastructure**

To avoid AWS charges:

```bash
terraform destroy
```

Approve with **yes**.

Terraform will delete all resources including VPC, EC2 instances, ALB, NAT Gateways, and subnets.

---

## **📸 Evidence**

Screenshots documenting the deployment process are stored in:

👉 **[evidence/](./evidence/)**

This includes:

- Terraform plan & apply
- VPC, subnets, NAT GW
- ALB & target groups
- EC2 instances
- SSH to Bastion, Web, and DB systems
- PostgreSQL connection
- ALB webpage tests

---
