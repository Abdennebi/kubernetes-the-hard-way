#!/usr/bin/env bash
set -x

export NUM_CONTROLLERS=3
export NUM_WORKERS=3
export KUBERNETES_VERSION=v1.6.4

if [[ -z ${NUM_CONTROLLERS} || -z ${NUM_WORKERS} || -z ${KUBERNETES_VERSION} ]]; then
    echo "Must set NUM_CONTROLLERS, NUM_WORKERS and KUBERNETES_VERSION (e.g. 'vX.Y.Z') environment variables"
    exit 1
fi

if [[ ! ${KUBERNETES_VERSION} =~ ^v[0-9].[0-9].[0-9]$ ]]; then
    echo "KUBERNETES_VERSION must be in form 'vX.Y.Z'"
    exit 1
fi

if [[ -z ${REGION} ]]; then
    echo "Must define a region"
    exit 1
fi

./start-infra-gcp.sh
./setup-ca.sh
./bootstrap-etcd.sh
./bootstrap-controllers.sh
./bootstrap-workers.sh
./kubectl-remote-access.sh
./create-routes.sh
./deploy-dns.sh
./smoke-test.sh
#./cleanup.sh

echo "==================== ${0} COMPLETE ===================="
