// SPDX-License-Identifier: MIT
pragma solidity ^0.7.5;
pragma abicoder v2;

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

    event transferRequestCreated(uint _id, uint _amnount, address _initiator, address _reciver);
    event ApprovalReceived(uint _id, uint _approvals, address _approver);
    event TransferApproved(uint _id);

    Transfer[] transferRequest;

    function createTransfer(uint _amount, address payable _receiver) public onlyOnwers{
        emit transferRequestCreated(transferRequest.length, _amount, msg.sender, _receiver);
        transferRequest.push(Transfer(_amount, _receiver, 0, false, transferRequest.length));
    }

    mapping (address => mapping (uint => bool)) approvals;

    function approve(uint _id) public onlyOnwers{
        require(transferRequest[_id].hasBeensend == false);
        require(approvals[msg.sender][_id] == false, "You already voted.");

        approvals[msg.sender][_id] == true;
        transferRequest[_id].approvals++;

        emit ApprovalReceived(_id, transferRequest[_id].approvals, msg.sender);

        if(transferRequest[_id].approvals >= limit) {
        transferRequest[_id].hasBeensend = true;
        transferRequest[_id].receiver.transfer(transferRequest[_id].amount);
        emit TransferApproved(_id);
        }
    }
    function getTransferRedquest() public view returns (Transfer[] memory) {
        return transferRequest;
    }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }
    

    mapping(address => uint) balance;
    event balancedAdded(uint amount, address depositeTo);
    function Deposit() payable public returns (uint){
        balance[msg.sender] += msg.value;
        emit balancedAdded(msg.value, msg.sender);
        return balance[msg.sender];
    }

    
}