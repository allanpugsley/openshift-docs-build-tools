FROM quay.io/ivanhorvath/ccutil:amazing as builder

COPY ./aura.tar.gz /

RUN pip install --no-cache-dir /aura.tar.gz \
    && python -m pip install --no-cache setuptools wheel pyyaml requests yamllint pillow \
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

RUN gem install asciidoctor asciidoctor-diagram

RUN git config --system --add safe.directory '*'

WORKDIR /ocpd-src

CMD ["/bin/sh"]