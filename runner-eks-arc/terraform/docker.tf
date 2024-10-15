# This data block will generate a new hash id if atleast one change done on the mentioned path.
# This will help us to decide if docker build is required or not using null resource below
data "external" "folder_hash" {
  program = ["bash", "-c", "find ${path.module}/../docker/ -type f -exec sha256sum {} + | sha256sum | cut -d' ' -f1 | jq -R '{hash: .}'"]
}

#-------------------------------------------------<DOCKER BUILD>--------------------------------------------------
resource "docker_image" "image" {
  name = "${aws_ecr_repository.github_runner_ecr.repository_url}:latest"
  build {
    context = "${path.cwd}/../docker"
  }

  triggers = { "hash" = data.external.folder_hash.result.hash }
}

#-------------------------------------------------<DOCKER PUSH>--------------------------------------------------
resource "null_resource" "folder_change_trigger" {
  triggers = {
    folder_hash_sha = data.external.folder_hash.result.hash
  }

  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.github_runner_ecr.repository_url}
      docker push ${aws_ecr_repository.github_runner_ecr.repository_url}:latest
    EOT
  }

  depends_on = [docker_image.image]
}

