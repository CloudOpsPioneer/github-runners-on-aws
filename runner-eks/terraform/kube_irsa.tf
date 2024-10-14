#------------------------------------------------<EKS CSI SECRET Service Account IAM ROLE>------------------------------------------------#

locals {
  oidc_issuer_url = aws_eks_cluster.runner_eks_cluster.identity.0.oidc.0.issuer
}


data "external" "thumbprint" {
  program = ["bash", "-c", "echo | openssl s_client -connect oidc.eks.us-east-1.amazonaws.com:443 2>&- | openssl x509 -fingerprint -noout | sed 's/://g' | awk -F= '{print tolower($2)}' | jq -R '{thumbprint: .}'"]
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.external.thumbprint.result["thumbprint"]]
  url             = local.oidc_issuer_url
}


data "aws_iam_policy_document" "eks_runner_sa_assume" {

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.oidc_provider.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(local.oidc_issuer_url, "https://", "")}:sub"

      values = [
        "system:serviceaccount:default:github-runner-irsa" #SERVICE ACCOUNT from above
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(local.oidc_issuer_url, "https://", "")}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    effect = "Allow"
  }
}


data "aws_iam_policy_document" "eks_secret_inline" {
  statement {
    sid = "secretManagerPolicy"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role" "eks_runner_iam_role" {
  name               = "github-runner-eks-secret-iam-role"
  assume_role_policy = data.aws_iam_policy_document.eks_runner_sa_assume.json
  inline_policy {
    name   = "secrets-manager-policy"
    policy = data.aws_iam_policy_document.eks_secret_inline.json
  }
}

#------------------------------------------------<KUBE SERVICE ACCOUNT>------------------------------------------------#
/*
resource "kubernetes_service_account_v1" "irsa" {
  metadata {
    name = "github-runner-irsa"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.eks_runner_iam_role.arn
    }
  }

  depends_on = [aws_eks_node_group.runner_node_1]
}
*/

/*
#Yaml format of ServiceAccount
#-----------------------------

apiVersion: v1
kind: ServiceAccount
metadata:
  name: github-runner-irsa
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::123456789012:role/example-role"  # Replace the ARN with the correct value from `aws_iam_role.eks_runner_iam_role.arn`
*/

