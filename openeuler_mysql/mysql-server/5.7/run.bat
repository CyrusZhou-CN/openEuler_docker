docker run --name openeuler_mysql5.7 -e MYSQL_ROOT_PASSWORD='123456' --privileged=true --restart=always -tid lsqtzj/openeuler_mysql:5.7 
docker exec -it openeuler_mysql5.7  /bin/bash