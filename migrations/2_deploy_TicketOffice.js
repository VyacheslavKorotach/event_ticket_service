const TicketOffice = artifacts.require("TicketOffice.sol");

module.exports = function(deployer) {
  deployer.deploy(TicketOffice);
};