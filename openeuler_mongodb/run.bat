docker run -d -tid --name openeuler_mongodb -p 7017:27017 --privileged=true lsqtzj/openeuler_mongodb /sbin/init
docker exec -it openeuler_mongodb /bin/bash
