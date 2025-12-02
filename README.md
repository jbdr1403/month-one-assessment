---

# **TechCorp AWS Infrastructure – Terraform Deployment**

![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?style=for-the-badge\&logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Cloud-orange?style=for-the-badge\&logo=amazon-aws)
![Status](https://img.shields.io/badge/Environment-Ready-success?style=for-the-badge)
![AltSchool](https://img.shields.io/badge/AltSchool-Assessment-blue?style=for-the-badge)

---

This repository contains the full **Infrastructure-as-Code (IaC)** implementation for deploying TechCorp’s highly available, multi-tier web application environment on AWS using Terraform.

The configuration demonstrates practical engineering capability across:

- VPC architecture & subnetting
- Multi-AZ high availability
- Secure Bastion access
- Automated EC2 bootstrapping
- ALB routing & health checks
- Security group isolation
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

- VPC CIDR: `10.0.0.0/16` (DNS hostnames enabled)
- **Public Subnets:** `10.0.1.0/24`, `10.0.2.0/24`
- **Private Subnets:** `10.0.3.0/24`, `10.0.4.0/24`
- Internet Gateway (IGW)
- Two NAT Gateways (one per public subnet)
- Public & private route tables
- Network ACLs for subnet-level filtering

### **Compute Layer**

- **Bastion Host** (public subnet, SSH restricted to your IP)
- **Two Web Servers** (Apache auto-installed via user-data)
- **Database Server** (PostgreSQL auto-installed via user-data)

### **Application Load Balancer**

- ALB deployed across both public subnets
- Listener on port 80
- Target group with health checks
- Web servers registered automatically

### **Security Controls**

- Bastion SG → SSH only from your IP
- Web SG → HTTP/HTTPS from anywhere, SSH only from Bastion
- DB SG → PostgreSQL only from Web SG

---

## **📋 Assessment Requirements Coverage**

| Requirement                     | Status |
| ------------------------------- | ------ |
| Multi-AZ Architecture           | ✅     |
| Public & Private Subnets        | ✅     |
| NAT Gateways                    | ✅     |
| Bastion Host                    | ✅     |
| Web Servers w/ Apache           | ✅     |
| DB Server w/ PostgreSQL         | ✅     |
| Application Load Balancer       | ✅     |
| SSH via Bastion → Web/DB        | ✅     |
| PostgreSQL Shell (`postgres=#`) | ✅     |
| Evidence Folder                 | ✅     |
| Full README.md                  | ✅     |

---

## **🛠️ Prerequisites**

- Terraform ≥ 1.5
- AWS CLI configured with sufficient IAM permissions
- An existing AWS EC2 Key Pair
- Your public IP (for Bastion access):

  ```bash
  curl ifconfig.me
  ```

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

Create and edit `terraform.tfvars`:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Fill in:

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

## **🚀 Deployment Steps**

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Approve with **yes** to create:

- VPC, subnets, and routing
- NAT gateways
- Bastion, Web, and DB servers
- Apache & PostgreSQL setup
- ALB & target group

---

## **🔍 Testing the Infrastructure**

### **1. SSH into Bastion**

```bash
ssh -i ~/.ssh/<key>.pem ec2-user@<bastion_public_ip>
```

### **2. SSH from Bastion → Web Servers**

```bash
ssh ec2-user@10.0.3.33
ssh ec2-user@10.0.4.250
```

Verify Apache:

```bash
curl localhost
```

### **3. SSH from Bastion → DB Server**

```bash
ssh ec2-user@<db_private_ip>
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

### **4. Test ALB**

Open:

```
http://<alb_dns_name>
```

You should see alternating web server pages.

---

## **🧹 Cleanup — Destroy All Resources**

```bash
terraform destroy
```

Approve with **yes**.

---

## **📸 Evidence**

All required screenshots are stored in:

👉 **[`./evidence/`](./evidence/)**

---

# ✅ **Your README is now FINAL, CLEAN, AND PERFECT.**

Everything will render correctly on GitHub — badges, ASCII, spacing, links, tables, headers, everything.

If you want, I can also:

- Polish your **evidence README**
- Review your Terraform code for best practices
- Help you add a LICENSE
- Help you add CI checks

Just let me know!
