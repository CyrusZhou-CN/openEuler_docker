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

# 编译安装 Python 修复 libpython3.9.so.1.0()(64bit) 问题
RUN tar -xvf /tmp/Python-*.tar.xz -C /opt/ && rm -rf /tmp/Python-*.tar.xz && \
    cd /opt/Python-* && \
    ./configure -prefix=/usr \
    --enable-optimizations --with-lto \
    --with-threads \
    --enable-shared \
    --enable-universalsdk \
    --with-platlibdir=lib64 && \
    make -j8 && make install

RUN cp /lib/libpython3.9.so /lib/libpython3.so && \
    cp /lib/libpython3.9.so /lib64/libpython3.so && \
    cp /lib/libpython3.9.so /lib64/libpython3.9.so && \
    ln -sf /lib/libpython3.9.so /lib64/libpython3.9.so.1.0 && \
    ldconfig

RUN cp -rf /usr/lib/python3.8/site-packages/dnf-plugins /usr/lib/python3.9/site-packages/dnf-plugins && \
    cp -rf /usr/lib/python3.8/site-packages/dnf /usr/lib/python3.9/site-packages/dnf && \    
    cp -rf /usr/lib64/python3.8/site-packages/libdnf /usr/lib64/python3.9/site-packages/libdnf && \
    cp -rf /usr/lib64/python3.8/site-packages/rpm /usr/lib64/python3.9/site-packages/rpm && \
    cp -rf /usr/lib64/python3.8/site-packages/libcomps /usr/lib64/python3.9/site-packages/libcomps && \
    cp -rf /usr/lib64/python3.8/site-packages/gpg /usr/lib64/python3.9/site-packages/gpg && \
    cp -rf /usr/lib64/python3.8/site-packages/hawkey /usr/lib64/python3.9/site-packages/hawkey && \
    mv /usr/lib64/python3.9/site-packages/gpg/_gpgme.cpython-38-x86_64-linux-gnu.so /usr/lib64/python3.9/site-packages/gpg/_gpgme.cpython-39-x86_64-linux-gnu.so

RUN /usr/bin/python3 -m pip install --upgrade pip
RUN rpm -ivh /tmp/compat-openssl10*.rpm
RUN yum clean all
# 清除安装包
RUN rm -rf /tmp/* /opt/*

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH
CMD ["/bin/bash"]