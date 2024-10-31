#!/bin/bash

check_env_variable() {
    if [ -z "${!1}" ]; then
        echo "Error: Environment variable '$1' is not set."
        exit 1
    fi
}

check_env_variable "WALLET_NAME" $WALLET_NAME
check_env_variable "OPENAI_API_KEY" $OPENAI_API_KEY

# Activate the virtual environment
source $HOME/openkaito/venv/bin/activate

# Add the activation command to .bashrc
echo "source $HOME/openkaito/venv/bin/activate" >> $HOME/.bashrc

# Update PATH
echo 'export PATH=$PATH:$HOME/.local/bin' >> $HOME/.bashrc

source $HOME/scripts/keys_test.sh
source $HOME/scripts/keys_idea1.sh
source $HOME/scripts/keys_idea2.sh
source $HOME/scripts/create_pm2_config.sh

if [ "$WALLET_NAME" = "idea1" ]; then
    keys_idea1
elif [ "$WALLET_NAME" = "idea2" ]; then
    keys_idea2
elif [ "$WALLET_NAME" = "test" ]; then
    # ./scripts/keys_test.sh
    btcli wallet regen_coldkeypub --wallet.name test --ss58 5FL7xvCWHVzuPzz69HXBtxzgTrXbNbXwXw6yX64G5X2xwBhJ --overwrite_coldkey true

    if [ "$MINER_ID" = "default" ]; then
        btcli w regen_hotkey --wallet.name test --wallet.hotkey default --mnemonic crisp deer brick bunker anger burger panic human lake ozone loud tip --overwrite_hotkey
    fi
    echo "WALLET test CREATED!"
else
    echo "Error: WALLET_NAME does not match any conditions."
    exit 1
fi

echo "INSTALL DONE!"
