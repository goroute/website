---
title: 'Install'
date: 2019-02-11T19:27:37+10:00
weight: 1
---

Go route uses go modules which allows easy installation via standart go get command. This simple guide show how to add go route to your project.

### Adding or updating goroute

Run go get inside your project root directory.
```
go get -u github.com/goroute/route
```

### Updating to specific version

Modify go.mod file with specific version.

```
module mymodule

require (
	github.com/goroute/route v0.0.1
)
```

Build project to automatically updates go.sum file

```
go build .
```

### Problems

If you have any problem adding goroute to your project please read [go modules](https://github.com/golang/go/wiki/Modules) wiki.
