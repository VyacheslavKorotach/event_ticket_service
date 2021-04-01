const TicketOffice = artifacts.require("TicketOffice");
const utils = require("./helpers/utils");
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
        await contractInstance.createNewEvent(
            eventNames[0], eventDescriptions[0], eventLocations[0], eventStartDates[0],
            eventEndDates[0], eventTicketPrices[0], eventTotalTickets[0], {from: alice}
        );
        const result2 = await contractInstance.getEventDetails("1", {from: alice} );
        assert.equal(result2.name, eventNames[0]);
        // console.log(result2);
    })

    it("should be able to buy the ticket", async () => {
        await contractInstance.createNewEvent(
            eventNames[0], eventDescriptions[0], eventLocations[0], eventStartDates[0],
            eventEndDates[0], eventTicketPrices[0], eventTotalTickets[0], {from: alice}
        );
        const result3 = await contractInstance.buyTicket("1", {from: bob, value: "10000000000000000"})
        assert.equal(result3.receipt.status, true);
    })

    it("should be able to validate user tickets", async () => {
        await contractInstance.createNewEvent(
            eventNames[0], eventDescriptions[0], eventLocations[0], eventStartDates[0],
            eventEndDates[0], eventTicketPrices[0], eventTotalTickets[0], {from: alice}
        );
        await contractInstance.buyTicket("1", {from: bob, value: "10000000000000000"})
        const result5 = await contractInstance.checkTicket("1", "1", bob, {from: alice})
        assert.equal(result5, true);
        // console.log(result5);
    })

    context("should be able to withdraw ETH for the sold tickets", async () => {
        it("owner should be might withdraw ETH", async () => {
            await contractInstance.createNewEvent(
                eventNames[0], eventDescriptions[0], eventLocations[0], eventStartDates[0],
                eventEndDates[0], eventTicketPrices[0], eventTotalTickets[0], {from: alice}
            );
            await contractInstance.buyTicket("1", {from: bob, value: "10000000000000000"})
            await contractInstance.buyTicket("1", {from: bob, value: "10000000000000000"})
            const result7 = await contractInstance.withdraw("1", {from: alice})
            assert.equal(result7.receipt.status, true);
            // console.log(result7);
        })

        it("3-d person should not be might withdraw ETH", async () => {
            await contractInstance.createNewEvent(
                eventNames[0], eventDescriptions[0], eventLocations[0], eventStartDates[0],
                eventEndDates[0], eventTicketPrices[0], eventTotalTickets[0], {from: alice}
            );
            await contractInstance.buyTicket("1", {from: bob, value: "10000000000000000"})
            await contractInstance.buyTicket("1", {from: bob, value: "10000000000000000"})
            await utils.shouldThrow(contractInstance.withdraw("1", {from: bob}))
        })

        it("second withdrawal at row should be throwed", async () => {
            await contractInstance.createNewEvent(
                eventNames[0], eventDescriptions[0], eventLocations[0], eventStartDates[0],
                eventEndDates[0], eventTicketPrices[0], eventTotalTickets[0], {from: alice}
            );
            await contractInstance.buyTicket("1", {from: bob, value: "10000000000000000"})
            await contractInstance.buyTicket("1", {from: bob, value: "10000000000000000"})
            await contractInstance.withdraw("1", {from: alice})
            await utils.shouldThrow(contractInstance.withdraw("1", {from: alice}))
        })
    })

    context("should be able to transfer tickets to the new owner", async () => {
        it("owner should be might transfer the ticket", async () => {
            await contractInstance.createNewEvent(
                eventNames[0], eventDescriptions[0], eventLocations[0], eventStartDates[0],
                eventEndDates[0], eventTicketPrices[0], eventTotalTickets[0], {from: alice}
            );
            await contractInstance.buyTicket("1", {from: bob, value: "10000000000000000"})
            await contractInstance.buyTicket("1", {from: bob, value: "10000000000000000"})
            const result7 = await contractInstance.ticketTransfer("1", alice,  {from: bob})
            assert.equal(result7.receipt.status, true);
            // console.log(result7);
        })

        it("3-d person should not be might transfer the ticket", async () => {
            await contractInstance.createNewEvent(
                eventNames[0], eventDescriptions[0], eventLocations[0], eventStartDates[0],
                eventEndDates[0], eventTicketPrices[0], eventTotalTickets[0], {from: alice}
            );
            await contractInstance.buyTicket("1", {from: bob, value: "10000000000000000"})
            await contractInstance.buyTicket("1", {from: bob, value: "10000000000000000"})
            await utils.shouldThrow(contractInstance.ticketTransfer("1", bob,  {from: alice}))
            const result2 = await contractInstance.getEventDetails("1", {from: alice} );
            console.log(result2);
        })
    })

    it("Organizers can cancel an event they have created", async () => {
        await contractInstance.createNewEvent(
            eventNames[0], eventDescriptions[0], eventLocations[0], eventStartDates[0],
            eventEndDates[0], eventTicketPrices[0], eventTotalTickets[0], {from: alice}
        );
        // await utils.shouldThrow(contractInstance.cancelEvent("1", {from: bob}))
        await contractInstance.cancelEvent("1", {from: alice});
    })
})
