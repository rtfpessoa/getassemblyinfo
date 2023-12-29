# Usage
# docker buildx build -f Dockerfile --platform linux/amd64 --build-arg="TARGETARCH=x64" -t dotnetnonroot.azurecr.io/dotnetapp-x64 .
# docker buildx build -f Dockerfile --platform linux/arm64 --build-arg="TARGETARCH=arm64" -t dotnetnonroot.azurecr.io/dotnetapp-arm64 .

# To learn about building .NET container images:
# https://github.com/dotnet/dotnet-docker/blob/main/samples/README.md
# FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
FROM mcr.microsoft.com/dotnet/nightly/sdk:9.0-preview AS build
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

# To enable globalization:
# https://github.com/dotnet/dotnet-docker/blob/main/samples/enable-globalization.md
# final stage/image
FROM mcr.microsoft.com/dotnet/runtime:8.0-jammy
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["./GetAssemblyInfo"]
