// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract LiquiMarkets is ERC20, Ownable {
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
        DEFAULT,
        CANCELLED
    }

    Offer[] offers;

    // ==============
    // === ERRORS ===
    // ==============

    error Error__OfferIsNotOpen();
    error Error__InsufficientEthSentToPurchaseTokens();

    // ==============
    // === EVENTS ===
    // ==============
    event OfferCreated();
    event OfferAccepted();
    event OfferCancelled();
    event OfferSettled();
    event TokensClaimed();

    constructor(string memory _name, string memory _symbol, address _owner) ERC20(_name, _symbol) Ownable(_owner) {}

    // =======================
    // === OFFER FUNCTIONS ===
    // =======================

    function createOffer(uint256 _points) public payable {
        // create Offer with points & msg.value
        offers.push(
            Offer({points: _points, sellerCollateral: msg.value, buyerCollateral: 0, status: Offer_Status.OPEN})
        );
    }

    function acceptOffer(uint256 _offerIndex) public payable {
        // get the Offer
        Offer storage offer = offers[_offerIndex];

        // check if Offer status is 'OPEN'
        if (offer.status != Offer_Status.OPEN) {
            revert Error__OfferIsNotOpen();
        }

        // check that buyer has sent the correct amount of ETH
        if (msg.value != offer.sellerCollateral) {
            revert Error__InsufficientEthSentToPurchaseTokens();
        }

        offer.status = Offer_Status.ACCEPTED; // set status to ACCEPTED
        offer.buyerCollateral = msg.value; // set buyerCollateral

        mintSharesToBuyer(offer.points); // mint shares to buyer at a 1:1 shares:points ratio

        emit OfferAccepted();
    }

    function cancelOffer(uint256 _offerIndex) public {
        // get the Offer
        Offer storage offer = offers[_offerIndex];

        // check if Offer status is 'OPEN'
        if (offer.status != Offer_Status.OPEN) {
            revert Error__OfferIsNotOpen();
        }

        offer.status = Offer_Status.CANCELLED; // set status to CANCELLED

        emit OfferCancelled();
    }

    function mintSharesToBuyer(uint256 _points) internal {
        _mint(msg.sender, _points);
    }

    function burnSharesFromBuyer(uint256 _shares) internal {
        _burn(msg.sender, _shares);
    }

    // ============================
    // === SETTLEMENT FUNCTIONS ===
    // ============================

    function settle() public {}

    function claimTokens() public {}

    // =======================
    // === ADMIN FUNCTIONS ===
    // =======================

    function setLiquidTokenContractAddress(address _token) public onlyOwner {}
}
