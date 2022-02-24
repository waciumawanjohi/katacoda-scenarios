#/bin/bash

readonly SOURCE_CONTROLLER_VERSION=0.17.0

main () {
  install_ytt
  install_kapp
  launch.sh
  install_yq
  install_source_controller
}

install_ytt () {
  wget -O- https://carvel.dev/install.sh > install_ytt.sh
  sudo bash install_ytt.sh
  rm install_ytt.sh
}

install_kapp() {
  wget -O- https://carvel.dev/install.sh > install_kapp.sh
  sudo bash install_kapp.sh
  rm install_kapp.sh
}

install_source_controller() {
        kubectl create namespace gitops-toolkit || true

        kubectl create clusterrolebinding gitops-toolkit-admin \
                --clusterrole=cluster-admin \
                --serviceaccount=gitops-toolkit:default || true

        ytt --ignore-unknown-comments \
                -f https://github.com/fluxcd/source-controller/releases/download/v$SOURCE_CONTROLLER_VERSION/source-controller.crds.yaml \
                -f https://github.com/fluxcd/source-controller/releases/download/v$SOURCE_CONTROLLER_VERSION/source-controller.deployment.yaml |
                kapp deploy --yes -a gitops-toolkit --into-ns gitops-toolkit -f-
}

install_yq() {
  pip3 install yq --ignore-installed
}

main
