#!/bin/bash

BASE_DIR=${BASE_DIR:-/vmdata/coursevms}

NETWORK_NAME=${NETWORK_NAME:-rostnet01}

INFRA_IMAGE=${INFRA_IMAGE:-infra.ova}
INFRA_MAC=${INFRA_MAC:-8a22aeedbbfb}

BASTION_IMAGE=${BASTION_IMAGE:-bastion.ova}
BASTION_MAC=${BASTION_MAC:-b0faca65b1d0}
BASTION_EXTERNAL_PORT=${BASTION_EXTERNAL_PORT:-2289}

# Set up VirtualBox NAT Network
echo "Set up VirtualBox NAT Network..."
VBoxManage natnetwork add --netname "${NETWORK_NAME}" \
                          --network "192.168.125.0/24" \
                          --dhcp off \
                          --ipv6-enable on \
                          --ipv6-default on \
                          --ipv6-prefix "fdd2:c859:c78d:ccd8::/64" \
                          --enable


# Import infrastructure VM and add it to the network
VBoxManage import "${INFRA_IMAGE}" \
                  --vsys 0 --vmname infraserver \
                  --vsys 0 --group / \
                  --vsys 0 --basefolder "${BASE_DIR}"

                     
VBoxManage modifyvm infraserver \
                    --macaddress1 "${INFRA_MAC}" \
                    --nic1 natnetwork \
                    --nat-network1 "${NETWORK_NAME}" \
                    --cpus 2 \
                    --memory 2048

# Start infra vm
VBoxManage startvm infraserver --type=headless

# Import bastion VM and add it to the network
VBoxManage import "${BASTION_IMAGE}" \
                  --vsys 0 --vmname bastion \
                  --vsys 0 --group / \
                  --vsys 0 --basefolder "${BASE_DIR}"

VBoxManage modifyvm bastion \
                    --macaddress1 "${BASTION_MAC}" \
                    --nic1 natnetwork \
                    --nat-network1 "${NETWORK_NAME}" \
                    --cpus 2 \
                    --memory 2048

# Start bastion VM
VBoxManage startvm bastion --type=headless


# Forward bastion ssh port for external access
VBoxManage natnetwork modify --netname "${NETWORK_NAME}" \
                             --port-forward-4 "Bastion External:tcp:[]:${BASTION_EXTERNAL_PORT}:[192.168.125.10]:22"
