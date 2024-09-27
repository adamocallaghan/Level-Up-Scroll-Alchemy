-include .env

# =========================
# === SCRIPT DEPLOYMENT ===
# =========================

deploy-to-scroll:
	forge script script/DeployToScroll.s.sol:DeployToScroll --broadcast --verify --etherscan-api-key $(SCROLL_ETHERSCAN_API_KEY) --rpc-url $(SROLL_SEPOLIA_RPC) --account deployer -vvvvv

# ==============================
# === OPEN SETTLEMENT WINDOW ===
# ==============================

open-settlement-window:
	cast send $(LIQUIMARKETS_ADDRESS_SCROLL) --rpc-url $(SCROLL_SEPOLIA_RPC) "setSettlementOpenTimestamp(uint256)" 1727452345 --account deployer

call-balance-of:
	cast call 0xd30beb5B82bd837f78f777743745B068abec8701 --rpc-url https://scroll-sepolia.g.alchemy.com/v2/LHwHYShuz3y8Y0JH0k2tx1IZy7GubR8O "balanceOf(address)" 0x64a822f980dc5f126215d75d11dd8114ed0bdb5f --account deployer

call-balance-of-with-vars:
	cast call $(LIQUIMARKETS_ADDRESS_SCROLL) --rpc-url $(SCROLL_SEPOLIA_RPC) "balanceOf(address)" $(DEPLOYER_PUBLIC_ADDRESS) --account deployer