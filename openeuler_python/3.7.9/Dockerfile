FROM openeuler/openeuler:20.03


WORKDIR /opt
COPY ./python/ /tmp/

RUN yum -y update && yum -y install shadow-utils tar libaio-devel flex bison \
    ncurses-devel glibc-devel patch libnsl readline-devel telnet gdbm-devel libpcap-devel xz-devel libffi-devel\
    zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel\
    make gcc zlib zlib-static zlib-devel python3-psycopg2 python3-devel 
# bash: passwd: command not found
# bash: service: command not found
RUN yum install -y passwd initscripts sudo && \
    yum clean all
# 编译安装 openssl
RUN tar -zxvf /tmp/openssl-*.tar.gz -C /opt/ && rm -rf /tmp/openssl-*.tar.gz && \
    cd /opt/openssl-* && \
    ./config enable-ssl2 enable-ssl3 no-shared && \
    make -j8 && make install 

# 编译安装 Python
RUN tar -xvf /tmp/Python-*.tar.xz -C /opt/ && rm -rf /tmp/Python-*.tar.xz && \
    cd /opt/Python-* && \
    ./configure -prefix=/usr/local/python3.7 --with-ssl --enable-optimizations && \
    make -j8 && make install && \
    ln -sf /usr/local/python3.7/bin/python3.7 /usr/bin/python3.7 && \
    ln -sf /usr/local/python3.7/bin/python3.7 /usr/bin/python3 && \
    ln -sf /usr/local/python3.7/bin/python3.7 /usr/bin/python && \
    ln -sf /usr/local/python3.7/bin/pip3 /usr/bin/pip3 && \
    ln -sf /usr/local/python3.7/bin/pip3 /usr/bin/pip 
    
# 解决yum dnf出错问题
RUN cp -rf /usr/lib/python3.7/site-packages/dnf-plugins /usr/local/python3.7/lib/python3.7/site-packages/dnf-plugins && \
    cp -rf /usr/lib/python3.7/site-packages/fros-1.1-py3.7.egg-info /usr/local/python3.7/lib/python3.7/site-packages/fros-1.1-py3.7.egg-info && \
    cp -rf /usr/lib/python3.7/site-packages/pyfros /usr/local/python3.7/lib/python3.7/site-packages/pyfros && \
    cp -rf /usr/lib/python3.7/site-packages/pyparsing-2.4.7.dist-info /usr/local/python3.7/lib/python3.7/site-packages/pyparsing-2.4.7.dist-info && \
    cp -rf /usr/lib/python3.7/site-packages/dnf /usr/local/python3.7/lib/python3.7/site-packages/dnf && \    
    cp -rf /usr/lib64/python3.7/site-packages/libdnf /usr/local/python3.7/lib/python3.7/site-packages/libdnf && \
    cp -rf /usr/lib64/python3.7/site-packages/rpm /usr/local/python3.7/lib/python3.7/site-packages/rpm && \
    cp -rf /usr/lib64/python3.7/site-packages/rpm-4.15.1-py3.7.egg-info  /usr/local/python3.7/lib/python3.7/site-packages/rpm-4.15.1-py3.7.egg-info && \
    cp -rf /usr/lib64/python3.7/site-packages/libcomps /usr/local/python3.7/lib/python3.7/site-packages/libcomps && \
    cp -rf /usr/lib64/python3.7/site-packages/gpg /usr/local/python3.7/lib/python3.7/site-packages/gpg && \
    cp -rf /usr/lib64/python3.7/site-packages/gpg-1.14.0-py3.7.egg-info  /usr/local/python3.7/lib/python3.7/site-packages/gpg-1.14.0-py3.7.egg-info && \
    cp -rf /usr/lib64/python3.7/site-packages/hawkey /usr/local/python3.7/lib/python3.7/site-packages/hawkey 
# 清除安装包
RUN rm -rf /tmp/* /opt/*
# RUN rm -rf /usr/lib64/libssl* && \
#     cp /usr/local/openssl/lib/libssl* /usr/lib64 && \
#     chmod -R 755 /usr/lib64/libssl* && \
#     chmod -R 755 /usr/local/openssl && \
#     chmod -R 755 /usr/bin/openssl && \
#     chmod -R 755 /usr/include/openssl && \
#     chmod -R 755 /usr/local/python3.7 &&\
#     chmod -R 755 /usr/lib/python3.7  &&\
#     chmod -R 755 /usr/lib64/python3.7 &&\
#     ldconfig -v
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/openssl/lib/
CMD ["/bin/bash"]