// contracts/EventFactory.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./EventFactory.sol";

contract TicketOffice is EventFactory {

    function buyTicket(uint eventId) public returns (uint) {
        return events[eventId].buyTicket();
    }

}