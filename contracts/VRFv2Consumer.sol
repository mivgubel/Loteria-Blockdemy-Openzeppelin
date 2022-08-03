// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract VRFv2Consumer is Ownable, VRFConsumerBaseV2 {

  uint16 private constant REQUEST_CONFIRMATIONS = 3;
  uint32 private constant NUM_WORDS = 1;

  VRFCoordinatorV2Interface private coordinator;
  bytes32 private keyHash;
  uint64 private subscriptionId;

  uint256 private maxNumber = 10;

  constructor(address _vrfCoordinator, bytes32 _keyHash, uint64 _subscriptionId) Ownable() VRFConsumerBaseV2(_vrfCoordinator) {

    coordinator = VRFCoordinatorV2Interface(_vrfCoordinator);
    keyHash = _keyHash;
    subscriptionId = _subscriptionId;

  }

  function requestRandomNumber(uint32 _callbackGasLimit, uint256 _maxNumber) internal onlyOwner {

    coordinator.requestRandomWords(
      keyHash,
      subscriptionId,
      REQUEST_CONFIRMATIONS,
      _callbackGasLimit,
      NUM_WORDS
    );

    maxNumber = _maxNumber;

  }

  function fulfillRandomNumber(uint256 _randomNumber) internal virtual {}

  function fulfillRandomWords(uint256 /*_requestId*/, uint256[] memory _randomWords) internal override {

    fulfillRandomNumber(_randomWords[0] % maxNumber);

  }

}