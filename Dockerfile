# -----------------------------------------
# Stage 1: Base Docker-in-Docker environment
# -----------------------------------------
    FROM ubuntu:22.04 AS dind-base

    ENV TERRAFORM_VERSION=1.10.5
    
    # Install Python and tooling needed for Poetry
    RUN apt update && apt install -y \
        python3 \
        ca-certificates \
        curl \
        git \
        make \
        file \
        sudo \
        gettext \
        vim \
        wget \
        unzip \
        bash-completion
    
    # Install Terraform
    RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
        unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
        mv terraform /usr/local/bin/ && \
        chmod +x /usr/local/bin/terraform && \
        rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    
    RUN sudo install -m 0755 -d /etc/apt/keyrings/ && \
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
        sudo chmod a+r /etc/apt/keyrings/docker.asc
    
    RUN echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    RUN sudo apt update && sudo apt install -y docker-ce
    
    # Install AWS CLI
    RUN sudo apt install unzip && \
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
        unzip awscliv2.zip && \
        sudo ./aws/install
    
    # Install clusterawsadm
    RUN curl -LO https://github.com/kubernetes-sigs/cluster-api-provider-aws/releases/download/v2.7.1/clusterawsadm-linux-amd64 && \
        sudo install -o root -g root -m 0755 clusterawsadm-linux-amd64 /usr/local/bin/clusterawsadm