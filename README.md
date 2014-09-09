Golang from source Docker container
===================================

Development in Go, using a Docker container.  Source code is kept on the host computer outside of the container.

```
docker build -t justadam/golang .
cd 1.3
docker build -t justadam/golang:1.3 .
```

```
docker run -i -t -v "/path/to/your/go/source/:/workspace:rw" justadam/golang:1.3
```
