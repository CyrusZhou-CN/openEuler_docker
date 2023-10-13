#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM lsqtzj/openeuler:23.09
WORKDIR /tmp
RUN yum -y install tar nodejs libicu wget
ARG DOTNET_ROOT=/usr/local/dotnet
ARG DOTNET_RUNTIME=aspnetcore-runtime-7.0.12-linux-x64.tar.gz
RUN mkdir -p ${DOTNET_ROOT}
ENV DOTNET_ROOT=${DOTNET_ROOT}
ENV PATH=$PATH:${DOTNET_ROOT}

RUN wget https://download.visualstudio.microsoft.com/download/pr/65f1f116-4a94-42fc-b3da-5f9441a6d6e0/a55cd567c5433ce7f2c0dd956cb0cfe7/aspnetcore-runtime-7.0.12-linux-x64.tar.gz

RUN tar vfx "${DOTNET_RUNTIME}" -C "${DOTNET_ROOT}"
RUN rm -Rf ${DOTNET_RUNTIME}
RUN  yum -y install iputils