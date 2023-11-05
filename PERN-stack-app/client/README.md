 docker image build -t pern-client:v0.1 .
 
 docker run -dp 3000:3000 --name pern-client  pern-client:v0.1