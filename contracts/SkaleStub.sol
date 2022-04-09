//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./StubListing.sol";

contract SkaleStub is ERC721URIStorage {
    uint256 public maxMint;
    string public artist;
    string public date;
    string public location;
    uint256 public creatorResellShare;
    mapping(uint256 => bool) used;
    uint256 public usedCount;
    uint256 public mintedCount;
    uint256 public id;
    uint256 public amount;

    mapping(uint256 => StubListing) public asks;
    uint256 public listingCount;

    constructor(
        string memory _name,
        string memory _artist,
        string memory _date,
        string memory _location,
        uint256 _quantity,
        uint256 __creatorResellShare,
        uint256 _newStubId,
        uint256 _amount
    ) ERC721(_name, "STUB") {
        artist = _artist;
        date = _date;
        location = _location;
        maxMint = _quantity;
        creatorResellShare = __creatorResellShare;
        usedCount = 0;
        mintedCount = 0;
        id = _newStubId;
        amount = _amount;

        listingCount = 0;
    }

    /**
     * Custom accessor to create a unique token
     */
    function mint(address _to, string memory _tokenURI) public {
        require(mintedCount < maxMint, "Sold out!");
        super._mint(_to, mintedCount);
        super._setTokenURI(mintedCount, _tokenURI);
        used[mintedCount] = false;
        mintedCount++;
    }

    function _burn(uint256 tokenId) internal virtual override {
        super._burn(tokenId);
    }

    function admitOne(uint256 _tokenId) public virtual {
        require(
            ERC721.ownerOf(_tokenId) == msg.sender,
            "ERC721: caller is not owner!"
        );

        require(used[_tokenId] == false, "ERC721: Ticket already used!");
        usedCount++;
        used[_tokenId] = true;
    }

    function listToken(
        uint256 _tokenId,
        uint256 _askPrice,
        address _to
    ) public {
        require(
            ERC721.ownerOf(_tokenId) == msg.sender,
            "ERC721: caller is not owner!"
        );

        asks[listingCount] = new StubListing(
            _tokenId,
            _askPrice,
            address(this)
        );
        listingCount++;

        super._transfer(msg.sender, _to, _tokenId);
    }

    function getlistings() public view returns (StubListing[10] memory) {
        StubListing[10] memory listings = [
            asks[0],
            asks[1],
            asks[2],
            asks[3],
            asks[4],
            asks[5],
            asks[6],
            asks[7],
            asks[8],
            asks[9]
        ];

        return listings;
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
            uint256 eventUsedCount,
            uint256 eventMintedCount,
            uint256 eventId,
            address eventAddress,
            uint256 eventAmount
        )
    {
        eventName = this.name();
        eventArtist = this.artist();
        eventDate = this.date();
        eventLocation = this.location();
        eventMaxMint = this.maxMint();
        eventCreatorResellShare = this.creatorResellShare();
        eventUsedCount = this.usedCount();
        eventMintedCount = this.mintedCount();
        eventId = this.id();
        eventAddress = address(this);
        eventAmount = this.amount();
        return (
            eventName,
            eventArtist,
            eventDate,
            eventLocation,
            eventMaxMint,
            eventCreatorResellShare,
            eventUsedCount,
            eventMintedCount,
            eventId,
            eventAddress,
            eventAmount
        );
    }

    function transfer(
        address _from,
        address _to,
        uint256 _tokenId
    ) public virtual {
        super._transfer(_from, _to, _tokenId);
    }
}
