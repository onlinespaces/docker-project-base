#Docker Project Base
##Description
PHP-FPM, MySQL, Redis, Nignx, Elasticsearch, Logstash, Kibana and phpMyAdmin Docker Containers to start a project.

Currently, this project is geared towards symfony but can easily be modified for other PHP type projects i.e. Drupal, Laravel, etc...

This is my first attempt at Docker. So, any advice and/or suggestions are welcome.
##Goal
To have a development environment so that only git and docker are required to be installed on the host computer. This is a development environment only.

###MySQL
- MySQL 5.7

###PHP-FPM
- PHP7.0
- SSH
- MemCache
- xDebug
- Supervisord
- OpCache
- Nodejs
- Composer
- Yarn
- Grunt
- Gulp
- Symfony
- Git

###MySQL
This is the official MySQL 5.7 release.

Source:  https://hub.docker.com/_/mysql/

###NGINX
The NGINX 1.10.2 release

Source:  https://hub.docker.com/_/nginx/

###REDIS
The official Redis Docker image.

Source:  https://hub.docker.com/_/redis/

###ELK
An ELK stack Docker image.

Source:  https://hub.docker.com/r/willdurand/elk/

###phpMyAdmin
The official phpMyAdmin Docker image.

Source:  https://hub.docker.com/r/phpmyadmin/phpmyadmin/

##Installation
1. Clone the project into a directory
```
    git clone https://github.com/onlinespaces/docker-project-base.git
```
2. Rename .env.dev to .env and change any settings needed.

###Settings
```bash
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

CHAR_SET_SERVER=utf8mb4
COLLATION_SERVER=utf8mb4_unicode_ci
DEFAULT_CHAR_SET=utf8mb4

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
3. Build/run containers
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

4. Update your system's host file

   **Example:** The following is based on default settings. Add the following to your hosts file.
   ```
   127.0.0.1     project.local
   ::1           project.local
   127.0.0.1     phpmyadmin.local
   ::1           phpmyadmin.local
   127.0.0.1     elk.local
   ::1           elk.local
   ```
   ```bash
   # Windows
   C:\Windows\System32\drivers\etc\hosts
   ```
   ```bash
   # Unix/Mac
   /etc/hosts
   ```
5. Add code into your WEBSITE_DIR

##Usage
_The following assumes default settings:_

Run ```docker-composer up -d```, then:
- **Website:**  Visit ```project.local``` in your web browser
- **PhpMyAdmin:** Visit ```phpmyadmin.local``` in your web browser
   - Use username:  _```root```_ with password:  _```root```_
- **Kibana**:  ```project.local:81```
- **Log Locations:** ```logs/nginx``` and ```logs/symfony```

##Note about SSH
SSH is installed due to the fact that Docker for Windows does not support interactive commands. 

There are work around for this. But, I prefer to just SSH into the container.  It you are developing on a Mac, then, you do not need to install openssh and can comment out or remove those lines.

##More Info
After everything is built and running, you should see something like this if you run ```docker-compose ps``` from the command line:

```bash
             Name                            Command               State                                  Ports                                 
-----------------------------------------------------------------------------------------------------------------------------------------------
dockerprojectbase_db_1            docker-entrypoint.sh mysqld      Up      0.0.0.0:3306->3306/tcp                                               
dockerprojectbase_elk_1           /usr/bin/supervisord -n -c ...   Up      80/tcp                                                               
dockerprojectbase_nginx-proxy_1   /app/docker-entrypoint.sh  ...   Up      0.0.0.0:443->443/tcp, 0.0.0.0:80->80/tcp                             
dockerprojectbase_nginx_1         nginx -g daemon off;             Up      443/tcp, 80/tcp                                                      
dockerprojectbase_php-fpm_1       /usr/bin/supervisord             Up      0.0.0.0:2222->22/tcp, 0.0.0.0:9000->9000/tcp, 0.0.0.0:9001->9001/tcp 
dockerprojectbase_phpmyadmin_1    /run.sh phpmyadmin               Up      80/tcp                                                               
dockerprojectbase_redis_1         docker-entrypoint.sh redis ...   Up      0.0.0.0:6379->6379/tcp                                               
```
####Containers
- ```db```: MySQL database
- ```php-fpm```: PHP-FPM. This is where the application code volume is mounted. And, if you use SSH, this is the container you will contect to.
- ```nginx```:  The Nginx webserver. Also mounted to application code.
- ```phpmyadmin```: PHPMyAdmin to view database data and information.
- ```elk```:  ELK stack which uses Logstash to collect logs, sends then to Elasticsearch and visualize them with Kibana.
- ```redis```:  Redis database.
- ```nginx-proxy```:  A reverse proxy so that more than one nginx container can use the same ```HTTP_PORT```

##Useful Commands
```bash
# Go into the bash shell on the php-fpm container. (Only on Linux and Mac)
docker-compose exec php-fpm bash
```
```bash
# Stop all containers
docker stop $(docker ps -a -q)
```
```bash
# Start all stopped containers
docker-compose up -d
```
```bash
# Delete all containers
docker rm $(docker images -a -q)
```
```bash
# Delete all images
docker rmi $(docker images -a -q)
```

##Issues 
https://github.com/onlinespaces/docker-project-base/issues


