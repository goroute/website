---
title: 'REST API'
date: 2019-02-11T19:27:37+10:00
weight: 6
---

Goroute has a good support for building restful apis.

Full example could be found [here](https://github.com/goroute/examples/tree/master/cmd/rest).

```go
package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/goroute/route"
)

type Customer struct {
	ID   string `json:"id"`
	Name string `json:"name"`
}

func main() {
	mux := route.NewServeMux()

	v1 := mux.Group("/v1")

	v1.GET("/customers/:id", func(c route.Context) error {
		customerID := c.Param("id")
		return c.String(http.StatusOK, fmt.Sprintf("GET customer %s\n", customerID))
	})

	v1.POST("/customers", func(c route.Context) error {
		customer := &Customer{}
		if err := c.Bind(customer); err != nil {
			return err
		}
		return c.String(http.StatusOK, fmt.Sprintf("POST customer %v\n", customer))
	})

	v1.PUT("/customers/:id", func(c route.Context) error {
		customerID := c.Param("id")
		customer := &Customer{}
		if err := c.Bind(customer); err != nil {
			return err
		}
		return c.String(http.StatusOK, fmt.Sprintf("PUT customer %s: %v\n", customerID, customer))
	})

	v1.PATCH("/customers/:id", func(c route.Context) error {
		customerID := c.Param("id")
		return c.String(http.StatusOK, fmt.Sprintf("PATCH customer %s\n", customerID))
	})

	v1.DELETE("/customers/:id", func(c route.Context) error {
		customerID := c.Param("id")
		return c.String(http.StatusOK, fmt.Sprintf("DELETE customer %s\n", customerID))
	})

	mux.GET("/", func(c route.Context) error {
		return c.JSON(http.StatusOK, mux.Routes())
	})

	log.Fatal(http.ListenAndServe(":9000", mux))
}
```