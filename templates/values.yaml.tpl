imagePullSecrets: {}

installation:
  enabled: true
  kubernetesProvider: "${kubernetes_provider}"

apiServer:
  enabled: true

certs:
  node:
    key:
    cert:
    commonName:
  typha:
    key:
    cert:
    commonName:
    caBundle:

# Resource requests and limits for the tigera/operator pod.
resources: {}

# Tolerations for the tigera/operator pod.
tolerations:
- effect: NoExecute
  operator: Exists
- effect: NoSchedule
  operator: Exists

# NodeSelector for the tigera/operator pod.
nodeSelector:
  kubernetes.io/os: linux

# Custom annotations for the tigera/operator pod.
podAnnotations: {}

# Custom labels for the tigera/operator pod.
podLabels: {}

# Image and registry configuration for the tigera/operator pod.
tigeraOperator:
  image: tigera/operator
  version: "${tigera_operator_version}"
  registry: quay.io
calicoctl:
  image: docker.io/calico/ctl
  tag: master
