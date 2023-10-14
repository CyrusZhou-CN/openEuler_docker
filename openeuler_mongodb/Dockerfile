FROM lsqtzj/openeuler:23.09  AS base

WORKDIR /opt

RUN yum -y update && yum clean all

FROM base AS builder
RUN yum -y install wget tar perl make gcc

COPY mongodb-linux-*.tgz /opt/
RUN tar -zxvf mongodb-linux-*.tgz && rm -rf mongodb-linux-*.tgz && mv mongodb-* mongodb
RUN wget https://www.openssl.org/source/openssl-1.1.1l.tar.gz && \
    tar -xzvf openssl-1.1.1l.tar.gz && \
    cd openssl-1.1.1l && ./config --prefix=/usr/local/openssl && make && make install

FROM base AS runtime
COPY --from=builder /opt/mongodb /opt/mongodb
COPY --from=builder /usr/local/openssl /usr/local/openssl
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/openssl/lib

COPY mongodb.conf /opt/mongodb/conf/mongodb.conf
COPY ./main.sh /opt/main.sh
RUN ln -s /opt/mongodb/bin/* /usr/local/bin/

ENTRYPOINT ["/opt/main.sh"]
EXPOSE 27017
CMD ["/bin/bash"]