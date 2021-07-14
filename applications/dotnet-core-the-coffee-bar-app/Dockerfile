FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine AS build-env
WORKDIR /app

COPY dotnet-core-calculator-svc ./
RUN dotnet restore

COPY dotnet-core-calculator-svc ./
RUN dotnet publish -c Release -o out


FROM mcr.microsoft.com/dotnet/aspnet:5.0-alpine as base
WORKDIR /app
COPY --from=build-env /app/out .
