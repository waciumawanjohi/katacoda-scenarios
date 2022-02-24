#/bin/bash

main () {
  install_ytt
  install_kapp
  launch.sh
  install_yq
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

main
