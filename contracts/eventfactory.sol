// contracts/EventFactory.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UserEvent.sol";

contract EventFactory {
    event NewEvent(uint eventId, string name, string symbol);

    UserEvent[] public events;

    mapping (uint => address) public eventToOwner;
    mapping (address => uint) ownerEventCount;

    function createEvent(
        string memory name_,
        string memory symbol_,
        uint totalTickets_,
        uint ticketPrice_,
        string memory description_,
        string memory location_,
        string memory startDate_,
        string memory endDate_) public {
            UserEvent uEvent = new UserEvent(
                name_, symbol_, totalTickets_, ticketPrice_, description_, location_, startDate_, endDate_); 
            events.push(uEvent);
            uint id = events.length;
            eventToOwner[id] = msg.sender;
            ownerEventCount[msg.sender] = ownerEventCount[msg.sender]++;
            emit NewEvent(id, name_, symbol_);
        }

}
