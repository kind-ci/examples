# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
set -x;


kind create cluster --name "$CLUSTER_NAME" --config drone/kind-config --wait 1m

#replace localhost or 0.0.0.0 in the kubeconfig file with "docker", in order to be able to reach the cluster through the docker service
sed -i -E -e 's/localhost|0\.0\.0\.0/'"$CLUSTER_HOST"'/g' ${KUBECONFIG}

kubectl wait node --all --for condition=ready
