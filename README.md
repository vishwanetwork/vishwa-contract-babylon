# CosmWasm Starter Pack

This is a template to build smart contracts in Rust to run inside a
[Cosmos SDK](https://github.com/cosmos/cosmos-sdk) module on all chains that enable it.
To understand the framework better, please read the overview in the
[cosmwasm repo](https://github.com/CosmWasm/cosmwasm/blob/master/README.md),
and dig into the [cosmwasm docs](https://www.cosmwasm.com).
This assumes you understand the theory and just want to get coding.

## Creating a new repo from template

Assuming you have a recent version of Rust and Cargo installed
(via [rustup](https://rustup.rs/)),
then the following should get you a new repo to start a contract:

Install [cargo-generate](https://github.com/ashleygwilliams/cargo-generate) and cargo-run-script.
Unless you did that before, run this line now:

```sh
cargo install cargo-generate --features vendored-openssl
cargo install cargo-run-script
```

Now, use it to create your new contract.
Go to the folder in which you want to place it and run:

**Latest**

```sh
cargo generate --git https://github.com/CosmWasm/cw-template.git --name PROJECT_NAME
```

For cloning minimal code repo:

```sh
cargo generate --git https://github.com/CosmWasm/cw-template.git --name PROJECT_NAME -d minimal=true
```

You will now have a new folder called `PROJECT_NAME` (I hope you changed that to something else)
containing a simple working contract and build system that you can customize.

## Create a Repo

After generating, you have a initialized local git repo, but no commits, and no remote.
Go to a server (eg. github) and create a new upstream repo (called `YOUR-GIT-URL` below).
Then run the following:

```sh
# this is needed to create a valid Cargo.lock file (see below)
cargo check
git branch -M main
git add .
git commit -m 'Initial Commit'
git remote add origin YOUR-GIT-URL
git push -u origin main
```

## depoly

### env
```
export homeDir="$HOME/.babylond"
export chainId="euphrates-0.5.0"
export feeToken="ubbn"
export key="test-spending-key"
export keyringBackend="--keyring-backend=test"
export nodeUrl="https://rpc-euphrates.devnet.babylonlabs.io"
export apiUrl="https://lcd-euphrates.devnet.babylonlabs.io"
```

### import wallet
```
babylond keys import $key /code/config/mywallet.key
```

### get balance wallet
```
babylond query bank balances user --node https://rpc-euphrates.devnet.babylonlabs.io
or
babylond query bank balances $key --node $nodeUrl
```

### deploy contract
```
babylond tx wasm store /code/artifacts/bridge_contract_cosmos.wasm --from=$key --gas=auto --gas-prices=1$feeToken --gas-adjustment=1.3 --chain-id="$chainId" -b=sync --yes $keyringBackend --log_format=json --home=$homeDir --node=$nodeUrl
```
### get code id
curl -s -X GET "$apiUrl/cosmwasm/wasm/v1/code" -H "accept: application/json" | jq -r '.'
codeId=xxx
###
instantiate config
{
  "name": "Vishwa BTC",
  "symbol": "vBTC",
  "decimals": 8,
  "initial_balances": [
    {
      "address": "bbn1789kuzxqn6qpaydpmcnlacl2j33vngn2mv3fym",
      "amount": "1000000000000"
    }
  ],
  "mint": {
    "minter": "bbn1789kuzxqn6qpaydpmcnlacl2j33vngn2mv3fym",
    "cap": "2100000000000000"
  },
  "marketing": {
    "project": "Vishwa BTC",
    "description": "This is an example token for demonstration.",
    "logo": null
  }
}
```
babylond tx wasm instantiate $codeId "{\"name\":\"Vishwa BTC\",\"symbol\":\"vBTC\",\"decimals\":8,\"initial_balances\":[{\"address\":\"bbn1789kuzxqn6qpaydpmcnlacl2j33vngn2mv3fym\",\"amount\":\"100000000000\"}],\"mint\":{\"minter\":\"bbn1789kuzxqn6qpaydpmcnlacl2j33vngn2mv3fym\",\"cap\":\"2100000000000000\"},\"marketing\":{\"project\":\"Vishwa BTC\",\"description\":\"This is an example token for demonstration.\"}}" --from=$key --no-admin --label="vishwa-bridge" --gas=auto --gas-prices=1$feeToken --gas-adjustment=1.3 --chain-id="$chainId" -b=sync --yes $keyringBackend --log_format=json --home=$homeDir --node=$nodeUrl
```

### get contract address
```
curl -s -X GET "$apiUrl/cosmwasm/wasm/v1/code/$codeId/contracts" -H "accept: application/json" | jq -r '.'
```
### execute mint
```
executeMsg="{ \"mint\": { \"recipient\": \"bbn1789kuzxqn6qpaydpmcnlacl2j33vngn2mv3fym\", \"amount\": \"1000000\" } }"

babylond tx wasm execute $address "$executeMsg" --from=$key --gas=auto --gas-prices=1$feeToken --gas-adjustment=1.3 --chain-id="$chainId" -b=sync --yes $keyringBackend --log_format=json --home=$homeDir --node=$nodeUrl
```

### execute burn
```
executeBurnMsg="{ \"burn\": { \"amount\": \"100\" } }"

babylond tx wasm execute $address "$executeBurnMsg" --from=$key --gas=auto --gas-prices=1$feeToken --gas-adjustment=1.3 --chain-id="$chainId" -b=sync --yes $keyringBackend --log_format=json --home=$homeDir --node=$nodeUrl
```

### get mint balacne
queryBalanceMsg="{\"balance\": {\"address\": \"bbn1789kuzxqn6qpaydpmcnlacl2j33vngn2mv3fym\"}}"
```
babylond query wasm contract-state smart $address "$queryBalanceMsg" --node=$nodeUrl -o json | jq -r '.'
```


