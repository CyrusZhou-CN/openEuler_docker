FROM lsqtzj/openeuler:23.09 AS base

EXPOSE 80
WORKDIR /opt
RUN yum update -y
RUN yum -y install shadow-utils libxslt libzip libcurl oniguruma re2c libmcrypt mhash && groupadd -r www && useradd -r -g www www

FROM base AS builder

RUN yum -y install wget tar make gcc autoconf systemd-devel openjpeg2-devel gcc-c++ \
        pcre-devel zlib-devel libxml2 libxml2-devel openssl openssl-devel bzip2 bzip2-devel \
        libcurl libcurl-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel \
        gmp gmp-devel readline readline-devel libxslt libxslt-devel sqlite-devel bison \
        enchant automake libtool libedit libedit-devel oniguruma oniguruma-devel libzip libzip-devel \
        enchant enchant-devel libicu libicu-devel libldb openldap openldap-devel libaio krb5-devel

RUN wget https://www.openssl.org/source/openssl-1.1.1l.tar.gz && \
    tar -xzvf openssl-1.1.1l.tar.gz && \
    cd openssl-1.1.1l && ./config --prefix=/usr/local/openssl && make && make install

RUN wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz
RUN tar -zvxf libiconv-*.tar.gz && rm -Rf libiconv-*.tar.gz
RUN cd libiconv-* && ./configure --prefix=/usr/local/libiconv && make -j4 && make install

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH:/usr/local/libiconv/lib:/usr/local/openssl/lib
RUN ldconfig

RUN wget https://nginx.org/download/nginx-1.25.2.tar.gz
RUN tar -zvxf nginx-*.tar.gz && rm -Rf nginx-*.tar.gz
RUN cd nginx-* && ./configure --prefix=/usr/local/nginx  && make && make install

RUN wget https://github.com/php/php-src/archive/refs/tags/php-8.2.11.tar.gz
RUN tar -zvxf php-*.tar.gz && rm -Rf php-*.tar.gz
RUN cd /opt/php-src-php-* && ./buildconf --force &&  \
        ./configure \
        --prefix=/usr/local/php \
        --with-config-file-path=/usr/local/php/etc \
        --with-iconv-dir=/usr/local/libiconv \
        --with-openssl-dir=/usr/local/openssl \
        --with-fpm-user=www \
        --with-fpm-group=www \
        --with-curl \
        --enable-gd \
        --with-gettext \
        --with-kerberos \
        --with-libdir=lib64 \
        --with-mysqli \
        --with-pdo-mysql \
        --with-pdo-sqlite \
        --with-pear \
        --with-xmlrpc \
        --with-xsl \
        --with-zlib \
        --with-bz2 \
        --with-mhash \
        --enable-fpm \
        --enable-bcmath \
        --enable-inline-optimization \
        --enable-mbregex \
        --enable-mbstring \
        --enable-opcache \
        --enable-pcntl \
        --enable-shmop \
        --enable-soap \
        --enable-sockets \
        --enable-sysvsem \
        --enable-sysvshm \
        --enable-xml \
        --with-zip && make -j4 ZEND_EXTRA_LIBS='-liconv' && make install
RUN cd /opt/php-src-php-* && cp php.ini-production /usr/local/php/etc/php.ini
RUN  set -e;\        
        sed -i 's/post_max_size = 8M/post_max_size = 50M/g' /usr/local/php/etc/php.ini;\
        sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 50M/g' /usr/local/php/etc/php.ini;\
        sed -i 's/;date.timezone =/date.timezone = PRC/g' /usr/local/php/etc/php.ini;\
        sed -i 's/short_open_tag = Off/short_open_tag = On/g' /usr/local/php/etc/php.ini;\
        sed -i 's/; cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /usr/local/php/etc/php.ini;\
        sed -i 's/; cgi.fix_pathinfo=0/cgi.fix_pathinfo=0/g' /usr/local/php/etc/php.ini;\
        sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /usr/local/php/etc/php.ini;\
        sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /usr/local/php/etc/php.ini;\
        sed -i 's/register_long_arrays = On/;register_long_arrays = On/g' /usr/local/php/etc/php.ini;\
        sed -i 's/magic_quotes_gpc = On/;magic_quotes_gpc = On/g' /usr/local/php/etc/php.ini;\
        sed -i 's/memory_limit = 128M/memory_limit = 512M/g' /usr/local/php/etc/php.ini;\
        sed -i 's/disable_functions =.*/disable_functions = passthru,exec,system,chroot,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server/g' /usr/local/php/etc/php.ini;\
        ln -sf /usr/local/php/bin/php /usr/bin/php;\
        ln -sf /usr/local/php/bin/phpize /usr/bin/phpize;\
        ln -sf /usr/local/php/sbin/php-fpm /usr/bin/php-fpm;
        # { echo '[Zend Optimizer]';\
        #         echo 'zend_extension=/usr/local/zend/ZendGuardLoader.so';\
        #         echo 'zend_extension=/usr/local/zend/opcache.so';\
        #         echo 'zend_loader.enable=1';\
        #         echo 'zend_loader.disable_licensing=0';\
        #         echo 'zend_loader.obfuscation_level_support=3';\
        #         echo 'zend_loader.license_path=';\
        # } >> /usr/local/php/etc/php.ini
