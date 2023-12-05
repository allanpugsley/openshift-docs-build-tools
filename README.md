# openshift-build-tools

Dockerfile with tools to validate and build openshift-docs AsciiDoc files.

## Push to quay.io

```cmd
podman login registry.redhat.io

podman login quay.io/redhat-docs

podman build -t openshift-docs-asciidoc:latest -f asciidoc.Dockerfile

podman tag <commit hash> quay.io/redhat-docs/openshift-docs-asciidoc

podman push quay.io/redhat-docs/openshift-docs-asciidoc
```

The image is available from https://quay.io/repository/redhat-docs/openshift-docs-asciidoc?tab=tags&tag=latest

To use it, `podman pull quay.io/redhat-docs/openshift-docs-asciidoc`.