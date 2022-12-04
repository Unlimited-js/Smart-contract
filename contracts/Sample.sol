// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;


contract Sample{

      uint256 public current=12;

      function setNumber(uint256 _num) public {
        current = _num;

      }

    //   function viewNum() public pure  returns(_a uint256) {
    //     return current;
    //   }
}