RUN wget https://github.com/legale/phpenmod/raw/master/phpenmod -O /bin/phpenmod && chmod +x /bin/phpenmod
FROM base AS runtime

COPY  --from=builder /usr/local/nginx   /usr/local/nginx
COPY  --from=builder /usr/local/php  /usr/local/php
COPY  --from=builder /bin/phpenmod /bin/phpenmod
# COPY  --from=builder /usr/local/zend /usr/local/zend
COPY  --from=builder /usr/local/libiconv /usr/local/libiconv
COPY  --from=builder /usr/local/openssl /usr/local/openssl
COPY  ./php/php-fpm.conf  /usr/local/php/etc/php-fpm.conf

RUN     ln -s /usr/local/php/bin/php /usr/bin/php;\
        ln -s /usr/local/php/bin/phpize /usr/bin/phpize;\
        ln -s /usr/local/php/sbin/php-fpm /usr/bin/php-fpm;
RUN chmod 755 /usr/local/php/etc/php-fpm.conf && chmod 755 /usr/local/php/etc/php.ini
COPY ./nginx/nginx.conf /usr/local/nginx/conf/nginx.conf
COPY ./main.sh /opt/main.sh
RUN chmod 755 /opt/main.sh
RUN chmod +x /opt/main.sh

RUN mkdir -p /www
RUN chown -R www:www /www
RUN chown -R www:www /usr/local/nginx
RUN chown -R www:www /usr/local/php

VOLUME /www
WORKDIR /www

RUN mkdir -p /www/wwwroot/default && mkdir /www/wwwlogs && \
        set -e;\
        { echo '<head>';\
        echo '<title>Welcome to nginx!</title>';\
        echo '<style>';\       
        echo 'html { color-scheme: light dark; }';\
        echo 'body {width:950px; margin: 10 auto;';\
        echo 'font-family: Tahoma, Verdana, Arial, sans-serif; }';\
        echo '</style>';\
        echo '</head>';\
        echo '<body>';\
        echo '<h1><a href="https://www.openeuler.org/">openEuler</a>'  && \   
        cat /etc/os-release | grep -Po '(?<=VERSION=).*' | sed 's/"//g'| sed 's/$/<\/h1>/';\
        echo '<h1>Welcome to nginx!</h1>';\
        echo '<h2>';\
        echo $(/usr/local/nginx/sbin/nginx -v);\
        echo '</h2>';\           
        echo '<p>If you see this page, the nginx web server is successfully installed and';\
        echo 'working. Further configuration is required.</p>';\
        echo '<p>For online documentation and support please refer to';\
        echo '<a href="http://nginx.org/">nginx.org</a>.<br/>';\
        echo 'Commercial support is available at';\
        echo '<a href="http://nginx.com/">nginx.com</a>.</p>';\
        echo '<p><em>Thank you for using nginx.</em></p>';\
        echo '<?php';\
        echo 'phpinfo();';\
        echo '?>';\
        echo '</body>';\
        echo '</html>';\
        } >> /www/wwwroot/default/index.php
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH:/usr/local/libiconv/lib:/usr/local/openssl/lib
ENV PATH=$PATH:/usr/local/nginx/sbin/:/usr/local/php/sbin
ENTRYPOINT [ "/opt/main.sh"]
CMD ["/bin/bash"]