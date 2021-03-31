// contracts/EventFactory.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UserEvent.sol";

contract EventFactory {
    event NewEventCreated(uint eventId, string name, string symbol);
    event EventCanceled(uint eventId);

    UserEvent[] public events;

    mapping (uint => address) public eventToOwner;
    mapping (address => uint) ownerEventCount;
    uint totalEventCount;
    uint activeEventCount;

    struct eventDetails {
        string name;
        string symbol;
        uint totalTickets;
        uint ticketPrice;
        string description;
        string location;
        string startDate;
        string endDate;
        uint ticketsSold;
        bool eventCanceled;
        address eventOwner;
    }

    constructor() {
        totalEventCount = 0;
        activeEventCount = 0;
    }

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
            totalEventCount++;
            activeEventCount++;
            emit NewEventCreated(id, name_, symbol_);
    }

    /**
     * @dev Cancels the 'eventId' Event.
     * Task #6 - Organizers can cancel an event they have created.
     *
     * Requirements:
     *
     * - Only currently active event can be canceled.
     * - Only the Organizer can cancel the Event.
     * The conditions are checked in UserEvent cancelEvent(). 
     */
    function cancelEvent(uint eventId) public {
        events[eventId].cancelEvent();
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
            if (!events[i].isCanceled()) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    /**
     * @dev Gets the owner adress of the 'eventId'.
     */
    function OwnerOf(uint eventId) public view returns (address) {
        return eventToOwner[eventId];
    }

    /**
     * @dev Gets the structured details of the 'eventId'.
     */
    function getEventDetails(uint eventId) external view returns(eventDetails memory) {
        eventDetails memory details;
        details.name = events[eventId].name();
        details.symbol = events[eventId].symbol();
        details.totalTickets = events[eventId].totalTickets();
        details.ticketPrice = events[eventId].ticketPrice();
        details.description = events[eventId].description();
        details.location = events[eventId].location();
        details.startDate = events[eventId].startDate();
        details.endDate = events[eventId].endDate();
        details.name = events[eventId].name();
        details.ticketsSold = events[eventId].ticketsSold();
        details.eventCanceled = events[eventId].isCanceled();
        details.eventOwner = EventFactory.OwnerOf(eventId);
        return details;
    }
}
