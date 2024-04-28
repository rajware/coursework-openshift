#!/bin/sh

DOMAIN=${1:-${DOMAIN:-apps.ocp415.rwsl.in}}
SERVERCERTNAME=${2:-ingresscontroller}
CANAME=${3:-${CANAME:-exampleCA}}

# Generate Certificate Signing Request

echo "Generating Certificate Signing Request into ${SERVERCERTNAME}.csr..."
openssl req -new -nodes -out "${SERVERCERTNAME}.csr" -newkey rsa:4096 -keyout "${SERVERCERTNAME}.key" \
            -subj "/CN=${DOMAIN}/C=IN/ST=Karnataka/L=Bangalore/O=Example"

# Create a v3 ext file for providing a Subject Alternate Name for wildcard domin
cat > "${SERVERCERTNAME}.v3.ext" << EOEXT
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.${DOMAIN}
EOEXT

# Sign the CSR using CA

echo "Signing and generating the server certificate in ${SERVERCERTNAME}.pem..."
openssl x509 -req -in "${SERVERCERTNAME}.csr" -CA "${CANAME}.pem" -CAkey "${CANAME}.key" \
             -CAcreateserial -out "${SERVERCERTNAME}.pem" -days 730 -sha256 \
             -extfile "${SERVERCERTNAME}.v3.ext"

# Clean up ext file and CSR
echo "Cleaning up..."
rm "${SERVERCERTNAME}.v3.ext"
rm "${SERVERCERTNAME}.csr"