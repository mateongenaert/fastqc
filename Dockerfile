FROM ubuntu:20.04
MAINTAINER mongenae@its.jnj.com

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/London

ENV PACKAGES git gcc make g++ libboost-all-dev liblzma-dev libbz2-dev \
    ca-certificates zlib1g-dev libcurl4-openssl-dev curl unzip autoconf apt-transport-https ca-certificates gnupg software-properties-common wget openjdk-8-jre unzip

ENV FASTQC_VERSION 0.11.9

WORKDIR /home

RUN apt-get update && \
    apt remove -y libcurl4 && \
    apt-get install -y --no-install-recommends ${PACKAGES} && \
    apt-get clean

RUN apt-get update

WORKDIR /home

RUN wget --no-check-certificate https://github.com/s-andrews/FastQC/archive/refs/tags/v${FASTQC_VERSION}.zip
RUN unzip v${FASTQC_VERSION}.zip
WORKDIR /home/FastQC-${FASTQC_VERSION}
RUN chmod 755 ./fastqc
RUN ln -s /home/FastQC-${FASTQC_VERSION}/fastqc /usr/local/bin/fastqc

ENV PATH /home/FastQC-${FASTQC_VERSION}/:${PATH}
ENV LD_LIBRARY_PATH "/usr/local/lib:${LD_LIBRARY_PATH}"

RUN echo "export PATH=$PATH" > /etc/environment
RUN echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH" > /etc/environment
