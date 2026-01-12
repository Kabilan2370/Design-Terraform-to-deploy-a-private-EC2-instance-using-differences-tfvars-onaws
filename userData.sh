#!/bin/bash -xe

# Create 4GB swap
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab

# Install Docker
apt update -y
apt install -y ca-certificates curl gnupg lsb-release

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
> /etc/apt/sources.list.d/docker.list

apt update -y
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable docker
systemctl start docker

# Wait until Docker is ready
until docker info >/dev/null 2>&1; do
  sleep 3
done

# Create Docker network
docker network create group-net || true

# Run Postgres container
docker run -d \
  --name strapi-postgres \
  --network group-net \
  -e POSTGRES_USER=strapi \
  -e POSTGRES_PASSWORD=strapi123 \
  -e POSTGRES_DB=strapi_db \
  -v strapi-pgdata:/var/lib/postgresql/data \
  postgres:15

# Run Strapi container
docker run -d \
  --name strapi \
  --network group-net \
  -p 1337:1337 \
  -e DATABASE_CLIENT=postgres \
  -e DATABASE_HOST=strapi-postgres \
  -e DATABASE_PORT=5432 \
  -e DATABASE_NAME=strapi_db \
  -e DATABASE_USERNAME=strapi \
  -e DATABASE_PASSWORD=strapi123 \
  -e APP_KEYS=myAppKey,key2,key3,key4 \
  -e API_TOKEN_SALT=mySalt \
  -e ADMIN_JWT_SECRET=myAdminJWT \
  -e JWT_SECRET=myJWT \
  kabilan2003/strapicustom:7.3
