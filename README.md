## Quickstart

```
# install system dependencies
brew bundle

# download docker image
docker pull graham3333/corenlp-complete

# start ECS cluster
./ecs up --size 3 --instance-type t3.xlarge

# start service
./ecs compose service up

# scale service to 3
./ecs compose service scale 3

# make sure 3 containers are running
./ecs compose service ps
```

## Quickstop

```
./ecs down
```
