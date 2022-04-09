//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract SkaleStub is ERC721URIStorage {
    uint256 public maxMint;
    string public artist;
    string public date;
    string public location;
    uint256 public creatorResellShare;
    mapping(uint256 => bool) used;
    uint256 public usedCount;

    constructor(
        string memory _name,
        string memory _artist,
        string memory _date,
        string memory _location,
        uint256 _quantity,
        uint256 __creatorResellShare
    ) ERC721(_name, "STUB") {
        artist = _artist;
        date = _date;
        location = _location;
        maxMint = _quantity;
        creatorResellShare = __creatorResellShare;
        usedCount = 0;
    }

    /**
     * Custom accessor to create a unique token
     */
    function mint(
        address _to,
        uint256 _tokenId,
        string memory _tokenURI
    ) public {
        require(_tokenId < maxMint, "Sold out!");
        super._mint(_to, _tokenId);
        super._setTokenURI(_tokenId, _tokenURI);
        used[_tokenId] = false;
    }

    function _burn(uint256 tokenId) internal virtual override {
        super._burn(tokenId);
    }

    function admitOne(uint256 _tokenId) internal virtual {
        require(
            ERC721.ownerOf(_tokenId) == msg.sender,
            "ERC721: caller is not owner!"
        );
        usedCount++;
        used[_tokenId] = true;
    }

    function details()
        public
        view
        returns (
            string memory eventName,
            string memory eventArtist,
            string memory eventDate,
            string memory eventLocation,
            uint256 eventMaxMint,
            uint256 eventCreatorResellShare,
            uint256 eventUsedCount
        )
    {
        eventName = this.name();
        eventArtist = this.artist();
        eventDate = this.date();
        eventLocation = this.location();
        eventMaxMint = this.maxMint();
        eventCreatorResellShare = this.creatorResellShare();
        eventUsedCount = this.usedCount();
        return (
            eventName,
            eventArtist,
            eventDate,
            eventLocation,
            eventMaxMint,
            eventCreatorResellShare,
            eventUsedCount
        );
    }
}
