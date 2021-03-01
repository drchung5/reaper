kind create cluster --config kind-config.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

kubectl apply -f storageclass-kind.yaml
helm repo add datastax https://datastax.github.io/charts
helm repo update
helm install cass-operator datastax/cass-operator
kubectl wait \
  --for=condition=ready pod \
  --selector=name=cass-operator \
  --timeout=90s

kubectl apply -f cassandra-cluster.yaml
kubectl wait \
  --for=condition=Ready cassandradatacenter/dc1 \
  --timeout=240s