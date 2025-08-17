# PostgreSQL Database Setup

Configuración de PostgreSQL con pgAdmin para proyectos usando Docker.

## 🚀 Configuración inicial en el servidor

### 1. Clonar repositorio
```bash
cd /root
git clone <tu-repositorio-url> database
cd database
```

### 2. Configurar variables de entorno
```bash
# Copiar el archivo de ejemplo
cp .env.example .env

# Editar con valores reales
nano .env
```

### 3. Configurar permisos
```bash
# Crear directorios de volúmenes
mkdir -p volumes/postgres_data
mkdir -p volumes/pgadmin_data

# Establecer permisos correctos
sudo chown -R 999:999 volumes/postgres_data
sudo chown -R 5050:5050 volumes/pgadmin_data
sudo chmod -R 755 volumes/

# Dar permisos de ejecución al script de inicialización
chmod +x postgres-init/01-init-mainsite.sh
```

### 4. Iniciar servicios
```bash
docker-compose up -d
```

### 5. Verificar servicios
```bash
# Ver estado de contenedores
docker-compose ps

# Ver logs
docker-compose logs -f
```

## 🔑 Acceso a los servicios

- **PostgreSQL**: `localhost:5432`
  - Base de datos: `DatabaseName`
  - Usuario admin: `Username`
  - Usuario aplicación: `AppUserName`

- **pgAdmin**: `http://servidor-ip:5050`
  - Email: configurado en `.env`
  - Password: configurado en `.env`

## 🔌 Connection String para .NET

```csharp
// Para uso en aplicación .NET (usar las variables de .env)
"Host=localhost;Database=DatabaseName;Username=UserName;Password=UserPassword"
```

## 📋 Comandos útiles

```bash
# Parar servicios
docker-compose down

# Reiniciar servicios
docker-compose restart

# Ver logs de un servicio específico
docker-compose logs postgres

# Backup de base de datos
docker exec postgres_main pg_dump -U eosoft_mainsite MainSiteDB > backups/backup_$(date +%Y%m%d).sql

# Restaurar backup
docker exec -i postgres_main psql -U eosoft_mainsite MainSiteDB < backups/backup_20240101.sql

# Conectar directamente a PostgreSQL
docker exec -it postgres_main psql -U eosoft_mainsite -d MainSiteDB
```

## 📁 Estructura del proyecto

```
database/
├── docker-compose.yml      # Configuración de servicios
├── .env                   # Variables de entorno (NO en Git)
├── .env.example          # Plantilla de variables
├── postgres-init/        # Scripts de inicialización
│   └── 01-init-mainsite.sh
├── volumes/              # Datos persistentes (NO en Git)
│   ├── postgres_data/
│   └── pgadmin_data/
└── backups/              # Backups de BD
```

## ⚠️ Notas importantes

1. **Los volúmenes no se suben a Git** - son datos locales
2. **Cambiar todos los passwords por defecto**
3. **El script de inicialización solo se ejecuta la primera vez**

## 🛠️ Troubleshooting

### Error de permisos
```bash
sudo chown -R 999:999 volumes/postgres_data
sudo chown -R 5050:5050 volumes/pgadmin_data
```

### Recrear base de datos
```bash
docker-compose down
sudo rm -rf volumes/postgres_data/*
docker-compose up -d
```