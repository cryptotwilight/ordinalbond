// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;

interface IZBondTeleporter { 

	// teleports the bond cross chain, bond has to be held by the caller
	function teleportBond(address _zBondContract, uint256 _bondId, uint256 _chainId) external payable returns (uint256 _transferTimestamp);
	
	// manifests the given transfer amount as a zBond
	function manifestBond(uint256 _chainId, address _erc20, uint256 _amount) external payable returns (uint256 _bondId, address _zBondContract);

}