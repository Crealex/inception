# USER_DOC.md — User Documentation

## What is this project?

This stack deploys a small but complete web infrastructure made of three services running in Docker containers:

- **NGINX** — the only public entry point, accessible via HTTPS on port 443. It handles TLS encryption and forwards PHP requests to WordPress.
- **WordPress + PHP-FPM** — the content management system (CMS). It processes dynamic pages and communicates with the database.
- **MariaDB** — the relational database that stores all WordPress content (posts, users, settings, etc.).

The three containers communicate through a private Docker network. From the outside, only port 443 is reachable.

---

## Starting and stopping the project

From the root of the repository:

```bash
# Build images and start all services
make

# Stop all services (containers are removed, volumes are kept)
make down

# Stop and remove everything including volumes (data will be lost)
make fclean
```

> **Warning:** `make fclean` will delete the persistent data stored in `/home/<login>/data`. Use it only if you want a completely clean reset.

---

## Accessing the website

Once the stack is running, open your browser and navigate to:

```
https://<login>.42.fr
```

Since the TLS certificate is self-signed, your browser will warn you. This is expected — proceed to the site anyway.

To access the WordPress administration panel:

```
https://<login>.42.fr/wp-admin
```

Log in with the administrator credentials (see the section below).

---

## Credentials

Credentials are stored in the `.env` file located at `srcs/.env`. This file is **not tracked by Git** for security reasons.

Here is what you will find there:

| Variable | Description |
|---|---|
| `MYSQL_USER` | WordPress database user |
| `MYSQL_PASSWORD` | Password for the database user |
| `MYSQL_ROOT_PASSWORD` | MariaDB root password |
| `WP_ADMIN_USER` | WordPress administrator login |
| `WP_ADMIN_PASSWORD` | WordPress administrator password |
| `WP_ADMIN_EMAIL` | WordPress administrator email |
| `WP_USER` | A second, non-admin WordPress user |
| `WP_USER_PASSWORD` | Password for the second user |

> **Note:** The administrator username must **not** contain the word `admin` or `administrator` (in any case variation). This is a project requirement.

---

## Checking that services are running correctly

```bash
# List running containers and their status
docker compose -f srcs/docker-compose.yml ps

# View logs for a specific service (e.g., nginx)
docker compose -f srcs/docker-compose.yml logs nginx

# View logs for all services at once
docker compose -f srcs/docker-compose.yml logs
```

All three containers should show a status of `Up`. If one is restarting repeatedly, check its logs for errors.

---

## Where is the data stored?

Persistent data is stored on the **host machine** (your VM) in:

```
/home/<login>/data/
├── db/         ← MariaDB database files
└── wordpress/  ← WordPress site files (themes, uploads, plugins, etc.)
```

This data survives container restarts and even `make down`. Only `make fclean` removes it.
