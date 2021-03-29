// contracts/eventNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventFactory is ERC721, Ownable {
    constructor() ERC721("eventNFT", "ENFT") {
    }
}
