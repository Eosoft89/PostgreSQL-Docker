-- Script de inicialización para MainSite Database
-- Se ejecuta automáticamente al crear el contenedor por primera vez

-- Crear usuario específico para la aplicación
CREATE USER mainsite_user WITH PASSWORD 'mainsite_default_password';

-- Dar todos los privilegios en MainSiteDB al usuario de aplicación
GRANT ALL PRIVILEGES ON DATABASE "MainSiteDB" TO mainsite_user;

-- Hacer al usuario propietario de la base de datos
ALTER DATABASE "MainSiteDB" OWNER TO mainsite_user;

-- Conectar a MainSiteDB para configurar permisos adicionales
\c "MainSiteDB";

-- Dar permisos sobre el esquema public
GRANT ALL ON SCHEMA public TO mainsite_user;

-- Dar permisos para crear tablas
GRANT CREATE ON SCHEMA public TO mainsite_user;

-- Configurar permisos por defecto para futuras tablas y secuencias
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO mainsite_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO mainsite_user;

-- Mensaje de confirmación
SELECT 'MainSiteDB inicializada correctamente con usuario mainsite_user' AS status;