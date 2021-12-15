import React, { Component } from "react";
import Home from './components/Home';
import TokenFactory from './contracts/TokenFactory.json';
import getWeb3 from "./getWeb3";
import Caller from './contracts/Caller.json';
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
      instance.options.address = "0xCB277eD242016B7B8464c98d41842B648aF5B1f7";
      this.setState({ web3, accounts, tokenContract: instance });


      deployedNetwork = Caller.networks[networkId];
      instance = new web3.eth.Contract(
        Caller.abi,
        deployedNetwork && deployedNetwork.address,
      );
      instance.options.address = "0xB46dA2A2b23df6A8a8f51Fd769D4F9CCAe5B0DB1";
      this.setState({ callerContract: instance });
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
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
