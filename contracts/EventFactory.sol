// contracts/EventFactory.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UserEvent.sol";

contract EventFactory {
    event NewEventCreated(uint eventId, string name, string symbol);

    UserEvent[] public events;

    mapping (uint => address) public eventToOwner;
    mapping (address => uint) ownerEventCount;

    /**
     * @dev Creats new Event.
     * Task #1 - Event organizers can create events.
     * Emits a {NewEventCreated} event.
     */
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
            emit NewEventCreated(id, name_, symbol_);
        }

}
