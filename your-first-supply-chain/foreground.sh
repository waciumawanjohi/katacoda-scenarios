#/bin/bash

main () {
    launch.sh
}

main

git clone https://github.com/vmware-tanzu/cartographer.git
cd cartographer
./hack/setup katacoda-scenario-1
