// contracts/eventNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EventFactory is Ownable {
    event NewEvent(uint eventId, string name, string symbol);

    // ERC721[] public events;
    struct userEvent {
        ERC721 tickets;
        uint totalTickets;
        uint ticketPrice;  // in wei
        string description;
        string location;
        string startDate;
        string endDate;
        uint ticketsSold;
        bool eventCanceled;
    }

    userEvent[] public events;

    mapping (uint => address) public eventToOwner;
    mapping (address => uint) ownerEventCount;

    function createEvent(string memory name_, 
                          string memory symbol_, 
                          uint totalTickets, 
                          uint ticketPrice,
                          string memory description,
                          string memory location,
                          string memory startDate,
                          string memory endDate) public {
        userEvent memory uEvent;
        uEvent.tickets = new ERC721(name_, symbol_);
        uEvent.totalTickets = totalTickets;
        uEvent.ticketPrice = ticketPrice;
        uEvent.description = description;
        uEvent.location = location;
        uEvent.startDate = startDate;
        uEvent.endDate = endDate;
        uEvent.ticketsSold = uint(0);
        uEvent.eventCanceled = false;
        events.push(uEvent);
        uint id = events.length;
        eventToOwner[id] = msg.sender;
        ownerEventCount[msg.sender] = ownerEventCount[msg.sender]++;
        emit NewEvent(id, name_, symbol_);
    }
}
