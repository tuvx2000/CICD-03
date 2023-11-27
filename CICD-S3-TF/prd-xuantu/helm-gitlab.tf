# resource "helm_release" "gitlab-runner" {
#     name = "gitlab-runner"

#     chart = "gitlab-runner"
#     repository = "https://charts.gitlab.io/gitlab"
#     namespace = "gitlab-runner"
#     # version = "0.8.4"

#     values = [file("chart-values/gitlab-runner.yaml")]
# } 



# command line:
# helm repo add gitlab https://charts.gitlab.io
# helm repo update gitlab
# helm install --namespace <NAMESPACE> gitlab-runner -f <CONFIG_VALUES_FILE> gitlab/gitlab-runner

