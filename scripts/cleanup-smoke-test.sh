#!/usr/bin/env bash
set -x

gcloud compute ssh controller1 --command "kubectl delete deployment nginx"
gcloud compute ssh controller1 --command "kubectl delete svc nginx"
gcloud -q compute firewall-rules delete kubernetes-nginx-service
