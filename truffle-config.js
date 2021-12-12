const path = require("path");

const HDWalletProvider = require('@truffle/hdwallet-provider');
const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
    development: {
      network_id: "*",
      host: 'localhost',
      port: 8545
    },
    matic: {
      // provider: () => new HDWalletProvider("tree charge scrub weasel web trust clown artist liquid seed laugh vicious", `https://rpc-mumbai.maticvigil.com`),

      provider: () => new HDWalletProvider("common short girl race abuse brain whip regular exclude inherit century entry", "https://matic-mumbai.chainstacklabs.com"),
      network_id: 80001,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },
  }, 
  compilers: {
    solc: {
      version: "0.8.0",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      settings: {          // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: true,
          runs: 200
        },
      }
    }
  }
};
