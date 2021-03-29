const EventFactory = artifacts.require("eventfactory.sol");

module.exports = function(deployer) {
 deployer.deploy(EventFactory);
 