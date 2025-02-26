# App Demo Project

A simple application that shows you a list of partners (companies) where you can see more info about a specific partner.

Intended as a project to develop a modern app pipeline:
- use of strongly typed languages (golang/elm)
- back end "API" server
- front end "App" SPA that runs in browser
- hosted via git/github
- uses CI/CD pipeline (TBD)

# Requirements

These cover the entire project:
- git
- docker
- nodejs (and npm/nvm)
- golang
- postgres

This project is built on (gentoo) linux.

# Local development

Much of the development is run through helper scripts documented below. Each script needs to be run in a separate console tab at the same time.

## Configuration

Everything is configured by environment variables stored in `env-local.sh`.

## Database

```bash
cd db

./build-container

# NOTE: `run-container` script will create user/database and populate partners table on first run
./run-container # press ^C to stop

# Also helpful
./psql-container # for connecting to DB console
```

## Back end

```bash
cd back-end

go install

./run-local-server # press ^C to stop
```

## Front end

The server can be kept running in the background whilst the payload is rebuilt *unless* you have changed the front-end configuration in the `env-local.sh` file.

```bash
cd front-end

npm install

./build-payload

./run-local-server # press ^C to stop
```

# Testing

(TBD)

# Deployment

(TBD)
