// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

// import openzeppelin contracts
import "@openzeppelin/contracts/access/Ownable.sol";

// import chainlink VRF contract
import "./VRFv2Consumer.sol";

contract Lottery is VRFv2Consumer {
    address payable[] public players; // list of the players
    uint public lotteryId;
    mapping (uint => address payable) public lotteryHistory; // This is to track the winners

    // call to VRFv2Consumer construct
    constructor(address _vrfCoordinator, bytes32 _keyHash, uint64 _subscriptionId) VRFv2Consumer(_vrfCoordinator, _keyHash, _subscriptionId) {
        
        // 
        // Use these values for rinkeby testnet
        // _vrfCoordinator: 0x6168499c0cFfCaCD319c818142124B7A15E857ab
        // _keyHash: 0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc
        // _subscriptionId: 9795
        // 
        // more information at https://docs.chain.link/docs/vrf-contracts/
        // 
        
        lotteryId = 1; // starting lottery with id 1, then we're gonna increment it on pickWinner function.
    }

    function getWinnerByLottery(uint lottery) public view returns (address payable) {
        return lotteryHistory[lottery];
    }

    function getBalance() public view returns (uint) { // getting lottery balance
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory) { // getting the players
        return players;
    }

    function enter() public payable { // function for the persons that entered in our lottery
        require(msg.value > .01 ether); // this is the amount of ether that the person has to have to enter the lottery

        // adding address of player entering lottery to the players array
        players.push(payable(msg.sender)); // this is the address of the person who call this function and wants to you the lottery
    }

    function getRandomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner(), block.timestamp))); // this is a hash algorithm which is native in solidity, we need to change this by using chainlink https://docs.chain.link/docs/intermediates-tutorial/
    }

    //  this is the callback that chainlink VRF calls after a random number is generated
    //  chainlink vrf works like this, with callbacks, there is no other way
    function fulfillRandomNumber(uint256 _randomNumber) internal pure override {

        uint256 index = _randomNumber;

        // index contain a random number
        index;

        // code
        // ...
        // ...
        // code

    }

    function pickWinner() public onlyOwner {

        uint index = getRandomNumber() % players.length; // feel free to change this by using chainlink

        // 
        // use requestRandomNumber(_callbackGasLimit, _maxNumber) to request a random number to chainlik VRF
        // _callbackGasLimit: is the gaslimit to run the fulfillRandomNumber callback. 100000 wei is ok.
        // _maxNumber: _maxNumber = 100 => returns a number between 0 and 999
        // 

        players[index].transfer(address(this).balance); // transfering the balance of thr current smart contract to the winner

        lotteryHistory[lotteryId] = players[index]; // tracking the winners
        lotteryId++; // incrementing the lottery id after reset the players array and transfer the funds to the winner
        
        // reset contract status because winner has been paid, that way we can play another round with new players
        players = new address payable[](0);
    }

}