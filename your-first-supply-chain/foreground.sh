#/bin/bash

main () {
    launch.sh
    start_registry
    ./root/kpack-setup/ip.py
}

#readonly REGISTRY_PORT=5000
#readonly REGISTRY=${REGISTRY:-"${HOST_ADDR}:5000"}

start_registry() {
        log "starting registry"

        echo -e "\n\nregistry credentials:\n
        username: admin
        password: admin
        "

        env DOCKER_USERNAME=admin \
                DOCKER_PASSWORD=admin \
                DOCKER_REGISTRY="$REGISTRY" \
                DOCKER_CONFIG="$DOCKER_CONFIG" \
                "$DIR/docker-login.sh"

        docker container inspect $REGISTRY_CONTAINER_NAME &>/dev/null && {
                echo "registry already exists"
                return
        }

        docker run \
                --detach \
                -v "$DIR/registry-auth:/auth" \
                -e "REGISTRY_AUTH=htpasswd" \
                -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
                -e "REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd" \
                --name "$REGISTRY_CONTAINER_NAME" \
                --publish "${REGISTRY_PORT}":5000 \
                registry:2
}

main
