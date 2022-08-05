// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract VRFv2Consumer is Ownable, VRFConsumerBaseV2 {
    address private constant VRF_COORDINATOR =
        0x6168499c0cFfCaCD319c818142124B7A15E857ab;
    bytes32 private constant KEY_HASH =
        0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc;
    uint64 private constant SUBSCRIPTION_ID = 9795;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant CALLBACK_GAS_LIMIT = 100000;
    uint32 private constant NUM_WORDS = 1;

    VRFCoordinatorV2Interface private coordinator;

    uint256 private maxNumber = 10;

    constructor() Ownable() VRFConsumerBaseV2(VRF_COORDINATOR) {
        coordinator = VRFCoordinatorV2Interface(VRF_COORDINATOR);
    }

    function requestRandomNumber(uint256 _maxNumber) internal onlyOwner {
        coordinator.requestRandomWords(
            KEY_HASH,
            SUBSCRIPTION_ID,
            REQUEST_CONFIRMATIONS,
            CALLBACK_GAS_LIMIT,
            NUM_WORDS
        );

        maxNumber = _maxNumber;
    }

    function fulfillRandomNumber(uint256 _randomNumber) internal virtual {}

    function fulfillRandomWords(
        uint256, /*_requestId*/
        uint256[] memory _randomWords
    ) internal override {
        fulfillRandomNumber(_randomWords[0] % maxNumber);
    }
}
