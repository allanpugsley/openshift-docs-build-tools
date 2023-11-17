FROM registry.access.redhat.com/ubi8/ubi-minimal AS base
USER root
RUN microdnf install -y git ruby which && microdnf clean all && rm -rf /var/cache/yum
RUN gem install asciidoctor asciidoctor-diagram rouge
RUN git config --system --add safe.directory '*'
CMD ["/bin/bash"]