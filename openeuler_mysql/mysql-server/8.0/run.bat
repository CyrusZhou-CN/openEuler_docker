docker run --name openeuler_mysql8.0 -e MYSQL_ROOT_PASSWORD='123456' --privileged=true --restart=always -tid lsqtzj/openeuler_mysql:8.0
docker exec -it openeuler_mysql8.0  /bin/bash