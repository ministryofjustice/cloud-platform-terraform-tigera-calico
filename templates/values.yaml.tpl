imagePullSecrets: {}

installation:
  enabled: true
  kubernetesProvider: "${kubernetes_provider}"
spec:
  nodeSelector: all()
nodeAddressAutodetectionV4:
         kubernetes: NodeInternalIP

apiServer:
     enabled: true

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
  - key: node-role.kubernetes.io/master
    effect: NoSchedule
  - key: "monitoring-node"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule"
  - key: "ingress-node"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule" 
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
