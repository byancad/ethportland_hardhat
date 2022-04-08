//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./SkaleStub.sol";

contract SkaleStubFactory {
    address public owner;
    uint256 public stubCount;
    mapping(uint256 => address) public stubs;

    event LogStubCreated(uint256 newStubId, string name, string symbol);

    constructor() {
        owner = msg.sender;
        stubCount = 0;
    }

    function createStub(string memory _name, string memory _symbol)
        public
        returns (uint256)
    {
        SkaleStub newSkaleStub = new SkaleStub(_name, _symbol);
        uint256 newStubId = stubCount;
        stubs[newStubId] = address(newSkaleStub);
        emit LogStubCreated(newStubId, _name, _symbol);
        stubCount++;

        return newStubId;
    }

    function getStubAddress(uint256 stubId) public view returns (address) {
        return stubs[stubId];
    }

    function getRandom() public view returns (bytes32 addr) {
        assembly {
            let freemem := mload(0x40)
            let start_addr := add(freemem, 0)
            if iszero(staticcall(gas(), 0x18, 0, 0, start_addr, 32)) {
                invalid()
            }
            addr := mload(freemem)
        }
    }
}
