# Usage
# docker buildx build -f Dockerfile --platform linux/amd64 --build-arg="TARGETARCH=x64" -t dotnet/GetAssemblyInfo-x64:latest .
# docker buildx build -f Dockerfile --platform linux/arm64 --build-arg="TARGETARCH=arm64" -t dotnet/GetAssemblyInfo-arm64:latest .

# To learn about building .NET container images:
# https://github.com/dotnet/dotnet-docker/blob/main/samples/README.md
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG TARGETARCH
WORKDIR /source

RUN apt -y update && \
  apt-get -y install build-essential clang && \
  apt-get install -y libc6 libgcc1 libgcc-s1 libgssapi-krb5-2 liblttng-ust1 libssl3 libstdc++6 libunwind8 zlib1g zlib1g-dev

# copy csproj and restore as distinct layers
COPY GetAssemblyInfo/*.csproj .
RUN dotnet restore --arch $TARGETARCH

# copy and publish app and libraries
COPY GetAssemblyInfo/* .
RUN dotnet publish --no-restore --self-contained  -c Release -o /app --arch $TARGETARCH
