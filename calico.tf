
##########
# Calico 
##########

data "kubectl_file_documents" "calico_global_policies" {
  content = file("${path.module}/resources/calico-global-policies.yaml")
}

resource "kubectl_manifest" "calico_global_policies" {
  count     = length(data.kubectl_file_documents.calico_global_policies.documents)
  yaml_body = element(data.kubectl_file_documents.calico_global_policies.documents, count.index)


  depends_on = [helm_release.tigera_calico]
}

resource "kubernetes_namespace" "calico_system" {
  metadata {
    name = "calico-system"

    labels = {
      "component" = "calico"
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
      "component" = "calico"
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
      "component" = "calico"
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

# Calico Helm release cannot be deleted because of finalizers and installation issues, this can be removed once the below issue is fixed.
# https://github.com/projectcalico/calico/issues/6629
resource "null_resource" "remove_installation" {
  depends_on = [helm_release.tigera_calico]

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      kubectl delete installations.operator.tigera.io default
    EOT
  }

  triggers = {
    helm_tigera = helm_release.tigera_calico.status
  }
}


resource "helm_release" "tigera_calico" {
  name       = "tigera-calico-release"
  chart      = "tigera-operator"
  repository = "https://projectcalico.docs.tigera.io/charts"
  namespace  = "tigera-operator"
  timeout    = 300
  version    = "3.25.0"
  skip_crds = true

  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    kubernetes_provider = "EKS"
  })]

  depends_on = [
    kubernetes_namespace.tigera_operator,
    kubernetes_namespace.calico_system,
    kubernetes_namespace.calico_apiserver
    ]
}
