---

# **TechCorp AWS Infrastructure – Terraform Deployment**

![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?style=for-the-badge&logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Cloud-orange?style=for-the-badge&logo=amazon-aws)
![Status](https://img.shields.io/badge/Environment-Ready-success?style=for-the-badge)
![AltSchool](https://img.shields.io/badge/AltSchool-Assessment-blue?style=for-the-badge)

---

This repository contains the complete **Infrastructure-as-Code** configuration for deploying TechCorp’s highly available, securely segmented, multi-tier application environment on AWS.

The goal is to demonstrate practical engineering ability in:

- VPC design & subnetting
- Multi-AZ resilience
- Secure access patterns
- Automated provisioning via Terraform
- EC2 bootstrapping (Apache, PostgreSQL)
- Load balancing and health checks
- Infrastructure lifecycle management

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

### **Network Layer**

- VPC: `10.0.0.0/16` with DNS hostnames enabled
- Public Subnets: `10.0.1.0/24`, `10.0.2.0/24`
- Private Subnets: `10.0.3.0/24`, `10.0.4.0/24`
- Internet Gateway
- NAT Gateways (one per public subnet)
- Public & Private Route Tables
- Network ACLs

### **Compute Layer**

- **Bastion Host**
- **Two Web Servers** with Apache + instance-ID page
- **Database Server** with PostgreSQL installed via user-data

### **Application Load Balancer**

- ALB across both public subnets
- HTTP listener
- Health checks for target group

### **Security Controls**

- Bastion SG → SSH from your IP
- Web SG → HTTP/HTTPS, SSH from Bastion
- DB SG → PostgreSQL (5432) from Web SG

---

## **📋 Assessment Requirements Coverage**

| Requirement                | Status |
| -------------------------- | ------ |
| Multi-AZ Architecture      | ✅     |
| Public & Private Subnets   | ✅     |
| NAT Gateways               | ✅     |
| Bastion Host               | ✅     |
| Web Servers + Apache       | ✅     |
| DB Server + PostgreSQL     | ✅     |
| ALB + Target Group         | ✅     |
| SSH via Bastion → Web → DB | ✅     |
| Connect to PostgreSQL      | ✅     |
| Evidence Folder            | ✅     |
| Full README                | ✅     |

---

```
====================================================
                 P R E R E Q U I S I T E S
====================================================
```

---

## **🛠️ Prerequisites**

- Terraform ≥ 1.5
- AWS CLI configured
- Existing Key Pair
- Public IP address (`curl ifconfig.me`)
- IAM permissions for EC2, VPC, ELB

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
│   ├── *.png
│   └── README.md
│
└── README.md
```

---

## **📝 Configuration Variables**

Copy:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Modify:

```hcl
region  = "us-west-2"
key_pair_name = "mynew_instance"
my_ip   = "YOUR_PUBLIC_IP/32"

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

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Approve with **yes**.

---

```
====================================================
           T E S T I N G   T H E   S T A C K
====================================================
```

---

## **🔍 Testing**

### **1. SSH into Bastion**

```bash
ssh -i ~/.ssh/<key>.pem ec2-user@<bastion_public_ip>
```

### **2. SSH from Bastion → Web Servers**

```bash
ssh ec2-user@10.0.3.33
ssh ec2-user@10.0.4.250
```

Check Apache:

```bash
curl localhost
```

### **3. SSH from Bastion → DB Server**

```bash
ssh ec2-user@<db_ip>
```

Check PostgreSQL:

```bash
sudo systemctl status postgresql
sudo -u postgres psql
```

Expect:

```
postgres=#
```

### **4. Test Load Balancer**

Open:

```
http://<alb_dns_name>
```

---

```
====================================================
                     C L E A N U P
====================================================
```

---

## **🧹 Destroy Everything**

```bash
terraform destroy
```

Approve with **yes**.

---

## **📸 Evidence**

All screenshots are located in:

👉 **[evidence/](./evidence/)**

---
