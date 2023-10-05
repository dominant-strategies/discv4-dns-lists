#!/bin/bash

set -e

chains=("30303 prime" "30304 cyprus" "30305 paxos" "30306 hydra" "30307 cyprus1" "30308 cyprus2" "30309 cyprus3" "30310 paxos1" "30311 paxos2" "30312 paxos3" "30313 hydra1" "30314 hydra2" "30315 hydra3")
networks=(colosseum)

for chain in "${chains[@]}"; do
    set -- $chain
    for network in "${networks[@]}"; do
        
        echo -n "Deploy: $2.${network}.${QUAI_DNS_DISCV4_PARENT_DOMAIN}"

        # Ensure that we actually have a nodeset to deploy to DNS.
        [[ ! -d ${network}/$2.${network}.${QUAI_DNS_DISCV4_PARENT_DOMAIN} ]] || [[ ! -f ${network}/$2.${network}.${QUAI_DNS_DISCV4_PARENT_DOMAIN}/nodes.json ]] && { echo " | DNE, skipping"; continue; }
        echo
        ./devp2p dns to-cloudflare --zoneid "$QUAI_DNS_CLOUDFLARE_ZONEID" "${network}/$2.${network}.${QUAI_DNS_DISCV4_PARENT_DOMAIN}"
    done
done