package main

import "C"

import (
	"encoding/json"
	"io/ioutil"
	"net/http"
)

const timeURL = "http://worldtimeapi.org/api/timezone/Europe/Kiev"

//export getTime
func getTime() *C.char {
	// error handling omitted for brevity

	resp, _ := http.Get(timeURL)

	body, _ := ioutil.ReadAll(resp.Body)

	t := &struct {
		DateTime string `json:"datetime"`
	}{}

	_ = json.Unmarshal(body, t)

	return C.CString(t.DateTime)
}

func main() {}
