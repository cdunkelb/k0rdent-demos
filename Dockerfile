# -----------------------------------------
# Stage 1: Base Docker-in-Docker environment
# -----------------------------------------
FROM docker:dind AS dind-base

# Install necessary packages
RUN apk add --no-cache bash curl unzip sudo make jq bash-completion

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    sudo ./aws/install

# Install clusterawsadm
RUN curl -LO https://github.com/kubernetes-sigs/cluster-api-provider-aws/releases/download/v2.7.1/clusterawsadm-linux-amd64 && \
    sudo install -o root -g root -m 0755 clusterawsadm-linux-amd64 /usr/local/bin/clusterawsadm

RUN mkdir k0rdnet && cd k0rdnet && git clone https://github.com/cdunkelb/k0rdent-demos.git && cd k0rdent-demos && git checkout containerized

WORKDIR /k0rdnet/k0rdent-demos
