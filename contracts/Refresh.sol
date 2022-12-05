// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Refresh
 * @dev Refreshe game
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Refresh {

    address gameAddress;
    
    constructor(address game) {
        gameAddress = game;
    }

    function refreshGame() public returns(bool) {
        (bool success, bytes memory data) = 
        gameAddress.call(abi.encodeWithSignature("refreshGame()"));

        return success;
    }
}