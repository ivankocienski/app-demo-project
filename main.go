package main

import (
  "fmt"
  "net/http"
  "encoding/json"

  "github.com/gorilla/mux"
)

type StatusPayloadType struct {
  Status string
  PartnerCount int
}

func handleStatus(w http.ResponseWriter, _ *http.Request) {
  payload := StatusPayloadType{
    Status: "online",
    PartnerCount: 1234,
  }

  w.Header().Set("Content-Type", "application/json")
  json.NewEncoder(w).Encode(payload)
}

func main() {
  r := mux.NewRouter()

  r.HandleFunc("/api/v1/status", handleStatus).Methods("GET")

  fmt.Println("Starting on http://localhost:8002")
  http.ListenAndServe(":8002", r)
}
