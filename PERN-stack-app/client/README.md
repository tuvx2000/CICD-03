 docker image build -t pern-client:v0.9 .
 
 docker run -dp 3000:3000 --name pern-client  pern-client:v0.9


docker tag pern-client:v0.9 tuvx2000/pern-client:v0.9
docker push tuvx2000/pern-client:v0.9