#/bin/bash

readonly KPACK_VERSION=0.5.1
readonly SOURCE_CONTROLLER_VERSION=0.17.0

main () {
    install_ytt
    install_kapp
    install_yq
    launch.sh
    install_controllers
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

install_controllers() {
  git clone https://github.com/vmware-tanzu/cartographer.git
  pushd cartographer
    git checkout waciuma/katacoda
    ./hack/setup.sh katacoda-scenario-1
  popd
}

main
