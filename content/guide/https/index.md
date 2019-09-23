---
title: 'Auto TLS'
date: 2019-02-11T19:27:37+10:00
weight: 4
---

Go has a great support for HTTPS and Let's Encrypt certificates. We are going to use [autocert](https://godoc.org/golang.org/x/crypto/acme/autocert) package
from official golang crypto repository.

Full example could be found [here](https://github.com/goroute/examples/tree/master/cmd/https).

```go
package main

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/goroute/route"
	"golang.org/x/crypto/acme/autocert"
)

func main() {
	mux := route.NewServeMux()

	mux.GET("/", func(c route.Context) error {
		return c.String(http.StatusOK, "Hello TLS!")
	})

	log.Fatal(serveTLS(mux))
}

func serveTLS(mux *route.Mux) error {
	hostName := "example.com"
	m := &autocert.Manager{
		Prompt:     autocert.AcceptTOS,
		Cache:      autocert.DirCache("certs"),
		HostPolicy: autocert.HostWhitelist(hostName, fmt.Sprintf("www.%s", hostName)),
	}
	srv := &http.Server{
		Handler:           mux,
		ReadTimeout:       30 * time.Second,
		ReadHeaderTimeout: 30 * time.Second,
		WriteTimeout:      30 * time.Second,
		TLSConfig:         m.TLSConfig(),
	}
	return srv.ListenAndServeTLS("", "")
}
```
