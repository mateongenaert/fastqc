FROM ubuntu:20.04
MAINTAINER mongenae@its.jnj.com

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/London

ENV PACKAGES git gcc make g++ libboost-all-dev liblzma-dev libbz2-dev \
    ca-certificates zlib1g-dev libcurl4-openssl-dev curl unzip autoconf apt-transport-https ca-certificates gnupg software-properties-common wget cpanminus

ENV FASTQC_VERSION 0.11.9

WORKDIR /home

RUN apt-get update && \
    apt remove -y libcurl4 && \
    apt-get install -y --no-install-recommends ${PACKAGES} && \
    apt-get clean

RUN apt-get update

RUN cpanm FindBin 

RUN apt-get install -y  software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer

RUN apt-get install -y unzip

WORKDIR /home

RUN wget --no-check-certificate https://github.com/s-andrews/FastQC/archive/refs/tags/v${FASTQC_VERSION}.tar.gz
RUN tar -xzf ${ASTQC_VERSION}.tar.gz
WORKDIR /home/FastQC
RUN chmod 755 fastqc
RUN ln -s /home/FastQC/fastqc /usr/local/bin/fastqc

ENV PATH /home/FastQC/:${PATH}
ENV LD_LIBRARY_PATH "/usr/local/lib:${LD_LIBRARY_PATH}"

RUN echo "export PATH=$PATH" > /etc/environment
RUN echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH" > /etc/environment
