#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM openeuler/openeuler:22.09
# 由于海外访问国内服务不稳定修改更新服务地址
RUN  sed -i "s|http://repo.openeuler.org/|https://fr-repo.openeuler.org/|g" /etc/yum.repos.d/openEuler.repo
WORKDIR /tmp
RUN yum -y install tar nodejs libicu wget
ARG DOTNET_ROOT=/usr/local/dotnet
ARG DOTNET_RUNTIME=aspnetcore-runtime-7.0.0-rc.2.22476.2-linux-x64.tar.gz
RUN mkdir -p ${DOTNET_ROOT}
ENV DOTNET_ROOT=${DOTNET_ROOT}
ENV PATH=$PATH:${DOTNET_ROOT}

RUN wget https://download.visualstudio.microsoft.com/download/pr/eda5c509-4e42-48b7-95dc-0584b0645d20/2e6219b8fc0873628b9cd8fe9c726b0c/aspnetcore-runtime-7.0.0-rc.2.22476.2-linux-x64.tar.gz

RUN tar vfx "${DOTNET_RUNTIME}" -C "${DOTNET_ROOT}"
RUN rm -Rf ${DOTNET_RUNTIME}
RUN  yum -y install iputils