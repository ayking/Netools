FROM ubuntu:24.04 AS base

USER root

RUN url https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc
RUN curl https://packages.microsoft.com/config/ubuntu/24.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list

# Install dependencies
RUN apt-get update && apt-get install -y \
    net-tools iproute2 netcat-traditional netcat-openbsd dnsutils curl \
    iputils-ping iptables nmap tcpdump wget traceroute \
    redis-tools postgresql-client unixodbc-dev odbcinst unixodbc

FROM base AS sql

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH=$PATH:/opt/mssql-tools/bin

RUN wget https://packages.microsoft.com/ubuntu/20.04/prod/pool/main/m/msodbcsql17/msodbcsql17_17.10.6.1-1_amd64.deb && \
    ACCEPT_EULA=Y dpkg -i msodbcsql17_17.10.6.1-1_amd64.deb && \
    rm msodbcsql17_17.10.6.1-1_amd64.deb
RUN wget https://packages.microsoft.com/ubuntu/20.04/prod/pool/main/m/mssql-tools/mssql-tools_17.10.1.1-1_amd64.deb && \
    ACCEPT_EULA=Y dpkg -i mssql-tools_17.10.1.1-1_amd64.deb && \
    rm mssql-tools_17.10.1.1-1_amd64.deb



