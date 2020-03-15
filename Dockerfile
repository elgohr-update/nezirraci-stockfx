#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["ElcomManage.csproj", "./"]
RUN dotnet restore "ElcomManage.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "ElcomManage.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ElcomManage.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ElcomManage.dll"]
