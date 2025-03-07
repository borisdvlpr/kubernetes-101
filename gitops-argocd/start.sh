!#/bin/bash

# for more setup details please refer to https://argo-cd.readthedocs.io/en/stable/getting_started/
# configuration of argocd only runs if the namespace doesn't exist
if ! kubectl get namespace argocd %> /dev/null; then
    echo "ArgoCD namespace not found. Installing ArgoCD..."

    # install argocd on kubernetes cluster
    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

    # wait for all pods in argocd namespace to be ready
    echo "Creating ArgoCD pods..."
    kubectl wait --for=condition=ready pod --all -n argocd --timeout=90s
    echo "ArgoCD pods created."

    # configure cli access to argocd 
    argocd login --core

    # set the current namespace to argocd
    kubectl config set-context --current --namespace=argocd

    # deploy application
    kubectl apply -f application.yaml

    echo "ArgoCD installation complete."
else
    # set the current namespace to argocd
    kubectl config set-context --current --namespace=argocd
fi

# retrieve secret to log in on argocd ui
echo "Access ArgoCD dashboard at 'localhost:8080' with username 'admin' and password:"
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d && echo

# expose argocd-server to access argocd ui
kubectl port-forward svc/argocd-server -n argocd 8080:443
