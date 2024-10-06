// SPDX-License-Identifier: MIT
pragma solidity ^0.7.5;

contract MultiSig{

    address[] public owners;
    uint limit;
    constructor (address[] memory _owners, uint _limit) {
        owners = _owners;
        limit = _limit;
    }

    modifier onlyOnwers() {
        bool owner = false;
        for(uint i=0; i<=owners.length; i++){
            if(owners[i] == msg.sender){
                owner = true;
            }
        }
        require(owner == true);
        _;
    }

    struct Transfer{
        uint amount;
        address payable receiver;
        uint approvals;
        bool hasBeensend;
        uint id;
    }

    Transfer[] transferRequest;

    mapping(address => uint) balance;
    event balancedAdded(uint amount, address depositeTo);
    function Deposit() payable public returns (uint){
        balance[msg.sender] += msg.value;
        emit balancedAdded(msg.value, msg.sender);
        return balance[msg.sender];
    }

    function createTransfer(uint _amount, address payable _receiver) public onlyOnwers{
        transferRequest.push(Transfer(_amount, _receiver, 0, false, transferRequest.length));
    }
    //
}