#!/bin/bash

set -e

BASE_DIR=${BASE_DIR:-/vmdata/coursevms}
NETWORK_NAME=${NETWORK_NAME:-rostnet01}

NODE_NAME=${1:-${NODE_NAME:-unknown}}
NODE_MAC=${2:-${NODE_MAC:-unknown}}
NODE_ISO_PATH=${3:-${NODE_ISO_PATH:-unknown}}

if [ "unknown" = "${NODE_NAME}" ]; then
    echo "Please specify the node name via the NODE_NAME variable or first parameter."
    exit 1
fi

if [ "unknown" = "${NODE_MAC}" ]; then
    echo "Please specify the node MAC address via the NODE_MAC variable or second parameter."
    exit 1
fi

if [ "unknown" = "${NODE_ISO_PATH}" ]; then
    echo "Please specify the node MAC address via the NODE_ISO_PATH variable or third parameter."
    exit 1
fi

# Default node size for OpenShift
# Cores: 4
# RAM: 16GB
# Disk: 100GB
NODE_CORES=${NODE_CORES:-4}
NODE_RAM=${NODE_RAM:-16384} 
NODE_DISK_MB=${NODE_DISK_MB:-102400}

# Create the node
VBoxManage createvm --name "${NODE_NAME}" \
                    --groups "/" \
                    --basefolder "${BASE_DIR}" \
                    --ostype Linux_64 \
                    --register

VBoxManage modifyvm "${NODE_NAME}" \
                    --macaddress1 "${NODE_MAC}" \
                    --nic1 natnetwork \
                    --nat-network1 "${NETWORK_NAME}" \
                    --cpus "${NODE_CORES}" \
                    --memory "${NODE_RAM}" \
                    --graphicscontroller vmsvga

HDNAME=${BASE_DIR}/${NODE_NAME}/${NODE_NAME}_DISK_01.vdi
VBoxManage createhd --filename "${HDNAME}" \
                    --size "${NODE_DISK_MB}" \
                    --format VDI

VBoxManage storagectl "${NODE_NAME}" --name "SATA Controller" \
                                     --add sata \
                                     --controller IntelAhci

VBoxManage storageattach "${NODE_NAME}" --storagectl "SATA Controller" \
                                        --port 0 \
                                        --device 0 \
                                        --type hdd \
                                        --medium  "${HDNAME}"

VBoxManage storagectl "${NODE_NAME}" --name "IDE Controller" \
                                     --add ide \
                                     --controller PIIX4

VBoxManage storageattach "${NODE_NAME}" --storagectl "IDE Controller" \
                                        --port 1 --device 0 \
                                        --type dvddrive \
                                        --medium "${NODE_ISO_PATH}"

VBoxManage modifyvm "${NODE_NAME}" --boot1 dvd \
                                   --boot2 disk \
                                   --boot3 none \
                                   --boot4 none 