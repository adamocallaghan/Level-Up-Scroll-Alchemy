-include .env

# =========================
# === SCRIPT DEPLOYMENT ===
# =========================

deploy-to-scroll:
	forge script script/DeployToScroll.s.sol:DeployToScroll --broadcast --verify --etherscan-api-key $(SCROLL_ETHERSCAN_API_KEY) --rpc-url $(SCROLL_SEPOLIA_RPC) --account deployer -vvvvv

# ==============================
# === OPEN SETTLEMENT WINDOW ===
# ==============================

open-settlement-window:
	cast send $(LIQUIMARKETS_ADDRESS_SCROLL) --rpc-url $(SCROLL_SEPOLIA_RPC) "setSettlementOpenTimestamp(uint256)" 1727452345 --account deployer

# ============================
# === SET SETTLEMENT TOKEN ===
# ============================

set-settlement-token:
	cast send $(LIQUIMARKETS_ADDRESS_SCROLL) --rpc-url $(SCROLL_SEPOLIA_RPC) "setLiquidTokenContractAddress(address)" $(SCROLL_TOKEN) --account deployer

# ==========================================
# === GET BALANCE OF LIQUID SCROLL MARKS ===
# ==========================================

call-balance-of:
	cast call $(LIQUIMARKETS_ADDRESS_SCROLL) --rpc-url $(SCROLL_SEPOLIA_RPC) "balanceOf(address)(uint)" $(DEPLOYER_PUBLIC_ADDRESS) --account deployer

get-liquid-token-address:
	cast call $(LIQUIMARKETS_ADDRESS_SCROLL) --rpc-url $(SCROLL_SEPOLIA_RPC) "liquidToken()(address)" --account deployer