# API Demo

Objective: Produce a demonstration API capable of delivering a experience typical of some kind of REST service. This can then be used to build and embed the server application in a Docker container, and then built in to a Docker swarm cluster.

## Requirements, building and running

Requires go (go1.23.5). Clone repo and `go install`

This has 2 environment variables:

- `APP_LISTEN_ON` sets where the server runs from, defaults to `0.0.0.0:8002`
- `APP_PGCONFIG` **must** be set and looks like `api_demo_role:password@localhost:5432/api_demo_db`

Then run either with `go run .` or `go build . && ./api-demo`.

# Specs

The basic scenario is: a "partner" is defined with the following:
```
type Partner struct {
  Id int
  Name string
  Summary string
  Description string
  CreatedAt datetime
  ContactEmail string
}
```

The API needs to support the following end-points:
```
/api/v1/partners
  The "index". Shows all partners, sorted by name. Only id, name and summary.

/api/v1/partners/:id
  Shows all fields from a partner, if found. Otherwise 404 with suitable message.

/api/v1/stats
  Shows stats about service. Only partner count.
```

## Objectives

Basic:
- must be built as stand-alone binary
- configured by environment variables
- uses postgresql
- API is JSON based over HTTP
- Importing data

Also:
- tests
- linting
- best practices?
- formal documentation

Hypothetical continuation:
- build front-end

# Up next

Dockerising.
