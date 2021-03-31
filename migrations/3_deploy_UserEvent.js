const UserEvent = artifacts.require("UserEvent.sol");

module.exports = function(deployer) {
 deployer.deploy(UserEvent);
 