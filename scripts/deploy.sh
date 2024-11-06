docker run --rm -it -v "$(pwd)":/code babylonlabs-io/babylond /bin/sh

# docker run --rm -it -v "$(pwd)":/code babylonlabs-io/babylond /bin/sh \
#   babylond keys add $key $keyringBackend \
#   babylond tx wasm store /code/artifacts/bridge_contract_cosmos.wasm \
#   --from=$key --gas=auto --gas-prices=1$feeToken --gas-adjustment=1.3 \
#   --chain-id="$chainId" -b=sync --yes $keyringBackend --log_format=json \
#   --home=$homeDir --node=$nodeUrl
