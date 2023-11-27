# resource "helm_release" "metrics-server" {
#     name = "metrics-server"

#     repository = "https://kubernetes-sigs.github.io/metrics-server"
#     chart = "metrics-server"
#     namespace = "platform"
#     version = "3.8.2"

#     set{
#         name = "args[0]"
#         value = "--kuberlet-insecure-tls"
#     }
# } 


# # command line:
# kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
# kubectl get deployment metrics-server -n kube-system