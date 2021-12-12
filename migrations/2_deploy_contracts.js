// var SimpleStorage = artifacts.require("./SimpleStorage.sol");

// module.exports = function(deployer) {
//   deployer.deploy(SimpleStorage);
// };
var Token = artifacts.require("./Token.sol");
var TokenFactory = artifacts.require("./TokenFactory.sol");
var Caller = artifacts.require("./Caller.sol");
var Price = artifacts.require("./Price.sol");
var MaticToUsdt = artifacts.require("./MaticToUsdt.sol");
var UsdtToInr = artifacts.require("./UsdtToInr.sol");
module.exports = function (deployer, accounts) {
  deployer.deploy(Caller);
  deployer.deploy(TokenFactory);
  deployer.deploy(Price);
  deployer.deploy(MaticToUsdt);
  deployer.deploy(UsdtToInr);
  deployer.deploy(Token,'DUMMY', 'DUMMY', accounts[0], 0.01);
  
};