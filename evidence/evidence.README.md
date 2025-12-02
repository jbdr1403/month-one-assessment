---

# **📸 Evidence – TechCorp Infrastructure**

![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?style=for-the-badge\&logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Infrastructure-orange?style=for-the-badge\&logo=amazon-aws)
![Verification](https://img.shields.io/badge/Status-Verified_Screenshots-success?style=for-the-badge)
![Assessment](https://img.shields.io/badge/AltSchool-Assessment-blue?style=for-the-badge)

```
============================================================
        T E C H C O R P   C L O U D   I N F R A S T R U C T U R E
                      E V I D E N C E   D O C U M E N T A T I O N
============================================================
```

This folder contains **all required screenshots** for the AltSchool Cloud Engineering Month-One Assessment.
Each screenshot directly maps to the infrastructure resource or verification step described in the assessment document.

---

# **🗂️ Evidence Sections**

```
+-----------------------------------------------------------+
| 1. Terraform Outputs                                      |
| 2. AWS Networking                                         |
| 3. EC2 Instances                                          |
| 4. Application Load Balancer                              |
| 5. SSH Access Path Verification                           |
| 6. Application-Level Validation                           |
| 7. End-to-End ALB Testing                                 |
+-----------------------------------------------------------+
```

---

# **1. Terraform Outputs**

### ✔ terraform plan

![Terraform Plan](./terraform_plan.png)

### ✔ terraform apply

![Terraform Apply](./terraform_apply.png)

```
---------------------------------------------
| terraform plan → infrastructure preview   |
| terraform apply → successful deployment   |
---------------------------------------------
```

---

# **2. AWS Networking**

Covers the VPC topology, subnets, and routing configuration.

### ✔ VPC

![VPC](./vpc.png)

### ✔ Subnets

![Subnets](./subnets.png)

### ✔ NAT Gateways

![NAT Gateways](./NAT_gateway.png)

### ✔ Internet Gateway

![Internet Gateway](./igw.png)

### ✔ Route Tables

![Route Tables](./route_table.png)

```
-------------------------------------------------------
| Required Network Artifacts Verified in the Console:  |
|  - 1 VPC                                             |
|  - 2 Public Subnets                                  |
|  - 2 Private Subnets                                 |
|  - 2 NAT Gateways                                    |
|  - 1 Internet Gateway                                |
|  - Correctly Associated Route Tables                 |
-------------------------------------------------------
```

---

# **3. EC2 Instances**

### ✔ Bastion Host

![Bastion](./bastion_ec2.png)

### ✔ Web Servers 1

![Web 1](./web_server_1_ec2.png)

### ✔ Web Server 2

![Web 2](./web_server_2_ec2.png)

### ✔ Database Server

![Database](./db_ec2.png)

```
---------------------------------------------------------
| Fully Provisioned Compute Layer:                      |
|  - Bastion (public subnet)                            |
|  - Web Servers (private subnets across AZs)           |
|  - Database Server (private subnet)                   |
---------------------------------------------------------
```

---

# **4. Application Load Balancer**

### ✔ Application Load Balancer

![ALB](./alb.png)

### ✔ Target Group (healthy instances)

![Target Group](./target_grps.png)

```
------------------------------------------------------
| ALB correctly distributing traffic across web tier |
| Target group health checks reporting 'healthy'     |
------------------------------------------------------
```

---

# **5. SSH Access Path Verification**

### ✔ SSH into Bastion from Local Machine

![SSH Bastion](./bastion_host.png)

### ✔ SSH from Bastion → Web Servers → DB Server

![SSH Web](./web_db_servers.png)

```
-------------------------------------------------------------
|  Verified Multi-Hop SSH Access Path (Best Practice)        |
|  Local → Bastion → Web Server / DB Server (Private Subnet)|
-------------------------------------------------------------
```

---

# **6. Application-Level Validation**

### ✔ Apache running on Web Servers

![Apache Curl](./alb_1.png)
![Apache Curl](./alb_2.png)

### ✔ PostgreSQL running on DB Server

![Postgres Service](./postgres_running.png)

### ✔ Connected to PostgreSQL (`postgres=#`)

![Postgres Shell](./postgres_connected.png)

```
-----------------------------------------------------------
| Automation Validated:                                   |
|  - Apache auto-installed on web servers via user_data   |
|  - PostgreSQL auto-installed on DB via user_data        |
|  - Successful DB shell access (`postgres=#`)            |
-----------------------------------------------------------
```

---

# **7. Load Balancer Test**

### ✔ ALB DNS output – Web Server 1

![ALB WS1](./alb-webserver1.png)

### ✔ ALB DNS output – Web Server 2

![ALB WS2](./alb-webserver2.png)

```
----------------------------------------------------------------
| ALB test confirms high availability and correct target flow   |
| Traffic alternates between Web Server 1 and Web Server 2      |
----------------------------------------------------------------
```

---

# **📁 Final Instruction**

Place each screenshot in this folder using the exact filenames listed above.
This ensures the reviewers can quickly confirm:

- Infrastructure correctness
- Security controls
- Automation behavior
- Network access
- Service availability

```
============================================================
            E N D   O F   E V I D E N C E   D O C
============================================================
```

---

If you'd like, I can also:

✔ Validate your folder structure
✔ Generate a badge-enhanced README for `/user_data`
✔ Produce a CONTRIBUTING.md
✔ Add a LICENSE file
✔ Add a Terraform CI GitHub workflow

Just say **yes**.
