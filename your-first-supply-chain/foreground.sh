#/bin/bash

main () {
  launch.sh
  install_carto_dependencies
}

install_carto_dependencies() {
  mkdir -p "hack/overlays"
  wget -O- https://raw.githubusercontent.com/vmware-tanzu/cartographer/main/hack/overlays/remove-resource-requests-from-deployments.yaml > hack/overlays/remove-resource-requests-from-deployments.yaml
  wget -O- https://raw.githubusercontent.com/vmware-tanzu/cartographer/waciuma/demo/hack/setup.sh > hack/setup.sh
  chmod +x hack/setup.sh
  ./hack/setup.sh example-dependencies
}

main
