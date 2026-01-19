# Terraform + Ansible Web Application with CI/CD

[![Terraform](https://img.shields.io/badge/Terraform-1.7+-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Ansible](https://img.shields.io/badge/Ansible-2.9+-EE0000?logo=ansible&logoColor=white)](https://www.ansible.com/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![GitHub Actions](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=github-actions&logoColor=white)](https://github.com/features/actions)

A production-grade Infrastructure as Code (IaC) project demonstrating secure AWS deployment with automated CI/CD pipeline. Features OIDC authentication, multi-stage deployment workflow, and security-first architecture.

## 🚀 Key Differentiators

**What sets this project apart:**
- ✅ **Production-Grade CI/CD**: Automated Terraform validation, planning, and deployment via GitHub Actions
- ✅ **Secure Authentication**: AWS OIDC integration (no long-lived credentials)
- ✅ **Multi-Stage Workflow**: Separate plan and apply jobs with artifact passing
- ✅ **Security-First Design**: NIST 800-53 aligned architecture with defense-in-depth
- ✅ **High Availability**: Multi-AZ deployment with automatic failover
- ✅ **GitOps Workflow**: Infrastructure changes via pull requests with automated validation

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     GitHub Repository                        │
│  ┌────────────────────────────────────────────────────┐    │
│  │  Push to main → GitHub Actions Workflow            │    │
│  │  1. terraform fmt -check                           │    │
│  │  2. terraform validate                             │    │
│  │  3. terraform plan (save artifact)                 │    │
│  │  4. Manual approval (production environment)       │    │
│  │  5. terraform apply                                │    │
│  └──────────────────┬─────────────────────────────────┘    │
└─────────────────────┼─────────────────────────────────────┘
                      │ OIDC Auth (no access keys!)
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                         AWS Cloud                            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                    VPC 10.0.0.0/16                   │   │
│  │                                                       │   │
│  │  ┌──────────────────────────────────────────────┐  │   │
│  │  │          Public Subnets (AZ1, AZ2)           │  │   │
│  │  │  - Bastion Host                              │  │   │
│  │  │  - NAT Gateways                              │  │   │
│  │  │  - Internet Gateway                          │  │   │
│  │  └──────────────────────────────────────────────┘  │   │
│  │                                                       │   │
│  │  ┌──────────────────────────────────────────────┐  │   │
│  │  │       Private App Subnets (AZ1, AZ2)         │  │   │
│  │  │  - Ansible Control Server                    │  │   │
│  │  │  - Web Server 1 (AZ1)                        │  │   │
│  │  │  - Web Server 2 (AZ2)                        │  │   │
│  │  └──────────────────────────────────────────────┘  │   │
│  │                                                       │   │
│  │  ┌──────────────────────────────────────────────┐  │   │
│  │  │       Private Data Subnets (AZ1, AZ2)        │  │   │
│  │  │  - Reserved for future database tier         │  │   │
│  │  └──────────────────────────────────────────────┘  │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## 🔄 CI/CD Pipeline Architecture

```
Pull Request → GitHub Actions
     │
     ├─ terraform fmt -check ✓
     ├─ terraform validate ✓  
     ├─ terraform plan ✓
     │
     └─ PR Review Required
          │
          ▼
     Merge to main → GitHub Actions
          │
          ├─ Download plan artifact
          ├─ Manual approval (production gate)
          │
          └─ terraform apply → AWS Infrastructure
```

### Pipeline Features

**Security**:
- AWS OIDC authentication (no static credentials)
- IAM role assumption with least-privilege permissions
- GitHub environment protection rules
- Secret management via GitHub Secrets

**Quality Gates**:
- Code formatting validation (`terraform fmt -check`)
- Configuration validation (`terraform validate`)
- Pre-deployment plan review
- Artifact-based deployment (plan → apply)

**Efficiency**:
- Path-based triggers (only runs on `infra/**` changes)
- Conditional execution (apply only on main branch)
- Parallel job execution where possible
- Artifact caching between jobs

## 📋 Project Status

**Phase 1: Core Infrastructure & CI/CD** ✅ COMPLETE

- [x] VPC with 3-tier network architecture
- [x] Multi-AZ deployment (us-east-1a, us-east-1b)
- [x] Bastion host for secure access
- [x] Ansible control server
- [x] Web server instances across AZs
- [x] Security groups with least-privilege access
- [x] NAT gateways for private subnet internet access
- [x] **GitHub Actions CI/CD pipeline**
- [x] **OIDC authentication for AWS**
- [x] **Automated validation and deployment**

**Phase 2: Load Balancing & SSL** (Planned)

- [ ] Application Load Balancer
- [ ] Target groups with health checks
- [ ] Route 53 DNS configuration
- [ ] ACM SSL/TLS certificate
- [ ] HTTPS listener with auto-redirect

**Phase 3: Configuration Management** (In Progress)

- [ ] Ansible playbooks for web server configuration
- [ ] Application deployment automation
- [ ] Monitoring and logging setup

## 🔐 Security Implementation

### Defense in Depth Strategy

**Layer 1: Cloud Authentication**
- AWS OIDC (OpenID Connect) for GitHub Actions
- Short-lived security tokens (no access keys)
- Role-based access control (RBAC)
- Audit trail via CloudTrail

**Layer 2: Network Segmentation**
```
Internet → Bastion Host → Ansible Server → Web Servers
           (Your IP only) (Bastion only)  (Bastion only)
```

**Layer 3: Security Groups**
| Resource | Ingress | Source |
|----------|---------|--------|
| Bastion | Port 22 (SSH) | Your IP only |
| Ansible | Port 22 (SSH) | Bastion SG only |
| Web Servers | Port 22 (SSH) | Bastion SG only |
| Web Servers | Port 80 (HTTP) | VPC CIDR |

**Layer 4: GitOps Security**
- All changes via Git (version controlled)
- Pull request reviews required
- Automated validation before deployment
- Production environment approval gates

### NIST 800-53 Control Alignment

| Control | Implementation | Evidence |
|---------|----------------|----------|
| **AC-4**: Information Flow Enforcement | Network segmentation, Security Groups | VPC design, security_groups.tf |
| **SC-7**: Boundary Protection | Bastion host, NAT Gateways, Security Groups | Layered access control |
| **SC-8**: Transmission Confidentiality | VPC encryption, future SSL/TLS | Encrypted channels |
| **CM-2**: Baseline Configuration | Infrastructure as Code | All Terraform files |
| **CM-3**: Configuration Change Control | GitHub PR workflow, automated validation | .github/workflows/terraform.yml |
| **CM-6**: Configuration Settings | Security group rules, network ACLs | Least-privilege enforcement |
| **AU-2**: Audit Events | GitHub Actions logs, CloudTrail | All changes logged |

## 🛠️ Technologies & Best Practices

| Category | Technology | Why This Choice |
|----------|-----------|-----------------|
| **IaC** | Terraform 1.7+ | Industry standard, declarative, large ecosystem |
| **CI/CD** | GitHub Actions | Native Git integration, OIDC support, free for public repos |
| **Config Mgmt** | Ansible 2.9+ | Agentless, idempotent, large community |
| **Cloud** | AWS | Enterprise standard, comprehensive security features |
| **Auth** | AWS OIDC | Eliminates long-lived credentials (security best practice) |
| **Modules** | terraform-aws-modules/vpc | Community-vetted, battle-tested, regularly updated |
| **OS** | Amazon Linux 2023 | AWS-optimized, long-term support, security-focused |

## 📋 Prerequisites

- AWS Account with appropriate IAM permissions
- GitHub repository with Actions enabled
- Terraform >= 1.7.0 installed locally
- AWS CLI configured (for local testing)
- SSH key pair created in AWS

## 🚀 Deployment Guide

### Option 1: Automated Deployment (Recommended)

1. **Fork this repository**
2. **Configure GitHub Secrets**:
   - `AWS_REGION`: Your target AWS region (e.g., `us-east-1`)
   - `AWS_ROLE_ARN`: ARN of IAM role for OIDC authentication

3. **Set up AWS OIDC Provider** (one-time setup):
```bash
# Create OIDC provider for GitHub Actions
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
```

4. **Create IAM role for GitHub Actions**:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:YOUR_USERNAME/terraform-ansible-webapp:*"
        }
      }
    }
  ]
}
```

5. **Update `infra/terraform.tfvars`** and commit to main branch
6. **GitHub Actions automatically**:
   - Validates formatting
   - Runs terraform plan
   - Requires approval (if production environment configured)
   - Applies changes to AWS

### Option 2: Manual Deployment (Local Testing)

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/terraform-ansible-webapp.git
cd terraform-ansible-webapp/infra

# Initialize Terraform
terraform init

# Review changes
terraform plan

# Apply infrastructure
terraform apply

# View outputs
terraform output
```

