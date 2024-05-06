# Scripts

This directory contains utility scripts used during an OpenShift training. These are used to set up and tear down an OpenShift cluster using Oracle VirtualBox as the underlying bare-metal platform.

The scripts are listed below:

|Script|Description|
|---|---|
|setup-vbox-infra.sh|This sets up a VirtualBox NAT Network, and creates two VMS, which will act as infrastructure and bastion nodes. It requires .ova templates for creating the VMs, which can be found in the latest release of this repository. Finally, it creates a port-forwarding rule that exposes the bastion node's SSH port through the NAT Network.|
|setup-node.sh|This sets up a VM. It takes three positional parameters: the name of the VM, the MAC Id, and the path to a Core OS ISO file, which will be mounted as a bootable DVD drive. Environment variables can be used to control the number of cores, the amount of memory, and the size of virtual hard disk allocated to the VM.|
|eject-node-dvd.sh|This will remove a mounted ISO from a VM. It takes one positional parameter: the name of the VM.|
|expose-cluster.sh|This sets up three port-forwarding rules, which make ports 80, 443, and 6443 of the infrastructure VM exposed via the NAT Network.|
|unexpose-cluster.sh|This removes the port forwarding rules set up by `expose-cluster.sh`|
|teardown-node.sh|This completely removes a node VM. It takes one posistional parameter: the VM name|
|teardown-vbox-infra.sh|This removes the infrastructure and bastion VMs, and deletes the NAT Network.|
|generate-ca.sh|This generates a self signed "root" certificate, which can be used to sign server certificates.|
|generate-server-certificate.sh|This creates a certificate signing request for a server certificate, and then signs it using a CA(root) certificate created by `generate-ca.sh`|

