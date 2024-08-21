if [ -z "$1" ]; then
  echo APP_NAME input is missing
  echo Usage: $0 APP_NAME ENV NAMESPACE
  exit 1
else
  APP_NAME=$1
fi

if [ -z "$2" ]; then
  echo ENV input is missing
  echo Usage: $0 APP_NAME ENV NAMESPACE
  exit 1
else
  ENV=$2
fi

if [ -z "$3" ]; then
  echo NAMESPACE input is missing
  echo Usage: $0 APP_NAME ENV NAMESPACE
  exit 1
else
  ENV=$2
fi

ARGOCD_PASSWORD=$(kubectl get secrets argocd-initial-admin-secret -n argocd  -o=jsonpath='{.data.password}' | base64 --decode)
argocd login  argocd-main-dev.rdevopsb79.online:443 --grpc-web --username admin --password ${ARGOCD_PASSWORD}

argocd app create ${APP_NAME} --project default --sync-policy auto --repo https://github.com/raghudevopsb79/roboshop-helm --path chart --dest-namespace ${NAMESPACE} --dest-server https://kubernetes.default.svc --values-literal-file env-${ENV}/${APP_NAME}.yaml


