Docker LAMPP 5.6
================

Dockerized LAMPP stack based on these components:

* Apache2
* PHP 5.6
* PhpMyAdmin 4.8
* MariaDB 10.3
* Redis 3.0.7
* MongoDb 3.4.4
* Beanstalkd 1.10
* RabbitMQ 3.6.10

Table of contents
-----------------
* [Changelog](#changelog)
* [Requirements](#requirements)
* [Building Docker Image](#building-docker-image)
* [Using Docker Compose](#using-docker-compose)
* [Mounting Volume](#mounting-volume)
* [Custom LAMPP Configuration](#custom-lampp-configuration)
* [Expose Port](#expose-port)

Changelog
---------

Open this [CHANGELOG.md](https://github.com/cikupin/docker-lampp/blob/master/CHANGELOG.md) file to see version changelog.

Requirements
------------

Please make sure that you have installed docker engine and docker compose on your local machine. Follow the instructions at these websites according to your host OS:
* https://docs.docker.com/engine/installation/
* https://docs.docker.com/compose/install/

After you installed those components, clone this repository by using the following command:

```
git clone https://github.com/cikupin/docker-lampp.git
```

Building Docker Image
---------------------

To use apache2, PHP 5.6, and PhpMyAdmin 4.4.13.1 you need to build custom images that I have created before. Other stacks such as database & queue services, can be used by using these images:
* MariaDB (https://hub.docker.com/_/mariadb)
* Redis (https://hub.docker.com/_/redis)
* MongoDb (https://hub.docker.com/r/cikupin/mongodb-alpine)
* Beanstalkd (https://hub.docker.com/r/cikupin/beanstalkd)
* RabbitMQ (https://hub.docker.com/_/rabbitmq)

To use apache2, PHP 5.6, and PhpMyAdmin 4.4.13.1, you may choose one of these steps: **build image from Dockerfile** or **pull docker image from docker hub**.

#### 1. Build image from Docker file

Go to **Build/** subdirectory, then build the image by using this command:

```
docker build -t cikupin/php-apache2:5.6 .
```

#### 2. Pull docker image from docker hub

Pull image by simply using this command:

```
docker pull cikupin/php-apache2:5.6
```

Using Docker Compose
--------------------

To use this LAMPP stack, I recommend you to use docker compose to manage and to run multiple docker container. Using docker compose also enable to manage custom configuration for all of your services.

Go to the same directory with docker-compose.yml and run the following command:

```
docker-compose up -d
```

All services that are registered in docker compose file  will be running. To stop and remove all related containers, use this command:

```
docker-compose down
```

Mounting volume
---------------

Data in container will be deleted automatically when you remove container. In order to keep your data from container although you had deleted your container, you need to mount your folder in your container to your local machine. So, I mount directories for PHP project and database directories by using docker volumes.

```yaml
services:
  php-apache2:
    volumes:
      - /var/www/html:/var/www/html
  mariadb-docker:
    volumes:
      - ~/Apps/docker_data/mariadb:/var/lib/mysql
  mongodb-docker:
    volumes:
      - ~/Apps/docker_data/mongodb:/data/db
```

**Format :** (path_in_local):(path_in_container)

When you delete your container, your data still exists in your local machine. You can reuse your data for another container my mounting them. So that you don't need to worry about losing your data.

To know more about docker volumes, please refer to these sites: https://docs.docker.com/compose/compose-file/compose-file-v2/#volumes-volume_driver and https://docs.docker.com/engine/reference/run/#volume-shared-filesystems.

Custom LAMPP Configuration
--------------------------

Docker compose enable you to run the container and use some custom configurations to be used in your docker container. These following scripts are custom configurations that are registered in docker-compose.yml file:

```yaml
services:
  php-apache2:
    volumes:
      - ./etc/apache2/sites-available/000-default.conf:/etc/apache2/sites-available/000-default.conf
      - ./usr/local/etc/php/php.ini:/usr/local/etc/php/php.ini
```

You can edit those file according to your desired configurations, or you may add another files to be configured and mount them to your container.

Expose Port
-----------

Basically any services within the container cannot accessed from local machine by using *localhost* or *127.0.0.1* IP address unless you expose their port. Exposing them enable to access services by using *localhost* as if it runs on your local machine. Otherwise, you must access service by using docker container IP address.

To see container's IP address, use the following command:

```
docker inspect <container_name>
```

or

```
docker network inspect <docker_network_name>
```

To see list of existing docker networks, use this:

```
docker network ls
```

To know more about docker expose and docker network, see references below:
1. Docker expose
  * https://docs.docker.com/compose/compose-file/compose-file-v2/#ports
  * https://docs.docker.com/engine/reference/run/#expose-incoming-ports
2. Docker network
  * https://docs.docker.com/engine/userguide/networking
