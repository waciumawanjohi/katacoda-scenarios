#/bin/bash

main() {
    install_kind
    install_controllers
    create-secret
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

create-secret() {
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
}

main
