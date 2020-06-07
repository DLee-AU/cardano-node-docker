DFILE_VERSION=1.2

latest: 1.13.0

1.13.0:
	docker build --build-arg NODE_VERSION=1.13.0 \
           --build-arg NODE_REPOSITORY="https://github.com/input-output-hk/cardano-node" \
           --build-arg NODE_BRANCH="master" \
           -t "adalove/cardano-node:${DFILE_VERSION}-1.13.0" .

1.12.0:
	docker build --build-arg NODE_VERSION=1.12.0 \
           --build-arg NODE_REPOSITORY="https://github.com/input-output-hk/cardano-node" \
           --build-arg NODE_BRANCH="master" \
           -t "adalove/cardano-node:${DFILE_VERSION}-1.12.0" .

1.11.0:
	docker build --build-arg NODE_VERSION=1.11.0 \
	   --build-arg NODE_REPOSITORY="https://github.com/input-output-hk/cardano-node" \
	   --build-arg NODE_BRANCH="master" \
	   -t "adalove/cardano-node:${DFILE_VERSION}-1.11.0" .

1.10.1:
	docker build --build-arg NODE_VERSION=1.10.1 \
	   --build-arg NODE_REPOSITORY="https://github.com/input-output-hk/cardano-node" \
	   --build-arg NODE_BRANCH="master" \
	   -t "adalove/cardano-node:${DFILE_VERSION}-1.10.1" .

1.10.0:
	docker build --build-arg NODE_VERSION=1.10.0 \
	   --build-arg NODE_REPOSITORY="https://github.com/input-output-hk/cardano-node" \
	   --build-arg NODE_BRANCH="master" \
	   -t "adalove/cardano-node:${DFILE_VERSION}-1.10.0" .

1.9.3:
	docker build --build-arg NODE_VERSION=1.9.3 \
	   --build-arg NODE_REPOSITORY="https://github.com/input-output-hk/cardano-node" \
	   --build-arg NODE_BRANCH="master" \
	   -t "adalove/cardano-node:${DFILE_VERSION}-1.9.3" .

1.9.2:
	docker build --build-arg NODE_VERSION=1.9.2 \
	   --build-arg NODE_REPOSITORY="https://github.com/input-output-hk/cardano-node" \
	   --build-arg NODE_BRANCH="master" \
	   -t "adalove/cardano-node:${DFILE_VERSION}-1.9.2" .

1.9.1:
	docker build --build-arg NODE_VERSION=1.9.1 \
	   --build-arg NODE_REPOSITORY="https://github.com/input-output-hk/cardano-node" \
	   --build-arg NODE_BRANCH="master" \
	   -t "adalove/cardano-node:${DFILE_VERSION}-1.9.1" .

1.9.0:
	docker build --build-arg NODE_VERSION=1.9.0 \
	   --build-arg NODE_REPOSITORY="https://github.com/input-output-hk/cardano-node" \
	   --build-arg NODE_BRANCH="master" \
	   -t "adalove/cardano-node:${DFILE_VERSION}-1.9.0" .

1.8.0:
	docker build --build-arg NODE_VERSION=1.8.0 \
	   --build-arg NODE_REPOSITORY="https://github.com/input-output-hk/cardano-node" \
	   --build-arg NODE_BRANCH="master" \
	   -t "adalove/cardano-node:${DFILE_VERSION}-1.8.0" .

1.7.0:
	docker build --build-arg NODE_VERSION=1.7.0 \
	   --build-arg NODE_REPOSITORY="https://github.com/input-output-hk/cardano-node" \
	   --build-arg NODE_BRANCH="master" \
	   -t "adalove/cardano-node:${DFILE_VERSION}-1.7.0" .

1.6.0:
	docker build --build-arg NODE_VERSION=1.6.0 \
	   --build-arg NODE_REPOSITORY="https://github.com/input-output-hk/cardano-node" \
	   --build-arg NODE_BRANCH="master" \
	   -t "adalove/cardano-node:${DFILE_VERSION}-1.6.0" .
