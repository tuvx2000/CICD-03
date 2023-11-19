 docker image build -t pern-server:v0.7 .
 
 docker run -dp 80:80 --name pern-server  pern-server:v0.7


docker tag pern-server:v0.7 tuvx2000/pern-server:v0.8
docker push tuvx2000/pern-server:v0.8

kubectl port-forward service/nginx-service  8080:80

npm init

npm install express pg cors

-> write index file

-> node index