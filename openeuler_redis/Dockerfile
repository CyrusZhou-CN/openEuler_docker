FROM lsqtzj/openeuler:23.09 AS base
WORKDIR /opt

FROM base AS builder
RUN yum -y install wget tar make gcc gcc-c++

ARG  REDIS_VERSION=7.2.1
RUN wget https://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz
RUN tar -zvxf redis-${REDIS_VERSION}.tar.gz

RUN cd redis-${REDIS_VERSION} && \
	make -j4 && make PREFIX=/usr/local/redis install
RUN cp /opt/redis-${REDIS_VERSION}/redis.conf /usr/local/redis/bin/redis.conf
FROM base AS runtime

COPY --from=builder /usr/local/redis /usr/local/redis
RUN sed -i "s/bind 127.0.0.1/#bind 127.0.0.1/g" /usr/local/redis/bin/redis.conf && \
	sed -i "s/protected-mode yes/protected-mode no/g" /usr/local/redis/bin/redis.conf
EXPOSE 6379

ENV PATH=$PATH:/usr/local/redis/bin
COPY main.sh /opt/main.sh
RUN chmod +x /opt/main.sh

ENTRYPOINT [ "/opt/main.sh"]
CMD ["/bin/bash"]