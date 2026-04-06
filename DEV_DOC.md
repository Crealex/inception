# DEV_DOC.md — Developer Documentation

## Prerequisites

Before setting up the project, make sure the following are installed on your VM:

- **Docker** (Engine + CLI)
- **Docker Compose** (v2+, bundled with modern Docker)
- **make**
- **git**

To verify:

```bash
docker --version
docker compose version
make --version
```

---

## Project structure overview

```
.
├── Makefile
├── secrets/                    # Sensitive data (NOT tracked by git)
│   └── ...
└── srcs/
    ├── .env                    # Environment variables (NOT tracked by git)
    ├── docker-compose.yml
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/           # nginx.conf
        │   └── tools/          # entrypoint script (TLS cert generation, etc.)
        ├── wordpress/
        │   ├── Dockerfile
        │   └── tools/          # entrypoint script (wp-cli setup, etc.)
        └── mariadb/
            ├── Dockerfile
            └── tools/          # entrypoint script (DB init)
```

---

## Setting up from scratch

### 1. Clone the repository

```bash
git clone <your-repo-url>
cd <project-folder>
```

### 2. Create the `.env` file

The `.env` file is intentionally absent from the repository. You need to create it manually at `srcs/.env`:

```env
DOMAIN_NAME=<login>.42.fr

MYSQL_DATABASE=wordpress
MYSQL_USER=<your_db_user>
MYSQL_PASSWORD=<your_db_password>
MYSQL_ROOT_PASSWORD=<your_root_password>

WP_ADMIN_USER=<your_wp_admin>       # Must NOT contain "admin" or "administrator"
WP_ADMIN_PASSWORD=<your_wp_admin_password>
WP_ADMIN_EMAIL=<your_wp_admin_email>

WP_USER=<a_second_wp_user>
WP_USER_PASSWORD=<second_user_password>
WP_USER_EMAIL=<second_user_email>
```

> **Important:** Never commit this file. Make sure `srcs/.env` is listed in your `.gitignore`.

### 3. Configure your local DNS

The site must be reachable via `<login>.42.fr`. Add this line to `/etc/hosts` on your VM (or on your host machine if you are accessing through VirtualBox port forwarding):

```
127.0.0.1    <login>.42.fr
```

### 4. Create the data directories

The named volumes store their data at specific paths on the host. Create them beforehand:

```bash
mkdir -p /home/<login>/data/db
mkdir -p /home/<login>/data/wordpress
```

---

## Building and launching the project

The Makefile at the root of the repository handles everything:

```bash
make
```

Under the hood, this runs something equivalent to:

```bash
docker compose -f srcs/docker-compose.yml up --build -d
```

Each service has its own `Dockerfile`. Images are built from either Alpine or Debian (penultimate stable version) and **not** pulled from Docker Hub (except the base OS images).

---

## Useful Docker Compose commands

All commands below assume you are at the root of the project. Adjust the `-f` path if needed.

```bash
# Start services (with rebuild)
docker compose -f srcs/docker-compose.yml up --build -d

# Stop services (keeps volumes)
docker compose -f srcs/docker-compose.yml down

# View running containers
docker compose -f srcs/docker-compose.yml ps

# Follow logs for a specific service
docker compose -f srcs/docker-compose.yml logs -f wordpress

# Open a shell inside a running container
docker exec -it <container_name> sh

# List all Docker volumes
docker volume ls

# Inspect a specific volume
docker volume inspect <volume_name>
```

---

## Data persistence

The two named Docker volumes are configured to store their data at specific paths on the host machine:

| Volume name | Host path | Content |
|---|---|---|
| `db` | `/home/<login>/data/db` | MariaDB database files |
| `wordpress` | `/home/<login>/data/wordpress` | WordPress files (core, uploads, plugins, themes) |

These paths survive container restarts and `docker compose down`. Data is only lost if you manually remove the volumes (`docker volume rm`) or run `make fclean`.

Because the WordPress and NGINX containers both need access to the WordPress files, **both mount the same `wordpress` volume**. This is how NGINX can serve static assets directly without going through PHP-FPM.

---

## Network architecture

All three containers communicate through a single user-defined Docker bridge network defined in `docker-compose.yml`. No container exposes its port directly to the host except NGINX on port 443.

| Service | Internal port | Exposed to host |
|---|---|---|
| NGINX | 443 | Yes (443) |
| WordPress/PHP-FPM | 9000 | No |
| MariaDB | 3306 | No |

Using `network: host` or the `--link` flag is **forbidden** by the project rules.

---

## TLS certificate

NGINX uses a self-signed TLS certificate generated at container startup using `openssl`. The certificate is valid for `<login>.42.fr` and enforces TLSv1.2 or TLSv1.3 only.

The generation happens in the NGINX entrypoint script, so it runs automatically when the container starts.

---

## Environment variables and credentials

Credentials are passed to containers via the `.env` file, which Docker Compose loads automatically. Each service picks up the variables it needs through the `environment:` section in `docker-compose.yml`.

> **Security note:** The `.env` file must be listed in `.gitignore`. Any credentials found in the Git repository will result in project failure. The project also recommends using Docker secrets for an extra layer of security — secrets are mounted as files inside the container rather than passed as plain environment variables.

---

## Makefile targets

| Target | Effect |
|---|---|
| `make` | Build images and start all services in detached mode |
| `make down` | Stop and remove containers (volumes preserved) |
| `make clean` | Stop containers and remove built images |
| `make fclean` | Full reset: containers, images, volumes, and host data directories |
| `make re` | `fclean` followed by `make` |
