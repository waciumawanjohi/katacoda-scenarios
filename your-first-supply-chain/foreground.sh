#/bin/bash

main() {
    launch.sh
    install_controllers
    create-secret
}

install_controllers() {
    git clone https://github.com/vmware-tanzu/cartographer.git
    pushd cartographer
        git checkout waciuma/katacoda
        ./hack/setup.sh cluster katacoda-scenario-1
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
