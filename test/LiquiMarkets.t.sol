// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import "forge-std/Test.sol";
import {LiquiMarkets} from "../src/LiquiMarkets.sol";

struct Offer {
    uint256 points;
    address seller;
    uint256 sellerCollateral;
    address buyer;
    uint256 buyerCollateral;
    Offer_Status status;
}

enum Offer_Status {
    OPEN,
    ACCEPTED,
    SETTLED,
    DEFAULT,
    CANCELLED
}

contract LiquiMarketsTest is Test {
    LiquiMarkets public market;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    function setUp() external {
        // mint eth to bob & alice
        vm.deal(bob, 1000e18);
        vm.deal(alice, 1000e18);

        // instantiate contracts
        market = new LiquiMarkets("Liquid Scroll Marks", "liqMarks", msg.sender);
    }

    function test_createOffer() public {
        vm.startPrank(bob);
        market.createOffer{value: 1 ether}(1234);
        vm.stopPrank();

        (uint256 offerPoints,,,,,) = market.offers(0);

        assertEq(offerPoints, 1234);
    }

    function test_acceptOffer() public {
        createOffer_bob(1 ether, 5454);
        acceptOffer_alice(0);

        (,,,, uint256 sellerCollateral,) = market.offers(0);

        assertEq(sellerCollateral, 1 ether);
    }

    // ===============
    // === HELPERS ===
    // ===============

    function createOffer_bob(uint256 _etherValue, uint256 _tokensForSale) public {
        vm.startPrank(bob);
        market.createOffer{value: _etherValue}(_tokensForSale);
        vm.stopPrank();
    }

    function acceptOffer_alice(uint256 _offerIndex) public {
        vm.startPrank(alice);
        market.acceptOffer{value: 1 ether}(_offerIndex);
        vm.stopPrank();
    }
}
