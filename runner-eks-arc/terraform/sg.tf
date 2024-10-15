#-------------------------------------------------<EKS Cluster Security Group>--------------------------------------------------
resource "aws_security_group" "eks_sg" {
  name        = "github-runner-eks-cluster-sg"
  description = "EKS Cluster Security Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.my_private_ip]
    description = "private ip of my ec2 instance hosted on same vpc as eks. I am running TF and kubectl commands from here"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "github-runner-eks-cluster-sg"
  }
}

#-------------------------------------------------<Security Group rule - EKS Cluster SG>--------------------------------------------------
resource "aws_security_group_rule" "eks_cluster_sg_rule_1" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  security_group_id        = aws_eks_cluster.runner_eks_cluster.vpc_config.0.cluster_security_group_id
  source_security_group_id = aws_security_group.eks_node_group_sg.id
  description              = "Adding security group of eks node group to eks cluster SG"
}

#------------------------------------------------------<EKS Node Group Security Group>-------------------------------------------------------
resource "aws_security_group" "eks_node_group_sg" {
  name        = "github-runner-eks-node-group-sg"
  description = "Security Group of EKS node group.Passed to Launch Template"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_eks_cluster.runner_eks_cluster.vpc_config.0.cluster_security_group_id]
    description     = "eks cluster security group"
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "github-runner-eks-node-group-sg"
  }

}
