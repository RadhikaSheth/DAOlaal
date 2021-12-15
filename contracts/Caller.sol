// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./matic_usd.sol";
import "./usdt_inr.sol";
import "./Price.sol";
import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/ChainlinkClient.sol";

interface IMaticToUsd {
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
    uint256 public mToU;
    uint256 private UToI;
    uint256 private price;
    address private addressUsdtToInr = 0x7CA0C41767d830A94798a0A42648af533c1b721f;
    address private addressMaticToUsdt = 0x6284298047b29Cf304B8F96EfEc96ff3D68B92aa;
    address private addressPrice = 0xd6849312155313d47647E36CEb1ece771747e807;
    mapping(string => uint256) private map;
    uint256 public finalMatic;
    constructor() {

    }

    function readPrice(string memory symbol) public view returns(uint256) {
        return IPrice(addressPrice).readPrice(symbol);
    }

    function getMaticToUsdt() public returns(uint256){
        return uint256(IMaticToUsd(addressMaticToUsdt).getLatestPrice());
    }

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
        mToU = uint256(IMaticToUsd(addressMaticToUsdt).getLatestPrice());
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

    function maticToInr() public view returns(uint256){
        return (mToU/100000000)*UToI;
    }


}