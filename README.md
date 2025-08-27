# 🚀 DevOps Project – Website + Docker + Terraform + GitHub Actions  

![Build Status](https://img.shields.io/github/actions/workflow/status/Mr-siva/your-repo-name/terraform.yaml?branch=main&label=CI%2FCD&logo=github)  
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform)  
![AWS](https://img.shields.io/badge/AWS-ECS%20%7C%20ECR-FF9900?logo=amazon-aws)  
![Docker](https://img.shields.io/badge/Docker-Containerization-2496ED?logo=docker)  

---

## 📌 Overview  
This project demonstrates a **complete DevOps workflow** with:  
1. 🌐 **Website Source Code** – simple web application.  
2. 🐳 **Dockerization** – Dockerfile builds and updates the image on every new commit.  
3. ☁️ **Terraform IaC** – creates AWS ECS cluster and ECR repository to host and store Docker images.  
4. 🤖 **GitHub Actions** – CI/CD pipeline for automated build, push, and deploy.  

---

## ⚙️ Project Flow  
```mermaid
flowchart TD
    A[Source Code Commit] --> B[GitHub Actions CI/CD]
    B --> C[Build Docker Image]
    C --> D[Push to AWS ECR]
    D --> E[Terraform Infra on AWS ECS]
    E --> F[Deployed Website]
