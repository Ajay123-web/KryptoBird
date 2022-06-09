const KryptoBirdz = artifacts.require("Kryptobird"); //the argument is the name of contract

module.exports = function(deployer) {
  deployer.deploy(KryptoBirdz);
};
