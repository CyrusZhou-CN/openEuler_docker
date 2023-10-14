FROM lsqtzj/openeuler:23.09 AS base
WORKDIR /opt

FROM base AS builder

WORKDIR /opt
COPY ./python/ /tmp/

RUN yum -y update && yum -y install shadow-utils tar libaio-devel flex bison \
    ncurses-devel glibc-devel patch libnsl readline-devel telnet gdbm-devel libpcap-devel xz-devel libffi-devel\
    zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel\
    make gcc zlib zlib-static zlib-devel python3-psycopg2 python3-devel perl

# 编译安装 openssl
RUN tar -zxvf /tmp/openssl-*.tar.gz -C /opt/ && rm -rf /tmp/openssl-*.tar.gz && \
    cd /opt/openssl-* && \
    ./config enable-ssl2 enable-ssl3 no-shared --prefix=/usr/local/openssl && \
    make -j8 && make install 

# 编译安装 Python
RUN tar -xvf /tmp/Python-*.tar.xz -C /opt/ && rm -rf /tmp/Python-*.tar.xz && \
    cd /opt/Python-* && \
    ./configure --prefix=/usr/local/python3.7 \
    --with-openssl=/usr/local/openssl \
    --enable-optimizations \
    --with-lto \
    --with-threads \
    --enable-shared \
    --enable-universalsdk \
    --with-platlibdir=lib64 && \
    make -j8 && make install
    
FROM base AS runtime
COPY --from=builder /usr/local/python3.7 /usr/local/python3.7
COPY --from=builder /usr/local/openssl /usr/local/openssl

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/python3.7/lib:/usr/local/openssl/lib/
RUN ldconfig
RUN sed -i 's/\/usr\/bin\/python3/\/usr\/bin\/python3.11/g' /usr/bin/dnf
RUN sed -i 's/\/usr\/bin\/python3/\/usr\/bin\/python3.11/g' /usr/bin/yum
RUN /usr/local/python3.7/bin/python3.7 -m pip install --upgrade pip
RUN ln -sf /usr/local/python3.7/bin/python3.7 /usr/bin/python3.7 && \
    ln -sf /usr/local/python3.7/bin/python3.7 /usr/bin/python3 && \
    ln -sf /usr/local/python3.7/bin/python3.7 /usr/bin/python && \
    ln -sf /usr/local/python3.7/bin/pip3 /usr/bin/pip3 && \
    ln -sf /usr/local/python3.7/bin/pip3 /usr/bin/pip 

CMD ["/bin/bash"]