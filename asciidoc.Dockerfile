FROM registry.access.redhat.com/ubi8/ruby-30:latest

USER root

ENV LANG=en_US.UTF-8

RUN gem install ascii_binder && \
    gem install asciidoctor-diagram rouge listen && \
    # Need to stay on asciidoctor 2.0.20
    gem install asciidoctor -v 2.0.20 && \
    gem uninstall asciidoctor -v '> 2.0.20' && \
    yum clean all && \
    asciidoctor -v

RUN yum update -y \
    && yum install -y jq python3 python3-devel \
    && yum module reset nodejs -y \
    && yum module install nodejs:18 -y \
    && yum clean all

COPY ./aura.tar.gz /

ENV PYTHONUNBUFFERED=1

RUN python3 -m ensurepip \
    && pip3 install --no-cache-dir /aura.tar.gz \
    && python3 -m pip install --no-cache --upgrade pip setuptools wheel pyyaml requests yamllint pillow \
    && rm -rf /var/cache/yum /tmp/* /var/tmp/*

RUN curl -s https://api.github.com/repos/errata-ai/vale/releases/latest | grep "browser_download_url.*Linux_64-bit.tar.gz" | cut -d : -f 2,3 | tr -d \" | wget -qi - && \
    tar -xvzf *Linux_64-bit.tar.gz && \
    mv vale /usr/local/bin/vale && \
    vale -v

# Install netlify-cli on AMD64 only
RUN if [ "$(uname -m)" != "aarch64" ]; then \
    npm install -g netlify-cli --unsafe-perm=true; \
    fi

RUN chmod -R a+rw /opt/app-root/src/

RUN git config --system --add safe.directory '*'

WORKDIR /ocpd-src

CMD ["/bin/bash"]
