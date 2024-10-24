#!/bin/bash
check_env_variable() {
    if [ -z "${!1}" ]; then
        echo "Error: Environment variable '$1' is not set."
        exit 1
    fi
}

check_env_variable "RUNPOD_TCP_PORT_70000" $RUNPOD_TCP_PORT_70000
check_env_variable "RUNPOD_PUBLIC_IP" $RUNPOD_PUBLIC_IP
check_env_variable "MINER_ID" $MINER_ID
check_env_variable "WALLET_NAME" $WALLET_NAME

echo "{" > $HOME/pm2.json
echo "  \"apps\": [" >> $HOME/pm2.json
echo "    {" >> $HOME/pm2.json
echo "      \"name\": \"miner_${WALLET_NAME}_${MINER_ID}\"," >> $HOME/pm2.json
echo "      \"script\": \"$HOME/openkaito/neurons/miner.py\"," >> $HOME/pm2.json
echo "      \"interpreter\": \"python3\"," >> $HOME/pm2.json
echo "      \"args\": \"--netuid 88 --subtensor.network test --wallet.name $WALLET_NAME --wallet.hotkey $MINER_ID --logging.debug --logging.trace --blacklist.force_validator_permit --axon.port $RUNPOD_TCP_PORT_70000\"," >> $HOME/pm2.json
echo "      \"log_date_format\": \"YYYY-MM-DD HH:mm:ss\"," >> $HOME/pm2.json
echo "      \"max_size\": \"10M\"," >> $HOME/pm2.json
echo "      \"retain\": \"5\"" >> $HOME/pm2.json
echo "    }" >> $HOME/pm2.json
echo "  ]" >> $HOME/pm2.json
echo "}" >> $HOME/pm2.json
