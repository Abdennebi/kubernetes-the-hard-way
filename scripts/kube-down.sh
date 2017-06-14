#!/usr/bin/env bash
set -x

gcloud config set compute/region europe-west1
gcloud config set compute/zone europe-west1-b

export NUM_CONTROLLERS=3
export NUM_WORKERS=3
export KUBERNETES_VERSION=v1.6.4
export REGION=europe-west1

if [[ -z ${NUM_CONTROLLERS} || -z ${NUM_WORKERS} ]]; then
    echo "Must set NUM_CONTROLLERS and NUM_WORKERS env vars"
    exit 1
fi

(( NUM_CONTROLLERS-- ))
(( NUM_WORKERS-- ))

for i in $(eval echo "{0..${NUM_CONTROLLERS}}"); do
    hosts="${hosts}controller${i} "
done

for i in $(eval echo "{0..${NUM_WORKERS}}"); do
    hosts="${hosts}worker${i} "
done

gcloud -q compute instances delete ${hosts}

gcloud -q compute forwarding-rules delete kubernetes-rule --region ${REGION}

gcloud -q compute target-pools delete kubernetes-pool

gcloud -q compute http-health-checks delete kube-apiserver-check

gcloud -q compute addresses delete kubernetes --region ${REGION}

gcloud -q compute firewall-rules delete \
  kubernetes-allow-api-server \
  kubernetes-allow-healthz \
  kubernetes-allow-icmp \
  kubernetes-allow-internal \
  kubernetes-allow-internal-podcidr \
  kubernetes-allow-rdp \
  kubernetes-allow-ssh \
  kubernetes-nginx-service

for i in $(eval echo "{0..${NUM_WORKERS}}"); do
    gcloud -q compute routes delete kubernetes-route-10-200-${i}-0-24
done

gcloud -q compute networks subnets delete kubernetes

gcloud -q compute networks delete kubernetes
