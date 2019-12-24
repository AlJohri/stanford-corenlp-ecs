## Quickstart

```
# install system dependencies
brew bundle

# download docker image
docker pull graham3333/corenlp-complete

# start ECS cluster
./ecs up --size 3 --instance-type c5.large

# create aws log group
./ecs compose create --create-log-groups

# create task definition and run one instance of task
./ecs compose up

# check if task is running
./ecs compose ps

# scale up service 3 containers
./ecs compose scale 3

# scale down all containers
./ecs compose scale 0

# scale down all cluster instances
./ecs scale --size 0

# shutdown ECS cluster
./ecs down
```
