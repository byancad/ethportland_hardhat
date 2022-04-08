//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import {MerkleProofUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/cryptography/MerkleProofUpgradeable.sol";

contract Greeter {
    string private greeting;
    bytes32 merkleroot;

    constructor(string memory _greeting) {
        console.log("Deploying a Greeters with greeting :", _greeting);
        greeting = _greeting;
    }

    function greet() public view returns (string memory) {
        return greeting;
    }

    function setGreeting(string memory _greeting) public {
        console.log("Changing greeting from '%s' to '%s'", greeting, _greeting);
        greeting = _greeting;
    }

    function testProof(bytes32[] memory _proof) public view {
        require(
            MerkleProofUpgradeable.verify(
                _proof,
                merkleroot,
                keccak256(abi.encodePacked(msg.sender))
            ),
            "invalid proof foo!"
        );
    }
}
