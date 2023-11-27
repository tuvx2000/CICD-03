resource "helm_release" "image-updater" {
    name = "image-updater"

    chart = "argocd-image-updater"
    repository = "https://argoproj.github.io/argo-helm"
    namespace = "platform"
    version = "0.8.4"

    values = [file("chart-values/image-updater.yaml")]
} 

resource "helm_release" "argocd-apps" {
    name = "argocd-apps"

    chart = "argocd-apps"
    repository = "https://argoproj.github.io/argo-helm"
    namespace = "platform"
    # version = "0.8.4"

    values = [file("chart-values/argo-apps.yaml")]
} 