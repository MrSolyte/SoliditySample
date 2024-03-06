// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract lottery {

    // Events
    event PlayerEntered(address indexed player, uint amount);
    event WinnerSelected(address indexed winner, uint amount);



    // State variables
    address public owner; // Address of the owner of the contract
    address payable[] public players; // Array to store addresses of players
    uint public lotteryId; // Current lottery ID
    uint public entryFee;
    bool public lotteryOpen;

    mapping(uint => address payable) lotteryHistory; // Mapping to store lottery history by ID

    // Constructor
    constructor() {
        owner = msg.sender; // Set the owner of the contract to the deployer
        lotteryId = 1; // Initialize lottery ID to 1
        lotteryOpen = true;
    }

    // Modifier to restrict access to only the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function"); // Ensure only the owner can call the function
        _;
    }

    // Function to get the winner address by lottery ID
    function getWinnerBylottery(uint lotteryAddress) public view returns (address payable) {
        return lotteryHistory[lotteryAddress]; // Return the address of the winner for a given lottery ID
    } 

    // Function to get the balance of the contract
    function getBalance() public view returns(uint) {
        return address(this).balance; // Return the balance of the contract
    }

    // Function to get the array of players
    function getPlayer() public view returns(address payable[] memory) {
        return players; // Return the array of player addresses
    }

    // Function for players to enter the lottery by sending ether
    function enter() public payable {
        require(msg.value > 0.01 ether, "Insufficient value to enter the lottery"); // Require a minimum value of ether to enter the lottery

        // Add the address of the player to the players array
        players.push(payable(msg.sender));

          // Emit event
        emit PlayerEntered(msg.sender, msg.value);
    }

    // Function to generate a random number, only callable by the owner
    function getRandomNumber() onlyOwner public view returns(uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp))); // Generate a random number using owner's address, block difficulty, and timestamp
    }

    // Function to pick a winner, only callable by the owner
    function pickWinner() public onlyOwner {
         require(lotteryOpen == false, "Lottery is still open");
        // Generate a random index based on the number of players
        uint index = getRandomNumber() % players.length;

        // Transfer the contract balance to the winner
        players[index].transfer(address(this).balance);

         // Emit event
        emit WinnerSelected(players[index], address(this).balance);

        // Increment lottery ID
        lotteryId++;

        // Record the winner in lottery history
        lotteryHistory[lotteryId] = players[index];

        // Reset the state of the contract by creating a new empty players array
        players = new address payable[](0);

         // Reset the state of the contract
        delete players;
        lotteryOpen = true;
    }


          // Function to close the lottery, only callable by the owner
     function closeLottery() public onlyOwner {
        require(lotteryOpen, "Lottery is already closed");
        lotteryOpen = false;
    }


       

       
    }

