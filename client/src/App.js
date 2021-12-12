import React, { Component } from "react";
import Home from './components/Home';
import TokenFactory from './contracts/TokenFactory.json';
import Price from './contracts/Price.json'
import getWeb3 from "./getWeb3";
import Caller from './contracts/Caller.json';
import MaticToUsdt from './contracts/MaticToUsdt.json';
import UsdtToInr from './contracts/UsdtToInr.json';
import "./App.css";

class App extends Component {
  state = { storageValue: 0, web3: null, accounts: null, tokenContract: null, callerContract: null, maticClient: null };

  componentDidMount = async () => {
    try {
      const web3 = await getWeb3();
      const accounts = await web3.eth.getAccounts();
      const networkId = await web3.eth.net.getId();
      var deployedNetwork = TokenFactory.networks[networkId];
      var instance = new web3.eth.Contract(
        TokenFactory.abi,
        deployedNetwork && deployedNetwork.address,
      );
      instance.options.address = "0xA963aB65320C16a581eeb264125C5fF1FcE58985";
      this.setState({ web3, accounts, tokenContract: instance });


      deployedNetwork = Caller.networks[networkId];
      instance = new web3.eth.Contract(
        Caller.abi,
        deployedNetwork && deployedNetwork.address,
      );
      instance.options.address = "0x399e239d370B5caa8c834F562Eb1D844A92f1443";
      this.setState({ callerContract: instance });
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  runExample = async () => {
    const { accounts, tokenContract, callerContract } = this.state;
    //Price:
    // const getPrice = await contract.methods.getPrice("BSE:RELIANCE").send({ from: accounts[0]});
    // console.log(getPrice);
    // const price = await contract.methods.readPrice("BSE:RELIANCE").call();
    // console.log(price);


    //Caller:
    // const price = await contract.methods.readUpdatedprice("radhika").call();
    // console.log("price: ",price);
    // const updatePrice = await contract.methods.updatePrice("BSE:RELIANCE").send({from:accounts[0]});
    // console.log(updatePrice);
    


    // Token Factory:
    // const response = await tokenContract.methods.createToken("XReliance","BSE:RELIANCE",1).send({ from: accounts[0] });
    // console.log("Response",response);
    const Web3 = this.state.web3;
    const amount = Web3.utils.toWei('0.5');
    // await tokenContract.methods.buyToken("BSE:RELIANCE", rprice).send({ from: accounts[0], value: amount, to: '0x0cf14f7F4B2eE7Cf3Dd5cA1CE5D66b01729E9a3d'});
    // await tokenContract.methods.incCollateral(accounts[0],rprice).send({from : accounts[0]});
    // const collateral = await tokenContract.methods.getCollateral(accounts[0]).call();
    // console.log("collateral", collateral);
    // const allTokensLength = await contract.methods.allTokensLength().call();
    // console.log(allTokensLength);
    await tokenContract.methods.burnToken("BSE:RELIANCE", 2).send({ from: accounts[0] });
    Web3.eth.sendTransaction({
      from: '0x0cf14f7F4B2eE7Cf3Dd5cA1CE5D66b01729E9a3d',
      to: '0x5980aaf8D7a4763390301089E4eED93857666d79',
      value: amount
    })
      .then(function (receipt) {
        console.log(receipt);
      });
    const balance = await tokenContract.methods.viewBalance("BSE:RELIANCE", accounts[0]).call();
    console.log("balance: ", balance);
  };

  render() {
    if (!this.state.web3) {
      return <div>loading...</div>;
    } else {
      return (
        <Home web3={this.state.web3} accounts={this.state.accounts} tokenContract={this.state.tokenContract} callerContract={this.state.callerContract} />
      );
    }

  }
}

export default App;
