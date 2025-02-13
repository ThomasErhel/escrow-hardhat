// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Escrow {
	address public arbiter;
	address public beneficiary;
	address public depositor;

	bool public isApproved;

	constructor(address _arbiter, address _beneficiary) payable {
		arbiter = _arbiter;
		beneficiary = _beneficiary;
		depositor = msg.sender;
	}

	event Approved(uint);

	function approve() external {
		require(msg.sender == arbiter);
		uint balance = address(this).balance;
		(bool sent, ) = payable(beneficiary).call{value: balance}("");
 		require(sent, "Failed to send Ether");
		emit Approved(balance);
		isApproved = true;
	}

	event Canceled(uint);

	function cancel() external {
	require(msg.sender == depositor, "Only depositor can cancel");
	require(!isApproved, "Cannot cancel an approved escrow");
	uint balance = address(this).balance;
	(bool sent, ) = payable(depositor).call{value: balance}("");
	require(sent, "Failed to send Ether");
	emit Canceled(balance);
	}
}
