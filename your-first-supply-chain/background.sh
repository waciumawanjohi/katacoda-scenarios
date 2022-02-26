#/bin/bash

readonly KPACK_VERSION=0.5.1
readonly SOURCE_CONTROLLER_VERSION=0.17.0

main () {
    install_ytt
    install_kapp
    install_yq
    launch.sh
}

install_ytt () {
    wget --no-check-certificate -O- https://carvel.dev/install.sh > install_ytt.sh #TODO remove certificate flag when katacoda k8s env supports cert checking
    sudo bash install_ytt.sh
    rm install_ytt.sh
}

install_kapp() {
    wget --no-check-certificate -O- https://carvel.dev/install.sh > install_kapp.sh #TODO remove certificate flag when katacoda k8s env supports cert checking
    sudo bash install_kapp.sh
    rm install_kapp.sh
}

install_yq() {
    pip3 install yq --ignore-installed
}

main
