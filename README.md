## LiquiMarkets: Points & Marks Marketplace

** A marketplace that allows counterparties to buy & sell illiquid points and tokens, or to make those positions semi-liquid **

## Built with...

- Alchemy
- Scroll
- Foundry
- OpenZeppelin

## How it works...

# Sellers:

- create an 'Offer' for the amount of points, marks, or other illiquid tokens they want to sell - and at what price (in ETH).
- provide collateral to the value of those points (used as default insurance).

# Buyers:

- accept an Offer by providing the full purchase price (in ETH).
- 'shares' are minted to the user for the exact amount of points/marks they are purchasing (creating a semi-liquid position)

# Settlement:

Sellers...

- within 24 hours of the TGE (token generation event) for the tokens being sold, the Seller must deposit the correct number of tokens into the LiquiMarkets contract
- when this is complete the Seller can then claim their payment (the Buyers' deposited ETH) alongside their own collateral
- failure to deposit the correct number of tokens within 24 hours of TGE results in the Sellers collateral being at risk of forfeiture

Buyers...

- once a Seller has deposited the full amount of tokens the Buyer has purchased, the tokens become available to Claim by the Buyer.
- in order to Claim these tokens, the Buyer must deposit the same amount of 'shares' into the LiquiMarkets contract, which are then burned.
