# AKS Multi-Service Production Environment

This repository contains a full-stack DevOps project demonstrating a production-ready Kubernetes environment on **Azure Kubernetes Service (AKS)**. The project includes automated infrastructure provisioning, containerized microservices, path-based routing, and internal network security.

## Features
- **Infrastructure as Code (IaC):** Fully provisioned using Terraform (VNET, Subnets, AKS).
- **Path-Based Routing:** Utilizes Nginx Ingress Controller to route traffic to multiple services via a single Load Balancer IP.
- **Microservices:** - **Service A (Python):** A Bitcoin price tracker fetching real-time data, calculating 10-minute averages, and exposing a health-check server on port 8080.
  - **Service B (Nginx):** A lightweight web server representing a secondary internal service.
- **Production-Ready Standards:** - Resource limits/requests for CPU and Memory.
  - Liveness and Readiness probes for self-healing.
  - Non-root container execution logic.
- **Security:** Kubernetes **Network Policies** implemented to isolate services (Service A is forbidden from communicating with Service B).

---

## Project Structure
```text
.
├── terraform/           # Terraform configuration files (main.tf, providers.tf)
├── service-a/           # Python App, requirements.txt, and Dockerfile
├── k8s/                 # Kubernetes manifests (Deployments, Services, Ingress, NetworkPolicy)
└── README.md            # Project documentation