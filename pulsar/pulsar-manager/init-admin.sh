#!/bin/sh
set -e

PM_API="http://apache-pulsar-manager:7750"

echo "⏳ Waiting for Pulsar Manager API..."

until curl -sf "$PM_API/pulsar-manager/csrf-token" > /dev/null; do
  sleep 2
done

echo "✅ Pulsar Manager API is up"

# ------------------------------------------------
# 1️⃣ Get CSRF token (anonymous)
# ------------------------------------------------
CSRF_TOKEN=$(curl -s "$PM_API/pulsar-manager/csrf-token" | sed 's/"//g')

echo "🔐 Creating admin user (if not exists)"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
  -H "X-XSRF-TOKEN: $CSRF_TOKEN" \
  -H "Cookie: XSRF-TOKEN=$CSRF_TOKEN;" \
  -H "Content-Type: application/json" \
  -X PUT "$PM_API/pulsar-manager/users/superuser" \
  -d '{
    "name":"admin",
    "password":"admin123",
    "description":"Administrator",
    "email":"admin@yopmail.com"
  }')

if [ "$HTTP_CODE" = "200" ]; then
  echo "✅ Admin user CREATED (admin / admin123)"
elif [ "$HTTP_CODE" = "409" ]; then
  echo "⚠️ Admin user already exists — nothing to do"
else
  echo "❌ Failed to create admin user (code=$HTTP_CODE)"
  exit 1
fi

echo "🎉 Pulsar Manager admin initialization finished"