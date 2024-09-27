-include .env

# =========================
# === SCRIPT DEPLOYMENT ===
# =========================
deploy-to-scroll:
	forge script script/DeployToScroll.s.sol:DeployToScroll --broadcast --verify --etherscan-api-key $(SCROLL_ETHERSCAN_API_KEY) --rpc-url $(SROLL_SEPOLIA_RPC) --account deployer -vvvvv

