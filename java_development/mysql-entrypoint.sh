#!/bin/bash
set -e

echo ">>> Iniciando MySQL para validación de schemas..."

# Iniciar mysqld temporalmente sin acceso externo
docker-entrypoint.sh mysqld --skip-networking --socket=/tmp/mysql.sock &
pid="$!"

# Esperar a que MySQL esté listo
for i in {30..0}; do
    if mysqladmin --socket=/tmp/mysql.sock ping &>/dev/null; then
        break
    fi
    echo "Esperando a que MySQL inicie..."
    sleep 1
done

if [ "$i" = 0 ]; then
    echo "Error: MySQL no pudo iniciar."
    exit 1
fi

# Ejecutar SQL de inicialización
if [ -f /docker-entrypoint-initdb.d/init-multiple-schemas.sql ]; then
    echo ">>> Ejecutando init-multiple-schemas.sql"
    mysql -uroot -p"$MYSQL_ROOT_PASSWORD" --socket=/tmp/mysql.sock < /docker-entrypoint-initdb.d/init-multiple-schemas.sql
fi

# Detener mysqld temporal
kill -s TERM "$pid"
wait "$pid"

echo ">>> Arrancando MySQL en modo normal..."
exec docker-entrypoint.sh mysqld \
    --default-authentication-plugin=mysql_native_password \
    --character-set-server=utf8mb4 \
    --collation-server=utf8mb4_unicode_ci
