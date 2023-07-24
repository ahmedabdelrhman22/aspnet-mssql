resource "aws_iam_role" "demo" {
  name = "eks-cluster-demo"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "demo-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.demo.name
}

resource "aws_eks_cluster" "demo" {
  name     = "demo"
  role_arn = aws_iam_role.demo.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private-us-east-1a.id,
      aws_subnet.private-us-east-1b.id,
      aws_subnet.public-us-east-1a.id,
      aws_subnet.public-us-east-1b.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.demo-AmazonEKSClusterPolicy]
}

resource "null_resource" "kubeconfig" {  provisioner "local-exec" {
    command = <<EOFset -e
      mkdir -p ~/.kube/
      cp ${module.eks.kubeconfig_filename} ~/.kube/config
      curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/linux/amd64/aws-iam-authenticator
      chmod +x aws-iam-authenticator
      mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator
      curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kubectl
      chmod +x kubectl
      cp ./kubectl $HOME/bin/EOF  }
}




resource "null_resource" "certmanager" {  provisioner "local-exec" {  command = <<EOT
set -e
export PATH=$PATH:$HOME/bin
./kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.1.0/cert-manager.yaml
cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: youremail@example.com
    privateKeySecretRef:
      name: letsencrypt
    solvers:
    - selector: {}
      dns01:
        cloudflare:
          email: ${var.cloudflare_email}
          apiKeySecretRef:
            name: cloudflare-api-token-secret
            key: api-token
EOF
EOT
  }
}




resource "kubernetes_ingress" "this" {
  metadata {
    name      = "sub.example.com"
    annotations = {
      "cert-manager.io/cluster-issuer" = "letsencrypt"
    }
  }
  spec {
    rule {
      host = "sub.example.com"
      http {
        path {
          backend {
            service_name = yourservice
            service_port = 80
          }
          path = "/"
        }
      }
    }
    tls {
      hosts       = ["sub.example.com"]
      secret_name = "sub.example.com"
    }
  }
}

Terraform
Kubernetes
Cert 






