// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;

import "../interfaces/IRegister.sol";

contract Register is IRegister { 

    address owner; 

    mapping(string=>address) addressByName; 

    constructor(address _owner) {
        owner = _owner; 
    }

    function getAddress(string memory _name) override view external returns (address _address){
        return addressByName[_name];
    }

    function addAddress(string memory _name, address _address) external returns (bool _added){
        require(msg.sender == owner, "admin only");
        addressByName[_name] = _address; 
        return true; 
    }

}