# App Demo Project

This repo contains a project demonstrating modern app patterns:
- Go based back-end that primarily acts as API
  - Database
  - Containerised
  - CI pipeline
- Elm based front-end
  - Served by back-end (for now)
  - Runs entirely in browser as SPA.
  - Is built when deploying back-end
- Support and infrastructure
  - Configuration
  - Containerisation
  - Any deployment tools / scripts
  - Database
    - Provisioning
    - Data seeding scripts

## Tech used
- golang
- elm
- nodejs
- postgres
- docker (and docker compose)
- git / github
- REST
- HTML/CSS (bulma)

## Local Development

Documentation for working on the code on a local environment.

### Database

In console tab left open:

```bash
cd db

./build-container

./run-container
```

### Back end

In another console tab run:

```bash
cd back-end

make

. ./env-localh.sh; ./api-demo
```

### Front end

(TBD)

