FROM registry.access.redhat.com/ubi8/ruby-30:latest

USER root

ENV LANG=en_US.UTF-8

RUN gem install listen asciidoctor asciidoctor-diagram rouge ascii_binder && yum clean all

RUN yum update -y \
    && yum install -y jq python3 python3-devel \
    && yum module reset nodejs -y \
    && yum module install nodejs:18 -y \
    && yum copr enable mczernek/vale -y \
    && yum install vale -y \
    && yum clean all

COPY ./aura.tar.gz /

ENV PYTHONUNBUFFERED=1

RUN python3 -m ensurepip \
    && python3 -m pip install --no-cache --upgrade pip setuptools wheel pyyaml lxml requests yamllint \
    && pip3 install --no-cache-dir /aura.tar.gz \
    && rm -rf /var/cache/yum /tmp/* /var/tmp/*

RUN npm install -g netlify-cli --unsafe-perm=true

RUN chmod -R a+rw /opt/app-root/src/

RUN git config --system --add safe.directory '*'

WORKDIR /ocpd-src

CMD ["/bin/bash"]
