.PHONY: init
init:
	bash ./docker-compose-init.bash

.PHONY: destroy
destroy:
	bash ./docker-compose-destroy.bash

.PHONY: reload
reload: destroy init

.PHONY: test
test:
	bash ./bin/docker-benchmark.bash
