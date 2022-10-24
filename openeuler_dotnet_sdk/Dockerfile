#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM openeuler/openeuler:22.09
# 由于海外访问国内服务不稳定修改更新服务地址
RUN  sed -i "s|http://repo.openeuler.org/|https://fr-repo.openeuler.org/|g" /etc/yum.repos.d/openEuler.repo
WORKDIR /tmp
RUN yum -y install tar nodejs libicu wget
ARG DOTNET_ROOT=/usr/local/dotnet
ARG DOTNET_SDK=dotnet-sdk-6.0.402-linux-x64.tar.gz
RUN mkdir -p ${DOTNET_ROOT}
ENV DOTNET_ROOT=${DOTNET_ROOT}
ENV PATH=$PATH:${DOTNET_ROOT}

RUN wget https://download.visualstudio.microsoft.com/download/pr/d3e46476-4494-41b7-a628-c517794c5a6a/6066215f6c0a18b070e8e6e8b715de0b/dotnet-sdk-6.0.402-linux-x64.tar.gz


RUN tar vfx "${DOTNET_SDK}" -C "${DOTNET_ROOT}"
RUN rm -Rf "${DOTNET_SDK}"
RUN  yum -y install iputils