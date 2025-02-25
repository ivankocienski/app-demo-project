package main

import (
	"context"
	"encoding/json"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"

	"github.com/gorilla/mux"
	"github.com/jackc/pgx/v5"
)

//
// globals (ugh)
//

var pgConfig string
var pgConnection *pgx.Conn

//
// types
//

type StatusPayloadType struct {
	Status       string
	PartnerCount int
}

type ProblemPayload struct {
	Problem string `json:"problem"`
}

type PartnerType struct {
	Id            int       `json:"id"`
	Name          string    `json:"name"`
	Summary       string    `json:"summary"`
	Description   string    `json:"description"`
	Created_at    time.Time `json:"created_at"`
	Contact_email string    `json:"contact_email"`
}

type PartnerShortType struct {
	Id         int       `json:"id"`
	Name       string    `json:"name"`
	Summary    string    `json:"summary"`
	Created_at time.Time `json:"created_at"`
}

type PartnerIndexPayload struct {
	Partners []PartnerShortType `json:"partners"`
}

//
// handlers
//

func handleStatus(w http.ResponseWriter, _ *http.Request) {
	var err error

	log.Println("handleStatus()")

	var partnerCount int
	err = pgConnection.
		QueryRow(context.Background(), "select count(*) as count from partners").
		Scan(&partnerCount)

	if err != nil {
		log.Fatal("QueryRow failed: %v\n", err)
		return
	}

	payload := StatusPayloadType{
		Status:       "online",
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
		log.Print("Query failed:", err)
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

		partners = append(partners, PartnerShortType{id, name, summary, created_at})
	}

	payload := PartnerIndexPayload{
		Partners: partners,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(payload)
}

func handlePartnerShow(w http.ResponseWriter, r *http.Request) {
	var err error

	log.Println("handlePartnerShow()")

	vars := mux.Vars(r)

	id, err := strconv.Atoi(vars["id"])
	if err != nil {
		log.Print("id is not a valid integer")
		return
	}

	// var id int
	var name, summary, description, contact_email string
	var created_at time.Time

	err = pgConnection.
		QueryRow(context.Background(), "select name, summary, description, created_at, contact_email as count from partners where id=$1", id).
		Scan(&name, &summary, &description, &created_at, &contact_email)

	if err == pgx.ErrNoRows {
		payload := ProblemPayload{"Could not find partner with that ID"}

		w.WriteHeader(404)
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(payload)
		return
	}

	if err != nil {
		log.Print("QueryRow failed:", err)
		return
	}

	payload := PartnerType{
		Id:            id,
		Name:          name,
		Summary:       summary,
		Description:   description,
		Created_at:    created_at,
		Contact_email: contact_email,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(payload)

}

//
// main
//

func main() {
  var err error
  var present bool

  log.Println("go-api-demo starting up")

	// DB

  pgConfig, present = os.LookupEnv("APP_PGCONFIG")
  if !present {
    log.Fatal("Fatal: APP_PGCONFIG is not set in environment, stopping")
  }
  // MAYBE validate it looks like a PG URL? or not? How much do i trust pgx?

  pgConfig = "postgresql://" + pgConfig
  log.Println("pgConfig=", pgConfig)

  pgConnection, err = pgx.Connect(context.Background(), pgConfig)
	if err != nil {
		log.Fatal("Unable to connect to database:", err)
	}

	defer pgConnection.Close(context.Background())

	// server
	r := mux.NewRouter()

	r.HandleFunc("/api/v1/status", handleStatus).Methods("GET")
	r.HandleFunc("/api/v1/partners", handlePartnersIndex).Methods("GET")
	r.HandleFunc("/api/v1/partners/{id}", handlePartnerShow).Methods("GET")

  listenOn, present := os.LookupEnv("APP_LISTEN_ON")
  if !present || len(listenOn) == 0 {
    listenOn = "0.0.0.0:8002"
  }

	log.Printf("Starting on http://%v", listenOn)
	err = http.ListenAndServe(listenOn, r)
  if err != nil {
    log.Fatal("Fatal: failed to open server:", err)
  }
}
