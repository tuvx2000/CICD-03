 docker image build -t pern-client:v0.1 .
 
 docker run -dp 3000:3000 --name pern-client  pern-client:v0.1


docker tag pern-client:v0.1 tuvx2000/pern-client:v0.1
 docker push tuvx2000/pern-client:v0.1