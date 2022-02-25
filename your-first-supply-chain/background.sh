#/bin/bash

readonly KPACK_VERSION=0.5.1
readonly SOURCE_CONTROLLER_VERSION=0.17.0

main () {
    install_ytt
    install_kapp
    install_yq
    launch.sh
#    get_overlays
#    install_source_controller
#    install_kpack
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

install_yq() {
    pip3 install yq --ignore-installed
}

get_overlays() {
    mkdir -p "overlays"
    wget -O- https://raw.githubusercontent.com/vmware-tanzu/cartographer/main/hack/overlays/remove-resource-requests-from-deployments.yaml > overlays/remove-resource-requests-from-deployments.yaml
}

install_source_controller() {
    kubectl create namespace gitops-toolkit || true

    kubectl create clusterrolebinding gitops-toolkit-admin \
        --clusterrole=cluster-admin \
        --serviceaccount=gitops-toolkit:default || true

    ytt --ignore-unknown-comments \
        -f "overlays/remove-resource-requests-from-deployments.yaml" \
        -f https://github.com/fluxcd/source-controller/releases/download/v$SOURCE_CONTROLLER_VERSION/source-controller.crds.yaml \
        -f https://github.com/fluxcd/source-controller/releases/download/v$SOURCE_CONTROLLER_VERSION/source-controller.deployment.yaml |
        kapp deploy --yes -a gitops-toolkit --into-ns gitops-toolkit -f-
}

install_kpack() {
    kubectl apply -f https://github.com/pivotal/kpack/releases/download/v$KPACK_VERSION/release-$KPACK_VERSION.yaml
}

main
