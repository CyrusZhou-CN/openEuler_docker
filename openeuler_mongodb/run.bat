docker run -d -tid --name openeuler_mongodb -p 7017:27017 --privileged=true lsqtzj/openeuler_mongodb:6.0.2
docker exec -it openeuler_mongodb /bin/bash
