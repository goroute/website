---
title: 'Quick Start'
date: 2019-02-11T19:27:37+10:00
draft: false
weight: 2
---

Create new project.

```
mkdir hello
cd ./hello
go mod init hello
```

Create main.go file with content.

```go
package main

import (
	"github.com/goroute/route"
	"log"
	"net/http"
)

func main() {
	mux := route.NewServeMux()

	mux.GET("/", func(c route.Context) error {
		return c.String(http.StatusOK, "Hello!")
	})

	log.Fatal(http.ListenAndServe(":9000", mux))
}
```

Run HTTP server.

```
go run .
```

Open browser and go to <b>http://localhost:9000</b>