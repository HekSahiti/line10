ifndef AWS_REGION
#Throw error if AWS region not defined
$(error AWS_REGION is not set, please set region, example: export AWS_REGION=us-east-1)
else
export AWS_REGION
endif

ifndef ENVIRONMENT
#Throw error if environment not defined
$(error ENVIRONMENT is not set, please set environment, example: export ENVIRONMENT=env)
else
export ENVIRONMENT
endif

##
# TASKS
##

# Ask user for confirmation helper
#
_check:
	@echo "================================== Warning! ==================================" && \
	echo "== There is no going back." && \
	echo "== This will destroy all infrastructure and data in this project" && \
	echo "==============================================================================="
	@echo -n "Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]

## Initialize 00_terraform remote state
init:
	@echo "terraform init"
	@terraform init

init-reconfigure:
	@echo "terraform init -reconfigure"
	@terraform init -reconfigure 

init-first-run: init-reconfigure

init-force-copy:
	terraform init -force-copy

## Clean up the project
clean: 
	rm -rf .terraform *.tfstate*

apply: init
	terraform apply -compact-warnings -var-file=${ENVIRONMENT}.tfvars -lock=false

apply-auto-approve: init
	terraform apply -auto-approve -compact-warnings -var-file=${ENVIRONMENT}.tfvars -lock=false

plan: init
	terraform plan -compact-warnings -var-file=${ENVIRONMENT}.tfvars -lock=false

destroy: _check init
	terraform destroy -var-file=${ENVIRONMENT}.tfvars -lock=false
