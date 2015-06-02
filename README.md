Go from source Docker container
===============================

Development in Go, using a Docker container.  Once the container is created, stay inside and run all normal go commands.

* Source code is kept on the host computer outside of the container.  And so is your editor.
* Build system provided by gb. 

```
$ docker build -t justadam/golang .
$ cd 1.3
$ docker build -t justadam/golang:1.3 .
```

### Create the container

```
$ docker run -it --name go1.3 -v "/path/to/your/go/source/:/workspace:rw" justadam/golang:1.3
```

### Get back into the container

```
$ docker start -ia go1.3
```
