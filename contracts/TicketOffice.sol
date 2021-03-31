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
    function buyTicket(uint eventId) external returns (uint) {
        uint _ticketId = events[eventId].buyTicket();
        emit NewTicketSold(eventId, _ticketId, msg.sender);
        return _ticketId;
    }

    /**
     * @dev Returns true if in the 'eventId' exists the 'ticketId' owned by the 'owner'.
     * Task #3 - Organizers can validate user tickets.
     */
    function checkTicket(uint eventId, uint tickedId, address owner) external view returns (bool) {
        require(events[eventId].ownerOf(tickedId) == owner);
        return true;
    }

    /**
     * @dev Transfers the 'ticketId' to the new owner to his Etherium address 'to_'.
     * Task #5 - The ticket can be transferred from one user to another using an ether account.
     *
     * Requirements:
     *
     * - Only the owner or approved person can transfer the ticketId. 
     *   The restrictions realised in OpenZeppelin ERC721.sol (transferFrom)
     */
    function ticketTransfer(uint eventId, uint tickedId, address to_) external returns (bool) {
        events[eventId].transferFrom(msg.sender, to_, tickedId);
        return true;
    }
}
