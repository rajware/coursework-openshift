#!/bin/bash

NODE_NAME=${1:-${NODE_NAME:-unknown}}

if [ "unknown" = "${NODE_NAME}" ]; then
    echo "Please specify the node name via the NODE_NAME variable or first parameter."
    exit 1
fi

VBoxManage storageattach "${NODE_NAME}" --storagectl "IDE Controller" \
                                        --port 1 --device 0 \
                                        --type dvddrive \
                                        --medium None