// SPDX-License-Identifier: MIT

pragma solidity ^0.8.5;

// import"https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract GIRO0_Token is ERC20{
    constructor() public ERC20("girro","giroS"){
        _mint(msg.sender, 10000000*10**18);
    }
        
    
}
