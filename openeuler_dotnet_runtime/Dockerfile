#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM openeuler/openeuler:22.09
# 由于海外访问国内服务不稳定修改更新服务地址
RUN  sed -i "s|http://repo.openeuler.org/|https://fr-repo.openeuler.org/|g" /etc/yum.repos.d/openEuler.repo
WORKDIR /tmp
RUN yum -y install tar nodejs libicu wget
ARG DOTNET_ROOT=/usr/local/dotnet
ARG DOTNET_RUNTIME=aspnetcore-runtime-7.0.4-linux-x64.tar.gz
RUN mkdir -p ${DOTNET_ROOT}
ENV DOTNET_ROOT=${DOTNET_ROOT}
ENV PATH=$PATH:${DOTNET_ROOT}

RUN wget https://download.visualstudio.microsoft.com/download/pr/f2e33ca2-e597-4d7c-b34d-60e47b5fe2fc/a22feac281b4bf63c8b5195a30e6cce1/aspnetcore-runtime-7.0.4-linux-x64.tar.gz

RUN tar vfx "${DOTNET_RUNTIME}" -C "${DOTNET_ROOT}"
RUN rm -Rf ${DOTNET_RUNTIME}
RUN  yum -y install iputils