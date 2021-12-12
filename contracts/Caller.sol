// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./matic_usdt.sol";
import "./usdt_inr.sol";
import "./Price.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

interface IMaticToUsdt {
    function getLatestPrice() external returns(int);
    // function getPrice() external returns (bytes32 requestId);
    // function readPrice() external view returns(uint256);
}

interface IUsdtToInr {
    function getPrice() external returns (bytes32 requestId);
    function readPrice() external view returns(uint256);
}

interface IPrice {
    function getPrice() external returns (bytes32 requestId);
    function readPrice(string memory symbol) external view returns(uint256);
}

contract Caller is ChainlinkClient {
    using Chainlink for Chainlink.Request;
    
    
    event mtouevent(uint256 indexed value1);
    event utoievent(uint256 indexed value1);
    event maticevent(uint256 indexed value1);
    event priceevent(uint256 indexed value1);
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    uint256 private mToU;
    uint256 private UToI;
    uint256 private price;
    address private addressUsdtToInr = 0x49B488255c8b15B29F4382d5F64235E9ff78fA0D;
    address private addressMaticToUsdt = 0xb7290de5DaD7092E61FEBAaED8c786E4A90764b7;
    address private addressPrice = 0xda4DeC7D31a9DA9be01466314aE661B8Ac5DcdFC;
    mapping(string => uint256) private map;
    uint256 public finalMatic;
    constructor() {

    }

    function readPrice() public view returns(uint256) {
        return price;
    }

    // function getMaticToUsdt() public returns(bool){
    //     IMaticToUsdt(addressMaticToUsdt).getLatestPrice();
    //     return true;
    // }

    // function readMaticToUsdt() public view returns(uint256){
    //     return IMaticToUsdt(addressMaticToUsdt).getLatestPrice();
    // }

    function getUsdtToInr() public returns(bool){
        IUsdtToInr(addressUsdtToInr).getPrice();
        return true;
    }

    function readUsdtToInr() public view returns(uint256){
        return IUsdtToInr(addressUsdtToInr).readPrice();
    }

    function updatePrice(string memory symbol) public returns(uint256){
        mToU = uint256(IMaticToUsdt(addressMaticToUsdt).getLatestPrice());
        emit mtouevent(mToU); // log the current value
        UToI = IUsdtToInr(addressUsdtToInr).readPrice();
        emit utoievent(UToI); // log the current value
        price = IPrice(addressPrice).readPrice(symbol);
        emit priceevent(price);
        // require(price == 0,"Price is zero!");
        // require(mToU == 0,"mToU is zero");
        // require(UToI == 0,"UToI is zero");
        finalMatic = ((price*100000000/UToI)/mToU);
        emit maticevent(finalMatic);
        map[symbol] = finalMatic;
        return finalMatic;
    }
    function readUpdatedprice(string memory symbol) public view returns (uint256){
        return map[symbol];
    }

}