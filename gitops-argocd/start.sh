!#/bin/bash

# for more setup details please refer to https://argo-cd.readthedocs.io/en/stable/getting_started/
# install argocd on kubernetes cluster
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# configure cli access to argocd 
argocd login --core

# set the current namespace to argocd
kubectl config set-context --current --namespace=argocd
