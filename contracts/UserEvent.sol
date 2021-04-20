// contracts/UserEvent.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract UserEvent is ERC721 {
    uint internal totalEventCount;
    uint internal activeEventCount;
    uint internal totalTicketCount;

    struct eventDetails {
        string name;
        string description;
        string location;
        string startDate;
        string endDate;
        uint ticketPrice;
        uint totalTickets;
        uint ticketsSold;
        bool eventCanceled;
    }    

    eventDetails[] public events;

    constructor() ERC721("EventTicketService", "ETS") {
        totalEventCount = 0;
        activeEventCount = 0;
        totalTicketCount = 0;
    }

    function eName(uint eventId) public view virtual returns (string memory) {
        require(eventId > 0);
        return events[eventId-1].name;
        // return events[eventId].name;
    }

    function description(uint eventId) public view virtual returns (string memory) {
        require(eventId > 0);
        return events[eventId-1].description;
    }

    function location(uint eventId) public view virtual returns (string memory) {
        require(eventId > 0);
        return events[eventId-1].location;
    }

    function startDate(uint eventId) public view virtual returns (string memory) {
        require(eventId > 0);
        return events[eventId-1].startDate;
    }

    function endDate(uint eventId) public view virtual returns (string memory) {
        require(eventId > 0);
        return events[eventId-1].endDate;
    }

    function ticketPrice(uint eventId) public view virtual returns (uint) {
        require(eventId > 0);
        return events[eventId-1].ticketPrice;
    }

    function totalTickets(uint eventId) public view virtual returns (uint) {
        require(eventId > 0);
        return events[eventId-1].totalTickets;
    }

    function ticketsSold(uint eventId) public view virtual returns (uint) {
        require(eventId > 0);
        return events[eventId-1].ticketsSold;
    }

    function isCanceled(uint eventId) public view virtual returns (bool) {
        require(eventId > 0);
        return (events[eventId-1].eventCanceled == true); 
    }

    function incTicketsSold(uint eventId) internal returns (uint) {
        require(eventId > 0);
        events[eventId-1].ticketsSold++;
        return events[eventId-1].ticketsSold;
    }

    /**
     * @dev Gets the structured details of the 'eventId'.
     */
    function getEventDetails(uint eventId) external view returns(eventDetails memory) {
        // require(eventId > 0);
        eventDetails memory details;
        details.name = eName(eventId);
        details.description = description(eventId);
        details.location = location(eventId);
        details.startDate = startDate(eventId);
        details.endDate = endDate(eventId);
        details.ticketPrice = ticketPrice(eventId);
        details.totalTickets = totalTickets(eventId);
        details.ticketsSold = ticketsSold(eventId);
        details.eventCanceled = isCanceled(eventId);
        return details;
    }
}
