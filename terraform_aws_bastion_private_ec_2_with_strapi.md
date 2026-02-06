# Terraform AWS Infrastructure with Bastion Host and Strapi

## 📌 Overview
This repository contains a **modular Terraform project** that provisions a secure AWS infrastructure using Infrastructure as Code (IaC). The setup includes a **custom VPC**, **bastion host**, **private EC2 instance**, **Application Load Balancer (ALB)**, and all required **security groups**. A **Strapi application** is deployed on the private EC2 instance and accessed securely through the ALB and bastion host.

This project was built as a **learning + hands-on DevOps project** to practice real-world AWS networking, security, and Terraform best practices.

---

## 🏗️ Architecture

**High-level architecture:**

- Custom VPC with public and private subnets
- Bastion Host (t2.micro) in public subnet
- Private EC2 instance (t3.medium) running Strapi
- Application Load Balancer (ALB) to expose Strapi
- Security Groups with least-privilege access
- SSH access to private EC2 only via bastion host

**Traffic flow:**

```
Internet
   │
   ▼
Application Load Balancer (ALB)
   │
   ▼
Private EC2 (Strapi on port 1337)

Admin SSH Access:
Local Machine → Bastion Host → Private EC2
```

---

## 🧱 Terraform Module Structure

```
.
├── main.tf
├── variable.tf
├── outputs.tf
├── .terraform.lock.hcl
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variable.tf
│   │   └── output.tf
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── variable.tf
│   │   └── outputs.tf
│   ├── alb/
│   │   ├── main.tf
│   │   ├── variable.tf
│   │   └── output.tf
│   ├── security_groups/
│   │   ├── variable.tf
│   │   └── outputs.tf
│   └── key_pair/
│       ├── main.tf
│       ├── variable.tf
│       └── outputs.tf
└── README.md
```

Each component is isolated into reusable Terraform modules following best practices.

---

## 🔐 Security Design

- Bastion host allows SSH only from a trusted IP
- Private EC2 does **not** allow public SSH access
- Private EC2 allows SSH **only from the bastion host security group**
- Strapi (port 1337) is accessible **only via ALB**
- Terraform state and sensitive files are excluded using `.gitignore`

---

## 🐳 Strapi with Docker

The Strapi application is containerized using Docker and runs on the private EC2 instance.

### Key points:
- Node.js 18 Alpine base image
- Strapi admin panel built during image build
- Port 1337 exposed for ALB routing
- Environment variables used for configuration

Strapi runs securely inside a private subnet and is not directly exposed to the internet.

---

## 🚀 How to Use This Project

### Prerequisites
- AWS account
- Terraform >= 1.x
- AWS CLI configured
- Docker installed (for Strapi)

### Steps

1. Clone the repository
2. Initialize Terraform
   ```bash
   terraform init
   ```
3. Review the execution plan
   ```bash
   terraform plan
   ```
4. Apply the infrastructure
   ```bash
   terraform apply
   ```
5. Access Strapi via the ALB DNS name

---

## 🧠 What This Project Demonstrates

- Infrastructure as Code using Terraform
- Modular Terraform design
- Secure AWS networking (VPC, subnets, security groups)
- Bastion host pattern for private access
- ALB integration with private EC2
- Containerized application deployment using Docker

---

## 📈 Future Improvements

- Add Terraform backend (S3 + DynamoDB)
- Use AWS SSM Session Manager instead of SSH
- Deploy Strapi using ECS or EKS
- Add CI/CD pipeline (GitHub Actions)
- Add monitoring with CloudWatch

---

## 👤 Author

Built as a hands-on DevOps learning project to understand real-world AWS infrastructure, security, and deployment workflows.

---

## 📄 License

This project is for learning and demonstration purposes.

