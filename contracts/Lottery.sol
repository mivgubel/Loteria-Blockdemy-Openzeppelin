// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

// import openzeppelin contracts
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// import chainlink VRF contract
import "./VRFv2Consumer.sol";

contract Lottery is Pausable, Ownable, VRFv2Consumer {
    address payable[] public players; // list of the players
    uint256 public lotteryId;
    mapping(uint256 => address payable) public lotteryHistory; // This is to track the winners
    uint256 public index;

    //Declare an RandomNumber Event
    event RandomNumber();

    // call to VRFv2Consumer construct
    constructor() VRFv2Consumer() {
        lotteryId = 1; // starting lottery with id 1, then we're gonna increment it on pickWinner function.
        index = 0;
    }

    function getWinnerByLottery(uint256 lottery)
        public
        view
        returns (address payable)
    {
        return lotteryHistory[lottery];
    }

    function getBalance() public view whenNotPaused returns (uint256) {
        // getting lottery balance
        return address(this).balance;
    }

    function getPlayers()
        public
        view
        whenNotPaused
        returns (address payable[] memory)
    {
        // getting the players
        return players;
    }

    function enter() public payable {
        // function for the persons that entered in our lottery
        require(msg.value > .01 ether); // this is the amount of ether that the person has to have to enter the lottery

        // adding address of player entering lottery to the players array
        players.push(payable(msg.sender)); // this is the address of the person who call this function and wants to you the lottery
    }

    // function to request a random number from chainlink VRF
    function getRandomNumber() public onlyOwner {
        requestRandomNumber(players.length);
    }

    function pickWinner() public onlyOwner {
        require(index > 0);

        players[index - 1].transfer(address(this).balance); // transfering the balance of thr current smart contract to the winner

        lotteryHistory[lotteryId] = players[index - 1]; // tracking the winners
        lotteryId++; // incrementing the lottery id after reset the players array and transfer the funds to the winner

        // reset contract status because winner has been paid, that way we can play another round with new players
        players = new address payable[](0);
        index = 0;
    }

    //  callback that chainlink VRF calls after a random number is generated
    function fulfillRandomNumber(uint256 _randomNumber) internal override {
        index = _randomNumber + 1;

        emit RandomNumber();
    }
}
