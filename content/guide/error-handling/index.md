---
title: 'Error Handling'
date: 2019-02-11T19:27:37+10:00
weight: 5
---

Goroute provides out of the box global error handling. This is possible due to route handler func signature.

Each route handler requires this signature:
```go
HandlerFunc func(Context) error
```

Which allows to directly return error:
```go
mux.GET("/user/:id", func(c Context) error {
    id := c.Param("id")
    if id == "" {
        return errors.New("id is empty")
    }
    if len(id) != 32 {
        return errors.New("id is invalid")
    }
    return c.NoContent(http.StatusOk)
})
```

# TODO
...