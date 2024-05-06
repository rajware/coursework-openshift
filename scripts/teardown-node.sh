#!/bin/bash

NODE_NAME=${1:-${NODE_NAME:-unknown}}

if [ "unknown" = "${NODE_NAME}" ]; then
    echo "Please specify the node name via the NODE_NAME variable or first parameter."
    exit 1
fi

VBoxManage controlvm "${NODE_NAME}" poweroff
sleep 5s
VBoxManage unregistervm "${NODE_NAME}" --delete