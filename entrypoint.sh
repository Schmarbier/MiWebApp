#!/bin/sh
set -e

echo "Esperando a que la base de datos est� disponible..."
sleep 5  # Da tiempo al contenedor de SQL Server para arrancar

if [ -z "$ConnectionStrings__MiWebAppContext" ]; then
  echo "ERROR: No se ha definido la variable de entorno ConnectionStrings__MiWebAppContext"
  exit 1
fi

echo "Usando la cadena de conexi�n: $ConnectionStrings__MiWebAppContext"

echo "Aplicando migraciones de Entity Framework..."
dotnet ef database update --connection "$ConnectionStrings__MiWebAppContext"

echo "Iniciando la aplicaci�n..."
exec dotnet MiWebApp.dll
