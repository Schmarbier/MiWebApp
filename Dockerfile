FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["MiWebApp.csproj", "./"]
RUN dotnet restore "./MiWebApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "MiWebApp.csproj" -c Release -o /app/build

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/build .

# Copiar el bundle de migraciones y darle permisos de ejecución
COPY migrations-bundle /app/migrations-bundle
RUN chmod +x /app/migrations-bundle

# Ejecutar migraciones antes de iniciar la aplicación
CMD ["/bin/sh", "-c", "./migrations-bundle && dotnet MiWebApp.dll"]