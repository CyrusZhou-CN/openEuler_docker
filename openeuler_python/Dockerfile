FROM lsqtzj/openeuler:23.09 AS base
WORKDIR /opt

FROM base AS builder

RUN yum -y update && yum -y install shadow-utils tar libaio-devel flex bison \
    ncurses-devel glibc-devel patch libnsl readline-devel telnet gdbm-devel libpcap-devel xz-devel libffi-devel\
    zlib-devel bzip2-devel openssl openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel\
    make gcc zlib zlib-static zlib-devel python3-pip python3-psycopg2 python3-devel cmake wget 
# bash: passwd: command not found
# bash: service: command not found
RUN yum install -y passwd initscripts sudo
RUN wget https://www.python.org/ftp/python/3.9.18/Python-3.9.18.tar.xz

RUN tar -xvf /opt/Python-*.tar.xz -C /opt/ && rm -rf /opt/Python-*.tar.xz && \
    cd /opt/Python-* && \
    ./configure --prefix=/usr/local/python3.9 \
    --enable-optimizations --with-lto \
    --with-threads \
    --enable-shared \
    --enable-universalsdk \
    --with-platlibdir=lib64 && \
    make -j8 && make install

FROM base AS runtime
COPY --from=builder /usr/local/python3.9 /usr/local/python3.9

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/python3.9/lib
RUN ldconfig
RUN sed -i 's/\/usr\/bin\/python3/\/usr\/bin\/python3.11/g' /usr/bin/dnf
RUN sed -i 's/\/usr\/bin\/python3/\/usr\/bin\/python3.11/g' /usr/bin/yum
RUN /usr/local/python3.9/bin/python3.9 -m pip install --upgrade pip
RUN ln -sf /usr/local/python3.9/bin/python3.9 /usr/bin/python3.9 && \
    ln -sf /usr/local/python3.9/bin/python3.9 /usr/bin/python3 && \
    ln -sf /usr/local/python3.9/bin/python3.9 /usr/bin/python && \
    ln -sf /usr/local/python3.9/bin/pip3 /usr/bin/pip3 && \
    ln -sf /usr/local/python3.9/bin/pip3 /usr/bin/pip 

CMD ["/bin/bash"]