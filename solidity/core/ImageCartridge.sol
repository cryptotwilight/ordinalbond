// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;

import "../interfaces/IRegister.sol";
import "../interfaces/IImageCartridge.sol";


contract ImageCartridge is IImageCartridge { 

    string constant MINTER = "Z_MINTER";

    IRegister register; 

    uint256 imageCount = 0; 
    uint256 latestIssuedUriId = 0; 
    mapping(uint256=>string) uriById; 
    mapping(uint256=>bool) isIssuedUri; 


    constructor(address _register) { 
        register = IRegister(_register);
    }

    function getImageCount() override view external returns (uint256 _count) {
        return imageCount; 
    }

    function getNextImage() override external returns (string memory _uri){
        require(msg.sender == register.getAddress(MINTER), " minter only ");
        uint256 issue_ = latestIssuedUriId++; 
        _uri = uriById[issue_];
        isIssuedUri[issue_] = true; 
        return _uri; 
    }

    function addImages(string [] memory _uris) external returns (uint256 _count) {
        imageCount += _uris.length; 
        for(uint256 x = 0; x < _uris.length; x++) {
            uriById[x] = _uris[x];
            _count++;
        }
        return _count; 
    }

}