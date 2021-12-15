// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./matic_usdt.sol";
import "./usdt_inr.sol";
import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/ChainlinkClient.sol";

contract Price is ChainlinkClient {
    using Chainlink for Chainlink.Request;
    uint256 public price;
    mapping(string => uint256) public map;
    mapping(string => uint256) public priceMap;
    string public ssymbol;
    event mtouevent(uint256 indexed value1);
    event utoievent(uint256 indexed value1);
    event maticevent(uint256 indexed value1);
    event priceevent(uint256 indexed value1);
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    uint256 private mToU;
    uint256 private UToI;
    address private addressUsdtToInr = 0x49B488255c8b15B29F4382d5F64235E9ff78fA0D;
    address private addressMaticToUsdt = 0x527Ab77B8e1f7083F2ff01a8f57B235Fdd96241f;
    uint256 public finalMatic;
    constructor() {
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
        oracle = 0xc8D925525CA8759812d0c299B90247917d4d4b7C;
        jobId = "bbf0badad29d49dc887504bacfbb905b";
        fee = 0.01 * 10 ** 18;

        
    }

    function readPrice(string memory symbol) public view returns(uint256) {
        return priceMap[symbol];
    }


    function getPrice(string memory symbol) public returns (bytes32 requestId) 
    {
        ssymbol = symbol;
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector); 
        string memory url = string(abi.encodePacked("https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=",symbol, "&interval=5min&apikey=RI0UGP2UY5QGT7OM"));
        request.add("get", url);
        // request.add("authorization","bearer h5sStYWrcnjZ4-k5m8pTlQ-cUpVWj6qlEO8sAJWvJPYw9E-NARMNVlPWfA3QKra1HY5tWRf6rQh8y8ywmF_dYDT0TAJawo4P_cGykjrBn4xBPlRcf6r50xW6uOkZk1ldNPooq6wV-9DSz_3L97qxjKI-ZC6-MbDcmX5ME95iRkQtH6VbttGhsMXJhS4dDfemCF71oYEYv3pDAAvyzRAfuA_Scsx3IQOPHKLZbOFcn7293i0ET5NoJiKuTwRQTMCuUtD4Mq_DXxywpvEA2V7Vlw");
        
        string[] memory path = new string[](3);
        path[0] = "Time Series (Daily)";
        path[1] = "2021-12-09";
        path[2] = "4. close";
        request.addStringArray("path", path);
        
        return sendChainlinkRequestTo(oracle, request, fee);
        
    }

    function fulfill(bytes32 _requestId, uint256 _price) public recordChainlinkFulfillment(_requestId)
    {
        price = _price;
        priceMap[ssymbol] = _price;
    }

    // function getMaticToUsdt() public returns(bool){
    //     IMaticToUsdt(addressMaticToUsdt).getPrice();
    //     return true;
    // }

    // function readMaticToUsdt() public view returns(uint256){
    //     return IMaticToUsdt(addressMaticToUsdt).readPrice();
    // }

    // function getUsdtToInr() public returns(bool){
    //     IUsdtToInr(addressUsdtToInr).getPrice();
    //     return true;
    // }

    // function readUsdtToInr() public view returns(uint256){
    //     return IUsdtToInr(addressUsdtToInr).readPrice();
    // }

    // function updatePrice(string memory symbol) public returns(uint256){
    //     // IMaticToUsdt(addressMaticToUsdt).getPrice(); 
    //     // IUsdtToInr(addressUsdtToInr).getPrice();
    //     mToU = IMaticToUsdt(addressMaticToUsdt).readPrice();
    //     emit mtouevent(mToU); // log the current value
    //     UToI = IUsdtToInr(addressUsdtToInr).readPrice();
    //     emit utoievent(UToI); // log the current value
    //     getPrice(symbol);
    //     emit priceevent(price);
    //     // require(price == 0,"Price is zero!");
    //     // require(mToU == 0,"mToU is zero");
    //     // require(UToI == 0,"UToI is zero");
    //     finalMatic = ((price/UToI)/mToU)*100000;
    //     emit maticevent(finalMatic);
    //     map[symbol] = ((price/UToI)/mToU)*100000;
    //     return (((price/UToI)/mToU)*100000);
    // }
    // function readUpdatedprice(string memory symbol) public view returns (uint256){
    //     return map[symbol];
    // }

}