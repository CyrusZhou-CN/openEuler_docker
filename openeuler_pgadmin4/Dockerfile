FROM lsqtzj/openeuler_httpd:2.4.57  AS base

EXPOSE 80
WORKDIR /opt
RUN yum update -y
RUN yum install -y python3-pip python3-devel

FROM base AS builder
RUN yum install -y make wget

RUN wget https://github.com/GrahamDumpleton/mod_wsgi/archive/refs/tags/4.9.4.tar.gz
RUN tar xvfz 4.9.4.tar.gz && \
    rm -Rf 4.9.4.tar.gz && \
    cd mod_wsgi-4.9.4 && ./configure --with-python=/usr/bin/python3 && \
    make -j4 && make install

RUN wget https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v6.21/source/pgadmin4-6.21.tar.gz

RUN tar vfx pgadmin4-*.tar.gz && rm -Rf pgadmin4-*.tar.gz && mv pgadmin4-* pgadmin4

RUN  echo -e "LOG_FILE = '/var/log/pgadmin4/pgadmin4.log'\n\
SQLITE_PATH = '/var/lib/pgadmin4/pgadmin4.db'\n\
SESSION_DB_PATH = '/var/lib/pgadmin4/sessions'\n\
STORAGE_DIR = '/var/lib/pgadmin4/storage'\n\
SERVER_MODE = True" > /opt/pgadmin4/web/config_local.py

FROM base AS runtime
COPY --from=builder /opt/pgadmin4 /opt/pgadmin4
COPY --from=builder /usr/lib64/httpd /usr/lib64/httpd

RUN yum -y install krb5-devel postgresql-devel*
RUN echo "LoadModule wsgi_module /usr/lib64/httpd/modules/mod_wsgi.so" >> /etc/httpd/conf/httpd.conf
RUN echo "Include /etc/httpd/conf/extra/pgAdmin4.conf" >> /etc/httpd/conf/httpd.conf
RUN sed -i "4 i<a href='/pgadmin4'>pgAdmin4</a>" /var/www/html/index.html

RUN /usr/bin/python3 -m venv /opt/pgadmin4/venv && \
    source /opt/pgadmin4/venv/bin/activate && \ 
    /opt/pgadmin4/venv/bin/python3 -m pip install --upgrade pip  && \ 
    pip install -r /opt/pgadmin4/requirements.txt

# RUN { echo '[yarn]';\
#                 echo 'name=Yarn Repository';\
#                 echo 'baseurl=https://dl.yarnpkg.com/rpm/';\
#                 echo 'gpgcheck=1';\
#                 echo 'gpgkey=https://dl.yarnpkg.com/rpm/pubkey.gpg';\
#                 echo 'enabled=1';\
#         } >> /etc/yum.repos.d/yarn.repo

#RUN yum update -y && yum install -y yarn git
COPY ./pgAdmin4.conf /etc/httpd/conf/extra/pgAdmin4.conf
RUN mkdir -p /var/lib/pgadmin
COPY ./main.sh main.sh
RUN chown -R www:www /opt/pgadmin4
#RUN cd /opt/pgadmin4/web && yarn install

RUN yum clean all

ENV PGADMIN_DEFAULT_EMAIL="admin@domain.com"
ENV PGADMIN_DEFAULT_PASSWORD="admin"

ENTRYPOINT [ "/opt/main.sh"]
CMD ["/bin/bash"]