#Docker Project Base
PHP-FPM, MySQL, Redis, Nignx, Elasticsearch, Logstash, Kibana and phpMyAdmin Docker Containers to start a project.

Currently, this project is geared towards symfony but can easily be modified for other PHP type projects i.e. Drupal, Laravel, etc...

This is my first attempt at Docker. So, any advice and/or suggestions are welcome.
##Goal
To have a development environment so that only git and docker are required to be installed on the host computer.
##Description
###MySQL
- MySQL 5.7

###PHP-FPM
- PHP7.0
- SSH
- MemCache
- xDebug
- Superisord
- OpCache
- Nodejs
- Composer
- Yarn
- Grunt
- Gulp
- Symfony
- Git

**Note:** SSH is installed due to the fact that Docker for Windows does not support interactive commands. There are work around for this. But, I prefer to just SSH into the container.  It you are developing on a Mac, then, you do not need to install openssh and can comment out or remove those lines.

###NGINX

###REDIS
The official Redis Docker image.

Source:  https://hub.docker.com/_/redis/

###ELK
An ELK stack Docker image.

Source:  https://hub.docker.com/r/willdurand/elk/

###phpMyAdmin
The official phpMyAdmin Docker image.

Source:  https://hub.docker.com/r/phpmyadmin/phpmyadmin/

##Instructions
1. Clone the project into a directory
```
    git clone https://github.com/onlinespaces/docker-project-base.git
```
2. Rename .env.dev to .env and change any settings needed.

###Settings
```
# The type of application. Currently, this is not used.
APPLICATION_TYPE=symfony

# Project Information
# This will be the directory that the code is stored in.
# If you change this value, you also need to change the location in the logstash.conf file
PROJECT_NAME=project

# Domains
DOMAIN_NAME=project.local
PHPMYADMIN_DOMAIN_NAME=phpmyadmin.local
ELK_DOMAIN_NAME=elk.local

# The name of the directory where web files are stored.
# Symfony usually is 'web' and Drupal is 'public'
WEBSITE_DIR=web
HTTP_PORT=80
HTTPS_PORT=443

# MYSQL Settings
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=symfony
MYSQL_USER=docker
MYSQL_PASSWORD=docker
MYSQL_PORT=3306

# XDEBUG Settings
XDEBUG_IDE_KEY=PHPSTORM
XDEBUG_REMOTE_PORT=9000

# PHP-FPM. This should be different from xdebug
PHP_FPM_PORT=9001

# Timezone
TIME_ZONE=/usr/share/zoneinfo/US/Central

# SSH Port
SSH_PUBLIC_PORT=2222

# Git Info
USER_EMAIL=your.email@email.com
USER_NAME=Your Name
```

##Starting
In the root directory, build the containers:
```
docker-compose build
```
Then start the containers:
```
docker-compose up -d
```
You can combine these commands into a single command:
```
docker-compose up --build -d
```
**Make sure to include the *-d* flag.**


more coming soon ... I hope =)

##Issues 
https://github.com/onlinespaces/docker-project-base/issues


