#!/bin/sh
set -e

echo "Esperando a que la base de datos esté disponible..."
sleep 5  # Espera unos segundos por si la base de datos aún no está lista

echo "Aplicando migraciones de Entity Framework..."
dotnet ef database update

echo "Iniciando la aplicación..."
exec dotnet MiWebApp.dll