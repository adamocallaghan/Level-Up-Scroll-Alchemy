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

    Offer[] offers; // array of offers

    address public liquidToken; // liquid token for user durign settlement

    uint256 public settlementOpenTimestamp;

    // ==============
    // === ERRORS ===
    // ==============

    error Error__OfferIsNotOpen();
    error Error__InsufficientEthSentToPurchaseTokens();
    error Error__YouAreNotTheSellerOfThisOffer();
    error Error__YouAreNotTheBuyerOfThisOffer();
    error Error__SettlementNotYetOpen();

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
            Offer({
                points: _points,
                seller: msg.sender,
                sellerCollateral: msg.value,
                buyer: address(0),
                buyerCollateral: 0,
                status: Offer_Status.OPEN
            })
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

        // check that msg.sender is the Seller
        if (offer.seller != msg.sender) {
            revert Error__YouAreNotTheSellerOfThisOffer();
        }

        // check if Offer status is 'OPEN'
        if (offer.status != Offer_Status.OPEN) {
            revert Error__OfferIsNotOpen();
        }

        offer.status = Offer_Status.CANCELLED; // set status to CANCELLED

        // transfer ETH back to Seller
        (bool sent,) = offer.seller.call{value: offer.sellerCollateral}("");
        require(sent, "Failed to send Ether");

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

    function settle(uint256 _offerIndex) public {
        // get the Offer
        Offer storage offer = offers[_offerIndex];

        // check that msg.sender is the Seller
        if (offer.seller != msg.sender) {
            revert Error__YouAreNotTheSellerOfThisOffer();
        }

        // settlement must be open
        if (settlementOpenTimestamp < block.timestamp) {
            revert Error__SettlementNotYetOpen();
        }

        // Seller must transfer the exact amont of tokens to this contract
        ERC20(liquidToken).transferFrom(msg.sender, address(this), offer.points);

        offer.status = Offer_Status.SETTLED; // set status to SETTLED

        // checks done, liquidTokens transfered to this contract = release collateral & payment
        (bool sent,) = offer.seller.call{value: offer.sellerCollateral + offer.buyerCollateral}("");
        require(sent, "Failed to send Ether");

        emit OfferSettled();
    }

    function claimTokens(uint256 _offerIndex) public {
        // get the Offer
        Offer storage offer = offers[_offerIndex];

        // check that msg.sender is the Buyer
        if (offer.buyer != msg.sender) {
            revert Error__YouAreNotTheBuyerOfThisOffer();
        }

        // settlement must be open
        if (settlementOpenTimestamp < block.timestamp) {
            revert Error__SettlementNotYetOpen();
        }

        // Seller must transfer the exact amont of shares to this contract
        ERC20(address(this)).transferFrom(msg.sender, address(this), offer.points);

        // burn the shares
        burnSharesFromBuyer(offer.points);

        // transfer the liquidTokens to the Buyer
        ERC20(liquidToken).transfer(msg.sender, offer.points);

        emit TokensClaimed();
    }

    // =======================
    // === ADMIN FUNCTIONS ===
    // =======================

    function setLiquidTokenContractAddress(address _liquidToken) public onlyOwner {
        liquidToken == _liquidToken;
    }

    function setSettlementOpenTimestamp(uint256 _timestamp) public onlyOwner {
        settlementOpenTimestamp = _timestamp;
    }
}
