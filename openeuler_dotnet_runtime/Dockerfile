#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM openeuler/openeuler:22.09
# 由于海外访问国内服务不稳定修改更新服务地址
RUN  sed -i "s|http://repo.openeuler.org/|https://fr-repo.openeuler.org/|g" /etc/yum.repos.d/openEuler.repo
WORKDIR /tmp
RUN yum -y install tar nodejs libicu wget
ARG DOTNET_ROOT=/usr/local/dotnet
ARG DOTNET_RUNTIME=aspnetcore-runtime-6.0.10-linux-x64.tar.gz
RUN mkdir -p ${DOTNET_ROOT}
ENV DOTNET_ROOT=${DOTNET_ROOT}
ENV PATH=$PATH:${DOTNET_ROOT}

RUN wget https://download.visualstudio.microsoft.com/download/pr/7d44ddeb-ad35-41a8-a581-03b151afbd80/6888586c28836b1e1f71df879184550b/aspnetcore-runtime-6.0.10-linux-x64.tar.gz

RUN tar vfx "${DOTNET_RUNTIME}" -C "${DOTNET_ROOT}"
RUN rm -Rf ${DOTNET_RUNTIME}
RUN  yum -y install iputils