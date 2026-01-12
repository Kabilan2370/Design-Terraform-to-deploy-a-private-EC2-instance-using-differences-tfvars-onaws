#!/bin/bash

# Install 4GB swap file
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
# Make swap permanent
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Add Docker's official GPG key:
apt update -y
apt install ca-certificates curl -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" \
  > /etc/apt/sources.list.d/docker.list

apt update -y

apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl enable docker
systemctl start docker

docker network create group-net
docker run -d \
  --name strapi-postgres \
  --network group-net \
  -e POSTGRES_USER=strapi \
  -e POSTGRES_PASSWORD=strapi123 \
  -e POSTGRES_DB=strapi_db \
  -v strapi-pgdata:/var/lib/postgresql/data \
  postgres:15

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
