rm angular-node-chart-0.1.0.tgz

helm create angular-node-chart

helm package angular-node-chart

kubectl port-forward svc/angular-webapp 3080:3080  