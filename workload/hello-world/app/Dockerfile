FROM mcr.microsoft.com/dotnet/sdk:9.0-alpine3.20 AS build-env
WORKDIR /App

RUN apk update && apk upgrade
RUN apk add --no-cache clang build-base zlib-dev

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM alpine:3.20

WORKDIR /App
COPY --from=build-env /App/out .
ENTRYPOINT ["./hello-world"]