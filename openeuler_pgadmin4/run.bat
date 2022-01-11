docker run --name openeuler_pgadmin4 -p 9980:80 -e PGADMIN_DEFAULT_EMAIL=admin@domain.com -e PGADMIN_DEFAULT_PASSWORD=admin -tid lsqtzj/openeuler_pgadmin4
docker exec -it openeuler_pgadmin4 /bin/bash