#!/bin/sh
set -e

echo "⏳ Waiting for Pulsar Manager API..."

until curl -sf http://apache-pulsar-manager:7750/pulsar-manager/csrf-token > /dev/null; do
  sleep 2
done

echo "✅ Pulsar Manager API is up"

CSRF_TOKEN=$(curl -s http://apache-pulsar-manager:7750/pulsar-manager/csrf-token | sed 's/"//g')

echo "🔐 Creating admin user (idempotent)"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
  -H "X-XSRF-TOKEN: $CSRF_TOKEN" \
  -H "Cookie: XSRF-TOKEN=$CSRF_TOKEN;" \
  -H "Content-Type: application/json" \
  -X PUT http://apache-pulsar-manager:7750/pulsar-manager/users/superuser \
  -d '{
    "name":"admin",
    "password":"admin123",
    "description":"Administrator",
    "email":"admin@yopmail.com"
  }')

if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "409" ]; then
  echo "✅ Admin user ready (code=$HTTP_CODE)"
else
  echo "❌ Failed to create admin user (code=$HTTP_CODE)"
  exit 1
fi
