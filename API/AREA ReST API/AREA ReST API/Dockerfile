FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["AREA ReST API/AREA ReST API.csproj", "AREA ReST API/"]
RUN dotnet restore "AREA ReST API/AREA ReST API.csproj"
COPY . .
WORKDIR "/src/AREA ReST API"
RUN dotnet build "AREA ReST API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AREA ReST API.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AREA ReST API.dll"]
