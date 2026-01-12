# Design-Terraform-to-deploy-a-private-EC2-instance-using-differences-tfvars-onaws

### 1. Development Environment (dev)

- Purpose: A playground for developers to write, test, and experiment with code without affecting real users or live data.

### 2. Production Environment (prod)

- Purpose: The live, stable environment where real users interact with your application. 

**1. Here, I created 2 public and 2 private subnet groups. ALB should will work on atleast 2 or 3 subnets.**

**2. I used Application Load Balancer it's listening on 80 and the target group will forward the traffic to ec2 machine on 1337.**

**3. My EC2 instance is running on private subnet so, the public subnet should not be enabled and we cann't access it.**

**4. So, Here I attached a NAT gatway to give the network from public subnet to private subnet.**

**5. Installed 4GB swap memory to resuce the ram usage**

      # Install 4GB swap file
      sudo fallocate -l 4G /swapfile
      sudo chmod 600 /swapfile
      sudo mkswap /swapfile
      sudo swapon /swapfile
      # Make swap permanent
      echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

**6. I attached a userdata while EC2 machine launch the container. It will auto install the docker and launch the containers attched with postgres database.
These both containers are running on same network**

      sudo docker run -d \
      --name strapi-postgres \
      --network group-net \
      -e POSTGRES_USER=strapi \
      -e POSTGRES_PASSWORD=strapi123 \
      -e POSTGRES_DB=strapi_db \
      -v strapi-pgdata:/var/lib/postgresql/data \
      postgres:15
  
    sudo docker run -d \
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

**7. Finally, I accessed though ALB DNS link**

  

