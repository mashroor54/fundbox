
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title FundBox - A simple contract to collect and allocate public funds
/// @author 
/// @notice Anyone can contribute funds. Only the owner can allocate them.

contract FundBox {
    address public owner;          // Contract owner (deployer)
    uint256 public totalFunds;     // Total funds collected
    mapping(address => uint256) public contributions; // Track how much each person contributed

    event FundReceived(address indexed from, uint256 amount);
    event FundsAllocated(address indexed to, uint256 amount);

    constructor() {
        owner = msg.sender; // Deployer becomes owner
    }

    /// @notice Function to receive funds
    receive() external payable {
        require(msg.value > 0, "Send some Ether!");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;

        emit FundReceived(msg.sender, msg.value);
    }

    /// @notice Owner can allocate funds to any address
    /// @param _to The recipient address
    /// @param _amount The amount to send
    function allocateFunds(address payable _to, uint256 _amount) external {
        require(msg.sender == owner, "Only owner can allocate funds");
        require(_amount <= address(this).balance, "Insufficient balance");

        _to.transfer(_amount);
        totalFunds -= _amount;

        emit FundsAllocated(_to, _amount);
    }

    /// @notice Get the current balance of the contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
