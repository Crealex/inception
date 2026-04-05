_This project has been created as part of the 42 curriculum by atomasi_

# Inception

Create a full home stack of container for self-host a wordpress website.

## Description

This project consist to create and configure multiple containers for a sleft-hosted wordpress website

For do this, we need to this 3 services:

1. Nginx (the web server)
2. Wodpress (the web site)
3. Mariadb (The database)

The main goals is to create, configure and manage the stack (without using any official image of these services).

## Instructions

To launch inception first you need to have all depencencies and git clone this repository
In the main folder you can do: `make` and `docker compose -f ./srcs/docker-compose.yml up -d --build`

All permanent data are in `/home/<user>/data`

To change the domain name you can modifiy /etc/hosts and add a line like this: `your-domain.com 127.0.0.1`
_Note: the 127.0.0.1 address is mandatory_

### Dependencies

- docker
- docker compose
- make
- git

## Project Description

I never do a project like this before, so I decide to start with the offical image of each services and replace progressivly with my own images, like this I learn the basics step by step i keep the architecture of my stack like the official stack because more easy for me.

Now, let me explain few knowdlege you need to know for a better understanding:

### Virtual machines vs Docker

The main difference between VM and Docker is the kernel

### Secrets vs Environnement variables

### Docker network vs Host network

### Docker volumes vs bind mounts

## Resources

- [https://tuto.grademe.fr/inception/]
- [https://developer.wordpress.org/cli/commands/]
- [https://docs.docker.com/]
- [https://mariadb.com/docs]
- [https://dev.mysql.com/doc/]
- [https://docs.docker.com/compose/]