## 🧪 Testing & Validation

### Automated Testing (GitHub Actions)

Every push to main or PR triggers:
```yaml
✓ terraform fmt -check   # Code formatting
✓ terraform validate     # Configuration syntax
✓ terraform plan         # Preview changes
```

### Manual Testing

```bash
# Test bastion SSH access
ssh -i ~/.ssh/your-key.pem ec2-user@$(terraform output -raw bastion_public_ip)

# From bastion, test Ansible connectivity
ssh ec2-user@$(terraform output -raw ansible_private_ip)

# Verify web servers accessible
WEB1=$(terraform output -json | jq -r '.web_private_ips.value.az1')
ssh ec2-user@$WEB1 "echo 'Web server accessible'"
```

### Security Audit

```bash
# Review security group rules
aws ec2 describe-security-groups \
  --filters "Name=tag:Project,Values=terraform-ansible-webapp" \
  --query 'SecurityGroups[*].[GroupName,IpPermissions]' \
  --output table

# Check for overly permissive rules
aws ec2 describe-security-groups \
  --query 'SecurityGroups[?IpPermissions[?IpRanges[?CidrIp==`0.0.0.0/0`]]].[GroupId,GroupName]' \
  --output table
```

## 💰 Cost Optimization

**Current Monthly Costs** (us-east-1):
```
EC2 Instances (4x t3.micro):    $30/month
NAT Gateways (2x Multi-AZ):     $65/month
Data Transfer:                   $5/month
GitHub Actions:                  $0 (free tier)
───────────────────────────────────────────
TOTAL:                          ~$100/month
```

