FROM lsqtzj/openeuler:23.09 AS base

EXPOSE 80

WORKDIR /opt

FROM base AS builder

ARG  HTTPD_VERSION=2.4.57
RUN yum install -y wget apr-devel apr-util-devel pcre pcre-devel gcc make tar gcc-c++ lua-devel \
    openssl openssl-devel zlib unzip cmake ncurses-devel expat-devel libjpeg openldap-devel \
    libjpeg-devel libpng libxml2 libxml2-devel curl-devel libtool libtool-ltdl libtool-ltdl-devel \
    libevent libevent-devel zlib-static zlib-devel autoconf gd perl freetype freetype-devel \
    doxygen libuuid-devel python rpm-build libdb-devel mysql-devel nss-devel postgresql-devel sqlite-devel unixODBC-devel
RUN yum clean all
RUN wget  https://dlcdn.apache.org/httpd/httpd-${HTTPD_VERSION}.tar.bz2
RUN rpmbuild -tb httpd-${HTTPD_VERSION}.tar.bz2


FROM base AS runtime
COPY --from=builder  /root/rpmbuild/RPMS/x86_64/*.rpm /opt/httpd/
RUN yum localinstall -y /opt/httpd/*.rpm
RUN rm -Rf /opt/httpd
RUN groupadd www && useradd -g www www -s /bin/false 
RUN sed -i "/^User daemon/c\User www"  /etc/httpd/conf/httpd.conf
RUN sed -i "/^Group daemon/c\Group www"  /etc/httpd/conf/httpd.conf
RUN sed -i "/^#ServerName/c\ServerName localhost:80" /etc/httpd/conf/httpd.conf

RUN echo "<html><body>" > /var/www/html/index.html && \
    echo "<h1>openEuler" >> /var/www/html/index.html && \
    cat /etc/os-release | grep -Po '(?<=VERSION=).*' | sed 's/"//g'| sed 's/$/<\/h1>/' >> /var/www/html/index.html && \
    httpd -V | sed '1 s/^/<h2>/' | sed '1 s/$/<\/h2>/' | sed '2,$ s/$/<\/br>/'| tee -a /var/www/html/index.html && \
    httpd -M | sed '1 s/^/<h2>/' | sed '1 s/$/<\/h2>/' | sed '2,$ s/$/<\/br>/'| tee -a /var/www/html/index.html && \
    echo "</body></html>" >> /var/www/html/index.html && \
    true

COPY ./main.sh main.sh
RUN chmod +x /opt/main.sh

ENV PATH=$PATH:/etc/apache/bin/
ENTRYPOINT [ "/opt/main.sh"]
CMD ["/bin/bash"]