#!/usr/bin/env bash
set -x

gcloud compute ssh controller1 --command "kubectl create -f https://raw.githubusercontent.com/abdennebi/kubernetes-the-hard-way/master/services/kubedns.yaml"

gcloud compute ssh controller1 --command "kubectl --namespace=kube-system get svc"

gcloud compute ssh controller1 --command "kubectl create -f https://raw.githubusercontent.com/abdennebi/kubernetes-the-hard-way/master/deployments/kubedns.yaml"

gcloud compute ssh controller1 --command "kubectl --namespace=kube-system get pods"
