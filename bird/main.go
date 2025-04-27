package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"math/rand/v2"
	"net/http"
	"net/url"
	"os"
)

type Bird struct {
	Name        string
	Description string
	Image       string
}

var backend_url = os.Getenv("BACKEND_URL")
var listen_port = os.Getenv("LISTEN_PORT")

// var config Config

// func loadConfig(filename string) error {
// 	file, err := os.Open(filename)
// 	if err != nil {
// 		return err
// 	}
// 	defer file.Close()
// 	return json.NewDecoder(file).Decode(&config)
// }




func defaultBird(err error) Bird {
	return Bird{
		Name:        "Bird in disguise",
		Description: fmt.Sprintf("This bird is in disguise because: %s", err),
		Image:       "https://www.pokemonmillennium.net/wp-content/uploads/2015/11/missingno.png",
	}
}

func getBirdImage(birdName string) (string, error) {
	res, err := http.Get(fmt.Sprintf("%s?birdName=%s", backend_url, url.QueryEscape(birdName)))
	if err != nil {
		return "", err
	}
	defer res.Body.Close()
	body, err := io.ReadAll(res.Body)
	return string(body), err
}

func getBirdFactoid() Bird {
	res, err := http.Get(fmt.Sprintf("https://freetestapi.com/api/v1/birds/%d", rand.IntN(50)))
	if err != nil {
		fmt.Printf("Error reading bird API: %s\n", err)
		return defaultBird(err)
	}
	defer res.Body.Close()
	body, err := io.ReadAll(res.Body)
	if err != nil {
		fmt.Printf("Error parsing bird API response: %s\n", err)
		return defaultBird(err)
	}
	var bird Bird
	err = json.Unmarshal(body, &bird)
	if err != nil {
		fmt.Printf("Error unmarshalling bird: %s", err)
		return defaultBird(err)
	}
	birdImage, err := getBirdImage(bird.Name)
	if err != nil {
		fmt.Printf("Error getting bird image: %s\n", err)
		return defaultBird(err)
	}
	bird.Image = birdImage
	return bird
}

func bird(w http.ResponseWriter, r *http.Request) {
	var buffer bytes.Buffer
	json.NewEncoder(&buffer).Encode(getBirdFactoid())
	io.WriteString(w, buffer.String())
	
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	fmt.Fprintln(w, "OK")
}

func main() {
	var apiKey="akdlasjfhafhjkheahei"
	
	fmt.Println(apiKey)
	http.HandleFunc("/", bird)
	http.HandleFunc("/health", healthHandler)
	fmt.Printf("Starting server on %s...\n", listen_port)
	http.ListenAndServe(listen_port, nil)
}