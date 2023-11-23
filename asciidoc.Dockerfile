FROM ruby:3.1.2-alpine AS builder

RUN apk update && apk add --virtual build-dependencies build-base \
    && gem install listen asciidoctor asciidoctor-diagram rouge ascii_binder

FROM ruby:3.1.2-alpine

COPY --from=builder /usr/local/bundle /usr/local/bundle

COPY ./aura.tar.gz /

ENV PYTHONUNBUFFERED=1

RUN apk add --update --no-cache git findutils python3 bash nodejs npm \
    && ln -sf python3 /usr/bin/python \
    && npm install netlify-cli -g

RUN python3 -m ensurepip && pip3 install --no-cache --upgrade pip setuptools \
    && python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel pyyaml lxml requests \
    && pip install --no-cache-dir /aura.tar.gz

RUN git config --system --add safe.directory '*'

RUN mkdir -p /tmp/vault/ocp-docs-netlify-secret

CMD ["/bin/bash"]