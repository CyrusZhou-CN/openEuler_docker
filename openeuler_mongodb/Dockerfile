FROM openeuler/openeuler:22.09  AS base

WORKDIR /opt

RUN yum -y update && yum clean all

FROM base AS builder
RUN yum -y install wget tar

COPY mongodb-linux-*.tgz /opt/
RUN tar -zxvf mongodb-linux-*.tgz && rm -rf mongodb-linux-*.tgz && mv mongodb-* mongodb

FROM base AS runtime
COPY --from=builder /opt/mongodb /opt/mongodb
COPY mongodb.conf /opt/mongodb/conf/mongodb.conf
COPY ./main.sh /opt/main.sh
RUN ln -s /opt/mongodb/bin/* /usr/local/bin/

ENTRYPOINT ["/opt/main.sh"]
EXPOSE 27017
CMD ["/bin/bash"]