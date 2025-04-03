FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["MiWebApp.csproj", "./"]
RUN dotnet restore
COPY . .
WORKDIR "/src/MiWebApp"
RUN dotnet build -c Release -o /app/build

# Instala las herramientas de EF Core
RUN dotnet tool install --global dotnet-ef
ENV PATH="$PATH:/root/.dotnet/tools"

# Ejecuta las migraciones
RUN dotnet ef database update --connection "$CONNECTION_STRING"

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/build .
ENTRYPOINT ["dotnet", "MiWebApp.dll"]