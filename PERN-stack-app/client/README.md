 docker image build -t pern-client:v0.7 .
 
 docker run -dp 3000:3000 --name pern-client  pern-client:v0.7


docker tag pern-client:v0.7 tuvx2000/pern-client:v0.7
docker push tuvx2000/pern-client:v0.7