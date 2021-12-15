// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./Token.sol";
import "./Caller.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC20/utils/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/access/Ownable.sol";

contract TokenFactory is Ownable {
    using SafeERC20 for IERC20;
    event eve(bytes32);
    address public beneficiary;
    address[] public allTokens;
    mapping (string => Token) public tokenMap;
    mapping (address => uint256) public collateralMap;
    mapping (address => string[]) public balanceMap;
    event TokenCreated(address indexed tokenAddress, uint256 startingSupply);
    event TransferBeneficiary(address indexed oldBeneficiary, address indexed beneficiary);
    event SweepToken(IERC20 indexed token, address indexed beneficiary, uint256 balance);

    // @dev On contract creation the beneficiary (and owner) are set to msg.sender
    constructor() {
        beneficiary = msg.sender;
    }


    function createToken(string memory name, string memory symbol, uint256 supply) public returns (address) {
        Token t = new Token(name, symbol, msg.sender, supply);
        tokenMap[symbol] = t;
        balanceMap[msg.sender].push(symbol);
        allTokens.push(address(t));
        emit TokenCreated(address(t), supply);
        return address(t);
    }

    function viewBalance(string memory symbol, address addr) view external returns(uint256){
        return tokenMap[symbol].balanceOf(addr);
    }

    function append(string memory symbol, uint256 supply) public returns(bool){
        tokenMap[symbol].appendToken(msg.sender,supply);
        return true;
    }

    function buyToken(string memory symbol, uint256 supply, address addr) public payable returns(bool){
        // string memory s = tokenMap[symbol].name();
        // string memory empty = "";
        // emit eve(keccak256(abi.encodePacked(s)));
        // if(keccak256(abi.encodePacked(s)) == keccak256(abi.encodePacked(empty))){
        //     createToken(symbol, symbol, supply);
        // }
        append(symbol, supply);
        return true;
    }

    function getCollateral(address addr) public view returns(uint256){
        return collateralMap[addr];
    }
                      
    function burnToken(string memory symbol, uint256 supply, address addr)public returns(bool){
        tokenMap[symbol].burnToken(msg.sender,supply);
        return true;
    }

    function tokenTransfer(string memory symbol, address receiver, uint256 amount) public returns(bool){
        Token t = tokenMap[symbol];
         return t.transferToken(receiver, amount);
    }

    function incCollateral(address addr, uint256 amount) public returns(bool){
        collateralMap[addr] += amount;
        return(true);
    }

    function decCollateral(address addr, uint256 amount) public returns(bool){
        collateralMap[addr] -= amount;
        return(true);
    }

    function liquidateCollateral(string memory symbol, uint256 liquidateRatio, address addr) public returns(bool){
        collateralMap[addr] = collateralMap[addr]*(1-liquidateRatio);
        uint256 liquidCollateralAmount = collateralMap[addr]*liquidateRatio;
        Caller caller = new Caller();
        uint256 liquidCollateralMatic = liquidCollateralAmount/caller.maticToInr();
        burnToken(symbol, addr, liquidCollateralMatic);
        append(symbol,liquidCollateralMatic);
        return true;
    }
    
}