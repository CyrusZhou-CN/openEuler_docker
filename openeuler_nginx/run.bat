docker run -p 9880:80 -d -tid --name openeuler_nginx  --privileged=true lsqtzj/openeuler_nginx  /sbin/init
docker exec -it openeuler_nginx /bin/bash