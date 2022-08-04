// SPDX-License-Identifier: MIT

// deployed: 0x2A9e03CcE7528a1818bCa7Dd64f2759a8377FB1A

pragma solidity ^0.8.0;

contract Lottery {
    address public owner; // the address of the person who deployed the contract
    address payable[] public players; // list of the players
    uint256 public lotteryId;
    mapping(uint256 => address payable) public lotteryHistory; // This is to track the winners

    constructor() {
        owner = msg.sender; // setting the address of the person who deployed the contract.
        lotteryId = 1; // starting lottery with id 1, then we're gonna increment it on pickWinner function.
    }

    function getWinnerByLottery(uint256 lottery)
        public
        view
        returns (address payable)
    {
        return lotteryHistory[lottery];
    }

    function getBalance() public view returns (uint256) {
        // getting lottery balance
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory) {
        // getting the players
        return players;
    }

    function enter() public payable {
        // function for the persons that entered in our lottery
        require(msg.value > .01 ether); // this is the amount of ether that the person has to have to enter the lottery

        // adding address of player entering lottery to the players array
        players.push(payable(msg.sender)); // this is the address of the person who call this function and wants to you the lottery
    }

    function getRandomNumber() public view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(owner, block.timestamp))); // this is a hash algorithm which is native in solidity, we need to change this by using chainlink https://docs.chain.link/docs/intermediates-tutorial/
    }

    function pickWinner() public onlyOwner {
        // require(msg.sender == owner); // restrict the use of this function to the owner of the contract
        uint256 index = getRandomNumber() % players.length; // feel free to change this by using chainlink
        players[index].transfer(address(this).balance); // transfering the balance of thr current smart contract to the winner

        lotteryHistory[lotteryId] = players[index]; // tracking the winners
        lotteryId++; // incrementing the lottery id after reset the players array and transfer the funds to the winner

        // reset contract status because winner has been paid, that way we can play another round with new players
        players = new address payable[](0);
    }

    modifier onlyOwner() {
        // reusable modifier
        require(msg.sender == owner); // restrict the use to the owner of the contract
        _; // whatever other code is in the function this modifier is apply to, have that run after the require statement
    }
}
