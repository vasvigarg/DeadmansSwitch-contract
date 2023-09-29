// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeadmansSwitch {
    address private owner;
    address private beneficiary;
    uint private lastActiveBlock;

    event SwitchTriggered(address indexed owner, address indexed beneficiary, uint timestamp);

    constructor(address _beneficiary) {
        owner = msg.sender;
        beneficiary = _beneficiary;
        lastActiveBlock = block.number;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    function still_alive() external onlyOwner {
        lastActiveBlock = block.number;
    }

    function checkSwitch() external {
    require(block.number - lastActiveBlock > 10, "Switch can only be triggered if inactive for 10 blocks");
    uint contractBalance = address(this).balance; 
    require(contractBalance > 0, "No balance to transfer");
    (bool success, ) = payable(beneficiary).call{value: contractBalance}("");
    require(success, "Transfer failed");
    emit SwitchTriggered(owner, beneficiary, block.timestamp);
    }

}
