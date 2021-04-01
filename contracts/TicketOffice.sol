// contracts/TicketOffice.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./EventFactory.sol";

contract TicketOffice is EventFactory {
    event NewTicketSold(uint eventId, uint ticketId, address to);
    event TicketTransfered(uint ticketId, address to);

    mapping (uint => uint) public ticketToEvent;

    /**
     * @dev Gets money 'ticketPrice' and mint new ticket on the Event 'eventId' to the buyer 'to'.
     * Task #4 - Event participants can buy a ticket to the event.
     *
     * Requirements:
     *
     * - The Event is not canceled.
     * - `_ticketsSold` is less then '_totalTickets'.
     * - amount of money in transaction is equal to '_ticketPrice'.
     *
     * Emits a {Transfer} event.
     */
    function buyTicket(eventId) public virtual payable returns(uint) {
        require(!isCanceled(eventId), "Event Canceled");
        require(ticketsSold(eventId) < totalTickets(), "All tickets are sold");
        require(msg.value == ticketPrice(eventId), "The ticket price is wrong");
        uint ticketId = totalTicketCount++;
        _mint(msg.sender, ticketId);
        ticketToEvent.ticketId = eventId;
        return tickedId;
    }

    /**
     * @dev Gets the owner adress of the 'ticketId'.
     */
    function ticketOwnerOf(uint ticketId) public view returns (address) {
        return ownerOf(tickedId);
    }

    /**
     * @dev Returns true if the 'ticketId' owned by the 'owner' and 'tickedId' issued to 'eventId'
     * Task #3 - Organizers can validate user tickets.
     */
    function checkTicket(uint eventId, uint tickedId, address owner) external view returns (bool) {
        require(ticketOwnerOf(ticketId) == owner);
        require(ticketToEvent.ticketId == eventId);
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

    /**
     * @dev Withdraws money (Ether) for the sold tickets to the Event Organizer.
     * Task #2 - Organizers can sell tickets and accept payments using Ether.
     *
     * Requirements:
     *
     * - Only the Organizer of event can withdraw money.
     */
    function withdraw() external onlyOwner {
        address _owner = owner();
        payable(_owner).transfer(address(this).balance);
    }
}
