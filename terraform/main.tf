terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.5.1"
    }
 
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
  }
}
 
provider "kind" {}
 
resource "kind_cluster" "gitops" {
  name = "gitops-lab"
}
 
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
 
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
 
  depends_on = [
    kind_cluster.gitops
  ]
}