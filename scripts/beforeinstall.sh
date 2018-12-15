#!/bin/bash
sudo apt-get update
sudo apt-get install -y software-properties-common debconf-utils
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
sudo echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer
sudo apt-get install nginx -y

#nginx conf virtualhost

cat > /etc/nginx/sites-available/tech.conf <<'EOF'

server {
    listen 80;
    server_name tech.ooakhotels.com;
     if ($http_x_forwarded_proto != 'https') {
       return 301 https://$host$request_uri;
   }
    location / {
        proxy_pass http://127.0.0.1:8090;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/tech.conf /etc/nginx/sites-enabled/tech.conf 




sudo service springboot stop

# create springboot service
cat > /etc/init/springboot.conf <<'EOF'

description "springboot Server"

  start on runlevel [2345]
  stop on runlevel [!2345]
  respawn
  respawn limit 10 5

  # run as non privileged user 
  # add user with this command:
  ## adduser --system --ingroup www-data --home /opt/apache-tomcat apache-tomcat
  # Ubuntu 12.04: (use 'exec sudo -u apache-tomcat' when using 10.04)
  setuid ubuntu
  setgid ubuntu

  # adapt paths:
  
  exec java -jar /home/ubuntu/deploy/spring-boot-web-0.0.1-SNAPSHOT.jar  

  # cleanup temp directory after stop
  post-stop script
  end script
EOF

sudo systemctl  reload-configuration


# remove old directory
rm -rf /home/ubuntu/deploy

# create directory deploy
mkdir -p /home/ubuntu/deploy 


