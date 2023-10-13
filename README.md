# Token

[![Foundry][foundry-badge]][foundry]

[foundry]: https://getfoundry.sh/
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg

## How to Compile

`forge build`

## How to Lint

`forge fmt`

## How to Test

`forge test`

## How to Deploy

1. `cp .env.example .env` and fill in values

2. Update constants in `script/TokenDeploy.s.sol` if necessary.

3. Deploy
Base Testnet: `source .env && forge script script/TokenDeploy.s.sol:TokenDeployScript --force --rpc-url $BASE_GOERLI_RPC_URL --slow --broadcast --verify --delay 5 --verifier-url $VERIFIER_URL -vvvv`
Base Mainnet: `source .env && forge script script/TokenDeploy.s.sol:TokenDeployScript --force --rpc-url $BASE_RPC_URL --slow --broadcast --verify --delay 5 --verifier-url $VERIFIER_URL -vvvv`
Base Tenderly Fork: `source .env && forge script script/TokenDeploy.s.sol:TokenDeployScript --force --rpc-url $TENDERLY_FORK_RPC_URL --slow --broadcast -vvvv`

4. Upgrade
Base Testnet: `source .env && forge script script/TokenUpgrade.s.sol:TokenUpgradeScript --force --rpc-url $BASE_GOERLI_RPC_URL --slow --broadcast --verify --delay 5 --verifier-url $VERIFIER_URL -vvvv`
Base Mainnet: `source .env && forge script script/TokenUpgrade.s.sol:TokenUpgradeScript --force --rpc-url $BASE_RPC_URL --slow --broadcast --verify --delay 5 --verifier-url $VERIFIER_URL -vvvv`
Base Tenderly Fork: `source .env && forge script script/TokenUpgrade.s.sol:TokenUpgradeScript --force --rpc-url $TENDERLY_FORK_RPC_URL --slow --broadcast -vvvv`

5. Manual verification (if required)
`source .env && forge verify-contract 0x4dB264876bf878a4d0375e7640C6D10faE1dd531 src/Token.sol:Token --verifier-url $VERIFIER_URL`
## Deployment Addresses

### Base Testnet
proxy: `0x603b3d3851020559d0e684e7e77d4d978a317d9b`
implementation: `0x0768b63c1e80082D7B8310470f6a1e6FcB08408F`

### Base Mainnet
proxy: `0x5607718c64334eb5174CB2226af891a6ED82c7C6`
implementation: `0x0E09f59754b4F3695553e2f37F08CC987361fd5c`