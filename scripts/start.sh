#!/bin/bash

source $HOME/scripts/install.sh

pm2 start $HOME/scripts/es_start.sh --name elasticsearch

source $HOME/scripts/es_pwd_set.sh

mv $HOME/scripts/vector_index_eth_denver_dataset.py  $HOME/openkaito/scripts/vector_index_eth_denver_dataset.py

pm2 start $HOME/pm2.json

echo "START DONE!"

tail -f /dev/null
