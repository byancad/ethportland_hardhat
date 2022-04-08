//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract SkaleStub is ERC721URIStorage {
    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {}

    /**
     * Custom accessor to create a unique token
     */
    function mint(
        address _to,
        uint256 _tokenId,
        string memory _tokenURI
    ) public {
        super._mint(_to, _tokenId);
        super._setTokenURI(_tokenId, _tokenURI);
    }

    function _burn(uint256 tokenId) internal virtual override {
        super._burn(tokenId);
    }
}
