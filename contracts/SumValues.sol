// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Sum
 * @dev Summing values
 */
contract SumValues {

    event Sum(uint256 a, uint256 b, uint256 result);

    function sum(uint256 a, uint256 b) public {
        emit Sum(a, b, a + b);
    }
}