**Cost Reduction Options**:
- Use `single_nat_gateway = true` for dev (~$32 savings)
- Use t4g (ARM) instances for 20% savings
- Destroy environment when not needed: `terraform destroy`
- Schedule EC2 instances with Lambda (stop after hours)

## 📁 Project Structure

```
terraform-ansible-webapp/
├── .github/
│   └── workflows/
│       └── terraform.yml         # ⭐ CI/CD pipeline
├── infra/
│   ├── main.tf                   # Core infrastructure
│   ├── providers.tf              # AWS provider config
│   ├── variables.tf              # Input variables
│   ├── outputs.tf                # Output values
│   ├── security_groups.tf        # Security rules
│   ├── terraform.tfvars          # Variable values (gitignored)
│   └── terraform.tfvars.example  # Template for variables
├── ansible/                      # Configuration management
│   ├── ansible.cfg
│   ├── inventory/
│   └── playbooks/
├── docs/
│   ├── DEPLOYMENT_CHECKLIST.md
│   └── images/
├── .gitignore
├── LICENSE
└── README.md
```

## 🎓 Key Learning Outcomes

This project demonstrates proficiency in:

**DevOps & CI/CD**:
- GitHub Actions workflow design
- OIDC authentication implementation
- Artifact management between pipeline stages
- Environment protection and approval gates
- GitOps workflow patterns

**Infrastructure as Code**:
- Terraform best practices and module usage
- State management considerations
- Variable and output patterns
- Resource dependency management

**Cloud Security**:
- Credential-less authentication (OIDC)
- Network segmentation strategies
- Least-privilege security groups
- Defense-in-depth architecture
- NIST 800-53 control implementation

**AWS Services**:
- VPC design and networking
- EC2 instance management
- IAM roles and policies
- CloudTrail for audit logging
- Multi-AZ high availability

## 🔍 Why This Project Matters

### For Hiring Managers

This project demonstrates I can:
1. ✅ Build production-ready infrastructure from scratch
2. ✅ Implement modern security practices (OIDC, no static credentials)
3. ✅ Design automated deployment pipelines
4. ✅ Apply compliance frameworks (NIST 800-53) to real architecture
5. ✅ Follow DevOps best practices (GitOps, PR reviews, automated testing)

### Bridging Compliance to Engineering

**From my RMF background, I understand**:
- SC-7 (Boundary Protection) → Implemented as security groups and bastion host
- AC-4 (Information Flow) → Implemented as network segmentation
- CM-3 (Change Control) → Implemented as GitHub PR workflow
- AU-2 (Audit Events) → Implemented as GitHub Actions logs + CloudTrail

**This project proves I can translate security controls into actual infrastructure code.**

## 📚 References & Resources

- [GitHub Actions + OIDC for AWS](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform AWS VPC Module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [NIST SP 800-53 Rev 5](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final)
- [AWS OIDC Integration](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html)

## 🤝 Contributing

This is a portfolio project showcasing my skills. However, if you find issues or have suggestions:
1. Open an issue describing the problem/enhancement
2. Fork the repository
3. Create a feature branch
4. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Nisha McDonnell**
- Website: [nishacloud.com](https://nishacloud.com)
- LinkedIn: [linkedin.com/in/YOUR_PROFILE](https://linkedin.com/in/YOUR_PROFILE)
- GitHub: [@YOUR_USERNAME](https://github.com/YOUR_USERNAME)

---

**Project Purpose**: This portfolio project demonstrates my transition from RMF/compliance work to hands-on cloud security engineering. It showcases my ability to design secure, automated infrastructure while maintaining compliance with industry frameworks.

**Current Status**: Phase 1 complete with production-grade CI/CD pipeline. Phase 2 (load balancing and SSL) planned for future enhancement.

---

⭐ **If you found this project helpful, please consider starring the repository!**
