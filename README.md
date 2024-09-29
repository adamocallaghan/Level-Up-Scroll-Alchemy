# LiquiMarkets: Points & Marks Marketplace

**A marketplace that allows counterparties to buy & sell illiquid points and tokens, or to make those positions semi-liquid**

## Built with...

- Alchemy
- Scroll
- Foundry
- OpenZeppelin

## How it works...

### Sellers:

- create an 'Offer' for the amount of points, marks, or other illiquid tokens they want to sell - and at what price (in ETH).
- provide collateral to the value of those points (used as insurance against defaulting on agreed offer).

### Buyers:

- accept an Offer by providing the full purchase price (in ETH).
- 'shares' are minted to the user for the exact amount of points/marks they are purchasing (creating a semi-liquid position)

### Settlement:

Sellers...

- within 24 hours of the TGE (token generation event) for the tokens being sold, the Seller must deposit the correct number of tokens into the LiquiMarkets contract
- when this is complete the Seller can then claim their payment (the Buyers' deposited ETH) alongside their own collateral
- failure to deposit the correct number of tokens within 24 hours of TGE results in the Sellers collateral being at risk of forfeiture

Buyers...

- once a Seller has deposited the full amount of tokens the Buyer has purchased, the tokens become available to Claim by the Buyer.
- in order to Claim these tokens, the Buyer must deposit the same amount of 'shares' into the LiquiMarkets contract, which are then burned.

## Live Deployment

- LiquiMarkets contract is deployed to Scroll Sepolia testnet here: 0x90C73a89b338894eB2fA41B7cd5D9e9D5e27C98D
- Scroll (mock) token - for settlement demonstration purposes - is deployed here: 0x0b0204de68eAf43b339a27eB508D18624b0349dF

- LiquiMarkets frontend is deployed via Vercel at: https://liquimarkets-ui.vercel.app/
- (Feel free to create an accept offers once you have some Scroll Sepolia testnet ETH in your wallet!)

## How to Deploy

To deploy the LiquiMarkets contract yourself...

- clone the repo to your local machine (you should have Foundry and your code editor installed already)
- create a .env file based on the sample .example.env file provided...
  - add your **Alchemy API key** for the Scroll Sepolia testnet to the .env file variable "SCROLL_SEPOLIA_RPC"
  - add your **Scrollscan API key** to the .env file variable "SCROLL_ETHERSCAN_API_KEY" (for verifying contracts)
  - add your **wallet private key** to the .env file variable "DEPLOYER_PRIVATE_KEY"
  - add your **wallet public address** to the .env file variable "DEPLOYER_PUBLIC_ADDRESS"
- the Makefile contains the commands to call the deployment script...
  - run `make deploy-to-scroll` to run the _DeployToScroll.s.sol_ script; this script
    - deploys the LiquiMarkets contract to Scroll Sepolia
    - deploys the Scroll (mock) token to Scroll Sepolia
    - mints 10,000 $SRCL (mock) tokens for later use in settling accepted offers
    - **Note:** if re-deploying the contracts make sure to change the create2 'salt' in the _DeployToScroll.s.sol_ script each time
  - paste your deployed LiquiMarkets and Scroll token addresses into the .env variables
  - run `make open-settlement-window` and `make set-settlement-token` to enable settlements on the contract

**Note:** the LiquiMarkets contract is point and token-agnostic, and can be used for any points program, locked positions, or even OTC agreements; to do this just change the constructor arguments for the LiquiMarkets contract in the _DeployToScroll.s.sol_ file, and change the token name/symbol in the ScrollToken.sol file.
