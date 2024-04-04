# Use the specified Harness Delegate image as the base
FROM --platform=linux/amd64 harness/delegate:24.03.82600

USER root

# Install jq
RUN microdnf update -y && \
    microdnf install -y jq && \
    microdnf clean all

# Install Azure CLI
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    rpm -ivh https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm && \
    microdnf install -y azure-cli && \
    microdnf clean all
