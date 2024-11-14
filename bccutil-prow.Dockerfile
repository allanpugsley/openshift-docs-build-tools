FROM quay.io/ivanhorvath/ccutil:amazing as builder

COPY ./aura.tar.gz /

# Install Python 3.11 dependencies and build from source without changing the system Python
RUN yum update -y \
    && yum install -y jq curl ruby ruby-devel git \
    gcc openssl-devel bzip2-devel libffi-devel zlib-devel make \
    && yum clean all \
    && curl -o /tmp/Python-3.11.0.tgz https://www.python.org/ftp/python/3.11.0/Python-3.11.0.tgz \
    && tar -xzf /tmp/Python-3.11.0.tgz -C /tmp \
    && cd /tmp/Python-3.11.0 \
    && ./configure --enable-optimizations \
    && make altinstall \
    && ln -sf /usr/local/bin/python3.11 /usr/bin/python3.11 \
    && rm -rf /tmp/Python-3.11.0*

# Add Python 3.11 to the path for this container environment without overriding the system Python
ENV PATH="/usr/local/bin:${PATH}"

# Install required Python packages with Python 3.11
RUN python3.11 -m ensurepip \
    && python3.11 -m pip install --no-cache --upgrade pip setuptools wheel \
    && python3.11 -m pip install --no-cache-dir lxml pyyaml requests yamllint pillow --use-deprecated=legacy-resolver \
    && python3.11 -m pip install --no-cache-dir /aura.tar.gz \
    && rm -rf /var/cache/yum /tmp/* /var/tmp/*

# Install Node.js and Netlify CLI
RUN curl -fsSL https://rpm.nodesource.com/setup_16.x | bash - \
    && yum install -y nodejs \
    && yum clean all \
    && rm -rf /var/cache/yum

RUN npm install -g netlify-cli@v14.2.0 --unsafe-perm=true

# Install Asciidoctor and Asciidoctor Diagram
RUN gem install asciidoctor-diagram && \
    # Need to stay on asciidoctor 2.0.20
    gem install asciidoctor -v 2.0.20 && \
    gem uninstall asciidoctor -v '> 2.0.20' && \
    yum clean all && \
    asciidoctor -v

RUN git config --system --add safe.directory '*'

WORKDIR /ocpd-src

CMD ["/bin/sh"]
