#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["Services/IdentityApi/IdentityApi.csproj", "Services/IdentityApi/"]
RUN dotnet restore "Services/IdentityApi/IdentityApi.csproj"
COPY . .
WORKDIR "/src/Services/IdentityApi"
RUN dotnet build "IdentityApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "IdentityApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
RUN mkdir /app/pics
RUN mkdir /src1
COPY Services/CatalogApi/pics /src1
RUN cd /src1 && cp -R . /app/pics
ENTRYPOINT ["dotnet", "IdentityApi.dll"]