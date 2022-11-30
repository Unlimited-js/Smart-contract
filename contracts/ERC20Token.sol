// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./ERC20.sol";
import "./ERC20Burnable.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract ERC20Token is ERC20("betGame Token", "BGT"), ERC20Burnable {
    address owner;

    constructor() {
        owner = msg.sender;
        _mint(address(this), 500000e18);
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "no permission!");
        _;
    }

    function transferFromContract(address _to, uint256 amount) external onlyOwner {
        uint bal = balanceOf(address(this));
        require(bal >= amount, "You are transferring more than the amount available!");
        _transfer(address(this), _to, amount);
    }
}

//vrvf2 0x985d408Fb5BacFc398aB49C33a63AC6DCc84AF1a
//betgameToken 0xbE4fCF60211ac042F8D5b663590AB3651Ec71330 gerli
//betgametOKEN 0xab20e6D156F6F1ea70793a70C01B1a379b603D50 POLGYGON

//betgame contract 0x9C83a01982a35B66FcA966760296233959f485E6