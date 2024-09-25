// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LiquiMarkets {
    // ====================
    // === STORAGE VARS ===
    // ====================

    struct Offer {
        uint256 points;
        uint256 sellerCollateral;
        uint256 buyerCollateral;
        Offer_Status status;
    }

    enum Offer_Status {
        OPEN,
        ACCEPTED,
        SETTLED,
        DEFAULT
    }

    Offer[] offers;

    // =======================
    // === OFFER FUNCTIONS ===
    // =======================

    function createOffer(uint256 _points) public payable {
        // create Offer with points & msg.value
        offers.push(
            Offer({points: _points, sellerCollateral: msg.value, buyerCollateral: 0, status: Offer_Status.OPEN})
        );
    }

    function acceptOffer(uint256 _offerIndex) public payable {}

    function cancelOffer() public {}

    // ============================
    // === SETTLEMENT FUNCTIONS ===
    // ============================

    function settle() public {}

    function claimTokens() public {}
}
