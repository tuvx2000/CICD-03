 docker image build -t pern-server:v0.8 .
 
 docker run -dp 80:80 --name pern-server  pern-server:v0.8


<<<<<<< HEAD
docker tag pern-server:v0.7 tuvx2000/pern-server:v0.8
=======
docker tag pern-server:v0.8 tuvx2000/pern-server:v0.8
>>>>>>> 489d509d96fdf39367e5b3626adee398ca24c9b1
docker push tuvx2000/pern-server:v0.8

kubectl port-forward service/nginx-service  8080:80

npm init

npm install express pg cors

-> write index file

-> node index