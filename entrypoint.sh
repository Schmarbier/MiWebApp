#!/bin/sh
set -e

echo "Esperando a que la base de datos est� disponible..."
sleep 5  # Espera unos segundos por si la base de datos a�n no est� lista

echo "Aplicando migraciones de Entity Framework..."
dotnet ef database update

echo "Iniciando la aplicaci�n..."
exec dotnet MiWebApp.dll