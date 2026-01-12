#!/bin/bash

# Add Docker's official GPG key:
sudo apt update -y
sudo apt install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update -y

apt update -y
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
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
  -e APP_KEYS=myAppKey \
  -e API_TOKEN_SALT=mySalt \
  -e ADMIN_JWT_SECRET=myAdminJWT \
  -e JWT_SECRET=myJWT \
  kabilan2003/strapicustom:7.3
