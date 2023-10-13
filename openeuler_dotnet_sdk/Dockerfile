#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM lsqtzj/openeuler:23.09

WORKDIR /tmp
RUN yum -y install tar nodejs libicu wget
ARG DOTNET_ROOT=/usr/local/dotnet
ARG DOTNET_SDK=dotnet-sdk-7.0.402-linux-x64.tar.gz
RUN mkdir -p ${DOTNET_ROOT}
ENV DOTNET_ROOT=${DOTNET_ROOT}
ENV PATH=$PATH:${DOTNET_ROOT}

RUN wget https://download.visualstudio.microsoft.com/download/pr/c4b5aad8-a416-436b-927c-3ebd5a9793ad/38efd1b64c8edc7c5f13699dd0be54e1/dotnet-sdk-7.0.402-linux-x64.tar.gz

RUN tar vfx "${DOTNET_SDK}" -C "${DOTNET_ROOT}"
RUN rm -Rf "${DOTNET_SDK}"
RUN  yum -y install iputils