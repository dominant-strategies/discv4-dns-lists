#!/bin/sh

declare -a arr=("30303 prime" "30304 cyprus" "30305 paxos" "30306 hyrda" "30307 cyprus1" "30308 cyprus2" "30309 cyprus3" "30310 paxos1" "30311 paxos2" "30312 paxos3" "30313 hydra1" "30314 hyrda2" "30315 hyrda3")

mkdir -p all-nodes
for net in "${arr[@]}"
do
    set -- $net
    echo $1 $2
    echo $QUAI_DNS_DISCV4_BOOTNODE:$1
    ./quai-devp2p discv4 crawl --addr 0.0.0.0:$1 -timeout "$QUAI_DNS_DISCV4_CRAWLTIME" --bootnodes $QUAI_DNS_DISCV4_BOOTNODE:$1 all-nodes/all-$2.json & 
    pids[${i}]=$!
    echo pids
done

# wait for all pids
for pid in ${pids[*]}; do
    wait $pid
done

for net in "${arr[@]}"
do
    set -- $net
    git add all-$2.json
done

QUAI_DNS_DISCV4_KEY_PUBLICINFO="$(cat $QUAI_DNS_DISCV4_KEYPASS_PATH | ./quaikey-util inspect $QUAI_DNS_DISCV4_KEY_PATH | grep -E '(Addr|Pub)')"
git -c user.name="alanorwick" -c user.email='alan.kev11@gmail.com' commit --author 'crawler <>' -m "ci update (all.json) $GITHUB_RUN_ID:$GITHUB_RUN_NUMBER
        
Crawltime: $QUAI_DNS_DISCV4_CRAWLTIME

$QUAI_DNS_DISCV4_KEY_PUBLICINFO"