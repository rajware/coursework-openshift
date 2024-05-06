#!/bin/sh

NETWORK_NAME=${NETWORK_NAME:-rostnet01}

VBoxManage natnetwork modify --netname "${NETWORK_NAME}" \
                             --port-forward-4 delete "Cluster External Http"
VBoxManage natnetwork modify --netname "${NETWORK_NAME}" \
                             --port-forward-4 delete "Cluster External Https"
VBoxManage natnetwork modify --netname "${NETWORK_NAME}" \
                             --port-forward-4 delete "API Externalm"

