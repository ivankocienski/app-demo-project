# API Demo

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

## Testing

Can be run with `go test`.
