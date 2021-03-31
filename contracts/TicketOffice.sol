// contracts/EventFactory.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./EventFactory.sol";

contract TicketOffice is EventFactory {
    event NewTicketSold(uint eventId, uint ticketId, address to);

    /**
     * @dev Realises interface to function that gets money and gives the ticket to the buyer.
     * Emits a {NewTicketSold} event.
     * Returns ticketId.
     */
    function buyTicket(uint eventId) public returns (uint) {
        uint _ticketId = events[eventId].buyTicket();
        emit NewTicketSold(eventId, _ticketId, msg.sender);
        return _ticketId;
    }

    /**
     * @dev Returns true if in the 'eventId' exists the 'ticketId' owned by the 'owner'.
     * Task #3 - Organizers can validate user tickets.
     */
    function checkTicket(uint eventId, uint tickedId, address owner) public view returns (bool) {
        require(events[eventId].ownerOf(tickedId) == owner);
        return true;
    }

}
