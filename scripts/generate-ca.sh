#!/bin/sh

CANAME=${1:-${CANAME:-exampleCA}}
CAFULLNAME=${2:-${CAFULLNAME:-Example}}

# Generate CA certificate

echo "Generating CA private key into ${CANAME}.key..."
openssl genrsa -des3 -out "${CANAME}.key" 2048

echo "Generating CA certificate into ${CANAME}.pem..."
openssl req -x509 -new -nodes -key "${CANAME}.key" -sha256 -days 1825 -out "${CANAME}.pem" -subj "/CN=${CAFULLNAME} Root/C=IN/ST=Karnataka/L=Bangalore/O=Example"
