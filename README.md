# openshift-build-tools

Dockerfile with tools to validate and build openshift-docs AsciiDoc files.

## Build image and push to quay.io

```cmd
podman login registry.redhat.io

podman login quay.io/redhat-docs

podman rmi quay.io/redhat-docs/openshift-docs-asciidoc:multiarch

podman rmi localhost/openshift-docs-asciidoc:multiarch

podman build -t openshift-docs-asciidoc:latest --platform linux/amd64 -f asciidoc.Dockerfile

podman tag <commit_hash> quay.io/redhat-docs/openshift-docs-asciidoc:latest

podman push quay.io/redhat-docs/openshift-docs-asciidoc:latest
```

## Multiarch build

```cmd
podman rmi quay.io/redhat-docs/openshift-docs-asciidoc:latest

podman rmi localhost/openshift-docs-asciidoc:latest

podman build --platform linux/arm64 --tag quay.io/redhat-docs/openshift-docs-asciidoc:multiarch -f asciidoc.Dockerfile

podman tag <commit_hash> quay.io/redhat-docs/openshift-docs-asciidoc:multiarch

podman push quay.io/redhat-docs/openshift-docs-asciidoc:multiarch
```

The image is available from https://quay.io/repository/redhat-docs/openshift-docs-asciidoc?tab=tags&tag=latest

To use it, `podman pull quay.io/redhat-docs/openshift-docs-asciidoc`.

## Testing

```cmd
podman run --rm -it -v "$(pwd)":~/ocpd-src:Z <commit_hash> sh -c 'asciidoctor -v'
```
