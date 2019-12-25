start:
	# install system dependencies
	brew bundle

	# start ECS cluster
	./ecs up --size 3 --instance-type t3.xlarge

	# start service
	./ecs compose service up

	# scale service to 3
	./ecs compose service scale 3

	# make sure 3 containers are running
	./ecs compose service ps

	# print out ALB url
	./ecs url

stop:
	./ecs down
