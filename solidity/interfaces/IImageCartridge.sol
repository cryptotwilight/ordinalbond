// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;

interface IImageCartridge { 

	function getImageCount() view external returns (uint256 _count);

	function getNextImage() external returns (string memory _uri);

}