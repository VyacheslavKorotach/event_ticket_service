// contracts/eventNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventFactory is Ownable {
    ERC721[] public events;

    mapping (uint => address) public eventToOwner;
    mapping (address => uint) ownerEventCount;

}
