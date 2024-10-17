# Follow this documentation for manual setup https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/

#------------------------------------------------<OIDC PROVIDER>------------------------------------------------#
locals {
  oidc_issuer_url = "https://token.actions.githubusercontent.com"
}


data "external" "thumbprint" {
  program = ["bash", "-c", "echo | openssl s_client -connect oidc.eks.us-east-1.amazonaws.com:443 2>&- | openssl x509 -fingerprint -noout | sed 's/://g' | awk -F= '{print tolower($2)}' | jq -R '{thumbprint: .}'"]
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.external.thumbprint.result["thumbprint"]]
  url             = local.oidc_issuer_url
}

#------------------------------------------------<TRUST POLICY>------------------------------------------------#
data "aws_iam_policy_document" "github_action_trust_policy" {

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.oidc_provider.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(local.oidc_issuer_url, "https://", "")}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringLike"
      variable = "${replace(local.oidc_issuer_url, "https://", "")}:sub"

      values = [
        "repo:CloudOpsPioneer/github-runners-on-aws",
        "repo:CloudOpsPioneer/terraform-cloud-*",
        "repo:CloudOpsPioneer/*"                                              # This is for Org level permission. You can remove previous two lines.
      ]
    }

    effect = "Allow"
  }
}


#------------------------------------------------<IAM ROLE>------------------------------------------------#

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "github_action_aws_workflow_role" {
  name = "github-action-aws-workflow-iam-role"

  assume_role_policy = data.aws_iam_policy_document.github_action_trust_policy.json

  inline_policy {
    name   = "s3-policy"
    policy = data.aws_iam_policy_document.s3_policy.json
  }

}