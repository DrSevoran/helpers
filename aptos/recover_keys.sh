#!/bin/bash

sudo systemctl stop aptos
PEER_ID=$(sed -n 2p $HOME/aptos/identity/peer-info.yaml | sed 's/.$//'  | sed 's/://g')
PRIVATE_KEY=$(cat $HOME/aptos/identity/private-key.txt)
WAYPOINT=$(cat $HOME/aptos/waypoint.txt)
cp $HOME/aptos-core/config/src/config/test_data/public_full_node.yaml $HOME/aptos/public_full_node.yaml
/usr/local/bin/yq e -i '.full_node_networks[] +=  { "identity": {"type": "from_config", "key": "'$PRIVATE_KEY'", "peer_id": "'$PEER_ID'"} }' $HOME/aptos/public_full_node.yaml
sed -i 's|127.0.0.1|0.0.0.0|' $HOME/aptos/public_full_node.yaml
sed -i -e "s|genesis_file_location: .*|genesis_file_location: \"$HOME\/aptos\/genesis.blob\"|" $HOME/aptos/public_full_node.yaml
sed -i -e "s|data_dir: .*|data_dir: \"$HOME\/aptos\/data\"|" $HOME/aptos/public_full_node.yaml
sed -i -e "s|0:01234567890ABCDEFFEDCA098765421001234567890ABCDEFFEDCA0987654210|$WAYPOINT|" $HOME/aptos/public_full_node.yaml
sudo systemctl start aptos