CUE_MOD?=
COMPONENT?=$(subst /,_,$(CUE_MOD))
BUILD_PATH:="${CUE_MOD}/build"
ifdef ENV
	ENV_TAG:=-t ${ENV}
	BUILD_PATH:="${BUILD_PATH}/${ENV}"
endif
# default for publishing
OCI_REGISTRY?=localhost:5001
TAG?=v0.0.1
# const color for logging
GREEN=\033[0;32m
NO_COLOR=\033[0m
# google deps
GOOGLEAPIS_VERSION=master
PROTOBUF_VERSION=v25.6

.PHONY: dump build ls clean generate publish getproto import

# dump object to yaml

dump:
ifndef CUE_MOD
	$(error Parameter CUE_MOD not found. Use pls: CUE_MOD=<path_to_mod> make build)
endif
	@cue cmd \
	-t hash_commit=$$(git rev-parse HEAD) \
	-t author_commit=$$(git log -1 --pretty=format:'%ae' | sed 's/@.*//') \
	-t version=$$(git tag --points-at HEAD) \
	-t component=${COMPONENT} \
	${ENV_TAG} \
	dump ./${CUE_MOD}/... ./lib ./tool

build:
ifndef CUE_MOD
	$(error Parameter CUE_MOD not found. Use pls: CUE_MOD=<path_to_mod> make build)
endif
	@echo "[${GREEN}RUN${NO_COLOR}] write files to ${CUE_MOD}/build/.."
	@cue cmd \
		-t hash_commit=$$(git rev-parse HEAD) \
		-t author_commit=$$(git log -1 --pretty=format:'%ae' | sed 's/@.*//') \
		-t version=$$(git tag --points-at HEAD) \
		-t component=${COMPONENT} \
		-t build_path=${BUILD_PATH} \
		${ENV_TAG} \
		build ./${CUE_MOD}/... ./lib ./tool
	@echo "[${GREEN}DONE${NO_COLOR}] build success!"

ls:
	@cue cmd ls ./${CUE_MOD}/... ./tool

clean:
	@rm -rf **/build build proto vendor cue.mod/gen
	@echo "[${GREEN}DONE${NO_COLOR}] clean success!"

# prepare module to working

generate:
	@echo "[${GREEN}RUN${NO_COLOR}] cue import *.proto..."
	@echo "[${GREEN}RUN${NO_COLOR}] cue import istio.io/api"
	@cue import proto ./proto/istio.io/api/... \
    	--proto_path ./proto \
    	--proto_path ./proto/istio.io/api \
			--proto_path ./proto/protobuf/src \
			--proto_path ./proto/googleapis \
			--proto_enum json \
    	--force
	@echo "[${GREEN}RUN${NO_COLOR}] cue import k8s.io/api/core/v1"
	@cue import proto ./proto/k8s.io/api/core/v1/... \
		--proto_path ./proto \
		--proto_enum json \
		--force
	@echo "[${GREEN}RUN${NO_COLOR}] cue import k8s.io/api/apps/v1"
	@cue import proto ./proto/k8s.io/api/apps/v1/... \
    	--proto_path ./proto \
		--proto_enum json \
    	--force
	@echo "[${GREEN}RUN${NO_COLOR}] cue import k8s.io/api/networking/v1"
	@cue import proto ./proto/k8s.io/api/networking/v1/... \
		--proto_path ./proto \
		--proto_enum json \
		--force
	@echo "[${GREEN}RUN${NO_COLOR}] cue import k8s.io/api/autoscaling/v2"
	@cue import proto ./proto/k8s.io/api/autoscaling/v2/... \
		--proto_path ./proto \
		--proto_enum json \
		--force
	@echo "[${GREEN}RUN${NO_COLOR}] cue import k8s.io/api/batch/v1"
	@cue import proto ./proto/k8s.io/api/batch/v1/... \
		--proto_path ./proto \
		--proto_enum json \
		--force
	@echo "[${GREEN}RUN${NO_COLOR}] cue import github.com/argoproj/argo-cd"
	@cue import proto ./proto/github.com/argoproj/argo-cd/... \
    	--proto_path ./proto \
		--proto_enum json \
    	--force
	@echo "[${GREEN}DONE${NO_COLOR}] All CUE definitions generated success!"

# publish module to registry
publish:
	@echo "git commit&push changes with --amend..."
	@git add --all 
	@git commit -m "initial local changes" --amend
	@echo "oci registry publish..."
	@CUE_REGISTRY=$(OCI_REGISTRY) cue mod publish $(TAG)

getproto:
	@echo "[${GREEN}RUN${NO_COLOR}] download go dependencies..."
	@go mod tidy
	@go mod vendor
	@echo "[${GREEN}RUN${NO_COLOR}] get protobuf"
	@cd vendor && git clone --no-checkout --filter=blob:none https://github.com/protocolbuffers/protobuf \
		&& cd protobuf \
		&& git sparse-checkout init --cone \
		&& git sparse-checkout set src \
		&& git checkout -b work $(PROTOBUF_VERSION)\
		&& shopt -s dotglob
	@echo "[${GREEN}RUN${NO_COLOR}] get googleapis"
	@cd vendor && git clone --no-checkout --filter=blob:none https://github.com/googleapis/googleapis \
		&& cd googleapis \
		&& git sparse-checkout init --cone \
		&& git sparse-checkout set google \
		&& git checkout -b work $(GOOGLEAPIS_VERSION) \
		&& shopt -s dotglob
	@echo "[${GREEN}RUN${NO_COLOR}] extract *.proto to proto/"
	@rsync -av \
		--include '*/' --include '*.proto' \
		--exclude '*' \
		./vendor/ ./proto
	@echo "[${GREEN}RUN${NO_COLOR}] remove all empty dir in ./proto"
	@find ./proto -type d -empty -delete
	@echo "[${GREEN}DONE${NO_COLOR}] success!"

import:
	@echo "[${GREEN}RUN${NO_COLOR}] find objects ${RESOURCES} in ${NAMESPACE} matching with ${NAME}..."
	@objects=$$(kubectl get $(RESOURCES) --namespace $(NAMESPACE) \
			| grep ${NAME} | awk '{print $$1}'); \
	mkdir -p ${NAME}; \
	for obj in $$objects; do \
		obj_type=$$(echo "$$obj" | cut -d "/" -f 1); \
		obj_name=$$(echo "$$obj" | cut -d "/" -f 2); \
		echo "$$obj_type/$$obj_name write to file..."; \
		kubectl get $$obj_type $$obj_name --namespace $(NAMESPACE) -o yaml > "$${NAME}/$${obj_name}.yaml"; \
	done
	@echo "[${GREEN}RUN${NO_COLOR}] run cue import..."
	@cue import -p k8s ./${NAME}/... -l metadata.name
	@echo "[${GREEN}DONE${NO_COLOR}] success!"