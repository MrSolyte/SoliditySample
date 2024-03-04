// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract vendingMachine {
    // State variables
    address public owner; // Address of the contract owner
    mapping(address => uint) public DonutBalances; // Mapping of user addresses to their donut balances
    mapping(address => uint) public totalEtherSpent; // Mapping of user addresses to total ether spent on donuts
    uint public totalEtherReceived; // Total ether received by the contract

    // Constructor
    constructor(){
        owner = msg.sender; // Set the contract owner as the deployer of the contract
        DonutBalances[address(this)] = 100; // Initial donut balance of the contract
    }

    // Function to get the contract's current donut balance
    function getVendingMachineBalance() public view returns (uint){
        return DonutBalances[address(this)]; // Return the contract's current donut balance
    }

    // Function to restock the donut supply of the vending machine
    function restock(uint amount) public {
        require(msg.sender == owner, "Only the owner can restock this machine"); // Only the owner can restock
        DonutBalances[address(this)] += amount; // Increase the donut balance of the vending machine
    }

    // Function to allow users to purchase donuts
    function purchase(uint amount) public payable {
        require(msg.value >= amount * 2 ether, "You must pay at least 2 ether per donut"); // Minimum payment requirement
        require(DonutBalances[address(this)] >= amount, "Not enough donuts in stock to fulfill purchase request"); // Check donut availability

        // Update donut balances
        DonutBalances[address(this)] -= amount; // Decrease donut balance of the vending machine
        DonutBalances[msg.sender] += amount; // Increase donut balance of the user

        // Update total ether spent and received
        totalEtherSpent[msg.sender] += msg.value; // Update total ether spent by the user
        totalEtherReceived += msg.value; // Update total ether received by the contract
    }
}
