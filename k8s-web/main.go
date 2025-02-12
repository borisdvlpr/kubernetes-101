package main

import (
	"io"
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

func main() {
	r := chi.NewRouter()
	r.Use(middleware.Logger)
	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("welcome"))
	})

	r.Get("/nginx", func(w http.ResponseWriter, r *http.Request) {
		resp, err := http.Get("http://nginx")
		if err != nil {
			http.Error(w, "Failed to get response from nginx", http.StatusInternalServerError)
			return
		}
		defer resp.Body.Close()

		body, err := io.ReadAll(resp.Body)
		if err != nil {
			http.Error(w, "Failed to read response body", http.StatusInternalServerError)
			return
		}
		w.Write(body)

	})

	http.ListenAndServe(":8080", r)
}
