#/bin/bash

main () {
    launch.sh
}

main

git clone https://github.com/vmware-tanzu/cartographer.git
cd cartographer
git checkout waciuma/katacoda
./hack/setup.sh katacoda-scenario-1
