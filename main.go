package main

import (
  "log"
  "net/http"
  "encoding/json"
  "os"
  "context"
  "time"

  "github.com/gorilla/mux"
  "github.com/jackc/pgx/v5"
)

const pgConfig = "postgresql://api_demo_role:password@localhost:5432/api_demo_db"
var pgConnection *pgx.Conn

type StatusPayloadType struct {
  Status string
  PartnerCount int
}

type PartnerShortType struct {
  Id int `json:"id"`
  Name string `json:"name"`
  Summary string `json:"summary"`
  Created_at time.Time `json:"created_at"`
}

type PartnerIndexPayload struct {
  Partners []PartnerShortType `json:"partners"`
}

func handleStatus(w http.ResponseWriter, _ *http.Request) {
  var err error

  log.Println("handleStatus()")

  var partnerCount int
  err = pgConnection.
    QueryRow(context.Background(), "select count(*) as count from partners").
    Scan(&partnerCount)

  if err != nil {
    log.Fatal("QueryRow failed: %v\n", err);
    return
  }

  payload := StatusPayloadType{
    Status: "online",
    PartnerCount: partnerCount,
  }

  w.Header().Set("Content-Type", "application/json")
  json.NewEncoder(w).Encode(payload)
}

func handlePartnersIndex(w http.ResponseWriter, _ *http.Request) {
  var err error

  log.Println("handlePartnersIndex()")

  rows, err := pgConnection.
    Query(context.Background(), "select id, name, summary, created_at from partners order by name")

  if err != nil {
    log.Print("Query failed:", err);
    return
  }

  var partners []PartnerShortType
  for rows.Next() {
    var id int
		var name string
    var summary string
    var created_at time.Time

		err := rows.Scan(&id, &name, &summary, &created_at)
		if err != nil {
      log.Print("Couldn't get row:", err)
			return
		}

    partners = append(partners, PartnerShortType { id, name, summary, created_at })
  }

  payload := PartnerIndexPayload {
    Partners: partners,
  }

  w.Header().Set("Content-Type", "application/json")
  json.NewEncoder(w).Encode(payload)
}

func main() {
  var err error

  // DB
  pgConnection, err = pgx.Connect(context.Background(), pgConfig)
  if err != nil {
    log.Fatal("Unable to connect to database: %v\n", err)
    os.Exit(1)
  }

  defer pgConnection.Close(context.Background())

  // server
  r := mux.NewRouter()

  r.HandleFunc("/api/v1/status", handleStatus).Methods("GET")
  r.HandleFunc("/api/v1/partners", handlePartnersIndex).Methods("GET")

  log.Println("Starting on http://localhost:8002")
  http.ListenAndServe(":8002", r)
}
