#/bin/bash

main() {
    install_kubectl
    install_kind
    install_controllers
    create_kpack_files
    timestamp_stop
}

install_kubectl() {
    snap install kubectl --classic
}

install_kind() {
    GO111MODULE="on" go get sigs.k8s.io/kind@v0.11.1
}

install_controllers() {
    git clone https://github.com/vmware-tanzu/cartographer.git
    pushd cartographer
        git checkout waciuma/katacoda
        ./hack/setup.sh katacoda-scenario-1
    popd
}

create_kpack_files() {
    pushd cartographer/hack
        readonly HOST_ADDR=$(./ip.py)
        readonly REGISTRY="${HOST_ADDR}:5000"
    popd

    ytt --ignore-unknown-comments \
        -f "cartographer/examples/shared/cluster/secret.yaml" \
        --data-value registry.server="$REGISTRY" \
        --data-value registry.username=admin \
        --data-value registry.password=admin \
        --output-files kpack-setup

    ytt --ignore-unknown-comments \
        -f "template-with-ytt/kpack-builder.yaml" \
        --data-value registry.server="$REGISTRY" \
        --output-files kpack-setup
}

timestamp_stop() {
    date +"%s" > stop
}

main
