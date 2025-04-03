FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["MiWebApp.csproj", "./"]
RUN dotnet restore "./MiWebApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "MiWebApp.csproj" -c Release -o /app/build

# Instalar las herramientas de EF Core
RUN dotnet tool install --global dotnet-ef
ENV PATH="$PATH:/root/.dotnet/tools"

# Ejecuta las migraciones
RUN echo "Connection string: $CONNECTION_STRING"
RUN dotnet ef database update --connection "Server=149.50.149.217,1433;Database=MiWebApp;User Id=sa;Password=Password"

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/build .
ENTRYPOINT ["dotnet", "MiWebApp.dll"]