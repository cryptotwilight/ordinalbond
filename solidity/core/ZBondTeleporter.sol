// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol";
import "../interfaces/IRegister.sol";
import "../interfaces/IZBondPool.sol";
import "../interfaces/IZBondContract.sol";
import "../interfaces/IImageCartridge.sol";

import "@zetachain/protocol-contracts/contracts/zevm/Interfaces.sol";
import "@zetachain/protocol-contracts/contracts/zevm/ZRC20.sol";


contract ZBondPool is IZBondPool { 

    string constant BEARER_BOND_CONTRACT        = "Z_BEARER_BOND_CONTRACT";
    string constant IMAGE_CARTRIDGE_CONTRACT    = "Z_IMAGE_CARTRIDGE_CONTRACT"; 

    IRegister register; 
    IZBondContract bonds;
    IZRC20 zrc20; 
    IImageCartridge images; 
    address self; 
    mapping(uint256=>uint256) bondAmountByBondId; 
     

    constructor(address _register, address _zrc20) { 
        register = IRegister(_register);
        bonds = IZBondContract(register.getAddress(BEARER_BOND_CONTRACT));
        images = IImageCartridge(register.getAddress(IMAGE_CARTRIDGE_CONTRACT));
        zrc20 = IZRC20(_zrc20);
        self = address(self);
    }

    function getZRC20() override view external returns (address _zrc20) {
        return address(zrc20); 
    }

    function getBalance(address _holder) override view external returns (uint256 _balance){
        uint256 [] memory bondIds = bonds.getBonds(_holder);
        for(uint256 x = 0; x < bondIds.length;  x++){
            _balance += bondAmountByBondId[bondIds[x]];
        }
        return _balance; 
    }

	function deposit(address _owner, uint256 _amount) override external payable returns (address _nftBearerBondContract, uint256 _bondId){
        zrc20.transferFrom(msg.sender, self, _amount);        
        string memory uri_          = images.getNextImage(); 
        _bondId                     = bonds.mintBond(_owner, _amount, uri_ );
        bondAmountByBondId[_bondId] = _amount; 
        return (address(bonds), _bondId);
    }

	function withdraw(address _holder, uint256 _bondId) override external returns (uint256 _amountWithdrawn){
        
        IERC721 erc721_ = IERC721(bonds);
        erc721_.transferFrom(_holder, self, _bondId);
        bonds.burnBond(_holder, _bondId);
        bondAmountByBondId[_bondId] = _amountWithdrawn;
        delete bondAmountByBondId[_bondId];

        zrc20.transfer(_holder, _amountWithdrawn);
        
        return _amountWithdrawn; 
    }
}