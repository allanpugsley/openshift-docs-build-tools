FROM registry.access.redhat.com/ubi8/ubi-minimal

USER root

COPY ./aura.tar.gz /

RUN microdnf upgrade --refresh --best --nodocs --noplugins --setopt=install_weak_deps=0

RUN microdnf install -y git python39 python39-pip && microdnf clean all && rm -rf /var/cache/yum

RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel pyyaml lxml requests && pip install --no-cache-dir /aura.tar.gz

RUN git config --system --add safe.directory '*'

CMD ["/bin/bash"]
