const TicketOffice = artifacts.require("TicketOffice");
// const utils = require("./helpers/utils");
const eventNames = ["Event 1", "Event 2"];
const eventTotalTickets = ["100", "200"];
const eventTicketPrices = ["10000000000000000", "20000000000000000"];
const eventDescriptions = ["desription 1", "description 2"];
const eventLocations = ["location 1", "location 2"];
const eventStartDates = ["start Date 1", "start Date 2"];
const eventEndDates = ["end Date 1", "end Date 2"];
contract("TicketOffice", (accounts) => {
    let [alice, bob] = accounts;
    let contractInstance;
    beforeEach(async () => {
        contractInstance = await TicketOffice.new();
    });

    it("should be able to create a new event", async () => {
        const result = await contractInstance.createNewEvent(
            eventNames[0], eventDescriptions[0], eventLocations[0], eventStartDates[0],
            eventEndDates[0], eventTicketPrices[0], eventTotalTickets[0], {from: alice}
        );
        assert.equal(result.receipt.status, true);
        assert.equal(result.logs[0].args.name, eventNames[0]);
        // console.log(result.logs[0].args);
    })

    it("should be able to get the event details", async () => {
        const result = await contractInstance.createNewEvent(
            eventNames[0], eventDescriptions[0], eventLocations[0], eventStartDates[0],
            eventEndDates[0], eventTicketPrices[0], eventTotalTickets[0], {from: alice}
        );
        const result2 = await contractInstance.getEventDetails("1", {from: alice} );
        assert.equal(result.receipt.status, true);
        assert.equal(result2.name, eventNames[0]);
        // console.log(result2);
    })

    it("should be able to buy the ticket", async () => {
        const result = await contractInstance.createNewEvent(
            eventNames[0], eventDescriptions[0], eventLocations[0], eventStartDates[0],
            eventEndDates[0], eventTicketPrices[0], eventTotalTickets[0], {from: alice}
        );
        const result3 = await contractInstance.buyTicket("1", {from: bob, value: "10000000000000000"})
        assert.equal(result.receipt.status, true);
        assert.equal(result3.receipt.status, true);
    })

    it("should be able to validate user tickets", async () => {
        const result = await contractInstance.createNewEvent(
            eventNames[0], eventDescriptions[0], eventLocations[0], eventStartDates[0],
            eventEndDates[0], eventTicketPrices[0], eventTotalTickets[0], {from: alice}
        );
        const result3 = await contractInstance.buyTicket("1", {from: bob, value: "10000000000000000"})
        const result5 = await contractInstance.checkTicket("1", "1", bob, {from: alice})
        assert.equal(result.receipt.status, true);
        assert.equal(result3.receipt.status, true);
        assert.equal(result5.receipt.status, true);
        // console.log(result5);
    })

})