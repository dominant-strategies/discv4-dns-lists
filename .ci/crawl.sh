#!/bin/bash

arr=("30303 prime" "30304 cyprus" "30305 paxos" "30306 hydra" "30307 cyprus1" "30308 cyprus2" "30309 cyprus3" "30310 paxos1" "30311 paxos2" "30312 paxos3" "30313 hydra1" "30314 hydra2" "30315 hydra3")

mkdir -p all-nodes
for net in "${arr[@]}"
do
    set -- $net
    port=$1
    node_name=$2
    # Convert node_name to uppercase and replace spaces/hyphens with underscores
    env_var="QUAI_DNS_DISCV4_BOOTNODE_$(echo $node_name | tr '[:lower:]-' '[:upper:]_')"
    bootnode=${!env_var} # Use indirect expansion to get the value of the dynamically generated env var
    
    echo $port $node_name
    echo $bootnode:$port
    
    ./devp2p discv4 crawl --addr 0.0.0.0:$port -timeout "$QUAI_DNS_DISCV4_CRAWLTIME" --bootnodes $bootnode all-nodes/all-$node_name.json & 
    pids[${i}]=$!
    echo pids
done

for net in "${arr[@]}"
do
    set -- $net
    port=$1
    node_name=$2
    
    jq 'to_entries | sort_by(-.value.score) | from_entries' all-nodes/all-$node_name.json > tmp_file.tmp && mv tmp_file.tmp all-nodes/all-$node_name.json
done



# wait for all pids
for pid in ${pids[*]}; do
    wait $pid
done

QUAI_DNS_DISCV4_KEY_PUBLICINFO="$(cat $QUAI_DNS_DISCV4_KEYPASS_PATH | ./key-util inspect $QUAI_DNS_DISCV4_KEY_PATH | grep -E '(Addr|Pub)')"
git add .
git -c user.name="ci" -c user.email='ci@dominantstrategies.io' commit --author 'crawler <>' -m "ci update (all.json) $GITHUB_RUN_ID:$GITHUB_RUN_NUMBER"

echo "Crawltime: $QUAI_DNS_DISCV4_CRAWLTIME"
echo "$QUAI_DNS_DISCV4_KEY_PUBLICINFO"
