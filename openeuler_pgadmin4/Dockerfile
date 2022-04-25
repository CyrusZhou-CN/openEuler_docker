FROM lsqtzj/openeuler_httpd:v2.4.51  AS base

EXPOSE 80
WORKDIR /opt
RUN yum update -y
RUN yum install -y python3-pip python3-devel

FROM base AS builder

COPY ./pgadmin4-*.tar.gz pgadmin4-*.tar.gz
COPY ./mod_wsgi-4.9.0.tar.gz mod_wsgi-4.9.0.tar.gz 
RUN tar vfx pgadmin4-*.tar.gz && rm -Rf pgadmin4-*.tar.gz && mv pgadmin4-* pgadmin4
RUN yum install -y make
RUN  echo -e "LOG_FILE = '/var/log/pgadmin4/pgadmin4.log'\n\
SQLITE_PATH = '/var/lib/pgadmin4/pgadmin4.db'\n\
SESSION_DB_PATH = '/var/lib/pgadmin4/sessions'\n\
STORAGE_DIR = '/var/lib/pgadmin4/storage'\n\
SERVER_MODE = True" > /opt/pgadmin4/web/config_local.py

RUN tar xvfz mod_wsgi-4.9.0.tar.gz && \
    rm -Rf mod_wsgi-4.9.0.tar.gz && \
    cd mod_wsgi-4.9.0 && ./configure --with-python=/usr/bin/python3.8 && \
    make -j4 && make install

FROM base AS runtime
COPY --from=builder /usr/lib64/httpd /usr/lib64/httpd
COPY --from=builder /opt/pgadmin4 /opt/pgadmin4
COPY --from=builder /usr/bin/python3.8 /usr/bin/python3.8
RUN yum -y install krb5-devel postgresql-devel*
RUN echo "LoadModule wsgi_module /usr/lib64/httpd/modules/mod_wsgi.so" >> /etc/httpd/conf/httpd.conf
RUN echo "Include /etc/httpd/conf/extra/pgAdmin4.conf" >> /etc/httpd/conf/httpd.conf
RUN sed -i "4 i<a href='/pgadmin4'>pgAdmin4</a>" /var/www/html/index.html

RUN /usr/bin/python3 -m venv /opt/pgadmin4/venv && \
    source /opt/pgadmin4/venv/bin/activate && \ 
    /opt/pgadmin4/venv/bin/python3 -m pip install --upgrade pip  && \ 
    pip install -r /opt/pgadmin4/requirements.txt

COPY ./pgAdmin4.conf /etc/httpd/conf/extra/pgAdmin4.conf

COPY ./main.sh main.sh
RUN chown -R www:www /opt/pgadmin4
RUN yum clean all

ENV PGADMIN_DEFAULT_EMAIL="admin@domain.com"
ENV PGADMIN_DEFAULT_PASSWORD="admin"

ENTRYPOINT [ "/opt/main.sh"]
CMD ["/bin/bash"]