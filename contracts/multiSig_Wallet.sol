// SPDX-License-Identifier: MIT
pragma solidity ^0.7.5;

contract MultiSig{
    mapping(address => uint) balance;
    event balancedAdded(uint amount, address depositeTo);
    function Deposit() payable public returns (uint){
        balance[msg.sender] += msg.value;
        emit balancedAdded(msg.value, msg.sender);
        return balance[msg.sender];
    }

    address owner;
    constructor () {
        owner = msg.sender;
    }

    function getOwner() public view  returns (address)
    {
        return owner;
    }

}