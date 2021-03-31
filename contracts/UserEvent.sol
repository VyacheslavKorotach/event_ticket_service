// contracts/UserEvent.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract UserEvent is Ownable, ERC721 {
    uint private _totalTickets;
    uint private _ticketPrice;  // in wei
    string private _description;
    string private _location;
    string private _startDate;
    string private _endDate;
    uint private _ticketsSold;
    bool private _eventCanceled;

    constructor(
        string memory name_,
        string memory symbol_,
        uint totalTickets_,
        uint ticketPrice_,
        string memory description_,
        string memory location_,
        string memory startDate_,
        string memory endDate_) ERC721(name_, symbol_) {
            _totalTickets = totalTickets_;
            _ticketPrice = ticketPrice_;
            _description = description_;
            _location = location_;
            _startDate = startDate_;
            _endDate = endDate_;
            _ticketsSold = uint(0);
            _eventCanceled = false;
        }

    modifier isActive() {
        require(!isCanceled(), "Event canceled");
        _;
    }

    // Getters block

    function isCanceled() public view returns (bool) {
        return _eventCanceled == true; 
    }

    function totalTickets() public view virtual returns (uint) {
        return _totalTickets;
    }

    function ticketPrice() public view virtual returns (uint) {
        return _ticketPrice;
    }

    function description() public view virtual returns (string) {
        return _description;
    }

    function location() public view virtual returns (string) {
        return _location;
    }

    function startDate() public view virtual returns (string) {
        return _startDate;
    }

    function endDate() public view virtual returns (string) {
        return _endDate;
    }

    function ticketsSold() public view virtual returns (uint) {
        return _ticketsSold;
    }

    /**
     * @dev Cets money (_ticketPrice) and mint new ticket on the Event to the buyer.
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
    function buyTicket() public virtual payable isActive returns(uint) {
        require(_ticketsSold < _totalTickets);
        require(msg.value == _ticketPrice);
        uint _ticketId = _mintTicket(msg.sender);
        return _ticketId;
    }
    
    function _mintTicket(address to_) private returns(uint) {
        _mint(to_, _ticketsSold + 1);
        return _ticketsSold++;
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

    /**
     * @dev Marks the Event as 'canceled'.
     * Task #6 - Organizers can cancel an event they have created.
     *
     * Requirements:
     *
     * - Only currently active event can be canceled.
     * - Only the Organizer can cancel the Event.
     */
    function cancelEvent() public isActive onlyOwner {
        _eventCanceled = true;
    }
}
