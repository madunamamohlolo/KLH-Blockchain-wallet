// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmartWallet {
    address public owner;

    // Restrict access to only the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    // Constructor to set the contract owner as the creator of the contract
    constructor() {
        owner = msg.sender;
    }

    // Function to deposit ether into the contract
    function deposit() public payable {}

    // Function to withdraw a specific amount of ether by the owner
    function withdraw(uint _amount) public onlyOwner {
        require(address(this).balance >= _amount, "Insufficient balance");
        payable(owner).transfer(_amount);
    }

    // Function to send ether to another address
    function sendEther(address payable _to, uint _amount) public onlyOwner {
        require(address(this).balance >= _amount, "Insufficient balance");
        _to.transfer(_amount);
    }

    // Function to get the current balance of the contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}