#!/bin/bash

#sudo service springboot start

sudo service nginx restart

sudo systemctl enable springboot.service
