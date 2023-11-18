FROM ruby:3.2.2-alpine3.18 AS builder

RUN apk update && apk add --virtual build-dependencies build-base

RUN gem install listen ascii_binder asciidoctor asciidoctor-diagram rouge

FROM ruby:3.2.2-alpine3.18

COPY --from=builder /usr/local/bundle /usr/local/bundle

RUN apk add --update --no-cache git bash && apk upgrade --no-cache

RUN git config --system --add safe.directory '*'

CMD ["/bin/bash"]
