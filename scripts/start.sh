#!/bin/bash

source $HOME/scripts/install.sh

pm2 start $HOME/scripts/es_start.sh --name elasticsearch

source $HOME/scripts/es_pwd_set.sh

source $HOME/scripts/es_restore.sh

cp $HOME/scripts/vector_index_eth_*.py  $HOME/openkaito/scripts/

pm2 start $HOME/pm2.json

echo "START DONE!"

tail -f /dev/null
