const TicketOffice = artifacts.require("TicketOffice");
// const utils = require("./helpers/utils");
const eventNames = ["Event 1", "Event 2"];
const eventSymbols = ["EVN1", "EVN2"];
const eventTotalTickets = ["100", "200"];
const eventTicketPrices = ["10", "20"];
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
            eventNames[0], eventSymbols[0], eventTotalTickets[0], eventTicketPrices[0], eventDescriptions[0],
            eventLocations[0], eventStartDates[0], eventEndDates[0], {from: alice}
        );
        assert.equal(result.receipt.status, true);
        assert.equal(result.logs[0].args.name, eventNames[0]);
        assert.equal(result.logs[0].args.symbol, eventSymbols[0]);
        // console.log(result);
    })

    it("should be able to create a new ticket", async () => {
        const result = await contractInstance.createNewEvent(
            eventNames[0], eventSymbols[0], eventTotalTickets[0], eventTicketPrices[0], eventDescriptions[0],
            eventLocations[0], eventStartDates[0], eventEndDates[0], {from: alice}
        );
        // const eventId = result.logs[0].args.eventId.toNumber();
        assert.equal(result.receipt.status, true);
        assert.equal(result.logs[0].args.name, eventNames[0]);
        assert.equal(result.logs[0].args.symbol, eventSymbols[0]);
        // console.log(result.logs[0].args.eventId);
    })

    it("should be able to get the event details", async () => {
        const result = await contractInstance.createNewEvent(
            eventNames[0], eventSymbols[0], eventTotalTickets[0], eventTicketPrices[0], eventDescriptions[0],
            eventLocations[0], eventStartDates[0], eventEndDates[0], {from: alice}
        );
        const result2 = await contractInstance.getEventDetails("1", {from: alice} );
        // const eventId = result.logs[0].args.eventId.toNumber();
        console.log(result2);
        assert.equal(result.receipt.status, true);
        assert.equal(result2.receipt.status, true);
        // assert.equal(result.logs[0].args.name, eventNames[0]);
        // assert.equal(result.logs[0].args.symbol, eventSymbols[0]);
        // console.log(result2);
    })

})