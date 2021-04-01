// contracts/EventFactory.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UserEvent.sol";

contract EventFactory is UserEvent {
    event NewEventCreated(uint eventId, string name);
    event EventCanceled(uint eventId);

    mapping (uint => address) public eventToOwner;
    mapping (address => uint) ownerEventCount;
    // mapping (uint => bool) EventCanceled;  // There are canceled events only

    /**
     * @dev Creats new Event.
     * Task #1 - Event organizers can create events.
     * Emits a {NewEventCreated} event.
     */
    function createNewEvent(
        string memory name_,
        string memory description_,
        string memory location_,
        string memory startDate_,
        string memory endDate_,
        uint ticketPrice_,    
        uint totalTickets_) public {
            events.push(
                eventDetails(name_, description_, location_, startDate_, endDate_,
                ticketPrice_, totalTickets_, 0, false)
            ); 
            uint id = events.length;
            eventToOwner[id] = msg.sender;
            ownerEventCount[msg.sender]++;
            totalEventCount++;
            activeEventCount++;
            emit NewEventCreated(id, name_);
    }

    /**
     * @dev Gets the owner adress of the 'eventId'.
     */
    function eventOwnerOf(uint eventId) public view returns (address) {
        return eventToOwner[eventId];
    }

    /**
     * @dev Marks the Event as 'canceled'.
     * Task #6 - Organizers can cancel an event they have created.
     *
     * Requirements:
     *
     * - Only currently active event can be canceled.
     * - Only the Organizer can cancel the Event.
     */
    function cancelEvent(uint eventId) public {
        require(!isCanceled(eventId), "The event already canceled");
        require(eventOwnerOf(eventId) == msg.sender, "You are not the owner of the event");
        eventDetails storage myEvent = events[eventId];
        myEvent.eventCanceled = true;
        activeEventCount--;
        emit EventCanceled(eventId);
    }

    /**
     * @dev Gets the array of the 'eventId'es of the active events.
     * Task #7 - Search for available events.
     */
    function getActiveEvnts() external view returns(uint[] memory) {
        uint[] memory result = new uint[](activeEventCount);
        uint counter = 0;
        for (uint i = 0; i < events.length; i++) {
            if (!isCanceled(i)) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    /**
     * @dev Gets the array of the 'eventId'es owned by the 'owner'.
     * Task #7 - Search for available events.
     */
    function getOwnerEvents(address owner) external view returns(uint[] memory) {
        uint[] memory result = new uint[](ownerEventCount[owner]);
        uint counter = 0;
        for (uint i = 0; i < events.length; i++) {
            if (eventToOwner[i] == owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
