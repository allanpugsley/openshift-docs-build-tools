FROM quay.io/ivanhorvath/ccutil:amazing as builder

COPY ./aura.tar.gz /

RUN yum update -y \
    && yum install -y jq python3 python3-devel \
    && yum clean all

RUN python3 -m ensurepip \
    && python3 -m pip install --no-cache --upgrade pip setuptools wheel \
    && python3 -m pip install --no-cache-dir lxml pyyaml requests yamllint pillow --use-deprecated=legacy-resolver \
    && pip install --no-cache-dir /aura.tar.gz \
    && rm -rf /var/cache/yum /tmp/* /var/tmp/*

RUN yum install -y \
    curl \
    ruby \
    ruby-devel \
    git \
    && yum clean all \
    && rm -rf /var/cache/yum

RUN curl -fsSL https://rpm.nodesource.com/setup_16.x | bash - \
    && yum install -y nodejs \
    && yum clean all \
    && rm -rf /var/cache/yum

RUN npm install -g netlify-cli@v14.2.0 --unsafe-perm=true

# Need to stay on asciidoctor 2.0.20
RUN gem install asciidoctor-diagram && \
    # Need to stay on asciidoctor 2.0.20
    gem install asciidoctor -v 2.0.20 && \
    gem uninstall asciidoctor -v '> 2.0.20' && \
    yum clean all

RUN git config --system --add safe.directory '*'

WORKDIR /ocpd-src

CMD ["/bin/sh"]