FROM cloyne/base

MAINTAINER Mitar <mitar.docker@tnode.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q -q

RUN apt-get install runit --yes --force-yes

RUN apt-get install pdns-server --yes --force-yes

EXPOSE 53/udp 53/tcp

RUN mkdir /etc/service/pdns
RUN /bin/echo -e '#!/bin/sh' > /etc/service/pdns/run
RUN /bin/echo -e 'exec /usr/sbin/pdns_server 2>&1' >> /etc/service/pdns/run
RUN chown root:root /etc/service/pdns/run
RUN chmod 755 /etc/service/pdns/run

RUN mkdir /etc/service/pdns/log
RUN mkdir /var/log/powerdns
RUN /bin/echo -e '#!/bin/sh' > /etc/service/pdns/log/run
RUN /bin/echo -e 'exec chpst -unobody svlogd -tt /var/log/powerdns' >> /etc/service/pdns/log/run
RUN chown root:root /etc/service/pdns/log/run
RUN chmod 755 /etc/service/pdns/log/run
RUN chown nobody:nogroup /var/log/powerdns

RUN /bin/echo -e 'bind-check-interval=3600' >> /etc/powerdns/pdns.d/pdns.simplebind

COPY ./etc/pdns.cloyne /etc/powerdns/pdns.d/pdns.cloyne

ENTRYPOINT ["/usr/sbin/runsvdir-start"]
