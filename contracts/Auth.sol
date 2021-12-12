// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
// import "@nomiclabs/builder/console.sol";
contract Auth is ChainlinkClient {
    using Chainlink for Chainlink.Request;
    uint256 public price;
    
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    string public token;
    
   
    constructor() public {
        setChainlinkToken(0x70d1F773A9f81C852087B77F6Ae6d3032B02D2AB);
        oracle = 0x1cf7D49BE7e0c6AC30dEd720623490B64F572E17;
        jobId = "da20aae0e4c843f6949e5cb3f7cfe8c4";
        fee = 10 ** 18; // 1 LINK
    }

    function getPrice() public view returns(uint256) {
        return price;
    }

    function getToken() public returns (bytes32 requestId) 
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        
        // Set the URL to perform the GET request on
        // NOTE: If this oracle gets more than 5 requests from this job at a time, it will not return. 
        request.add("get", "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=BTC&to_currency=CNY&apikey=demo");
        string[] memory path = new string[](2);
        path[0] = "Realtime Currency Exchange Rate";
        path[1] = "5. Exchange Rate";
        request.addStringArray("path", path);
        
        // Multiply the result by 10000000000 to remove decimals
        request.addInt("times", 10000000000);
        
        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }
    
    /**
     * Receive the response in the form of uint256
     */ 
    function fulfill(bytes32 _requestId, uint256 _price) public recordChainlinkFulfillment(_requestId)
    {
        price = _price;
    }
}