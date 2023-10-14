FROM lsqtzj/openeuler:23.09  AS base

WORKDIR /opt

ARG MARIADB_MAJOR=11.3.0

FROM base AS builder

RUN yum -y install wget tar 

RUN wget https://archive.mariadb.org/mariadb-${MARIADB_MAJOR}/source/mariadb-${MARIADB_MAJOR}.tar.gz
RUN tar -zvxf mariadb-${MARIADB_MAJOR}.tar.gz

RUN yum -y install cmake make gcc gcc-c++ ncurses-devel openssl-devel openssl libevent zlib-devel

RUN wget https://sourceforge.net/projects/pwgen/files/pwgen/2.08/pwgen-2.08.tar.gz
RUN tar -zvxf pwgen-2.08.tar.gz && \
	cd pwgen-2.08 && ./configure && make && make install

RUN mkdir -p /var/lib/mysql
RUN cd mariadb-${MARIADB_MAJOR} && \
	cmake . \
	-DCMAKE_INSTALL_PREFIX=/usr/local/mysql  \
	-DMYSQL_DATADIR=/var/lib/mysql \
	-DSYSCONFDIR=/etc \
	-DMYSQL_USER=mysql \
	-DWITH_INNOBASE_STORAGE_ENGINE=1 \
	-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
	-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
	-DWITH_PARTITION_STORAGE_ENGINE=1 \
	-DWITHOUT_MROONGA_STORAGE_ENGINE=1 \
	-DWITH_DEBUG=0 \
	-DWITH_READLINE=1 \
	-DCMAKE_BUILD_TYPE=Release \
	-DWITH_SSL=system \
	-DWITH_ZLIB=system \
	-DWITH_LIBWRAP=0 \
	-DENABLED_LOCAL_INFILE=1 \
	-DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
	-DDEFAULT_CHARSET=utf8 \
	-DDEFAULT_COLLATION=utf8_general_ci && \
	make -j4 && make install

FROM base AS runtime

RUN yum -y install lsb initscripts shadow-utils && groupadd -r mysql && useradd -r -g mysql mysql

COPY --from=builder /usr/local/bin/pwgen /usr/local/bin/pwgen
COPY --from=builder /usr/local/mysql /usr/local/mysql
RUN chown -R mysql:mysql /usr/local/mysql \
	&& mkdir -p /var/run/mysqld \
	&& chown mysql:mysql /var/run/mysqld

RUN mkdir -p /etc/mysql && \
	cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld &&\
	cp /usr/local/mysql/support-files/wsrep.cnf  /etc/mysql/my.cnf
# 默认忽略大小写
RUN sed -i '/\[mysqld\]/alower_case_table_names=1' /etc/mysql/my.cnf

EXPOSE 3306
RUN mkdir /docker-entrypoint-initdb.d

VOLUME /var/lib/mysql
ENV MARIADB_MAJOR $MARIADB_MAJOR
ARG MARIADB_VERSION=1:${MARIADB_MAJOR}+maria~focal
ENV MARIADB_VERSION $MARIADB_VERSION

ENV PATH=$PATH:/usr/local/mysql/bin/
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 3306
CMD ["mariadbd"]