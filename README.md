Golang from source Docker container
===================================

Development in Go, using a Docker container.  Source code is kept on the host computer outside of the container.

```
vim Dockerfile # (Edit your gid/username from host machine)
sudo docker build -t justadam/golang .
cd 1.2.1
sudo docker build -t justadam/golang:1.2.1 .
```

```
sudo docker run -i -t -v "/path/to/your/go/source/:/workspace:rw" justadam/golang:1.2.1
```
