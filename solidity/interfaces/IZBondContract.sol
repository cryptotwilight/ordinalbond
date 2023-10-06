// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;

struct ZBond { 
    uint256 id; 
    uint256 amount; 
	address zrc20; 
    string uri; 
}


interface IZBondContract { 

	// returns the value of a given bond id
	function getBond(uint256 _bondId) view external returns (ZBond memory _zbond);

	// returns all bonds held by the caller
	function getBonds(address _holder) view external returns (uint256 [] memory _bondIds);

	// mints the bond and returns it with the given bond id
	function mintBond(address _owner, uint256 _amount, string memory _cover) external returns (uint256 _bondId);

	// burns the bond and returns the amount transferred from the pool
	function burnBond(address _recipient, uint256 _bondId) external returns (uint256 _amount, address _zrc20);

}