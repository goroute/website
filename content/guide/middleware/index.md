---
title: 'Middleware'
date: 2019-02-11T19:27:37+10:00
draft: false
weight: 3
---

Goroute supports common middleware pattern. In this guide we will use standart goroute middlewares and create new one.

### Using middleware


```go
package main

import (
	"github.com/goroute/route"
	"github.com/goroute/recover"
	"github.com/goroute/compress"
	"github.com/goroute/cors"
	"github.com/goroute/static"
	"log"
	"net/http"
)

func main() {
	mux := route.NewServeMux()

	mux.Use(
		recover.New(),
		compress.New(),
		cors.New(),
		static.New(
			static.HTML5(true),
			static.Root("./dist"),
		),
	)

	mux.GET("/", func(c route.Context) error {
		return c.String(http.StatusOK, "Hello!")
	})

	log.Fatal(http.ListenAndServe(":9000", mux))
}
```

### Creating new middleware

To add our own middleware we just need to create a new func which returns `route.MiddlewareFunc`. 

Let's create a new middleware which logs each request path.

```go
import "github.com/goroute/route"

func logger() route.MiddlewareFunc {
	return func(next route.HandlerFunc) route.HandlerFunc {
		return func(c route.Context) error {
			fmt.Println("Request Path:", c.Request().URL.Path)
			return next(c)
		}
	}
}
```

Register middleware.

```go
mux.Use(logger())
```

#### Adding options

Common scenario for middleware is to have some configurable options. Let's use go option pattern to allow passing options.

Let's move our middleware to a new package called logger.
```go
package logger

import "github.com/goroute/route"

type Options struct {
	Skipper route.Skipper
	Level string
}

type Option func(*Options)

func GetDefaultOptions() Options {
	return Options{
		Skipper: route.DefaultSkipper,
		Level:   "info",
	}
}

func Skipper(skipper route.Skipper) Option {
	return func(o *Options) {
		o.Skipper = skipper
	}
}

func Level(level string) Option {
	return func(o *Options) {
		o.Level = level
	}
}

func New(options ...Option) route.MiddlewareFunc {
	// Apply options.
	opts := GetDefaultOptions()
	for _, opt := range options {
		opt(&opts)
	}

	return func(next route.HandlerFunc) route.HandlerFunc {
		return func(c route.Context) error {
			if opts.Skipper(c) {
				return next(c)
			}
			if opts.Level == "debug" {
				fmt.Println("Request Path:", c.Request().URL.Path)
			}
			return next(c)
		}
	}
}
```

Now we can import our middleware and register with options.

```go
import "mymodule/logger"

// ...

mux.Use(logger.New(logger.Level("debug")))

```