#!/usr/bin/env bash
set -x

gcloud config set compute/region europe-west1
gcloud config set compute/zone europe-west1-b

export NUM_CONTROLLERS=3
export NUM_WORKERS=3
export KUBERNETES_VERSION=v1.6.4
export REGION=europe-west1

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

./00-start-infra-gcp.sh
./01-setup-ca.sh
./02-bootstrap-etcd.sh
./03-bootstrap-controllers.sh
./04-bootstrap-workers.sh
./05-kubectl-remote-access.sh
./06-create-routes.sh
./07-deploy-dns.sh
./08-smoke-test.sh
#./cleanup.sh

echo "==================== ${0} COMPLETE ===================="
