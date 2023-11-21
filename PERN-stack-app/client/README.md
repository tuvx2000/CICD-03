 docker image build -t pern-client:v0.15 .
 
 docker run -dp 3000:3000 --name pern-client  pern-client:v0.9


docker tag pern-client:v0.15 tuvx2000/pern-client:v0.15
docker push tuvx2000/pern-client:v0.10


docker tag pern-client:v0.15 055475569617.dkr.ecr.ap-southeast-1.amazonaws.com/xuantu-ecr:v.016