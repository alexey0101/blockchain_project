// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title SampleERC20
 * @dev Create a sample ERC20 standard token
 */
contract SampleERC20 is ERC20 {
        constructor(uint256 initialSupply) 
          ERC20("TestToken", "TET") 
        {
                _mint(msg.sender, initialSupply);
        }
}