pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {LiquiMarkets} from "../src/LiquiMarkets.sol";
import {ScrollToken} from "../src/ScrollToken.sol";

contract DeployToScroll is Script {
    function run() external {
        // ===================
        // === SCRIPT VARS ===
        // ===================

        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        address DEPLOYER_PUBLIC_ADDRESS = vm.envAddress("DEPLOYER_PUBLIC_ADDRESS");

        // =========================
        // === SCROLL DEPLOYMENT ===
        // =========================

        console2.log("########################################");
        console2.log("######### Deploying to Scroll ##########");
        console2.log("########################################");

        vm.createSelectFork("scroll");

        vm.startBroadcast(deployerPrivateKey);

        // deploy LiquiMarkets contract
        LiquiMarkets market =
            new LiquiMarkets{salt: "bluebird"}("Liquid Scroll Marks", "liqMarks", DEPLOYER_PUBLIC_ADDRESS);

        console2.log("LiquiMarkets Address: ", address(market));

        // deploy Scroll token for settlement demonstration
        ScrollToken scroll = new ScrollToken{salt: "bluebird"}(DEPLOYER_PUBLIC_ADDRESS);

        console2.log("Scroll Token Address: ", address(scroll));

        // mint Scroll tokens to our Deployer Address for demonstation of settlement
        scroll.mintAllocation(DEPLOYER_PUBLIC_ADDRESS);

        vm.stopBroadcast();
    }
}
