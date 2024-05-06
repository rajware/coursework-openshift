#!/bin/sh

NETWORK_NAME=${NETWORK_NAME:-rostnet01}

VBoxManage natnetwork modify --netname "${NETWORK_NAME}" \
                             --port-forward-4 "Cluster External Http:tcp:[]:80:[192.168.125.9]:80"
VBoxManage natnetwork modify --netname "${NETWORK_NAME}" \
                             --port-forward-4 "Cluster External Https:tcp:[]:443:[192.168.125.9]:443"
VBoxManage natnetwork modify --netname "${NETWORK_NAME}" \
                             --port-forward-4 "API External:tcp:[]:6443:[192.168.125.9]:6443"

