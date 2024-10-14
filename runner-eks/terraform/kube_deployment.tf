#-------------------------------------------------<<<<<IGNORE THIS FILE>>>>>-------------------------------------------------
# Commented this since I converted the Manifest to helm chart. Refer https://github.com/karthikrajkkr/github-runners/tree/main/runner-eks/github-runner-helm

/*resource "kubernetes_deployment_v1" "github_runner" {
  metadata {
    name = "github-runner"
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "github-runner"
      }
    }

    template {
      metadata {
        labels = {
          app = "github-runner"
        }
      }

      spec {

        service_account_name = "github-runner-irsa" #<CHANGE LATER> 


        init_container {
          name    = "wait-for-secret"
          image   = "busybox"
          command = ["sh", "-c", "until [ -f /mnt/secrets/github-runner-creds ]; do echo waiting for secret; sleep 2; done"]

          volume_mount {
            name       = "secrets-store-inline"
            mount_path = "/mnt/secrets"
            read_only  = true
          }
        }

        container {
          name  = "github-runner"
          image = aws_ecr_repository.runner_ecr.repository_url

          env {
            name = "PAT"
            value_from {
              secret_key_ref {
                name = "gh-runner-secret"
                key  = "access_token"
              }
            }
          }

          env {
            name  = "GITHUB_OWNER"
            value = "karthikrajkkr"
          }

          env {
            name  = "GITHUB_REPO"
            value = "flaskapp-on-aws"
          }

          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }

          env {
            name = "NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          env {
            name  = "RUNNER_LABELS"
            value = "dev,flask-app,eks,cicd"
          }
          resources {
            requests = {
              cpu    = "500m"
              memory = "512Mi"
            }
            limits = {
              cpu    = "1"
              memory = "1Gi"
            }
          }
        }

        volume {
          name = "secrets-store-inline"
          csi {
            driver    = "secrets-store.csi.k8s.io"
            read_only = true
            volume_attributes = {
              secretProviderClass = "github-runner-creds"
            }
          }
        }

      }
    }
  }
  depends_on = [aws_eks_node_group.runner_node_1, helm_release.secrets_provider_aws, kubernetes_manifest.github_runner_creds]
}

*/

/*
#YAML format of Deployment for better understanding
#--------------------------------------------------
apiVersion: apps/v1
kind: Deployment
metadata:
  name: github-runner
spec:
  replicas: 1
  selector:
    matchLabels:
      app: github-runner
  template:
    metadata:
      labels:
        app: github-runner
    spec:
      serviceAccountName: github-runner-irsa
      initContainers:
        - name: wait-for-secret
          image: busybox
          command:
            - "sh"
            - "-c"
            - "until [ -f /mnt/secrets/github-runner-creds ]; do echo waiting for secret; sleep 2; done"
          volumeMounts:
            - name: secrets-store-inline
              mountPath: "/mnt/secrets"
              readOnly: true
      containers:
        - name: github-runner
          image: "<ECR_Image_URL>" # Replace <ECR_Image_URL> with actual URL from aws_ecr_repository.runner_ecr.repository_url
          env:
            - name: PAT
              valueFrom:
                secretKeyRef:
                  name: gh-runner-secret
                  key: access_token
            - name: GITHUB_OWNER
              value: "karthikrajkkr"
            - name: GITHUB_REPO
              value: "flaskapp-on-aws"
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: "metadata.name"
            - name: NODE_NAME
              valueFrom:
                fieldRef:
                  fieldPath: "spec.nodeName"
            - name: RUNNER_LABELS
              value: "dev,flask-app,eks,cicd"
          resources:
            requests:
              cpu: "500m"
              memory: "512Mi"
            limits:
              cpu: "1"
              memory: "1Gi"
      volumes:
        - name: secrets-store-inline
          csi:
            driver: "secrets-store.csi.k8s.io"
            readOnly: true
            volumeAttributes:
              secretProviderClass: "github-runner-creds"
*/
