// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;


interface IRegister { 

    function getAddress(string memory _name) view external returns (address _address);

}