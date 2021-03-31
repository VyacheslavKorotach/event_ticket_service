const TicketOffice = artifacts.require("TicketOffice");
const eventNames = ["Event 1", "Event 2"];
const eventSymbols = ["EVN1", "EVN2"];
const eventTotalTickets = ["100", "200"];
const eventTicketPrices = ["10", "20"];
const eventDescriptions = ["desription 1", "description 2"];
const eventLocations = ["location 1", "location 2"];
const eventStartDates = ["start Date 1", "start Date 2"];
const eventEmdDates = ["end Date 1", "end Date 2"];
contract("TicketOffice", (accounts) => {
    let [alice, bob] = accounts;

    // start here

    it("should be able to create a new event", async () => {
        const contractInstance = await TicketOffice.new();
        const result = await contractInstance.createNewEvent(
            eventNames[0], eventSymbols[0], eventTotalTickets[0], eventTicketPrices[0], eventDescriptions[0],
            eventLocations[0], eventStartDates[0], eventEmdDates[0], {from: alice}
        );
        assert.equal(result.receipt.status, true);
        // assert.equal(result.logs[0].args.name, eventNames[0]);
    })

    //define the new it() function
})