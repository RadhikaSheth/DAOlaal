// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/ChainlinkClient.sol";

contract UsdtToInr is ChainlinkClient {
    using Chainlink for Chainlink.Request;
    uint256 public price;
    
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    
   
    constructor() {
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
        oracle = 0xc8D925525CA8759812d0c299B90247917d4d4b7C;
        jobId = "bbf0badad29d49dc887504bacfbb905b";
        fee = 0.01 * 10 ** 18;
    }

    function readPrice() public view returns(uint256) {
        return price;
    }


    function getPrice() public returns (bytes32 requestId) 
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector); 
        request.add("get", "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=USDT&to_currency=INR&apikey=RI0UGP2UY5QGT7OM");
        
        string[] memory path = new string[](2);
        path[0] = "Realtime Currency Exchange Rate";
        path[1] = "5. Exchange Rate";
        request.addStringArray("path", path);
        
        return sendChainlinkRequestTo(oracle, request, fee);
        
    }

    function fulfill(bytes32 _requestId, uint256 _price) public recordChainlinkFulfillment(_requestId)
    {
        price = _price;
    }
}