FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
ENV ASPNETCORE_URLS=http://+:8080
COPY ["AREA_ReST_API/AREA_ReST_API.csproj", "AREA_ReST_API/"]
RUN dotnet restore "AREA_ReST_API/AREA_ReST_API.csproj"
COPY . .
WORKDIR "/src/AREA_ReST_API"
RUN dotnet build "AREA_ReST_API.csproj" -c Release -o /app/build

FROM build AS publish
ENV ASPNETCORE_URLS=http://+:8080
RUN dotnet publish "AREA_ReST_API.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "AREA_ReST_API.dll"]
