function init_bt_keys_test() {
    btcli wallet regen_coldkeypub --wallet.name test --ss58 5FL7xvCWHVzuPzz69HXBtxzgTrXbNbXwXw6yX64G5X2xwBhJ --overwrite_coldkey true

    if [ "$MINER_ID" = "default" ]; then
        btcli w regen_hotkey --wallet.name test --wallet.hotkey default --mnemonic crisp deer brick bunker anger burger panic human lake ozone loud tip --overwrite_hotkey
    fi
}
