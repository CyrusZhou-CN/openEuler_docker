#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM openeuler/openeuler:21.09

WORKDIR /tmp
RUN yum -y install tar nodejs libicu wget
ARG DOTNET_ROOT=/usr/local/dotnet
ARG DOTNET_SDK=dotnet-sdk-6.0.202-linux-x64.tar.gz
RUN mkdir -p ${DOTNET_ROOT}
ENV DOTNET_ROOT=${DOTNET_ROOT}
ENV PATH=$PATH:${DOTNET_ROOT}

RUN wget https://download.visualstudio.microsoft.com/download/pr/9d8c7137-2091-4fc6-a419-60ba59c8b9de/db0c5cda94f31d2260d369123de32d59/dotnet-sdk-6.0.202-linux-x64.tar.gz

RUN tar vfx "${DOTNET_SDK}" -C "${DOTNET_ROOT}"
RUN rm -Rf "${DOTNET_SDK}"