# cloud-platform-terraform-tigera-calico

[![Releases](https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-tigera-calico/all.svg?style=flat-square)](https://github.com/ministryofjustice/cloud-platform-terraform-tigera-calico/releases)

Terraform module that deploys calico using tigera operator
## Usage

# For EKS clusters
```
module "aws_eks_addons" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-tigera-calico=0.1.0"

}
```


<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| null | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| irsa_vpc_cni | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 4.6.0 |

## Resources

| Name |
|------|
| [aws_eks_addon](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| addon\_coredns\_version | Version for addon\_coredns\_version | `string` | `"v1.8.4-eksbuild.1"` | no |
| addon\_create\_coredns | Create coredns addon | `bool` | `true` | no |
| addon\_create\_kube\_proxy | Create kube\_proxy addon | `bool` | `true` | no |
| addon\_create\_vpc\_cni | Create vpc\_cni addon | `bool` | `true` | no |
| addon\_kube\_proxy\_version | Version for addon\_kube\_proxy\_version | `string` | `"v1.21.2-eksbuild.2"` | no |
| addon\_tags | Cluster addon tags | `map(string)` | `{}` | no |
| addon\_vpc\_cni\_version | Version for addon\_create\_vpc\_cni | `string` | `"v1.9.3-eksbuild.1"` | no |
| cluster\_name | Kubernetes cluster name - used to name (id) the auth0 resources | `any` | n/a | yes |
| cluster\_oidc\_issuer\_url | Used to create the IAM OIDC role | `string` | `""` | no |
| eks\_cluster\_id | trigger for null resource using eks\_cluster\_id | `any` | n/a | yes |

## Outputs

No output.

<!--- END_TF_DOCS --->

## Reading Material

https://github.com/tigera/operator