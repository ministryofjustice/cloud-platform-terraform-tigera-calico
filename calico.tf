
##########
# Calico #
##########

resource "kubectl_manifest" "calico_global_policies" {
  yaml_body = <<YAML
apiVersion: crd.projectcalico.org/v1
kind: GlobalNetworkPolicy
metadata:
  name: deny-aws-imds
spec:
  selector: projectcalico.org/namespace not in { "cert-manager", "ingress-controllers", "kube-system", "logging", "monitoring", "velero" }
  types:
    - Egress
  egress:
    - action: Log
      metadata: {}
      protocol: TCP
      destination:
        ports:
          - 80
          - 443
        nets:
          - 169.254.169.254/32
    - action: Deny
      metadata: {}
      protocol: TCP
      destination:
        ports:
          - 80
          - 443
        nets:
          - 169.254.169.254/32
YAML

  depends_on = [
    helm_release.tigera_calico
  ]

}

resource "kubernetes_namespace" "calico_system" {
  metadata {
    name = "calico-system"

    labels = {
      "component"                          = "calico"
      "pod-security.kubernetes.io/enforce" = "privileged"
    }

    annotations = {
      "cloud-platform.justice.gov.uk/application"                = "tigera-operator-calico"
      "cloud-platform.justice.gov.uk/business-unit"              = "Platforms"
      "cloud-platform.justice.gov.uk/owner"                      = "Cloud Platform: platforms@digital.justice.gov.uk"
      "cloud-platform.justice.gov.uk/source-code"                = "https://github.com/ministryofjustice/cloud-platform-infrastructure"
      "cloud-platform.justice.gov.uk/can-tolerate-master-taints" = "true"
      "cloud-platform-out-of-hours-alert"                        = "true"
    }
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "kubernetes_namespace" "calico_apiserver" {
  metadata {
    name = "calico-apiserver"

    labels = {
      "component"                          = "calico"
      "pod-security.kubernetes.io/enforce" = "privileged"
    }

    annotations = {
      "cloud-platform.justice.gov.uk/application"                = "tigera-operator-calico"
      "cloud-platform.justice.gov.uk/business-unit"              = "Platforms"
      "cloud-platform.justice.gov.uk/owner"                      = "Cloud Platform: platforms@digital.justice.gov.uk"
      "cloud-platform.justice.gov.uk/source-code"                = "https://github.com/ministryofjustice/cloud-platform-infrastructure"
      "cloud-platform.justice.gov.uk/can-tolerate-master-taints" = "true"
      "cloud-platform-out-of-hours-alert"                        = "true"
    }
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "kubernetes_namespace" "tigera_operator" {
  metadata {
    name = "tigera-operator"

    labels = {
      "component"                          = "calico"
      "pod-security.kubernetes.io/enforce" = "privileged"
    }

    annotations = {
      "cloud-platform.justice.gov.uk/application"                = "tigera-operator-calico"
      "cloud-platform.justice.gov.uk/business-unit"              = "Platforms"
      "cloud-platform.justice.gov.uk/owner"                      = "Cloud Platform: platforms@digital.justice.gov.uk"
      "cloud-platform.justice.gov.uk/source-code"                = "https://github.com/ministryofjustice/cloud-platform-infrastructure"
      "cloud-platform.justice.gov.uk/can-tolerate-master-taints" = "true"
      "cloud-platform-out-of-hours-alert"                        = "true"
    }
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "helm_release" "tigera_calico" {
  name       = "tigera-calico-release"
  chart      = "tigera-operator"
  repository = "https://projectcalico.docs.tigera.io/charts"
  namespace  = "tigera-operator"
  timeout    = 300
  version    = "3.28.1"
  skip_crds  = true

  set {
    name  = "installation.kubernetesProvider"
    value = "EKS"
  }

  depends_on = [
    kubernetes_namespace.tigera_operator,
    kubernetes_namespace.calico_system,
    kubernetes_namespace.calico_apiserver
  ]
}
