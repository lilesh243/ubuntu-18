#!/bin/bash
sudo apt-get update
sudo apt-get install -y software-properties-common debconf-utils
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
sudo echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer
sudo apt-get install nginx -y

#nginx conf virtualhost
_
sudo ln -s /etc/nginx/sites-available/tech.conf /etc/nginx/sites-enabled/tech.conf 




sudo service springboot stop

# create springboot service
#cat > /etc/init/springboot.conf <<'EOF'

#description "springboot Server"

 # start on runlevel [2345]
  #stop on runlevel [!2345]
  #respawn
  #respawn limit 10 5

  # run as non privileged user 
  # add user with this command:
  ## adduser --system --ingroup www-data --home /opt/apache-tomcat apache-tomcat
  # Ubuntu 12.04: (use 'exec sudo -u apache-tomcat' when using 10.04)
  #setuid ubuntu
  #setgid ubuntu

  # adapt paths:
  
  #exec java -jar /home/ubuntu/deploy/spring-boot-web-0.0.1-SNAPSHOT.jar  

  # cleanup temp directory after stop
 # post-stop script
 # end script
#EOF

cat > /etc/systemd/system/springboot.service <<'EOF'
[Unit]
Description=springboot App
After=network.target
[Service]
User=nobody
WorkingDirectory=/home/ubuntu/deploy
ExecStart=/usr/bin/java -jar /home/ubuntu/deploy/spring-boot-web-0.0.1-SNAPSHOT.jar 
Restart=always
RestartSec=500ms
StartLimitInterval=0
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable springboot.service



sudo systemctl  reload-configuration


# remove old directory
rm -rf /home/ubuntu/deploy

# create directory deploy
mkdir -p /home/ubuntu/deploy 


