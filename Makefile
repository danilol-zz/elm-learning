default: test

login:
	eval `aws ecr get-login --no-include-email`

init:
	docker pull kkarczmarczyk/node-yarn
	docker run --rm -v $PWD:/workspace kkarczmarczyk/node-yarn "yarn"
	ci/set_terraform_vars.sh

test: init
	docker run --rm -v $PWD:/workspace kkarczmarczyk/node-yarn "yarn test"
	ci/set_terraform_remote.sh
	ci/plan_terraform.sh

build: login
	docker pull $(REPO):$(TRAVIS_BRANCH)
	docker run --rm -v $PWD:/workspace kkarczmarczyk/node-yarn "yarn build"
	docker build --cache-from $(REPO):$(TRAVIS_BRANCH) -t $(REPO):$(TRAVIS_COMMIT) .
	ci/check_version.sh

deploy: login
	ci/deploy.sh

.PHONY: login init test build deploy
