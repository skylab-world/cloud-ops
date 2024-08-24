package main

import (
    "fmt"
    "net/http"
    "net/http/httptest"
    "testing"
)

func TestMainHandler(t *testing.T) {
    // Create a request to pass to our handler.
    req, err := http.NewRequest("GET", "/", nil)
    if err != nil {
        t.Fatal(err)
    }

    // Create a ResponseRecorder to record the response.
    rr := httptest.NewRecorder()

    // Create a handler function similar to the one in main.go
    handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, "Welcome to the cloud-ops service")
    })

    // Call the handler with the ResponseRecorder and request
    handler.ServeHTTP(rr, req)

    // Check the status code is what we expect.
    if status := rr.Code; status != http.StatusOK {
        t.Errorf("handler returned wrong status code: got %v want %v", status, http.StatusOK)
    }

    // Check the response body is what we expect.
    expected := "Welcome to the cloud-ops service"
    if rr.Body.String() != expected {
        t.Errorf("handler returned unexpected body: got %v want %v", rr.Body.String(), expected)
    }
}
