FROM registry.access.redhat.com/ubi8/ruby-30:latest

ENV LANG=en_US.UTF-8

USER root

RUN gem install listen asciidoctor asciidoctor-diagram rouge ascii_binder && yum clean all

RUN yum update -y \
    && yum install -y gcc-c++ make jq python3 \
    && yum clean all

RUN yum module reset nodejs -y \
    && yum module install nodejs:18 -y

RUN npm install -g netlify-cli

COPY ./aura.tar.gz /

ENV PYTHONUNBUFFERED=1

RUN python3 -m ensurepip \
    && pip3 install --no-cache --upgrade pip setuptools \
    && python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel pyyaml lxml requests yamllint \
    && pip install --no-cache-dir /aura.tar.gz \
    && rm -rf /var/cache/yum /tmp/* /var/tmp/*

RUN git config --system --add safe.directory '*'

CMD ["/bin/bash"]
