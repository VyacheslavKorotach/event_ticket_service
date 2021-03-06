// contracts/TicketOffice.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./EventFactory.sol";

contract TicketOffice is EventFactory {
    event NewTicketSold(uint eventId, uint ticketId, address to);
    event TicketTransfered(uint ticketId, address to);

    mapping (uint => uint) public ticketToEvent; // For which event each ticket is issued 
    mapping (address => uint) public balances; // Here are the balances of collected money for the solved tickets

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
    function buyTicket(uint eventId) external payable returns(uint) {
        require(!isCanceled(eventId), "Event Canceled");
        require(ticketsSold(eventId) < totalTickets(eventId), "All tickets are sold");
        require(msg.value == ticketPrice(eventId), "The ticket price is wrong");
        balances[eventOwnerOf(eventId)] += msg.value;
        totalTicketCount++;
        uint ticketId = totalTicketCount;
        _mint(msg.sender, ticketId);
        // eventDetails storage myEvent = events[eventId];
        // myEvent.ticketsSold++;
        // events[eventId].ticketsSold++;
        incTicketsSold(eventId);
        ticketToEvent[ticketId] = eventId;
        return ticketId;
    }

    /**
     * @dev Gets the owner adress of the 'ticketId'.
     */
    function ticketOwnerOf(uint ticketId) public view returns (address) {
        return ownerOf(ticketId);
    }

    /**
     * @dev Returns 'ticketId' of the first ticket owned by the 'owner' issued to 'eventId' or '0' if
     * 'owner' has no any ticket to the 'eventId' event.
     * Task #3 - Organizers can validate user tickets.
     */
    function checkTicket(uint eventId, address owner) external view returns (uint) {
        for (uint i = 1; i <= totalTicketCount; i++) {
            if (ownerOf(i) == owner && ticketToEvent[i] == eventId) {
                return i;
            }
        }
        return 0;
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
    function ticketTransfer(uint tickedId, address to_) external returns (bool) {
        transferFrom(msg.sender, to_, tickedId);
        return true;
    }

    /**
     * @dev Gets the 'msg.sender' balance in the system. It's money (wei) collected for the
     * sold tickets (that could be withdrawn by 'withdraw').
     */
    function getSenderBalance() external view returns(uint) {
        return (balances[msg.sender]);
    }

    /**
     * @dev Withdraws money (Ether) for the sold 'eventId' tickets to the 'eventId' Organizer.
     * Task #2 - Organizers can sell tickets and accept payments using Ether.
     *
     * Requirements:
     *
     * - Only the Organizer of event can withdraw money.
     */
    function withdraw(uint eventId) external {
        require(eventOwnerOf(eventId) == msg.sender, "Only Organiser of the event might withdraw money");
        require(balances[msg.sender] > 0, "Your balance is zero");
        uint amount = balances[msg.sender];
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    /**
     * @dev Gets the array of the 'ticketId'es owned by the 'owner'.
     */
    function getOwnerTickets(address owner) external view returns(uint[] memory) {
        uint[] memory result = new uint[](balanceOf(owner));
        uint counter = 0;
        for (uint i = 1; i <= totalTicketCount; i++) {
            if (ownerOf(i) == owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
