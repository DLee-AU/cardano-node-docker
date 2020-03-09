DFILE_VERSION=1.0
CARDANO_NODE_VERSION=1.6.0

latest: 1.6.0



1.6.0:
	docker build --build-arg NODE_VERSION=1.6.0 \
	   --build-arg NODE_REPOSITORY="https://github.com/input-output-hk/cardano-node" \
	   --build-arg NODE_BRANCH="master" \
	   -t "adalove/cardano-node:${DFILE_VERSION}-1.6.0" .