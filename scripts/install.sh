#!/bin/bash

source $HOME/scripts/keys_test.sh
source $HOME/scripts/keys_idea1.sh
source $HOME/scripts/keys_idea2.sh
source $HOME/scripts/create_pm2_config.sh
source $HOME/scripts/elasticsearch_install.sh

check_env_variable() {
    if [ -z "${!1}" ]; then
        echo "Error: Environment variable '$1' is not set."
        exit 1
    fi
}

check_env_variable "WALLET_NAME" $WALLET_NAME

# Create the virtual environment
python3 -m venv $HOME/

# Activate the virtual environment
source $HOME/bin/activate

# Add the activation command to .bashrc
echo "source $HOME/bin/activate" >> $HOME/.bashrc

# Update PATH
echo 'export PATH=$PATH:$HOME/.local/bin' >> $HOME/.bashrc

# Clone and install Bittensor
cd $HOME
git clone https://github.com/opentensor/bittensor.git
cd bittensor
pip install -e .

cd $HOME
git clone https://github.com/OpenKaito/openkaito.git
cd openkaito
pip3 install -e .

pip install --upgrade transformers

if [ "$WALLET_NAME" = "idea1" ]; then
    keys_idea1
elif [ "$WALLET_NAME" = "idea2" ]; then
    keys_idea2
elif [ "$WALLET_NAME" = "test" ]; then
    keys_test
else
    echo "Error: WALLET_NAME does not match any conditions."
    exit 1
fi

echo "INSTALL DONE!"
