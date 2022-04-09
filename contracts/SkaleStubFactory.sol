//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./SkaleStub.sol";

contract SkaleStubFactory {
    address public owner;
    uint256 public stubCount;
    mapping(uint256 => address) public stubs;
    mapping(address => uint256) public stubsAddresses;

    event LogStubCreated(uint256 newStubId, string name);

    constructor() {
        owner = msg.sender;
        stubCount = 0;
    }

    function createStub(
        string memory _name,
        string memory _artist,
        string memory _date,
        string memory _location,
        uint256 _quantity,
        uint256 _creatorResellShare,
        uint256 _amount
    ) public returns (uint256) {
        uint256 newStubId = stubCount;
        SkaleStub newSkaleStub = new SkaleStub(
            _name,
            _artist,
            _date,
            _location,
            _quantity,
            _creatorResellShare,
            newStubId,
            _amount
        );

        stubs[newStubId] = address(newSkaleStub);
        stubsAddresses[address(newSkaleStub)] = newStubId;
        emit LogStubCreated(newStubId, _name);
        stubCount++;

        return newStubId;
    }

    function getStubAddress(uint256 stubId) public view returns (address) {
        return stubs[stubId];
    }

    function getStubId(address stubAddress) public view returns (uint256) {
        return stubsAddresses[stubAddress];
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
