// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.4/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {

    // @param name The name of the token
    // @param symbol The symbol of the token
    // @param mintTo The address that the initial supply should be sent to
    // @param supply The totalSupply of the token
    constructor(
        string memory name,
        string memory symbol,
        address mintTo,
        uint256 supply
    ) ERC20(name, symbol) {
        // _mint(mintTo, supply);
    } 

    function appendToken( address mintTo, uint256 supply) external returns(bool){
        _mint(mintTo, supply);
        return true;
    }

    function burnToken(address burnFrom, uint256 supply) external returns(bool){
        _burn(burnFrom,supply);
        return true;
    }

    function transferToken(address receiver, uint256 amount) external returns(bool){
        return transferFrom(address(this),receiver,amount);
    }


}