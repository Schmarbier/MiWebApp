FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["MiWebApp.csproj", "./"]
RUN dotnet restore "./MiWebApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "MiWebApp.csproj" -c Release -o /app/build

# Instalar las herramientas de EF Core
RUN dotnet tool install --global dotnet-ef

# Agregar la ruta de las herramientas al PATH
ENV PATH="$PATH:/root/.dotnet/tools"

# Ejecutar las migraciones durante el build
RUN echo "Cadena de conexión: $CONN_STR"
RUN dotnet ef database update --connection "$CONN_STR"

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/build .

# El entrypoint ya no es necesario
ENTRYPOINT ["dotnet", "MiWebApp.dll"]