#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM openeuler/openeuler:21.09

WORKDIR /tmp
RUN yum -y install tar nodejs libicu wget
ARG DOTNET_ROOT=/usr/local/dotnet
ARG DOTNET_RUNTIME=aspnetcore-runtime-6.0.4-linux-x64.tar.gz
RUN mkdir -p ${DOTNET_ROOT}
ENV DOTNET_ROOT=${DOTNET_ROOT}
ENV PATH=$PATH:${DOTNET_ROOT}

RUN wget https://download.visualstudio.microsoft.com/download/pr/de3f6658-5d5b-4986-aeb1-7efdf5818437/7df572051df15117a0f52be1b79e1823/aspnetcore-runtime-6.0.4-linux-x64.tar.gz

RUN tar vfx "${DOTNET_RUNTIME}" -C "${DOTNET_ROOT}"
RUN rm -Rf ${DOTNET_RUNTIME}
RUN  yum -y install iputils