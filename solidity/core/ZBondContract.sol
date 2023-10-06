// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;

import "../interfaces/IRegister.sol";
import "../interfaces/IZBondContract.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";


contract ZBondContract is ERC721, IZBondContract { 

	string constant MINTER = "Z_BOND_MINTER";
	string constant BURNER = "Z_BOND_BURNER";

	IRegister register; 
	uint256 index = 0; 

	mapping(uint256=>bool) knownId; 
	mapping(uint256=>ZBond) zBondById; 



	constructor(address _register) ERC721("Z - Bond", "ZBOND" ) {
		register = IRegister(_register);
	}

	// returns the value of a given bond id
	function getBond(uint256 _bondId) view external returns (ZBond memory _zbond){
		require(knownId[_bondId], "unknown bond id");
		return zBondById[_bondId];
    }

	// returns all bonds held by the caller
	function getBonds(address _holder) view external returns (uint256 [] memory _bondIds){

    }

	// mints the bond and returns it with the given bond id
	function mintBond(address _owner, address _zrc20, uint256 _amount, string memory _cover) external returns (uint256 _bondId){
		require(msg.sender == register.getAddress(MINTER), "minter only");
		_bondId = getNext(); 
		ZBond memory bond_ = ZBond({
  							id : _bondId,  
    						amount : _amount, 
							zrc20 : _zrc20,
   							uri : _cover 
								});
								zBondById[_bondId] = bond_; 
								knownId[_bondId] = true; 
		_mint(_owner, _bondId);
    }

	// burns the bond and returns the amount transferred from the pool
	function burnBond(address _holder, uint256 _bondId) external returns (uint256 _amount, address _zrc20){
		require(msg.sender == register.getAddress(BURNER), "burner only");
		require(ownerOf(_bondId) == _holder, "holder only");
		ZBond memory bond_ = zBondById[_bondId];
		delete zBondById[_bondId]; 
		delete knownId[_bondId]; 
		_burn(_bondId);
		return (bond_.amount, bond_.zrc20 );
    }


//====================================== INTERNAL ===================================

	function getNext() internal returns (uint256 _next) {
		_next = index++;
		return _next;
	}

}