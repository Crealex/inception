_This project has been created as part of the 42 curriculum by atomasi_

# Inception

Set up a full stack of containers to self-host a WordPress website.

## Description

This project consists of creating and configuring multiple containers for a self-hosted WordPress website.

To achieve this, the following 3 services are required:

1. Nginx (the web server)
2. WordPress (the web site and CGI)
3. Mariadb (The database)

The main goal is to create, configure and manage the stack without using any pre-built official images of these services.

## Instructions

To launch Inception first make sure all dependencies are installed, then clone this repository.
In the main folder you can do: `make` and all is good!
*Note: the `docker compose -f ./srcs/docker-compose.yml up -d --build` cmd is called by the Makefile*

All permanent data are in `/home/<user>/data`

To configure the domain name you can modify /etc/hosts and add the following line: 
`127.0.0.1 your-domain-name.com`
_Note: the 127.0.0.1 address is mandatory_

For more informations go to [USER_DOC.md].
And if you are a developer you can go check the [DEV_DOC.md] for more information.

### Dependencies

- docker
- docker compose
- make
- git

## Project Description
Having never done a project like this before, I decided to start with the official image of each service and progressively replace them with my own custom images. This way, I could learn the basics step by step while keeping the architecture close to the official setup, which made the learning process easier.

Now, let me explain few knowledge you need to know for a better understanding:

### Virtual machines vs Docker

The main difference between VM and Docker is the usage of kernel because a container  uses the host machine's kernel whereas a VM virtualizes its own kernel, which means that a container is lighter than a vm but less secure.
There is less isolation, which also contributes to the fact that it is less secure.

### Secrets vs Environment variables

The Environment variables are usually in a .env file and loaded into the container when it starts up, making these variables accessible to anyone who has access to the container, whereas Secrets in docker are mounted as tmpfs file in the container at `/run/secrects/` making them inaccessible through environment variable inspection.

For this project I choose to use environment variables, because they are simpler to use, configure, debug and explain during peer-evaluation.

### Docker network vs Host network

Docker network is the internal network to communicate between containers, whereas host network is the network of the host machine, this network can communicate with some containers (if their ports are exposed) and with internet

If we use a docker network in Inception is to isolate the container to the host machine. The only entry point is Nginx port 443; all other ports are exposed only within the Docker internal network.

### Docker volumes vs bind mounts

We need to store certain data on the host machine so that it persists even if the container is deleted.
There are two options for doing this.
Bind mounts are simpler, but the path is specific to the host machine, as are the permissions, etc., so they are less portable.
Docker volumes let Docker handle the storage for persistent data, which ensures better portability because the permissions and file management are handled by Docker itself. In this project, we also use driver_opts to specify a custom path (/home/login/data) on the host machine, as required by the subject.

## Resources

- [tuto grademe](https://tuto.grademe.fr/inception/)
- [docs wordpress CLI](https://developer.wordpress.org/cli/commands/)
- [docs docker](https://docs.docker.com/)
- [docs mariadb](https://mariadb.com/docs)
- [docs mysql](https://dev.mysql.com/doc/)
- [docs docker compose](https://docs.docker.com/compose/)

### IA utilisation

I use IA (claude) like a pedagogic assistant or a teacher to explain me some theoretical concept or help me to debug my stack without send me any code or brainless response, because I configure it to have a Socratic approach. I use also IA for helping me to write (fix english, spelling) this reademe (and the others) as my English is not very strong.
