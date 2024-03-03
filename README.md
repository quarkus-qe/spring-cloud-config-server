# Spring Cloud Config Server
A docker image of Spring Cloud Config Server 


## How to build and run
- Note that you should use absolute path to config directory
```
docker build -t spring-cloud-config-server .
docker run -v /resources/config:/config -e SPRING_PROFILES_ACTIVE=native -p 8888:8888 docker.io/library/myspringcloudconfig
```
