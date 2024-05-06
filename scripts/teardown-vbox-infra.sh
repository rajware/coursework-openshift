#!/bin/bash

BASE_DIR=${BASE_DIR:-/vmdata/coursevms}
NETWORK_NAME=${NETWORK_NAME:-rostnet01}

# Remove  ssh port forwarding for external access of bastion node
VBoxManage natnetwork modify --netname "${NETWORK_NAME}" \
                             --port-forward-4 delete "Bastion External"

# Stop and delete bastion node
VBoxManage controlvm bastion poweroff
sleep 5s
VBoxManage unregistervm bastion --delete

# Stop and delete infra node
VBoxManage controlvm infraserver poweroff
sleep 5s
VBoxManage unregistervm infraserver --delete

# Stop and remove network

VBoxManage natnetwork stop --netname "${NETWORK_NAME}"

VBoxManage natnetwork remove --netname "${NETWORK_NAME}"
