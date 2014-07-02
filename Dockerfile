FROM cloyne/runit

MAINTAINER Mitar <mitar.docker@tnode.com>

EXPOSE 53/udp 53/tcp

RUN apt-get update -q -q && \
 apt-get install pdns-server --yes --force-yes && \
 mkdir /etc/service/pdns && \
 /bin/echo -e '#!/bin/sh' > /etc/service/pdns/run && \
 /bin/echo -e 'exec /usr/sbin/pdns_server 2>&1' >> /etc/service/pdns/run && \
 chown root:root /etc/service/pdns/run && \
 chmod 755 /etc/service/pdns/run && \
 mkdir /etc/service/pdns/log && \
 mkdir /var/log/powerdns && \
 /bin/echo -e '#!/bin/sh' > /etc/service/pdns/log/run && \
 /bin/echo -e 'exec chpst -u nobody:nogroup svlogd -tt /var/log/powerdns' >> /etc/service/pdns/log/run && \
 chown root:root /etc/service/pdns/log/run && \
 chmod 755 /etc/service/pdns/log/run && \
 chown nobody:nogroup /var/log/powerdns && \
 /bin/echo -e 'bind-check-interval=3600' >> /etc/powerdns/pdns.d/pdns.simplebind

COPY ./etc/pdns.cloyne /etc/powerdns/pdns.d/pdns.cloyne
