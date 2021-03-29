// contracts/eventNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventFactory is Ownable {
    event NewEvent(uint eventId, string name, string symbol);

    ERC721[] public events;

    mapping (uint => address) public eventToOwner;
    mapping (address => uint) ownerEventCount;

    function _createEvent(string memory name_, string memory symbol_) internal {
        events.push(new ERC721(name_, symbol_));
        uint id = events.length;
        eventToOwner[id] = msg.sender;
        ownerEventCount[msg.sender] = ownerEventCount[msg.sender]++;
        emit NewEvent(id, name_, symbol_);
    }
}
