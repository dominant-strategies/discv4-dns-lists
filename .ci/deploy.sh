#!/bin/bash

set -e

proto_groups=(all les snap)

for network in "$@"; do

    echo "Deploy: $network"

    for proto in "${proto_groups[@]}"; do
        echo -n "Deploy: ${proto}.${network}.${QUAI_DNS_DISCV4_PARENT_DOMAIN}"

        # Ensure that we actually have a nodeset to deploy to DNS.
        [[ ! -d ${proto}.${network}.${QUAI_DNS_DISCV4_PARENT_DOMAIN} ]] || [[ ! -f ${proto}.${network}.${QUAI_DNS_DISCV4_PARENT_DOMAIN}/nodes.json ]] && { echo " | DNE, skipping"; continue; }

        echo
        # TODO implement cloudflare
        # devp2p dns to-cloudflare --zoneid "$QUAI_DNS_CLOUDFLARE_ZONEID" "${proto}.${network}.${QUAI_DNS_DISCV4_PARENT_DOMAIN}"
    done
done
