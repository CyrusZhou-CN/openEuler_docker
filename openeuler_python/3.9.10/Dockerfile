FROM openeuler/openeuler:20.09

WORKDIR /opt
COPY ./python/ /tmp/

RUN yum -y update && yum -y install shadow-utils tar libaio-devel flex bison \
    ncurses-devel glibc-devel patch libnsl readline-devel telnet gdbm-devel libpcap-devel xz-devel libffi-devel\
    zlib-devel bzip2-devel openssl openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel\
    make gcc zlib zlib-static zlib-devel python3-pip python3-psycopg2 python3-devel cmake wget
# bash: passwd: command not found
# bash: service: command not found
RUN yum install -y passwd initscripts sudo

# 编译安装 Python
RUN tar -xvf /tmp/Python-*.tar.xz -C /opt/ && rm -rf /tmp/Python-*.tar.xz && \
    cd /opt/Python-* && \
    ./configure -prefix=/usr/local/python3.9 --with-ssl --enable-optimizations --enable-shared && \
    make -j8 && make install 
RUN /usr/bin/cp /usr/local/python3.9/lib/lib* /usr/lib64
RUN /usr/bin/cp /usr/local/python3.9/lib/lib* /usr/lib
RUN ln -sf /usr/local/python3.9/bin/python3.9 /usr/bin/python39 \
    && ln -sf /usr/local/python3.9/bin/python3.9 /usr/bin/python3.9 \
    && ln -sf /usr/local/python3.9/bin/pip3 /usr/bin/pip3.9 \
    && ln -sf /usr/local/python3.9/bin/pip3 /usr/bin/pip39
RUN /usr/bin/python39 -m pip install --upgrade pip
RUN rpm -ivh /tmp/compat-openssl10*.rpm
RUN yum clean all
# 清除安装包
RUN rm -rf /tmp/* /opt/*

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/python3.9/lib
CMD ["/bin/bash"]