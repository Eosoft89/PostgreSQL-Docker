#!/bin/bash
set -e

# Script de inicialización para MainSite Database
# Se ejecuta automáticamente al crear el contenedor por primera vez
# Usa variables de entorno del archivo .env

echo "🚀 Iniciando configuración de MainSiteDB..."

# Leer variables de entorno (vienen del docker-compose.yml)
APP_USER=${APP_DB_USER:-eosoft_mainsite}
APP_PASS=${APP_DB_PASSWORD:-default_password}
DB_NAME=${POSTGRES_DB:-MainSiteDB}

echo "📋 Configurando usuario: $APP_USER para base de datos: $DB_NAME"

# Ejecutar comandos SQL usando las variables de entorno
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DB_NAME" <<-EOSQL
    -- Crear usuario específico para la aplicación
    DO \$\$
    BEGIN
       IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '$APP_USER') THEN
          CREATE USER $APP_USER WITH PASSWORD '$APP_PASS';
          RAISE NOTICE 'Usuario % creado exitosamente', '$APP_USER';
       ELSE
          RAISE NOTICE 'Usuario % ya existe', '$APP_USER';
       END IF;
    END
    \$\$;

    -- Dar todos los privilegios en la base de datos al usuario de aplicación
    GRANT ALL PRIVILEGES ON DATABASE "$DB_NAME" TO $APP_USER;
    
    -- Hacer al usuario propietario de la base de datos
    ALTER DATABASE "$DB_NAME" OWNER TO $APP_USER;
    
    -- Conectar a la base de datos específica para configurar permisos adicionales
    \c "$DB_NAME";
    
    -- Dar permisos sobre el esquema public
    GRANT ALL ON SCHEMA public TO $APP_USER;
    
    -- Dar permisos para crear tablas
    GRANT CREATE ON SCHEMA public TO $APP_USER;
    
    -- Configurar permisos por defecto para futuras tablas y secuencias
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO $APP_USER;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO $APP_USER;
    
    -- Mensaje de confirmación
    SELECT 'MainSiteDB inicializada correctamente con usuario $APP_USER' AS status;
EOSQL

echo "✅ Configuración completada exitosamente"
echo "👤 Usuario de aplicación: $APP_USER"
echo "🗄️  Base de datos: $DB_NAME"
echo "🔗 Connection string: Host=localhost;Database=$DB_NAME;Username=$APP_USER;Password=***"