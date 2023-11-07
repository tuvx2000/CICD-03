 docker image build -t pern-server:v0.4 .
 
 docker run -dp 80:80 --name pern-server  pern-server:v0.4


docker tag pern-server:v0.4 tuvx2000/pern-server:v0.4
docker push tuvx2000/pern-server:v0.4

kubectl port-forward service/nginx-service  8080:80

npm init

npm install express pg cors

-> write index file

-> node index