const SimpleStorage = artifacts.require("SimpleStorage");
const Banque = artifacts.require("Banque");
const Token = artifacts.require("Token");
const JeuneDiplome = artifacts.require("JeuneDiplome");

module.exports = function (deployer, network, accounts) {
  deployer.deploy(SimpleStorage);
  deployer
    .deploy(Token, 1000)
    .then(async () => {
      //get instrance token
      let instance = await Token.deployed();
      //give 500 token to accounts 2
      await instance.transfer(accounts[1], 500);
    })
    .then(() => deployer.deploy(JeuneDiplome, Token.address))
    .then(async () => {
      //get instrance token
      let instance = await Token.deployed();
      //approve JeuneDiplome to use 500 token of own
      await instance.approve(JeuneDiplome.address, 500);
    })
    .then(() => deployer.deploy(Banque, Token.address))
    .then(async () => {
      //get instrance token
      let instance = await Token.deployed();
      //approve Banque to use 500 token of own
      await instance.approve(Banque.address, 500);
    });
};
