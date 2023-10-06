// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;



interface IZBondPool {

	// supported pool currency
	function getZRC20() view external returns (address _zrc20);

	// full balance of bonds held by the holder
	function getBalance(address _holder) view external returns (uint256 _balance);

	// deposit returns bond id 
	function deposit(address _owner, uint256 _amount) external payable returns (address _zBondContract, uint256 _bondId);

	// withdraw burns the given bond and issues the currency to the recipient
	function withdraw(address _recipient, uint256 _bondId) external returns (uint256 _amountWithdrawn);

}