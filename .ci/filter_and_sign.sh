#!/bin/bash

set -e
chains=("30303 prime" "30304 cyprus" "30305 paxos" "30306 hyrda" "30307 cyprus1" "30308 cyprus2" "30309 cyprus3" "30310 paxos1" "30311 paxos2" "30312 paxos3" "30313 hydra1" "30314 hyrda2" "30315 hyrda3")
networks=(mainnet ropsten)

for chain in "${chains[@]}"; do
    echo "Filter: $network"
    set -- $chain
    echo $1 $2

    for network in "${networks[@]}"; do
        echo "Sign: $network"

        mkdir -p "${network}/$2.${network}.${QUAI_DNS_DISCV4_PARENT_DOMAIN}"
        ./build/bin/quai-devp2p nodeset filter all-nodes/all-$2.json -quai-network ${network} > "${network}/$2.${network}.${QUAI_DNS_DISCV4_PARENT_DOMAIN}/nodes.json"

        echo -n "Sign: $2.${network}.${QUAI_DNS_DISCV4_PARENT_DOMAIN}"

        # Ensure that we actually have a nodeset to sign.
        [ ! -d ${network}"/"$2.${network}.${QUAI_DNS_DISCV4_PARENT_DOMAIN} ] || [ ! -f ${network}"/"$2.${network}.${QUAI_DNS_DISCV4_PARENT_DOMAIN}/nodes.json ] && { echo " | DNE, skipping"; continue; }

        echo
        cat "${QUAI_DNS_DISCV4_KEYPASS_PATH}" | ./build/bin/quai-devp2p dns sign "${network}"/"$2.${network}.${QUAI_DNS_DISCV4_PARENT_DOMAIN}" "${QUAI_DNS_DISCV4_KEY_PATH}" && echo "OK"

        git add "${network}/$2.${network}.${QUAI_DNS_DISCV4_PARENT_DOMAIN}"
    done

    QUAI_DNS_DISCV4_KEY_PUBLICINFO="$(cat $QUAI_DNS_DISCV4_KEYPASS_PATH | ./build/bin/quaikey-util inspect $QUAI_DNS_DISCV4_KEY_PATH | grep -E '(Addr|Pub)')"
    git -c user.name="alanorwick" -c user.email="alan.kev11@gmail.com" commit --author "crawler <>" -m "ci update ($network) $GITHUB_RUN_ID:$GITHUB_RUN_NUMBER"

done

Crawltime: $QUAI_DNS_DISCV4_CRAWLTIME

$QUAI_DNS_DISCV4_KEY_PUBLICINFO
    
